// Copyright (c) 2021, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import '../protoc.dart';

const protobufImportPrefix = r'$pb';
const asyncImportPrefix = r'$async';
const coreImportPrefix = r'$core';
const grpcImportPrefix = r'$grpc';
const mixinImportPrefix = r'$mixin';

extension FileDescriptorProtoExt on FileGenerator {
  String? commentBlock(List<int> path) {
    if (!options.generateComments) {
      return null;
    }

    final bits = descriptor.sourceCodeInfo.location
        .where((element) => element.path.toString() == path.toString())
        .toList();

    if (bits.length == 1) {
      final match = bits.single;
      if (match.hasLeadingComments()) {
        return toDartComment(match.leadingComments);
      }
    }

    if (bits.length > 1) {
      throw 'WTH? ${descriptor.sourceCodeInfo.toProto3Json()}';
    }

    return null;
  }
}

String? toDartComment(String value) {
  if (value.isNotEmpty) {
    var lines = LineSplitter.split(value).toList();

    final leadingSpaces = _leadingSpaces.firstMatch(lines.first);
    if (leadingSpaces != null) {
      final prefix = leadingSpaces.group(0)!;
      if (lines.every((element) => element.startsWith(prefix))) {
        lines = lines.map((e) => e.substring(prefix.length)).toList();
      }
    }

    while (lines.last.isEmpty) {
      lines.removeLast();
    }

    return lines.map((e) => '/// $e'.trimRight()).join('\n');
  }

  return null;
}

final _leadingSpaces = RegExp('^ +');
