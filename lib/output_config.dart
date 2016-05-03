// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

/// Configures where output of the protoc compiler should be placed and how to
/// import one generated file from another.
abstract class OutputConfiguration {
  const OutputConfiguration();

  /// Returns [filePath] with it's extension replaced with '.pb.dart'.
  String replacePathExtension(String filePath) =>
      '${path.withoutExtension(filePath)}.pb.dart';

  /// Returns [file] with it's extension replaced with '.pb.dart'.
  Uri replaceUriExtension(Uri file) =>
      path.url.toUri(replacePathExtension(path.url.fromUri(file)));

  /// Resolves an import of a .pb.dart file.
  ///
  /// Both [source] and [target] are .proto files, where [source] imports
  /// [target].
  ///
  /// The returned URI can be used within the source's .pb.dart file to
  /// import the target's .pb.dart file.
  Uri resolveImport(Uri target, Uri source);

  /// Resolves an import of a .pbjson.dart file.
  ///
  /// Both [source] and [target] are .proto files, where [source] imports
  /// [target].
  ///
  /// The returned URI can be used within the source's .pbjson.dart file to
  /// import the target's .pbjson.dart file.
  Uri resolveJsonImport(Uri target, Uri source);

  /// Returns the path where the .pb.dart file will be placed.
  ///
  /// The input is a .proto file and the output is a path under the output
  /// folder.
  Uri outputPathFor(Uri inputPath);

  /// Returns the path where the .pbjson.dart file will be place.
  ///
  /// The input is a .proto file and the output is a path under the output
  /// folder.
  ///
  /// (This file making data from the .proto file available as
  /// constants in Dart. The constants are JSON-encoded protobufs.)
  Uri jsonDartOutputPathFor(Uri inputPath);
}

/// Default [OutputConfiguration] that uses the same path as the input
/// file for the output file (just replaces the extension), and that uses
/// relative paths to resolve imports.
class DefaultOutputConfiguration extends OutputConfiguration {
  const DefaultOutputConfiguration();

  @override
  Uri outputPathFor(Uri input) => replaceUriExtension(input);

  @override
  Uri jsonDartOutputPathFor(Uri input) {
    var base = path.withoutExtension(path.url.fromUri(input));
    return path.url.toUri('$base.pbjson.dart');
  }

  @override
  Uri resolveImport(Uri target, Uri source) {
    var targetPath = path.url.fromUri(target);
    var sourceDir = path.url.dirname(path.url.fromUri(source));
    return path.url.toUri(
        replacePathExtension(path.url.relative(targetPath, from: sourceDir)));
  }

  @override
  Uri resolveJsonImport(Uri target, Uri source) {
    var targetPath = path.url.fromUri(target);
    var sourceDir = path.url.dirname(path.url.fromUri(source));
    var base =
        path.withoutExtension(path.url.relative(targetPath, from: sourceDir));
    return path.url.toUri('$base.pbjson.dart');
  }
}
