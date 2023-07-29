// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';
import 'test_util.dart';

void main() {
  final testAllTypes = getAllSet();
  final List<int> allFieldsData = testAllTypes.writeToBuffer();
  final emptyMessage = TestEmptyMessage.fromBuffer(allFieldsData);
  final unknownFields = emptyMessage.unknownFields;

  UnknownFieldSetField getField(String name) {
    final tagNumber = testAllTypes.getTagNumber(name)!;
    assert(unknownFields.hasField(tagNumber));
    return unknownFields.getField(tagNumber)!;
  }

  // Asserts that the given field sets are not equal and have different
  // hash codes.
  //
  // N.B.: It is valid for non-equal objects to have the same hash code, so
  // this test is more strict than necessary. However, in the test cases
  // identifies, the hash codes should differ, and as a matter of principle
  // hash collisions should be relatively rare.
  void checkNotEqual(UnknownFieldSet s1, UnknownFieldSet s2) {
    expect(s1 == s2, isFalse);
    expect(s2 == s1, isFalse);

    expect(s1.hashCode == s2.hashCode, isFalse,
        reason: '${s1.toString()} should have a different hash code '
            'from ${s2.toString()}');
  }

  // Asserts that the given field sets are equal and have identical hash codes.
  void checkEqualsIsConsistent(UnknownFieldSet set) {
    // Object should be equal to itself.
    expect(set, set);

    // Object should be equal to a copy of itself.
    final copy = set.clone();
    expect(copy, set);
    expect(set, copy);
  }

  test('testVarint', () {
    final optionalInt32 = getField('optionalInt32');
    expect(optionalInt32.varints[0], expect64(testAllTypes.optionalInt32));
  });

  test('testFixed32', () {
    final optionalFixed32 = getField('optionalFixed32');
    expect(optionalFixed32.fixed32s[0], testAllTypes.optionalFixed32);
  });

  test('testFixed64', () {
    final optionalFixed64 = getField('optionalFixed64');
    expect(optionalFixed64.fixed64s[0], testAllTypes.optionalFixed64);
  });

  test('testLengthDelimited', () {
    final optionalBytes = getField('optionalBytes');
    expect(optionalBytes.lengthDelimited[0], testAllTypes.optionalBytes);
  });

  test('testGroup', () {
    final tagNumberA = TestAllTypes_OptionalGroup().getTagNumber('a')!;

    final optionalGroupField = getField('optionalgroup');
    expect(optionalGroupField.groups.length, 1);
    final group = optionalGroupField.groups[0];
    expect(group.hasField(tagNumberA), isTrue);
    expect(group.getField(tagNumberA)!.varints[0],
        expect64(testAllTypes.optionalGroup.a));
  });

  test('testSerialize', () {
    expect(emptyMessage.writeToBuffer(), allFieldsData);
  });

  test('testCopyFrom', () {
    final message = emptyMessage.deepCopy();
    expect(message.toString(), emptyMessage.toString());
    expect(emptyMessage.toString().isEmpty, isFalse);
  });

  test('testMergeFrom', () {
    // Source.
    final sourceFieldSet = UnknownFieldSet()
      ..addField(2, UnknownFieldSetField()..addVarint(make64(2)))
      ..addField(3, UnknownFieldSetField()..addVarint(make64(3)));

    final source = TestEmptyMessage()..mergeUnknownFields(sourceFieldSet);

    // Destination.
    final destinationFieldSet = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addVarint(make64(1)))
      ..addField(3, UnknownFieldSetField()..addVarint(make64(4)));

    final destination = TestEmptyMessage()
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
    final fsb = unknownFields.clone()..clear();
    expect(fsb.asMap(), isEmpty);
  });

  test('testEmpty', () {
    expect(UnknownFieldSet().asMap(), isEmpty);
  });

  test('testClearMessage', () {
    final message = emptyMessage.deepCopy();
    message.clear();
    expect(message.writeToBuffer(), isEmpty);
  });

  test('testParseKnownAndUnknown', () {
    // Test mixing known and unknown fields when parsing.
    final fields = unknownFields.clone()
      ..addField(123456, UnknownFieldSetField()..addVarint(make64(654321)));

    final writer = CodedBufferWriter();
    fields.writeToCodedBufferWriter(writer);

    final destination = TestAllTypes.fromBuffer(writer.toBuffer());

    assertAllFieldsSet(destination);
    expect(destination.unknownFields.asMap().length, 1);

    final field = destination.unknownFields.getField(123456)!;
    expect(field.varints.length, 1);
    expect(field.varints[0], expect64(654321));
  });

  // Constructs a protocol buffer which contains fields with all the same
  // numbers as allFieldsData except that each field is some other wire
  // type.
  List<int> getBizarroData() {
    final bizarroFields = UnknownFieldSet();

    final varintField = UnknownFieldSetField()..addVarint(make64(1));

    final fixed32Field = UnknownFieldSetField()..addFixed32(1);

    unknownFields.asMap().forEach((int tag, UnknownFieldSetField value) {
      if (value.varints.isEmpty) {
        // Original field is not a varint, so use a varint.
        bizarroFields.addField(tag, varintField);
      } else {
        // Original field *is* a varint, so use something else.
        bizarroFields.addField(tag, fixed32Field);
      }
    });
    final writer = CodedBufferWriter();
    bizarroFields.writeToCodedBufferWriter(writer);
    return writer.toBuffer();
  }

  test('testWrongTypeTreatedAsUnknown', () {
    // Test that fields of the wrong wire type are treated like unknown fields
    // when parsing.
    final bizarroData = getBizarroData();
    final allTypesMessage = TestAllTypes.fromBuffer(bizarroData);
    final emptyMessage_ = TestEmptyMessage.fromBuffer(bizarroData);
    // All fields should have been interpreted as unknown, so the debug strings
    // should be the same.
    expect(allTypesMessage.toString(), emptyMessage_.toString());
  });

  test('testUnknownExtensions', () {
    // Make sure fields are properly parsed to the UnknownFieldSet even when
    // they are declared as extension numbers.
    final message = TestEmptyMessageWithExtensions.fromBuffer(allFieldsData);

    expect(message.unknownFields.asMap().length, unknownFields.asMap().length);
    expect(message.writeToBuffer(), allFieldsData);
  });

  test('testWrongExtensionTypeTreatedAsUnknown', () {
    // Test that fields of the wrong wire type are treated like unknown fields
    // when parsing extensions.

    final bizarroData = getBizarroData();
    final allExtensionsMessage = TestAllExtensions.fromBuffer(bizarroData);
    final emptyMessage_ = TestEmptyMessage.fromBuffer(bizarroData);

    // All fields should have been interpreted as unknown, so the debug strings
    // should be the same.
    expect(allExtensionsMessage.toString(), emptyMessage_.toString());
  });

  test('testParseUnknownEnumValue', () {
    final singularFieldNum = testAllTypes.getTagNumber('optionalNestedEnum')!;
    final repeatedFieldNum = testAllTypes.getTagNumber('repeatedNestedEnum')!;
    expect(singularFieldNum, isNotNull);
    expect(repeatedFieldNum, isNotNull);

    final fieldSet = UnknownFieldSet()
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

    final writer = CodedBufferWriter();
    fieldSet.writeToCodedBufferWriter(writer);
    {
      final message = TestAllTypes.fromBuffer(writer.toBuffer());
      expect(message.optionalNestedEnum, TestAllTypes_NestedEnum.BAR);
      expect(message.repeatedNestedEnum,
          [TestAllTypes_NestedEnum.FOO, TestAllTypes_NestedEnum.BAZ]);
      final singularVarints =
          message.unknownFields.getField(singularFieldNum)!.varints;
      expect(singularVarints.length, 1);
      expect(singularVarints[0], expect64(5));
      final repeatedVarints =
          message.unknownFields.getField(repeatedFieldNum)!.varints;
      expect(repeatedVarints.length, 2);
      expect(repeatedVarints[0], expect64(4));
      expect(repeatedVarints[1], expect64(6));
    }
    {
      final message = TestAllExtensions.fromBuffer(
          writer.toBuffer(), getExtensionRegistry());
      expect(message.getExtension(Unittest.optionalNestedEnumExtension),
          TestAllTypes_NestedEnum.BAR);

      expect(message.getExtension(Unittest.repeatedNestedEnumExtension),
          [TestAllTypes_NestedEnum.FOO, TestAllTypes_NestedEnum.BAZ]);
      final singularVarints =
          message.unknownFields.getField(singularFieldNum)!.varints;
      expect(singularVarints.length, 1);
      expect(singularVarints[0], expect64(5));
      final repeatedVarints =
          message.unknownFields.getField(repeatedFieldNum)!.varints;
      expect(repeatedVarints.length, 2);
      expect(repeatedVarints[0], expect64(4));
      expect(repeatedVarints[1], expect64(6));
    }
  });

  test('testLargeVarint', () {
    final unknownFieldSet = UnknownFieldSet()
      ..addField(
          1, UnknownFieldSetField()..addVarint(make64(0x7FFFFFFF, 0xFFFFFFFF)));
    final writer = CodedBufferWriter();
    unknownFieldSet.writeToCodedBufferWriter(writer);

    final parsed = UnknownFieldSet()
      ..mergeFromCodedBufferReader(CodedBufferReader(writer.toBuffer()));
    final field = parsed.getField(1)!;
    expect(field.varints.length, 1);
    expect(field.varints[0], expect64(0x7FFFFFFF, 0xFFFFFFFFF));
  });

  test('testEquals', () {
    final a = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addFixed32(1));

    final b = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addFixed64(make64(1)));

    final c = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addVarint(make64(1)));

    final d = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addLengthDelimited([]));

    final e = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addGroup(unknownFields));

    checkEqualsIsConsistent(a);
    checkEqualsIsConsistent(b);
    checkEqualsIsConsistent(c);
    checkEqualsIsConsistent(d);
    checkEqualsIsConsistent(e);

    checkNotEqual(a, b);
    checkNotEqual(a, c);
    checkNotEqual(a, d);
    checkNotEqual(a, e);
    checkNotEqual(b, c);
    checkNotEqual(b, d);
    checkNotEqual(b, e);
    checkNotEqual(c, d);
    checkNotEqual(c, e);
    checkNotEqual(d, e);

    final f1 = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addLengthDelimited([1, 2]));
    final f2 = UnknownFieldSet()
      ..addField(1, UnknownFieldSetField()..addLengthDelimited([2, 1]));

    checkEqualsIsConsistent(f1);
    checkEqualsIsConsistent(f2);

    checkNotEqual(f1, f2);
  });

  test(
      'consistent hashcode for messages with no unknown fields set and an empty unknown field set',
      () {
    final m = TestAllExtensions();
    // Force an unknown field set.
    final m2 = TestAllExtensions()..unknownFields;
    expect(m.hashCode, m2.hashCode);
  });

  test('Copy length delimited fields', () {
    // Length-delimited fields should be copied before adding to the unknown
    // field set to avoid aliasing.
    final originalBytes = [1, 2, 3, 4, 5, 6];
    final bytes = Uint8List.fromList([
      10, // tag = 1, type = length delimited
      originalBytes.length,
      ...originalBytes
    ]);

    final parsed = UnknownFieldSet()
      ..mergeFromCodedBufferReader(CodedBufferReader(bytes));

    expect(parsed.getField(1)?.lengthDelimited, [originalBytes]);

    // Modify the message. Input buffer should not be updated.
    final newBytes = [9, 8, 7, 6, 5, 4];
    parsed.getField(1)!.lengthDelimited[0].setRange(0, 6, newBytes);
    expect(bytes.sublist(2), originalBytes);

    // Modify the input buffer. Message should not be updated.
    bytes.setRange(2, 8, [10, 11, 12, 13, 14, 15]);
    expect(parsed.getField(1)!.lengthDelimited[0], newBytes);
  });
}
