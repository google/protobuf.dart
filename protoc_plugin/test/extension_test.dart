#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library extension_test;

import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';
import '../out/protos/enum_extension.pb.dart';
import '../out/protos/nested_extension.pb.dart';
import '../out/protos/non_nested_extension.pb.dart';
import '../out/protos/ExtensionNameConflict.pb.dart';
import '../out/protos/ExtensionEnumNameConflict.pb.dart';

import 'test_util.dart';

throwsArgError(String expectedMessage) => throwsA(predicate((x) {
      expect(x, isArgumentError);
      expect(x.message, expectedMessage);
      return true;
    }));

void main() {
  test('can set all extension types', () {
    TestAllExtensions message = new TestAllExtensions();
    setAllExtensions(message);
    assertAllExtensionsSet(message);
  });

  test('can modify all repeated extension types', () {
    TestAllExtensions message = new TestAllExtensions();
    setAllExtensions(message);
    modifyRepeatedExtensions(message);
    assertRepeatedExtensionsModified(message);
  });

  test('unset extensions return default values', () {
    assertExtensionsClear(new TestAllExtensions());
  });

  test('can read after freeze', () {
    TestAllExtensions message = new TestAllExtensions();
    setAllExtensions(message);
    message.freeze();
    assertAllExtensionsSet(message);
  });

  // void testExtensionReflectionGetters() {} // UNSUPPORTED -- reflection
  // void testExtensionReflectionSetters() {} // UNSUPPORTED -- reflection
  // void testExtensionReflectionSettersRejectNull() {} // UNSUPPORTED
  // void testExtensionReflectionRepeatedSetters() {} // UNSUPPORTED
  // void testExtensionReflectionRepeatedSettersRejectNull() // UNSUPPORTED
  // void testExtensionReflectionDefaults() // UNSUPPORTED

  test('can clear an optional extension', () {
    // clearExtension() is not actually used in test_util, so try it manually.
    var message = new TestAllExtensions();
    message.setExtension(Unittest.optionalInt32Extension, 1);
    message.clearExtension(Unittest.optionalInt32Extension);
    expect(message.hasExtension(Unittest.optionalInt32Extension), isFalse);
  });

  test('can clear a repeated extension', () {
    var message = new TestAllExtensions();
    message.addExtension(Unittest.repeatedInt32Extension, 1);
    message.clearExtension(Unittest.repeatedInt32Extension);
    expect(message.getExtension(Unittest.repeatedInt32Extension).length, 0);
  });

  test('can clone an extension field', () {
    TestAllExtensions original = new TestAllExtensions();
    original.setExtension(Unittest.optionalInt32Extension, 1);
    TestAllExtensions clone = original.clone();
    expect(clone.hasExtension(Unittest.optionalInt32Extension), isTrue);
    expect(clone.getExtension(Unittest.optionalInt32Extension), 1);
  });

  test('can clone all types of extension fields', () {
    assertAllExtensionsSet(getAllExtensionsSet().clone());
  });

  test('can merge extension', () {
    TestAllTypes_NestedMessage nestedMessage = TestAllTypes_NestedMessage()
      ..i = 42;
    TestAllExtensions mergeSource = TestAllExtensions()
      ..setExtension(Unittest.optionalNestedMessageExtension, nestedMessage);

    TestAllTypes_NestedMessage nestedMessage2 = TestAllTypes_NestedMessage()
      ..bb = 43;
    TestAllExtensions mergeDest = TestAllExtensions()
      ..setExtension(Unittest.optionalNestedMessageExtension, nestedMessage2);

    TestAllExtensions result = new TestAllExtensions()
      ..mergeFromMessage(mergeSource)
      ..mergeFromMessage(mergeDest);

    expect(result.getExtension(Unittest.optionalNestedMessageExtension).i, 42);
    expect(result.getExtension(Unittest.optionalNestedMessageExtension).bb, 43);
  });

  test("throws if field number isn't allowed for extension", () {
    var message = new TestAllTypes(); // does not allow extensions
    expect(() {
      message.setExtension(Unittest.optionalInt32Extension, 0);
    },
        throwsArgError(
            "Extension optionalInt32Extension not legal for message protobuf_unittest.TestAllTypes"));

    expect(() {
      message.getExtension(Unittest.optionalInt32Extension);
    },
        throwsArgError(
            "Extension optionalInt32Extension not legal for message protobuf_unittest.TestAllTypes"));
  });

  test("throws if an int32 extension is set to a bad value", () {
    var message = new TestAllExtensions();
    expect(() {
      message.setExtension(Unittest.optionalInt32Extension, "hello");
    },
        throwsArgError(
            "Illegal to set field optionalInt32Extension (1) of protobuf_unittest.TestAllExtensions"
            " to value (hello): not type int"));
  });

  test('throws if an int64 extension is set to a bad value', () {
    var message = new TestAllExtensions();
    expect(() {
      message.setExtension(Unittest.optionalInt64Extension, 123);
    },
        throwsArgError(
            "Illegal to set field optionalInt64Extension (2) of protobuf_unittest.TestAllExtensions"
            " to value (123): not Int64"));
  });

  test('throws if a message extension is set to a bad value', () {
    var message = new TestAllExtensions();

    // For a non-repeated message, we only check for a GeneratedMessage.
    expect(() {
      message.setExtension(Unittest.optionalNestedMessageExtension, 123);
    },
        throwsArgError(
            "Illegal to set field optionalNestedMessageExtension (18)"
            " of protobuf_unittest.TestAllExtensions to value (123): not a GeneratedMessage"));

    // For a repeated message, the type check is exact.
    expect(() {
      message.addExtension(
          Unittest.repeatedNestedMessageExtension, new TestAllTypes());
    }, throwsATypeError);
  });

  test('throws if an enum extension is set to a bad value', () {
    var message = new TestAllExtensions();

    // For a non-repeated enum, we only check for a ProtobufEnum.
    expect(() {
      message.setExtension(Unittest.optionalNestedEnumExtension, 123);
    },
        throwsArgError("Illegal to set field optionalNestedEnumExtension (21)"
            " of protobuf_unittest.TestAllExtensions to value (123): not type ProtobufEnum"));

    // For a repeated enum, the type check is exact.
    expect(() {
      message.addExtension(
          Unittest.repeatedForeignEnumExtension, TestAllTypes_NestedEnum.FOO);
    }, throwsATypeError);
  });

  test('can extend a message with a message field with a different type', () {
    expect(Non_nested_extension.nonNestedExtension.makeDefault(),
        new TypeMatcher<MyNonNestedExtension>());
    expect(Non_nested_extension.nonNestedExtension.name, 'nonNestedExtension');
  });

  test('can extend a message with a message field of the same type', () {
    expect(
        MyNestedExtension.recursiveExtension.makeDefault()
            is MessageToBeExtended,
        isTrue);
    expect(MyNestedExtension.recursiveExtension.name, 'recursiveExtension');
  });

  test('can extend message with enum', () {
    var msg = new Extendable();
    msg.setExtension(Enum_extension.animal, Animal.CAT);
  });

  test('extension class was renamed to avoid conflict with message', () {
    expect(ExtensionNameConflictExt.someExtension.tagNumber, 1);
  });

  test('extension class was renamed to avoid conflict with enum', () {
    expect(ExtensionEnumNameConflictExt.enumConflictExtension.tagNumber, 1);
  });
}
