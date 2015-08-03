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

  /// Resolves an import URI. Both [source] and [target] are .proto files,
  /// where [target] is imported from [source]. The result URI can be used to
  /// import [target]'s .pb.dart output from [source]'s .pb.dart output.
  Uri resolveImport(Uri target, Uri source);

  /// Returns the path, under the output folder, where the code will be
  /// generated for [inputPath]. The input is expected to be a .proto file,
  /// while the output is expected to be a .pb.dart file.
  Uri outputPathFor(Uri inputPath);
}

/// Default [OutputConfiguration] that uses the same path as the input
/// file for the output file (just replaces the extension), and that uses
/// relative paths to resolve imports.
class DefaultOutputConfiguration extends OutputConfiguration {

  const DefaultOutputConfiguration();

  Uri outputPathFor(Uri input) => replaceUriExtension(input);

  Uri resolveImport(Uri target, Uri source) {
    var builder = path.url;
    var targetPath = builder.fromUri(target);
    var sourceDir = builder.dirname(builder.fromUri(source));
    return builder.toUri(replacePathExtension(
        builder.relative(targetPath, from: sourceDir)));
  }
}
