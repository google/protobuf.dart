// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import '../protoc.dart';
import '../src/generated/descriptor.pb.dart';

const protobufImportPrefix = r'$pb';
const asyncImportPrefix = r'$async';
const coreImportPrefix = r'$core';
const grpcImportPrefix = r'$grpc';
const fixnumImportPrefix = r'$fixnum';
const mixinImportPrefix = r'$mixin';

extension FileDescriptorProtoExt on FileGenerator {
  bool _listEquals(List<int> a, List<int> b) {
    if (a.length != b.length) {
      return false;
    }
    // Note: paths are much likely to share common prefixes than to share common
    // suffixes, so it's probably faster to run this loop backwards ;)
    for (var i = a.length - 1; i >= 0; i--) {
      if (a[i] != b[i]) {
        return false;
      }
    }
    return true;
  }

  /// Convert leading comments of a definition at [path] to Dart doc comment
  /// syntax.
  ///
  /// This never returns an empty string: if the comment is empty it returns
  /// `null`.
  ///
  /// The output can contain multiple lines. None of the lines will have
  /// trailing whitespace.
  String? commentBlock(List<int> path) {
    SourceCodeInfo_Location? singleMatch;
    for (final location in descriptor.sourceCodeInfo.location) {
      if (_listEquals(location.path, path)) {
        if (singleMatch == null) {
          singleMatch = location;
        } else {
          // TODO: evaluate if we should just concatenate all of the matching
          // entries.
          stderr.writeln('Too many source code locations. Skipping.');
          return null;
        }
      }
    }

    if (singleMatch != null) {
      return toDartComment(singleMatch.leadingComments);
    }

    return null;
  }
}

/// Convert a comment to Dart doc comment syntax.
///
/// This is the internal method for [FileDescriptorProtoExt.commentBlock],
/// public to be able to test.
String? toDartComment(String value) {
  // TODO: Handle converting proto references to Dart references.
  // "[Foo][google.firestore.v1.Foo]" => to either "`Foo`" or "[Foo]".

  if (value.isEmpty) return null;

  var lines = LineSplitter.split(value).toList();

  // Find any leading spaces in the first line. If all of the lines have the
  // same leading spaces, remove them all.
  final leadingSpaces = _leadingSpaces.firstMatch(lines.first);
  if (leadingSpaces != null) {
    final prefix = leadingSpaces.group(0)!;
    if (lines.every((line) => line.isEmpty || line.startsWith(prefix))) {
      lines = lines
          .map((line) => line.isEmpty ? line : line.substring(prefix.length))
          .toList();
    }
  }

  // Remove empty, trailing lines.
  while (lines.isNotEmpty && lines.last.trim().isEmpty) {
    lines.removeLast();
  }

  // Don't generate a documentation comment if all lines are empty.
  if (lines.isEmpty) {
    return null;
  }

  return lines.map((e) => '/// $e'.trimRight()).join('\n');
}

final _leadingSpaces = RegExp('^ +');
