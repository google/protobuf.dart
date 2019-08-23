#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn("vm")
library reserved_names_test;

import 'package:test/test.dart';

import 'package:protobuf/meta.dart'
    show GeneratedMessage_reservedNames, ProtobufEnum_reservedNames;
import 'package:protoc_plugin/mixins.dart' show findMixin;

import 'mirror_util.dart' show findMemberNames;

// Import the libraries we will access via the mirrors.
// ignore_for_file: unused_import
import 'package:protobuf/protobuf.dart' show GeneratedMessage, ProtobufEnum;
import 'package:protobuf/src/protobuf/mixins/event_mixin.dart'
    show PbEventMixin;
import 'package:protobuf/src/protobuf/mixins/map_mixin.dart' show PbMapMixin;
import 'dart:collection' show MapMixin;

import 'dart:mirrors';

void main() {
  test('GeneratedMessage reserved names are up to date', () {
    var actual = Set<String>.from(GeneratedMessage_reservedNames);
    var expected =
        findMemberNames('package:protobuf/protobuf.dart', #GeneratedMessage);

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });

  test('ProtobufEnum reserved names are up to date', () {
    var actual = Set<String>.from(ProtobufEnum_reservedNames);
    var expected =
        findMemberNames('package:protobuf/protobuf.dart', #ProtobufEnum);

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });

  test("ReadonlyMessageMixin doesn't add any reserved names", () {
    var mixinNames = findMemberNames(
        'package:protobuf/protobuf.dart', #ReadonlyMessageMixin);
    var reservedNames = Set<String>.from(GeneratedMessage_reservedNames);
    for (var name in mixinNames) {
      if (name == "ReadonlyMessageMixin" || name == "unknownFields") continue;
      if (!reservedNames.contains(name)) {
        fail("name from ReadonlyMessageMixin is not reserved: ${name}");
      }
    }
  });

  test('PbMapMixin reserved names are up to date', () {
    var meta = findMixin("PbMapMixin");
    var actual = Set<String>.from(meta.findReservedNames());

    var expected = findMemberNames(meta.importFrom, #PbMapMixin)
      ..addAll(findMemberNames("dart:collection", #MapMixin))
      ..removeAll(GeneratedMessage_reservedNames);

    expect(
        actual.toList()..sort(), containsAllInOrder(expected.toList()..sort()));
  });

  test('PbEventMixin reserved names are up to date', () {
    var meta = findMixin("PbEventMixin");
    var actual = Set<String>.from(meta.findReservedNames());

    var expected = findMemberNames(meta.importFrom, #PbEventMixin)
      ..removeAll(GeneratedMessage_reservedNames);

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });
}
