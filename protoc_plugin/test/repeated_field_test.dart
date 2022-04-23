#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';

Matcher throwsError(Type expectedType, Matcher expectedMessage) =>
    throwsA(predicate((dynamic x) {
      expect(x.runtimeType, expectedType);
      expect(x!.message, expectedMessage);
      return true;
    }));

void main() {
  test('check properties are initialized for repeated fields', () {
    var msg = TestAllTypes();
    expect(
        (msg.info_.byName['repeatedNestedMessage']
                as FieldInfo<TestAllTypes_NestedMessage>)
            .check,
        isNotNull);

    expect(
        (msg.info_.byName['repeatedgroup']
                as FieldInfo<TestAllTypes_RepeatedGroup>)
            .check,
        isNotNull);

    expect(
        (msg.info_.byName['repeatedNestedEnum']
                as FieldInfo<TestAllTypes_NestedEnum>)
            .check,
        isNotNull);
  });

  test('test repeated field freezing', () {
    var msg = TestAllTypes();
    var list = msg.repeatedNestedMessage;
    msg.freeze();
    expect(() => list.add(TestAllTypes_NestedMessage.create()),
        throwsError(UnsupportedError, equals('`add` on a read-only list')));
  });
}
