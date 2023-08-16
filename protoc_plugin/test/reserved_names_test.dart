// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection' show MapMixin;
import 'dart:mirrors';

import 'package:protobuf/meta.dart'
    show GeneratedMessage_reservedNames, ProtobufEnum_reservedNames;
// Import the libraries we will access via the mirrors.
// ignore_for_file: unused_import
import 'package:protobuf/protobuf.dart' show GeneratedMessage, ProtobufEnum;
import 'package:protobuf/src/protobuf/mixins/event_mixin.dart'
    show PbEventMixin;
import 'package:protobuf/src/protobuf/mixins/map_mixin.dart' show PbMapMixin;
import 'package:protoc_plugin/mixins.dart' show findMixin;
import 'package:test/test.dart';

import 'mirror_util.dart' show findMemberNames;

void main() {
  test('GeneratedMessage reserved names are up to date', () {
    final actual = Set<String>.from(GeneratedMessage_reservedNames);
    final expected =
        findMemberNames('package:protobuf/protobuf.dart', #GeneratedMessage);

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });

  test('ProtobufEnum reserved names are up to date', () {
    final actual = Set<String>.from(ProtobufEnum_reservedNames);
    final expected =
        findMemberNames('package:protobuf/protobuf.dart', #ProtobufEnum);

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });

  test("ReadonlyMessageMixin doesn't add any reserved names", () {
    final mixinNames = findMemberNames(
        'package:protobuf/protobuf.dart', #ReadonlyMessageMixin);
    final reservedNames = Set<String>.from(GeneratedMessage_reservedNames);
    for (final name in mixinNames) {
      if (name == 'ReadonlyMessageMixin' || name == 'unknownFields') continue;
      if (!reservedNames.contains(name)) {
        fail('name from ReadonlyMessageMixin is not reserved: $name');
      }
    }
  });

  test('PbMapMixin reserved names are up to date', () {
    final meta = findMixin('PbMapMixin')!;
    final actual = Set<String>.from(meta.findReservedNames());

    final expected = findMemberNames(meta.importFrom, #PbMapMixin)
      ..addAll(findMemberNames('dart:collection', #MapMixin))
      ..removeAll(GeneratedMessage_reservedNames);

    expect(
        actual.toList()..sort(), containsAllInOrder(expected.toList()..sort()));
  });

  test('PbEventMixin reserved names are up to date', () {
    final meta = findMixin('PbEventMixin')!;
    final actual = Set<String>.from(meta.findReservedNames());

    final expected = findMemberNames(meta.importFrom, #PbEventMixin)
      ..removeAll(GeneratedMessage_reservedNames);

    expect(
        actual.toList()..sort(), containsAllInOrder(expected.toList()..sort()));
  });
}
