#!/usr/bin/env dart
// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library map_field_test;

import 'dart:convert';

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/map_field.pb.dart';

void main() {
  void _setValues(TestMap testMap) {
    testMap
      ..int32ToInt32Field[1] = 11
      ..int32ToInt32Field[2] = 22
      ..int32ToInt32Field[3] = 33
      ..int32ToStringField[1] = '11'
      ..int32ToStringField[2] = '22'
      ..int32ToStringField[3] = '33'
      ..int32ToBytesField[1] = utf8.encode('11')
      ..int32ToBytesField[2] = utf8.encode('22')
      ..int32ToBytesField[3] = utf8.encode('33')
      ..int32ToEnumField[1] = TestMap_EnumValue.DEFAULT
      ..int32ToEnumField[2] = TestMap_EnumValue.BAR
      ..int32ToEnumField[3] = TestMap_EnumValue.BAZ
      ..int32ToMessageField[1] = (TestMap_MessageValue()..value = 11)
      ..int32ToMessageField[2] = (TestMap_MessageValue()..value = 22)
      ..int32ToMessageField[3] = (TestMap_MessageValue()..value = 33)
      ..stringToInt32Field['1'] = 11
      ..stringToInt32Field['2'] = 22
      ..stringToInt32Field['3'] = 33;
  }

  void _updateValues(TestMap testMap) {
    testMap
      ..int32ToInt32Field[1] = 111
      ..int32ToInt32Field.remove(2)
      ..int32ToInt32Field[4] = 44
      ..int32ToStringField[1] = '111'
      ..int32ToStringField.remove(2)
      ..int32ToStringField[4] = '44'
      ..int32ToBytesField[1] = utf8.encode('111')
      ..int32ToBytesField.remove(2)
      ..int32ToBytesField[4] = utf8.encode('44')
      ..int32ToEnumField[1] = TestMap_EnumValue.BAR
      ..int32ToEnumField.remove(2)
      ..int32ToEnumField[4] = TestMap_EnumValue.ZOP
      ..int32ToMessageField[1] = (TestMap_MessageValue()..value = 111)
      ..int32ToMessageField.remove(2)
      ..int32ToMessageField[4] = (TestMap_MessageValue()..value = 44)
      ..stringToInt32Field['1'] = 111
      ..stringToInt32Field.remove('2')
      ..stringToInt32Field['4'] = 44;
  }

  void _expectEmpty(TestMap testMap) {
    expect(testMap.int32ToInt32Field, isEmpty);
    expect(testMap.int32ToStringField, isEmpty);
    expect(testMap.int32ToBytesField, isEmpty);
    expect(testMap.int32ToEnumField, isEmpty);
    expect(testMap.int32ToMessageField, isEmpty);
    expect(testMap.stringToInt32Field, isEmpty);
  }

  void _expectMapValuesSet(TestMap testMap) {
    expect(testMap.int32ToInt32Field[1], 11);
    expect(testMap.int32ToInt32Field[2], 22);
    expect(testMap.int32ToInt32Field[3], 33);

    expect(testMap.int32ToStringField[1], '11');
    expect(testMap.int32ToStringField[2], '22');
    expect(testMap.int32ToStringField[3], '33');

    expect(testMap.int32ToBytesField[1], utf8.encode('11'));
    expect(testMap.int32ToBytesField[2], utf8.encode('22'));
    expect(testMap.int32ToBytesField[3], utf8.encode('33'));

    expect(testMap.int32ToEnumField[1], TestMap_EnumValue.DEFAULT);
    expect(testMap.int32ToEnumField[2], TestMap_EnumValue.BAR);
    expect(testMap.int32ToEnumField[3], TestMap_EnumValue.BAZ);

    expect(testMap.int32ToMessageField[1].value, 11);
    expect(testMap.int32ToMessageField[2].value, 22);
    expect(testMap.int32ToMessageField[3].value, 33);

    expect(testMap.stringToInt32Field['1'], 11);
    expect(testMap.stringToInt32Field['2'], 22);
    expect(testMap.stringToInt32Field['3'], 33);
  }

  void _expectMapValuesUpdated(TestMap testMap) {
    expect(testMap.int32ToInt32Field.length, 3);
    expect(testMap.int32ToInt32Field[1], 111);
    expect(testMap.int32ToInt32Field[3], 33);
    expect(testMap.int32ToInt32Field[4], 44);

    expect(testMap.int32ToStringField.length, 3);
    expect(testMap.int32ToStringField[1], '111');
    expect(testMap.int32ToStringField[3], '33');
    expect(testMap.int32ToStringField[4], '44');

    expect(testMap.int32ToBytesField.length, 3);
    expect(testMap.int32ToBytesField[1], utf8.encode('111'));
    expect(testMap.int32ToBytesField[3], utf8.encode('33'));
    expect(testMap.int32ToBytesField[4], utf8.encode('44'));

    expect(testMap.int32ToEnumField.length, 3);
    expect(testMap.int32ToEnumField[1], TestMap_EnumValue.BAR);
    expect(testMap.int32ToEnumField[3], TestMap_EnumValue.BAZ);
    expect(testMap.int32ToEnumField[4], TestMap_EnumValue.ZOP);

    expect(testMap.int32ToMessageField.length, 3);
    expect(testMap.int32ToMessageField[1].value, 111);
    expect(testMap.int32ToMessageField[3].value, 33);
    expect(testMap.int32ToMessageField[4].value, 44);

    expect(testMap.stringToInt32Field.length, 3);
    expect(testMap.stringToInt32Field['1'], 111);
    expect(testMap.stringToInt32Field['3'], 33);
    expect(testMap.stringToInt32Field['4'], 44);
  }

  test('set and clear values', () {
    TestMap testMap = TestMap();
    _expectEmpty(testMap);

    _setValues(testMap);
    _expectMapValuesSet(testMap);

    testMap.clear();
    _expectEmpty(testMap);
  });

  test('update map values', () {
    TestMap testMap = TestMap();
    _setValues(testMap);
    _updateValues(testMap);
    _expectMapValuesUpdated(testMap);
  });

  test('null keys and value are not allowed', () {
    TestMap testMap = TestMap();

    try {
      testMap.stringToInt32Field[null] = 1;
      fail('Should have thrown an exception.');
    } on ArgumentError catch (e) {
      expect(e.message, "Can't add a null to a map field");
    }

    try {
      testMap.int32ToBytesField[1] = null;
      fail('Should have thrown an exception.');
    } on ArgumentError catch (e) {
      expect(e.message, "Can't add a null to a map field");
    }

    try {
      testMap.int32ToStringField[1] = null;
      fail('Should have thrown an exception.');
    } on ArgumentError catch (e) {
      expect(e.message, "Can't add a null to a map field");
    }

    try {
      testMap.int32ToEnumField[1] = null;
      fail('Should have thrown an exception.');
    } on ArgumentError catch (e) {
      expect(e.message, "Can't add a null to a map field");
    }

    try {
      testMap.int32ToMessageField[1] = null;
      fail('Should have thrown an exception.');
    } on ArgumentError catch (e) {
      expect(e.message, "Can't add a null to a map field");
    }
  });

  test('Serialize and parse map', () {
    TestMap testMap = TestMap();
    _setValues(testMap);

    testMap = TestMap.fromBuffer(testMap.writeToBuffer());
    _expectMapValuesSet(testMap);

    _updateValues(testMap);
    testMap = TestMap.fromBuffer(testMap.writeToBuffer());
    _expectMapValuesUpdated(testMap);

    testMap.clear();
    testMap = TestMap.fromBuffer(testMap.writeToBuffer());
    _expectEmpty(testMap);
  });

  test('json serialize map', () {
    TestMap testMap = TestMap();
    _setValues(testMap);

    testMap = TestMap.fromJson(testMap.writeToJson());
    _expectMapValuesSet(testMap);

    _updateValues(testMap);
    testMap = TestMap.fromJson(testMap.writeToJson());
    _expectMapValuesUpdated(testMap);

    testMap.clear();
    testMap = TestMap.fromJson(testMap.writeToJson());
    _expectEmpty(testMap);
  });

  test(
      'PbMap` is equal to another PbMap with equal key/value pairs in any order',
      () {
    TestMap t = TestMap()
      ..int32ToStringField[2] = 'test2'
      ..int32ToStringField[1] = 'test';
    TestMap t2 = TestMap()
      ..int32ToStringField[1] = 'test'
      ..int32ToStringField[2] = 'test2';
    TestMap t3 = TestMap()..int32ToStringField[1] = 'test';

    PbMap<int, String> m = t.int32ToStringField;
    PbMap<int, String> m2 = t2.int32ToStringField;
    PbMap<int, String> m3 = t3.int32ToStringField;

    expect(t, t2);
    expect(t.hashCode, t2.hashCode);

    expect(m, m2);
    expect(m == m2, isTrue);
    expect(m.hashCode, m2.hashCode);

    expect(m, isNot(m3));
    expect(m == m3, isFalse);
    expect(m.hashCode, isNot(m3.hashCode));
  });

  test('merge from other message', () {
    TestMap testMap = TestMap();
    _setValues(testMap);

    TestMap other = TestMap();
    other.mergeFromMessage(testMap);
    _expectMapValuesSet(other);

    testMap = TestMap()
      ..int32ToMessageField[1] = (TestMap_MessageValue()..value = 42)
      ..int32ToMessageField[2] = (TestMap_MessageValue()..value = 44);
    other = TestMap()
      ..int32ToMessageField[1] = (TestMap_MessageValue()..secondValue = 43);
    testMap.mergeFromMessage(other);

    expect(testMap.int32ToMessageField[1].value, 0);
    expect(testMap.int32ToMessageField[1].secondValue, 43);
    expect(testMap.int32ToMessageField[2].value, 44);
  });

  test('parse duplicate keys', () {
    TestMap testMap = TestMap()..int32ToStringField[1] = 'foo';
    TestMap testMap2 = TestMap()..int32ToStringField[1] = 'bar';

    TestMap merge = TestMap.fromBuffer(
        []..addAll(testMap.writeToBuffer())..addAll(testMap2.writeToBuffer()));

    // When parsing from the wire, if there are duplicate map keys the last key
    // seen should be used.
    expect(merge.int32ToStringField.length, 1);
    expect(merge.int32ToStringField[1], 'bar');
  });

  test('Deep merge from other message', () {
    Inner i1 = Inner()..innerMap['a'] = 'a';
    Inner i2 = Inner()..innerMap['b'] = 'b';

    Outer o1 = Outer()..i = i1;
    Outer o2 = Outer()..i = i2;

    o1.mergeFromMessage(o2);
    expect(o1.i.innerMap.length, 2);
  });

  test('retain explicit default values of sub-messages', () {
    TestMap testMap = TestMap()
      ..int32ToMessageField[1] = TestMap_MessageValue();
    expect(testMap.int32ToMessageField[1].secondValue, 42);

    TestMap testMap2 = TestMap()
      ..int32ToMessageField[2] = TestMap_MessageValue();

    testMap.mergeFromBuffer(testMap2.writeToBuffer());
    expect(testMap.int32ToMessageField[2].secondValue, 42);
  });

  test('Freeze message with map field', () {
    TestMap testMap = TestMap();
    _setValues(testMap);
    testMap.freeze();

    expect(() => _updateValues(testMap),
        throwsA(const TypeMatcher<UnsupportedError>()));
    expect(() => testMap.int32ToMessageField[1].value = 42,
        throwsA(const TypeMatcher<UnsupportedError>()));
    expect(() => testMap.int32ToStringField.remove(1),
        throwsA(const TypeMatcher<UnsupportedError>()));
    expect(() => testMap.int32ToStringField.clear(),
        throwsA(const TypeMatcher<UnsupportedError>()));
  });

  test('Values for different keys are not merged together when decoding', () {
    TestMap testMap = TestMap();
    testMap.int32ToMessageField[1] = (TestMap_MessageValue()..value = 11);
    testMap.int32ToMessageField[2] = (TestMap_MessageValue()..secondValue = 12);

    void testValues(TestMap candidate) {
      final message1 = candidate.int32ToMessageField[1];
      final message2 = candidate.int32ToMessageField[2];

      expect(message1.hasValue(), true);
      expect(message1.value, 11);
      expect(message1.hasSecondValue(), false);
      expect(message1.secondValue, 42);
      expect(message2.hasValue(), false);
      expect(message2.value, 0);
      expect(message2.hasSecondValue(), true);
      expect(message2.secondValue, 12);
    }

    testValues(TestMap.fromBuffer(testMap.writeToBuffer()));
    testValues(TestMap.fromJson(testMap.writeToJson()));
  });
}
