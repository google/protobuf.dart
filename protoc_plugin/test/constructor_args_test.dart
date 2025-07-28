// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'gen/google/protobuf/unittest.pb.dart';
import 'gen/google/protobuf/unittest_import.pb.dart';
import 'gen/map_field.pb.dart';
import 'src/test_util.dart';

void main() {
  group('map_field', () {
    test('Constructor map arguments accept key-value iterators', () {
      final msg = TestMap(
        stringToInt32Field: [
          MapEntry('a', 1),
          MapEntry('b', 2),
          MapEntry('a', 3),
        ],
        int32ToStringField: {1: 'hi'}.entries,
      );
      expect(msg.stringToInt32Field['a'], 3);
      expect(msg.stringToInt32Field['b'], 2);
      expect(msg.int32ToStringField[1], 'hi');
    });
  });

  group('generated_message', () {
    test('Named arguments in constructors', () {
      final value = TestAllTypes(
        optionalInt32: 101,
        optionalInt64: make64(102),
        optionalUint32: 103,
        optionalUint64: make64(104),
        optionalSint32: 105,
        optionalSint64: make64(106),
        optionalFixed32: 107,
        optionalFixed64: make64(108),
        optionalSfixed32: 109,
        optionalSfixed64: make64(110),
        optionalFloat: 111.0,
        optionalDouble: 112.0,
        optionalBool: true,
        optionalString: '115',
        optionalBytes: '116'.codeUnits,
        optionalGroup: TestAllTypes_OptionalGroup(a: 117),
        optionalNestedMessage: TestAllTypes_NestedMessage(bb: 118),
        optionalForeignMessage: ForeignMessage(c: 119),
        optionalImportMessage: ImportMessage(d: 120),
        optionalNestedEnum: TestAllTypes_NestedEnum.BAZ,
        optionalForeignEnum: ForeignEnum.FOREIGN_BAZ,
        optionalImportEnum: ImportEnum.IMPORT_BAZ,
        optionalStringPiece: '124',
        optionalCord: '125',
        repeatedInt32: [201, 301],
        repeatedInt64: [make64(202), make64(302)],
        repeatedUint32: [203, 303],
        repeatedUint64: [make64(204), make64(304)],
        repeatedSint32: [205, 305],
        repeatedSint64: [make64(206), make64(306)],
        repeatedFixed32: [207, 307],
        repeatedFixed64: [make64(208), make64(308)],
        repeatedSfixed32: [209, 309],
        repeatedSfixed64: [make64(210), make64(310)],
        repeatedFloat: [211.0, 311.0],
        repeatedDouble: [212.0, 312.0],
        repeatedBool: [true, false],
        repeatedString: ['215', '315'],
        repeatedBytes: ['216'.codeUnits, '316'.codeUnits],
        repeatedGroup: [
          TestAllTypes_RepeatedGroup(a: 217),
          TestAllTypes_RepeatedGroup(a: 317),
        ],
        repeatedNestedMessage: [
          TestAllTypes_NestedMessage(bb: 218),
          TestAllTypes_NestedMessage(bb: 318),
        ],
        repeatedForeignMessage: [
          ForeignMessage(c: 219),
          ForeignMessage(c: 319),
        ],
        repeatedImportMessage: [ImportMessage(d: 220), ImportMessage(d: 320)],
        repeatedNestedEnum: [
          TestAllTypes_NestedEnum.BAR,
          TestAllTypes_NestedEnum.BAZ,
        ],
        repeatedForeignEnum: [ForeignEnum.FOREIGN_BAR, ForeignEnum.FOREIGN_BAZ],
        repeatedImportEnum: [ImportEnum.IMPORT_BAR, ImportEnum.IMPORT_BAZ],
        repeatedStringPiece: ['224', '324'],
        repeatedCord: ['225', '325'],
        defaultInt32: 401,
        defaultInt64: make64(402),
        defaultUint32: 403,
        defaultUint64: make64(404),
        defaultSint32: 405,
        defaultSint64: make64(406),
        defaultFixed32: 407,
        defaultFixed64: make64(408),
        defaultSfixed32: 409,
        defaultSfixed64: make64(410),
        defaultFloat: 411.0,
        defaultDouble: 412.0,
        defaultBool: false,
        defaultString: '415',
        defaultBytes: '416'.codeUnits,
        defaultNestedEnum: TestAllTypes_NestedEnum.FOO,
        defaultForeignEnum: ForeignEnum.FOREIGN_FOO,
        defaultImportEnum: ImportEnum.IMPORT_FOO,
        defaultStringPiece: '424',
        defaultCord: '425',
      );

      // Convert the message with constructor arguments to the message without
      // constructor arguments, to be able to reuse `assertAllFieldsSet`.
      assertAllFieldsSet(TestAllTypes.fromBuffer(value.writeToBuffer()));
    });
  });
}
