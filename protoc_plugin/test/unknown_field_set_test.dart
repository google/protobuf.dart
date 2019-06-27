#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library unknown_field_set_test;

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';

import 'test_util.dart';

void main() {
  TestAllTypes testAllTypes = getAllSet();
  List<int> allFieldsData = testAllTypes.writeToBuffer();
  TestEmptyMessage emptyMessage = TestEmptyMessage.fromBuffer(allFieldsData);
  UnknownFieldSet unknownFields = emptyMessage.unknownFields;

  UnknownFieldSetField getField(String name) {
    int tagNumber = testAllTypes.getTagNumber(name);
    assert(unknownFields.hasField(tagNumber));
    return unknownFields.getField(tagNumber);
  }

  /**
   * Asserts that the given field sets are not equal and have different
   * hash codes.
   *
   * N.B.: It is valid for non-equal objects to have the same hash code, so
   * this test is more strict than necessary. However, in the test cases
   * identifies, the hash codes should differ, and as a matter of principle
   * hash collisions should be relatively rare.
   */
  void _checkNotEqual(UnknownFieldSet s1, UnknownFieldSet s2) {
    expect(s1 == s2, isFalse);
    expect(s2 == s1, isFalse);

    expect(s1.hashCode == s2.hashCode, isFalse,
        reason: '${s1.toString()} should have a different hash code '
            'from ${s2.toString()}');
  }

  /**
   * Asserts that the given field sets are equal and have identical hash codes.
   */
  void _checkEqualsIsConsistent(UnknownFieldSet set) {
    // Object should be equal to itself.
    expect(set, set);

    // Object should be equal to a copy of itself.
    UnknownFieldSet copy = set.clone();
    expect(copy, set);
    expect(set, copy);
  }

  test('testVarint', () {
    UnknownFieldSetField optionalInt32 = getField('optionalInt32');
    expect(optionalInt32.varints[0], expect64(testAllTypes.optionalInt32));
  });

  test('testFixed32', () {
    UnknownFieldSetField optionalFixed32 = getField('optionalFixed32');
    expect(optionalFixed32.fixed32s[0], testAllTypes.optionalFixed32);
  });

  test('testFixed64', () {
    UnknownFieldSetField optionalFixed64 = getField('optionalFixed64');
    expect(optionalFixed64.fixed64s[0], testAllTypes.optionalFixed64);
  });

  test('testLengthDelimited', () {
    UnknownFieldSetField optionalBytes = getField('optionalBytes');
    expect(optionalBytes.lengthDelimited[0], testAllTypes.optionalBytes);
  });

  test('testGroup', () {
    int tagNumberA = TestAllTypes_OptionalGroup().getTagNumber('a');
    expect(tagNumberA != null, isTrue);

    UnknownFieldSetField optionalGroupField = getField('optionalgroup');
    expect(optionalGroupField.groups.length, 1);
    UnknownFieldSet group = optionalGroupField.groups[0];
    expect(group.hasField(tagNumberA), isTrue);
    expect(group.getField(tagNumberA).varints[0],
        expect64(testAllTypes.optionalGroup.a));
  });

  test('testSerialize', () {
    expect(emptyMessage.writeToBuffer(), allFieldsData);
  });

  test('testCopyFrom', () {
    TestEmptyMessage message = emptyMessage.clone();
    expect(message.toString(), emptyMessage.toString());
    expect(emptyMessage.toString().isEmpty, isFalse);
  });

  test('testMergeFrom', () {
    // Source.
    UnknownFieldSet sourceFieldSet = UnknownFieldSet()
      ..addField(2, UnknownFieldSetField()..addVarint(make64(2)))
      ..addField(3, UnknownFieldSetField()..addVarint(make64(3)));

    TestEmptyMessage source = TestEmptyMessage()
      ..mergeUnknownFields(sourceFieldSet);

    // Destination.
    UnknownFieldSet destinationFieldSet = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addVarint(make64(1)))
      ..addField(3, UnknownFieldSetField()..addVarint(make64(4)));

    TestEmptyMessage destination = TestEmptyMessage()
      ..mergeUnknownFields(destinationFieldSet)
      ..mergeFromMessage(source);

    expect(
        destination.toString(),
        '1: 1\n'
        '2: 2\n'
        '3: 4\n'
        '3: 3\n');
  });

  test('testClear', () {
    UnknownFieldSet fsb = unknownFields.clone()..clear();
    expect(fsb.asMap(), isEmpty);
  });

  test('testEmpty', () {
    expect(UnknownFieldSet().asMap(), isEmpty);
  });

  test('testClearMessage', () {
    TestEmptyMessage message = emptyMessage.clone();
    message.clear();
    expect(message.writeToBuffer(), isEmpty);
  });

  test('testParseKnownAndUnknown', () {
    // Test mixing known and unknown fields when parsing.
    UnknownFieldSet fields = unknownFields.clone()
      ..addField(123456, UnknownFieldSetField()..addVarint(make64(654321)));

    CodedBufferWriter writer = CodedBufferWriter();
    fields.writeToCodedBufferWriter(writer);

    TestAllTypes destination = TestAllTypes.fromBuffer(writer.toBuffer());

    assertAllFieldsSet(destination);
    expect(destination.unknownFields.asMap().length, 1);

    UnknownFieldSetField field = destination.unknownFields.getField(123456);
    expect(field.varints.length, 1);
    expect(field.varints[0], expect64(654321));
  });

  // Constructs a protocol buffer which contains fields with all the same
  // numbers as allFieldsData except that each field is some other wire
  // type.
  List<int> getBizarroData() {
    UnknownFieldSet bizarroFields = UnknownFieldSet();

    UnknownFieldSetField varintField = UnknownFieldSetField()
      ..addVarint(make64(1));

    UnknownFieldSetField fixed32Field = UnknownFieldSetField()..addFixed32(1);

    unknownFields.asMap().forEach((int tag, UnknownFieldSetField value) {
      if (value.varints.isEmpty) {
        // Original field is not a varint, so use a varint.
        bizarroFields.addField(tag, varintField);
      } else {
        // Original field *is* a varint, so use something else.
        bizarroFields.addField(tag, fixed32Field);
      }
    });
    CodedBufferWriter writer = CodedBufferWriter();
    bizarroFields.writeToCodedBufferWriter(writer);
    return writer.toBuffer();
  }

  test('testWrongTypeTreatedAsUnknown', () {
    // Test that fields of the wrong wire type are treated like unknown fields
    // when parsing.
    List<int> bizarroData = getBizarroData();
    TestAllTypes allTypesMessage = TestAllTypes.fromBuffer(bizarroData);
    TestEmptyMessage emptyMessage_ = TestEmptyMessage.fromBuffer(bizarroData);
    // All fields should have been interpreted as unknown, so the debug strings
    // should be the same.
    expect(allTypesMessage.toString(), emptyMessage_.toString());
  });

  test('testUnknownExtensions', () {
    // Make sure fields are properly parsed to the UnknownFieldSet even when
    // they are declared as extension numbers.
    TestEmptyMessageWithExtensions message =
        TestEmptyMessageWithExtensions.fromBuffer(allFieldsData);

    expect(message.unknownFields.asMap().length, unknownFields.asMap().length);
    expect(message.writeToBuffer(), allFieldsData);
  });

  test('testWrongExtensionTypeTreatedAsUnknown', () {
    // Test that fields of the wrong wire type are treated like unknown fields
    // when parsing extensions.

    List<int> bizarroData = getBizarroData();
    TestAllExtensions allExtensionsMessage =
        TestAllExtensions.fromBuffer(bizarroData);
    TestEmptyMessage emptyMessage_ = TestEmptyMessage.fromBuffer(bizarroData);

    // All fields should have been interpreted as unknown, so the debug strings
    // should be the same.
    expect(allExtensionsMessage.toString(), emptyMessage_.toString());
  });

  test('testParseUnknownEnumValue', () {
    int singularFieldNum = testAllTypes.getTagNumber('optionalNestedEnum');
    int repeatedFieldNum = testAllTypes.getTagNumber('repeatedNestedEnum');
    expect(singularFieldNum, isNotNull);
    expect(repeatedFieldNum, isNotNull);

    UnknownFieldSet fieldSet = UnknownFieldSet()
      ..addField(
          singularFieldNum,
          UnknownFieldSetField()
            ..addVarint(make64(TestAllTypes_NestedEnum.BAR.value))
            ..addVarint(make64(5)))
      ..addField(
          repeatedFieldNum,
          UnknownFieldSetField()
            ..addVarint(make64(TestAllTypes_NestedEnum.FOO.value))
            ..addVarint(make64(4))
            ..addVarint(make64(TestAllTypes_NestedEnum.BAZ.value))
            ..addVarint(make64(6)));

    CodedBufferWriter writer = CodedBufferWriter();
    fieldSet.writeToCodedBufferWriter(writer);
    {
      TestAllTypes message = TestAllTypes.fromBuffer(writer.toBuffer());
      expect(message.optionalNestedEnum, TestAllTypes_NestedEnum.BAR);
      expect(message.repeatedNestedEnum,
          [TestAllTypes_NestedEnum.FOO, TestAllTypes_NestedEnum.BAZ]);
      final singularVarints =
          message.unknownFields.getField(singularFieldNum).varints;
      expect(singularVarints.length, 1);
      expect(singularVarints[0], expect64(5));
      final repeatedVarints =
          message.unknownFields.getField(repeatedFieldNum).varints;
      expect(repeatedVarints.length, 2);
      expect(repeatedVarints[0], expect64(4));
      expect(repeatedVarints[1], expect64(6));
    }
    {
      TestAllExtensions message = TestAllExtensions.fromBuffer(
          writer.toBuffer(), getExtensionRegistry());
      expect(message.getExtension(Unittest.optionalNestedEnumExtension),
          TestAllTypes_NestedEnum.BAR);

      expect(message.getExtension(Unittest.repeatedNestedEnumExtension),
          [TestAllTypes_NestedEnum.FOO, TestAllTypes_NestedEnum.BAZ]);
      final singularVarints =
          message.unknownFields.getField(singularFieldNum).varints;
      expect(singularVarints.length, 1);
      expect(singularVarints[0], expect64(5));
      final repeatedVarints =
          message.unknownFields.getField(repeatedFieldNum).varints;
      expect(repeatedVarints.length, 2);
      expect(repeatedVarints[0], expect64(4));
      expect(repeatedVarints[1], expect64(6));
    }
  });

  test('testLargeVarint', () {
    UnknownFieldSet unknownFieldSet = UnknownFieldSet()
      ..addField(
          1, UnknownFieldSetField()..addVarint(make64(0x7FFFFFFF, 0xFFFFFFFF)));
    CodedBufferWriter writer = CodedBufferWriter();
    unknownFieldSet.writeToCodedBufferWriter(writer);

    var parsed = UnknownFieldSet()
      ..mergeFromCodedBufferReader(CodedBufferReader(writer.toBuffer()));
    var field = parsed.getField(1);
    expect(field.varints.length, 1);
    expect(field.varints[0], expect64(0x7FFFFFFF, 0xFFFFFFFFF));
  });

  test('testEquals', () {
    UnknownFieldSet a = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addFixed32(1));

    UnknownFieldSet b = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addFixed64(make64(1)));

    UnknownFieldSet c = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addVarint(make64(1)));

    UnknownFieldSet d = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addLengthDelimited([]));

    UnknownFieldSet e = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addGroup(unknownFields));

    _checkEqualsIsConsistent(a);
    _checkEqualsIsConsistent(b);
    _checkEqualsIsConsistent(c);
    _checkEqualsIsConsistent(d);
    _checkEqualsIsConsistent(e);

    _checkNotEqual(a, b);
    _checkNotEqual(a, c);
    _checkNotEqual(a, d);
    _checkNotEqual(a, e);
    _checkNotEqual(b, c);
    _checkNotEqual(b, d);
    _checkNotEqual(b, e);
    _checkNotEqual(c, d);
    _checkNotEqual(c, e);
    _checkNotEqual(d, e);

    UnknownFieldSet f1 = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addLengthDelimited([1, 2]));
    UnknownFieldSet f2 = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addLengthDelimited([2, 1]));

    _checkEqualsIsConsistent(f1);
    _checkEqualsIsConsistent(f2);

    _checkNotEqual(f1, f2);
  });
}
