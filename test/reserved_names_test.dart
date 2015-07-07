#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library reserved_names_test;

import 'package:unittest/unittest.dart' show test, expect, equals;

import 'package:protobuf/meta.dart' show GeneratedMessage_reservedNames;
import 'package:protobuf/mixins_meta.dart' show findMixin; 

import 'mirror_util.dart' show findMemberNames;

void main() {

  test('GeneratedMessage reserved names are up to date', () {
    var actual = new Set<String>.from(GeneratedMessage_reservedNames);
    var expected = 
      findMemberNames('package:protobuf/protobuf.dart', #GeneratedMessage);

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });

  test('PbMapMixin reserved names are up to date', () {
    var meta = findMixin("PbMapMixin");
    var actual = new Set<String>.from(meta.findReservedNames());

    var expected = findMemberNames(meta.importFrom, #PbMapMixin)
      ..addAll(findMemberNames("dart:collection", #MapMixin))
      ..removeAll(GeneratedMessage_reservedNames);

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });
}
