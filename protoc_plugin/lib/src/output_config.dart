// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:path/path.dart' as path;

/// Configures where output of the protoc compiler should be placed and how to
/// import one generated file from another.
abstract class OutputConfiguration {
  const OutputConfiguration();

  /// Resolves an import of a generated Dart file.
  ///
  /// Both [source] and [target] are .proto files, where [source] imports
  /// [target].
  ///
  /// The returned URI can be used within one of the source's dart files to
  /// import the target's generated file with the given extension.
  Uri resolveImport(Uri target, Uri source, String extension);

  /// Returns the path where the .pb.dart file will be placed.
  ///
  /// The input is a .proto file and the output is a path under the output
  /// folder.
  Uri outputPathFor(Uri inputPath, String extension);
}

/// Default [OutputConfiguration] that uses the same path as the input
/// file for the output file (just replaces the extension), and that uses
/// relative paths to resolve imports.
class DefaultOutputConfiguration extends OutputConfiguration {
  const DefaultOutputConfiguration();

  @override
  Uri outputPathFor(Uri inputPath, String extension) {
    final base = path.withoutExtension(path.url.fromUri(inputPath));
    return path.url.toUri('$base$extension');
  }

  @override
  Uri resolveImport(Uri target, Uri source, String extension) {
    final targetPath = path.url.fromUri(target);
    final wellKnownImport = wellKnownTypeImportPaths[targetPath];
    if (wellKnownImport != null) {
      return path.url.toUri(wellKnownImport);
    }
    final sourceDir = path.url.dirname(path.url.fromUri(source));
    final base = path.withoutExtension(
      path.url.relative(targetPath, from: sourceDir),
    );
    return path.url.toUri('$base$extension');
  }
}

Map<String, String> wellKnownTypeImportPaths = Map.fromEntries(
  wellKnownTypeProtoPaths.map(
    (String path) => MapEntry(path, wellKnownProtoPathToImports(path)),
  ),
);

List<String> wellKnownTypeProtoPaths = [
  'google/protobuf/any.proto',
  'google/protobuf/api.proto',
  'google/protobuf/duration.proto',
  'google/protobuf/empty.proto',
  'google/protobuf/field_mask.proto',
  'google/protobuf/source_context.proto',
  'google/protobuf/struct.proto',
  'google/protobuf/timestamp.proto',
  'google/protobuf/type.proto',
  'google/protobuf/wrappers.proto',
];

String wellKnownProtoPathToImports(String importPath) {
  final importPathWithoutExtension = path.withoutExtension(importPath);
  return 'package:protobuf/well_known_types/$importPathWithoutExtension.pb.dart';
}
