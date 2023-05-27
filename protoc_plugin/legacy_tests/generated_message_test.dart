// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.11

import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';
import '../out/protos/toplevel.pb.dart';
import '../out/protos/toplevel_import.pb.dart' as t;

void main() {
  test('testSettersRejectNull', () {
    final message = TestAllTypes();
    expect(() {
      message.optionalString = null;
    }, throwsArgumentError);
    expect(() {
      message.optionalBytes = null;
    }, throwsArgumentError);
    expect(() {
      message.optionalNestedMessage = null;
    }, throwsArgumentError);
    expect(() {
      message.optionalNestedMessage = null;
    }, throwsArgumentError);
    expect(() {
      message.optionalNestedEnum = null;
    }, throwsArgumentError);
    expect(() {
      message.repeatedString.add(null);
    }, throwsArgumentError);
    expect(() {
      message.repeatedBytes.add(null);
    }, throwsArgumentError);
    expect(() {
      message.repeatedNestedMessage.add(null);
    }, throwsArgumentError);
    expect(() {
      message.repeatedNestedMessage.add(null);
    }, throwsArgumentError);
    expect(() {
      message.repeatedNestedEnum.add(null);
    }, throwsArgumentError);
  });

  test('testRepeatedSettersRejectNull', () {
    final message = TestAllTypes();

    message.repeatedString.addAll(['one', 'two']);
    expect(() {
      message.repeatedString[1] = null;
    }, throwsArgumentError);

    message.repeatedBytes.addAll(['one'.codeUnits, 'two'.codeUnits]);
    expect(() {
      message.repeatedBytes[1] = null;
    }, throwsArgumentError);

    message.repeatedNestedMessage.addAll([
      TestAllTypes_NestedMessage()..bb = 318,
      TestAllTypes_NestedMessage()..bb = 456
    ]);
    expect(() {
      message.repeatedNestedMessage[1] = null;
    }, throwsArgumentError);

    message.repeatedNestedEnum
        .addAll([TestAllTypes_NestedEnum.FOO, TestAllTypes_NestedEnum.BAR]);
    expect(() {
      message.repeatedNestedEnum[1] = null;
    }, throwsArgumentError);
  });

  test('testRepeatedAppendRejectsNull', () {
    final message = TestAllTypes();

    expect(() {
      message.repeatedForeignMessage.addAll([ForeignMessage()..c = 12, null]);
    }, throwsArgumentError);

    expect(() {
      message.repeatedForeignEnum.addAll([ForeignEnum.FOREIGN_BAZ, null]);
    }, throwsArgumentError);

    expect(() {
      message.repeatedString.addAll(['one', null]);
    }, throwsArgumentError);

    expect(() {
      message.repeatedBytes.addAll(['one'.codeUnits, null]);
    }, throwsArgumentError);
  });

  test('testToplevel', () {
    final message = t.M();
    message.t = T();
    t.SApi(null);
  });
}
