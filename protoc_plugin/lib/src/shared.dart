// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import '../protoc.dart';

const protobufImportPrefix = r'$pb';
const asyncImportPrefix = r'$async';
const coreImportPrefix = r'$core';
const grpcImportPrefix = r'$grpc';
const mixinImportPrefix = r'$mixin';

extension FileDescriptorProtoExt on FileGenerator {
  String? commentBlock(List<int> path) {
    final bits = descriptor.sourceCodeInfo.location
        .where((element) => element.path.toString() == path.toString())
        .toList();

    if (bits.length == 1) {
      final match = bits.single;
      return toDartComment(match.leadingComments);
    }

    if (bits.length > 1) {
      // TODO: evaluate if we should just concatenate all of the entries.
      stderr.writeln('Too many source code locations. Skipping.');
    }

    return null;
  }
}

String? toDartComment(String value) {
  if (value.isEmpty) return null;

  var lines = LineSplitter.split(value).toList();

  // Find any leading spaces in the first line.
  // If all of the lines have the same leading spaces, remove them all.
  final leadingSpaces = _leadingSpaces.firstMatch(lines.first);
  if (leadingSpaces != null) {
    final prefix = leadingSpaces.group(0)!;
    if (lines.every((element) => element.startsWith(prefix))) {
      lines = lines.map((e) => e.substring(prefix.length)).toList();
    }
  }

  // Remove empty, trailing lines
  while (lines.last.isEmpty) {
    lines.removeLast();
  }

  return lines.map((e) => '/// $e'.trimRight()).join('\n');
}

final _leadingSpaces = RegExp('^ +');
