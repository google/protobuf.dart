#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library message_test;

import 'package:protoc_plugin/src/descriptor.pb.dart' show DescriptorProto;
import 'package:test/test.dart';

import 'test_util.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';
import '../out/protos/google/protobuf/unittest.pbjson.dart';

void main() {
  TestRequired TEST_REQUIRED_UNINITIALIZED = new TestRequired();

  TestRequired TEST_REQUIRED_INITIALIZED = new TestRequired()
    ..a = 1
    ..b = 2
    ..c = 3;

  test('testMergeFrom', () {
    TestAllTypes mergeSource = new TestAllTypes()
      ..optionalInt32 = 1
      ..optionalString = 'foo'
      ..optionalForeignMessage = new ForeignMessage()
      ..optionalNestedMessage = (new TestAllTypes_NestedMessage()..i = 42)
      ..repeatedString.add('bar');

    TestAllTypes mergeDest = new TestAllTypes()
      ..optionalInt64 = make64(2)
      ..optionalString = 'baz'
      ..optionalForeignMessage = new ForeignMessage()
      ..optionalForeignMessage = (new ForeignMessage()..c = 3)
      ..optionalNestedMessage = (new TestAllTypes_NestedMessage()..bb = 43)
      ..repeatedString.add('qux');

    String mergeResultExpected = '''
optionalInt32: 1
optionalInt64: 2
optionalString: baz
optionalNestedMessage: {
  bb: 43
  i: 42
}
optionalForeignMessage: {
  c: 3
}
repeatedString: bar
repeatedString: qux
''';

    TestAllTypes result = new TestAllTypes()
      ..mergeFromMessage(mergeSource)
      ..mergeFromMessage(mergeDest);

    expect(result.toString(), mergeResultExpected);
  });

  test('testRequired', () {
    TestRequired message = new TestRequired();

    expect(message.isInitialized(), isFalse, reason: 'no required fields set');
    message.a = 1;
    expect(message.isInitialized(), isFalse,
        reason: 'single required field set');
    message.b = 1;
    expect(message.isInitialized(), isFalse,
        reason: 'all but one required field set');
    message.c = 1;
    expect(message.isInitialized(), isTrue, reason: 'required fields set');
  });

  test('testRequiredForeign', () {
    TestRequiredForeign message = new TestRequiredForeign();
    expect(message.isInitialized(), isTrue,
        reason: 'TestRequiredForeign without children should be initialized');

    message.optionalMessage = TEST_REQUIRED_UNINITIALIZED;
    expect(message.isInitialized(), isFalse,
        reason: 'TestRequiredForeign with optional TEST_REQUIRED_UNINITIALIZED '
            'should not be initialized');

    message.optionalMessage = TEST_REQUIRED_INITIALIZED;
    expect(message.isInitialized(), isTrue,
        reason: 'TestRequiredForeign with optional TEST_REQUIRED_INITIALIZED '
            'should be initialized');

    message.repeatedMessage.add(TEST_REQUIRED_UNINITIALIZED);
    expect(message.isInitialized(), isFalse,
        reason:
            'TestRequiredForeign with repeating TEST_REQUIRED_UNINITIALIZED '
            'should not be initialized');

    message.repeatedMessage[0] = TEST_REQUIRED_INITIALIZED;
    expect(message.isInitialized(), isTrue,
        reason: 'TestRequiredForeign with repeating TEST_REQUIRED_INITIALIZED '
            'should be initialized');
  });

  test('testRequiredExtension', () {
    TestAllExtensions message = new TestAllExtensions();
    expect(message.isInitialized(), isTrue);

    message.setExtension(TestRequired.single, TEST_REQUIRED_UNINITIALIZED);
    expect(message.isInitialized(), isFalse);

    message.setExtension(TestRequired.single, TEST_REQUIRED_INITIALIZED);
    expect(message.isInitialized(), isTrue);

    message.addExtension(TestRequired.multi, TEST_REQUIRED_UNINITIALIZED);
    expect(message.isInitialized(), isFalse);

    message.getExtension(TestRequired.multi)[0] = TEST_REQUIRED_INITIALIZED;
    expect(message.isInitialized(), isTrue);
  });

  test('testUninitializedException', () {
    try {
      new TestRequired().check();
      fail('Should have thrown an exception.');
    } on StateError catch (e) {
      expect(e.message, 'Message missing required fields: a, b, c');
    }
  });

  test('testBuildPartial', () {
    // We're mostly testing that no exception is thrown.
    TestRequired message = new TestRequired();
    expect(message.isInitialized(), isFalse);
  });

  test('testNestedUninitializedException', () {
    try {
      TestRequiredForeign message = new TestRequiredForeign();
      message.optionalMessage = TEST_REQUIRED_UNINITIALIZED;
      message.repeatedMessage.add(TEST_REQUIRED_UNINITIALIZED);
      message.repeatedMessage.add(TEST_REQUIRED_UNINITIALIZED);
      message.check();
      fail('Should have thrown an exception.');
    } on StateError catch (e) {
      // NOTE: error message differs from Java in that
      // fields are referenced using Dart fieldnames r.t.
      // proto field names.
      expect(
          e.message,
          'Message missing required fields: '
          'optionalMessage.a, '
          'optionalMessage.b, '
          'optionalMessage.c, '
          'repeatedMessage[0].a, '
          'repeatedMessage[0].b, '
          'repeatedMessage[0].c, '
          'repeatedMessage[1].a, '
          'repeatedMessage[1].b, '
          'repeatedMessage[1].c');
    }
  });

  test('testBuildNestedPartial', () {
    // We're mostly testing that no exception is thrown.
    TestRequiredForeign message = new TestRequiredForeign();
    message.optionalMessage = TEST_REQUIRED_UNINITIALIZED;
    message.repeatedMessage.add(TEST_REQUIRED_UNINITIALIZED);
    message.repeatedMessage.add(TEST_REQUIRED_UNINITIALIZED);
    expect(message.isInitialized(), isFalse);
  });

  test('testParseUnititialized', () {
    try {
      (new TestRequired.fromBuffer([])).check();
      fail('Should have thrown an exception.');
    } on StateError catch (e) {
      expect(e.message, 'Message missing required fields: a, b, c');
    }
  });

  test('testParseNestedUnititialized', () {
    TestRequiredForeign message = new TestRequiredForeign();
    message.optionalMessage = TEST_REQUIRED_UNINITIALIZED;
    message.repeatedMessage.add(TEST_REQUIRED_UNINITIALIZED);
    message.repeatedMessage.add(TEST_REQUIRED_UNINITIALIZED);
    List<int> buffer = message.writeToBuffer();

    try {
      (new TestRequiredForeign.fromBuffer(buffer)).check();
      fail('Should have thrown an exception.');
    } on StateError catch (e) {
      // NOTE: error message differs from Java in that
      // fields are referenced using Dart fieldnames r.t.
      // proto field names.
      expect(
          e.message,
          'Message missing required fields: '
          'optionalMessage.a, '
          'optionalMessage.b, '
          'optionalMessage.c, '
          'repeatedMessage[0].a, '
          'repeatedMessage[0].b, '
          'repeatedMessage[0].c, '
          'repeatedMessage[1].a, '
          'repeatedMessage[1].b, '
          'repeatedMessage[1].c');
    }
  });

  test('testClearField', () {
    int fieldNo;
    TestAllTypes message = new TestAllTypes();

    // Singular field with no default.
    fieldNo = 1;
    expect(message.hasField(fieldNo), isFalse);
    expect(message.getField(fieldNo), 0);
    message.clearField(fieldNo);
    expect(message.hasField(fieldNo), isFalse);
    message.setField(fieldNo, 0);
    expect(message.getField(fieldNo), 0);
    expect(message.hasField(fieldNo), isTrue);
    message.clearField(fieldNo);
    expect(message.hasField(fieldNo), isFalse);

    // Repeated field.
    fieldNo = 31;
    expect(message.hasField(fieldNo), isFalse);
    message.getField(fieldNo).add(1);
    expect(message.hasField(fieldNo), isTrue);

    // Singular field with default.
    fieldNo = 61;
    expect(message.hasField(fieldNo), isFalse);
    expect(message.getField(fieldNo), 41);
    message.clearField(fieldNo);
    message.setField(fieldNo, 41);
    expect(message.hasField(fieldNo), isTrue);
    message.setField(fieldNo, 42);
    expect(message.hasField(fieldNo), isTrue);
    expect(message.getField(fieldNo), 42);
    message.clearField(fieldNo);
    expect(message.hasField(fieldNo), isFalse);
    expect(message.getField(fieldNo), 41);
  });

  test('JSON constants share structure', () {
    const nestedTypeTag = 3;
    List fields = TestAllTypes$json['$nestedTypeTag'];
    expect(fields[0], same(TestAllTypes_NestedMessage$json));

    const enumTypeTag = 4;
    fields = TestAllTypes$json['$enumTypeTag'];
    expect(fields[0], same(TestAllTypes_NestedEnum$json));
  });

  test('Can read JSON constant into DescriptorProto', () {
    var d = new DescriptorProto()..mergeFromJsonMap(TestAllTypes$json);
    expect(d.name, "TestAllTypes");
    expect(d.field[0].name, "optional_int32");
    expect(d.nestedType[0].name, "NestedMessage");
  });
}
