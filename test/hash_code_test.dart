#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library hash_code_tests;

import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';

void main() {
  test('testHashCodeEmptyMessage', () {
    var m1 = new TestAllTypes();
    var m2 = new TestAllTypes();
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeOptionalInt32', () {
    var m1 = new TestAllTypes()..optionalInt32 = 42;
    var m2 = new TestAllTypes()..optionalInt32 = 42;
    expect(m1.hashCode, m2.hashCode);

    m1.optionalInt32 = 43;
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.optionalInt32 = 43;
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeOptionalInt64', () {
    var m1 = new TestAllTypes()..optionalInt64 = new Int64(42);
    var m2 = new TestAllTypes()..optionalInt64 = new Int64(42);
    expect(m1.hashCode, m2.hashCode);

    m1.optionalInt64 = new Int64(43);
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.optionalInt64 = new Int64(43);
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeOptionalString', () {
    var m1 = new TestAllTypes()..optionalString = "Dart";
    var m2 = new TestAllTypes()..optionalString = "Dart";
    expect(m1.hashCode, m2.hashCode);

    m1.optionalString = "JavaScript";
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.optionalString = "JavaScript";
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeOptionalEnum', () {
    var m1 = new TestAllTypes()
      ..optionalNestedEnum = TestAllTypes_NestedEnum.BAR;
    var m2 = new TestAllTypes()
      ..optionalNestedEnum = TestAllTypes_NestedEnum.BAR;
    expect(m1.hashCode, m2.hashCode);

    m1.optionalNestedEnum = TestAllTypes_NestedEnum.BAZ;
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.optionalNestedEnum = TestAllTypes_NestedEnum.BAZ;
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeRepeatedInt32', () {
    var m1 = new TestAllTypes();
    var m2 = new TestAllTypes();
    m1.repeatedInt32.add(42);
    m2.repeatedInt32.add(42);
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeRepeatedInt64', () {
    var m1 = new TestAllTypes();
    var m2 = new TestAllTypes();
    m1.repeatedInt32.add(42);
    m2.repeatedInt32.add(42);
    expect(m1.hashCode, m2.hashCode);

    m1.repeatedInt32.add(43);
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.repeatedInt32.add(43);
    expect(m1.hashCode, m2.hashCode);

    m1.repeatedInt32.clear();
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.repeatedInt32.clear();
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeRepeatedString', () {
    var m1 = new TestAllTypes();
    var m2 = new TestAllTypes();
    m1.repeatedString.add("Dart");
    m2.repeatedString.add("Dart");
    expect(m1.hashCode, m2.hashCode);

    m1.repeatedString.add("JavaScript");
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.repeatedString.add("JavaScript");
    expect(m1.hashCode, m2.hashCode);

    m1.repeatedString.clear();
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.repeatedString.clear();
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeRepeatedEnum', () {
    var m1 = new TestAllTypes();
    var m2 = new TestAllTypes();
    m1.repeatedNestedEnum.add(TestAllTypes_NestedEnum.BAR);
    m2.repeatedNestedEnum.add(TestAllTypes_NestedEnum.BAR);
    expect(m1.hashCode, m2.hashCode);

    m1.repeatedNestedEnum.add(TestAllTypes_NestedEnum.BAZ);
    expect(m1.hashCode, isNot(m2.hashCode));

    m2.repeatedNestedEnum.add(TestAllTypes_NestedEnum.BAZ);
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeUnknownFields', () {
    var m1 = new TestAllTypes();
    var m2 = new TestAllTypes();
    m1.unknownFields.mergeVarintField(12345, new Int64(123));
    m2.unknownFields.mergeVarintField(12345, new Int64(123));
    expect(m1.hashCode, m2.hashCode);
  });

  test('testHashCodeCombined', () {
    var m1 = new TestAllTypes()
      ..optionalInt32 = 42
      ..optionalInt64 = new Int64(42)
      ..optionalString = "Dart"
      ..optionalNestedEnum = TestAllTypes_NestedEnum.BAR;
    var m2 = new TestAllTypes()
      ..optionalInt32 = 42
      ..optionalInt64 = new Int64(42)
      ..optionalString = "Dart"
      ..optionalNestedEnum = TestAllTypes_NestedEnum.BAR;
    expect(m1.hashCode, m2.hashCode);

    m1.repeatedInt32..add(42)..add(43);
    m2.repeatedInt32..add(42)..add(43);
    m1.repeatedInt64..add(new Int64(42))..add(new Int64(43));
    m2.repeatedInt64..add(new Int64(42))..add(new Int64(43));
    m1.repeatedString..add("Dart")..add("JavaScript");
    m2.repeatedString..add("Dart")..add("JavaScript");
    m1.repeatedNestedEnum
      ..add(TestAllTypes_NestedEnum.BAR)
      ..add(TestAllTypes_NestedEnum.BAZ);
    m2.repeatedNestedEnum
      ..add(TestAllTypes_NestedEnum.BAR)
      ..add(TestAllTypes_NestedEnum.BAZ);
    expect(m1.hashCode, m2.hashCode);

    m1.unknownFields.mergeVarintField(12345, new Int64(123));
    m2.unknownFields.mergeVarintField(12345, new Int64(123));
    expect(m1.hashCode, m2.hashCode);
    expect(m1.hashCode, m2.hashCode);
  });
}
