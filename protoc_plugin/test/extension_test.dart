#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library extension_test;

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';
import '../out/protos/enum_extension.pb.dart';
import '../out/protos/extend_unittest.pb.dart';
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

final withExtensions = TestAllExtensions()
  ..setExtension(
      Unittest.optionalForeignMessageExtension, ForeignMessage()..c = 3)
  ..setExtension(Unittest.defaultStringExtension, 'bar')
  ..getExtension(Unittest.repeatedBytesExtension).add('pop'.codeUnits)
  ..setExtension(
      Extend_unittest.outer,
      Outer()
        ..inner = (Inner()..value = 'abc')
        ..setExtension(Extend_unittest.extensionInner, Inner()..value = 'def'));

void main() {
  test('can set all extension types', () {
    TestAllExtensions message = TestAllExtensions();
    setAllExtensions(message);
    assertAllExtensionsSet(message);
  });

  test('can modify all repeated extension types', () {
    TestAllExtensions message = TestAllExtensions();
    setAllExtensions(message);
    modifyRepeatedExtensions(message);
    assertRepeatedExtensionsModified(message);
  });

  test('unset extensions return default values', () {
    assertExtensionsClear(TestAllExtensions());
  });

  // void testExtensionReflectionGetters() {} // UNSUPPORTED -- reflection
  // void testExtensionReflectionSetters() {} // UNSUPPORTED -- reflection
  // void testExtensionReflectionSettersRejectNull() {} // UNSUPPORTED
  // void testExtensionReflectionRepeatedSetters() {} // UNSUPPORTED
  // void testExtensionReflectionRepeatedSettersRejectNull() // UNSUPPORTED
  // void testExtensionReflectionDefaults() // UNSUPPORTED

  test('can clear an optional extension', () {
    // clearExtension() is not actually used in test_util, so try it manually.
    var message = TestAllExtensions();
    message.setExtension(Unittest.optionalInt32Extension, 1);
    message.clearExtension(Unittest.optionalInt32Extension);
    expect(message.hasExtension(Unittest.optionalInt32Extension), isFalse);
  });

  test('can clear a repeated extension', () {
    var message = TestAllExtensions();
    message.addExtension(Unittest.repeatedInt32Extension, 1);
    message.clearExtension(Unittest.repeatedInt32Extension);
    expect(message.getExtension(Unittest.repeatedInt32Extension).length, 0);
  });

  test('can clone an extension field', () {
    TestAllExtensions original = TestAllExtensions();
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

    TestAllExtensions result = TestAllExtensions()
      ..mergeFromMessage(mergeSource)
      ..mergeFromMessage(mergeDest);

    expect(result.getExtension(Unittest.optionalNestedMessageExtension).i, 42);
    expect(result.getExtension(Unittest.optionalNestedMessageExtension).bb, 43);
  });

  test("throws if field number isn't allowed for extension", () {
    var message = TestAllTypes(); // does not allow extensions
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
    var message = TestAllExtensions();
    expect(() {
      message.setExtension(Unittest.optionalInt32Extension, "hello");
    },
        throwsArgError(
            "Illegal to set field optionalInt32Extension (1) of protobuf_unittest.TestAllExtensions"
            " to value (hello): not type int"));
  });

  test('throws if an int64 extension is set to a bad value', () {
    var message = TestAllExtensions();
    expect(() {
      message.setExtension(Unittest.optionalInt64Extension, 123);
    },
        throwsArgError(
            "Illegal to set field optionalInt64Extension (2) of protobuf_unittest.TestAllExtensions"
            " to value (123): not Int64"));
  });

  test('throws if a message extension is set to a bad value', () {
    var message = TestAllExtensions();

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
          Unittest.repeatedNestedMessageExtension, TestAllTypes());
    }, throwsATypeError);
  });

  test('throws if an enum extension is set to a bad value', () {
    var message = TestAllExtensions();

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
        TypeMatcher<MyNonNestedExtension>());
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
    var msg = Extendable();
    msg.setExtension(Enum_extension.animal, Animal.CAT);
  });

  test('extension class was renamed to avoid conflict with message', () {
    expect(ExtensionNameConflictExt.someExtension.tagNumber, 1);
  });

  test('extension class was renamed to avoid conflict with enum', () {
    expect(ExtensionEnumNameConflictExt.enumConflictExtension.tagNumber, 1);
  });

  test('to toDebugString', () {
    TestAllExtensions value = TestAllExtensions()
      ..setExtension(Unittest.optionalInt32Extension, 1)
      ..addExtension(Unittest.repeatedStringExtension, 'hello')
      ..addExtension(Unittest.repeatedStringExtension, 'world')
      ..setExtension(Unittest.optionalNestedMessageExtension,
          TestAllTypes_NestedMessage()..i = 42)
      ..setExtension(
          Unittest.optionalNestedEnumExtension, TestAllTypes_NestedEnum.BAR);

    String expected = '[optionalInt32Extension]: 1\n'
        '[optionalNestedMessageExtension]: {\n'
        '  i: 42\n'
        '}\n'
        '[optionalNestedEnumExtension]: BAR\n'
        '[repeatedStringExtension]: hello\n'
        '[repeatedStringExtension]: world\n';

    expect(value.toString(), expected);
  });

  test('can compare messages with and without extensions', () {
    final withExtension = TestFieldOrderings()
      ..myString = 'foo'
      ..setExtension(Unittest.myExtensionString, 'bar');
    final b = withExtension.writeToBuffer();
    final withUnknownField = TestFieldOrderings.fromBuffer(b);
    ExtensionRegistry r = ExtensionRegistry();
    Unittest.registerAllExtensions(r);
    final decodedWithExtension = TestFieldOrderings.fromBuffer(b, r);
    final noExtension = TestFieldOrderings()..myString = 'foo';
    expect(withExtension == decodedWithExtension, true);
    expect(withUnknownField == decodedWithExtension, false);
    expect(decodedWithExtension == withUnknownField, false);
    expect(withUnknownField == noExtension, false);
    expect(noExtension == withUnknownField, false);
    decodedWithExtension.setExtension(Unittest.myExtensionInt, 42);
    expect(withExtension == decodedWithExtension, false);
    expect(decodedWithExtension == withExtension, false);
    expect(decodedWithExtension == withExtension, false);
  });

  test(
      'ExtensionRegistry.reparseMessage will preserve already registered extensions',
      () {
    ExtensionRegistry r1 = ExtensionRegistry();
    Unittest.registerAllExtensions(r1);

    ExtensionRegistry r2 = ExtensionRegistry();
    Extend_unittest.registerAllExtensions(r2);
    final withUnknownFields =
        TestAllExtensions.fromBuffer(withExtensions.writeToBuffer());
    final reparsedR1 = r1.reparseMessage(withUnknownFields);

    expect(
        reparsedR1.getExtension(Unittest.optionalForeignMessageExtension).c, 3);

    expect(
        r2
            .reparseMessage(reparsedR1)
            .getExtension(Unittest.optionalForeignMessageExtension)
            .c,
        3);
  });

  test(
      'ExtensionRegistry.reparseMessage reparses extensions that were not in the original registry',
      () {
    ExtensionRegistry r = ExtensionRegistry();
    Unittest.registerAllExtensions(r);
    Extend_unittest.registerAllExtensions(r);

    final withUnknownFields =
        TestAllExtensions.fromBuffer(withExtensions.writeToBuffer());
    final reparsed = r.reparseMessage(withUnknownFields);

    expect(withUnknownFields.getExtension(Unittest.defaultStringExtension),
        'hello');

    expect(reparsed.getExtension(Unittest.defaultStringExtension), 'bar');

    expect(
        reparsed.unknownFields
            .getField(Unittest.defaultStringExtension.tagNumber),
        null,
        reason:
            'ExtensionRegistry.reparseMessage does not leave reparsed fields in unknownFields');
    expect(reparsed.getExtension(Unittest.repeatedBytesExtension),
        ['pop'.codeUnits]);

    expect(
        reparsed.getExtension(Unittest.optionalForeignMessageExtension).c, 3);

    expect(reparsed.getExtension(Extend_unittest.outer).inner.value, 'abc');

    final onlyOuter = ExtensionRegistry()..add(Extend_unittest.outer);
    final onlyOuterReparsed = onlyOuter.reparseMessage(withUnknownFields);
    expect(
        onlyOuterReparsed
            .getExtension(Extend_unittest.outer)
            .hasExtension(Extend_unittest.extensionInner),
        isFalse);
    expect(
        onlyOuter
            .reparseMessage(withUnknownFields)
            .getExtension(Extend_unittest.outer)
            .getExtension(Extend_unittest.extensionInner)
            .value,
        '');

    expect(
        reparsed
            .getExtension(Extend_unittest.outer)
            .hasExtension(Extend_unittest.extensionInner),
        isTrue);
    expect(
        reparsed
            .getExtension(Extend_unittest.outer)
            .getExtension(Extend_unittest.extensionInner)
            .value,
        'def');
  });

  test('ExtensionRegistry.reparseMessage does not update the original', () {
    ExtensionRegistry r = ExtensionRegistry();
    Unittest.registerAllExtensions(r);
    Extend_unittest.registerAllExtensions(r);

    final withUnknownFields =
        TestAllExtensions.fromBuffer(withExtensions.writeToBuffer());

    final reparsedWithEmpty =
        ExtensionRegistry().reparseMessage(withUnknownFields);
    expect(reparsedWithEmpty, same(withUnknownFields));

    final reparsed = r.reparseMessage(withUnknownFields);

    List<String> strings =
        withUnknownFields.getExtension(Unittest.repeatedStringExtension);
    expect(strings, []);
    strings.add('pop2');
    expect(reparsed.getExtension(Unittest.repeatedStringExtension), []);
  });

  test('ExtensionRegistry.reparseMessage will throw on malformed buffers', () {
    final ExtensionRegistry r = ExtensionRegistry();
    Unittest.registerAllExtensions(r);
    final ExtensionRegistry r2 = ExtensionRegistry();

    Extend_unittest.registerAllExtensions(r2);

    // The message encoded in this buffer has an encoding error in the
    // Extend_unittest.outer extension field.
    final withMalformedExtensionEncoding = TestAllExtensions.fromBuffer([
      154, 1, 2, 8, 3, 210, //
      4, 3, 98, 97, 114, 194, 6, 14, 10, 5, 10, 4,
      97, 98, 99, 18, 5, 10, 3, 100, 101, 102
    ]);
    expect(
        r
            .reparseMessage(withMalformedExtensionEncoding)
            .getExtension(Unittest.defaultStringExtension),
        'bar',
        reason:
            'this succeeds because it does not decode Extend_unittest.outer');
    expect(() => r2.reparseMessage(withMalformedExtensionEncoding),
        throwsA(const TypeMatcher<InvalidProtocolBufferException>()));
  });

  test('ExtensionRegistry.reparseMessage preserves frozenness', () {
    final ExtensionRegistry r = ExtensionRegistry();
    Unittest.registerAllExtensions(r);

    final withUnknownFields =
        TestAllExtensions.fromBuffer(withExtensions.writeToBuffer());
    withUnknownFields.freeze();

    expect(
        () => r
            .reparseMessage(withUnknownFields)
            .setExtension(Unittest.defaultStringExtension, 'blah'),
        throwsA(TypeMatcher<UnsupportedError>()));
  });

  test(
      'ExtensionRegistry.reparseMessage returns the same object when no new extensions are parsed',
      () {
    final original = Outer()
      ..inner = (Inner()
        ..innerMost = (InnerMost()
          ..setExtension(Extend_unittest.innerMostExtensionString, 'a')))
      ..inners.addAll([
        (Inner()..setExtension(Extend_unittest.innerExtensionString, "a")),
        Inner()..value = 'value'
      ])
      ..innerMap[0] =
          (Inner()..setExtension(Extend_unittest.innerExtensionString, "a"));

    final reparsed = ExtensionRegistry().reparseMessage(original);
    expect(identical(reparsed, original), isTrue);
  });

  test(
      'ExtensionRegistry.reparseMessage reparses extension in deeply nested subfield',
      () {
    final original = Outer()
      ..inner = (Inner()
        ..innerMost = (InnerMost()
          ..setExtension(Extend_unittest.innerMostExtensionString, 'a')));

    final withUnknownFields = Outer.fromBuffer(original.writeToBuffer());

    expect(
        withUnknownFields.inner.innerMost
            .hasExtension(Extend_unittest.innerMostExtensionString),
        isFalse);

    final r = ExtensionRegistry()
      ..add(Extend_unittest.innerMostExtensionString);
    final reparsed = r.reparseMessage(withUnknownFields);

    expect(identical(reparsed.inner, withUnknownFields.inner), isFalse);
    expect(
        identical(reparsed.inner.innerMost, withUnknownFields.inner.innerMost),
        isFalse);
    expect(
        reparsed.inner.innerMost
            .hasExtension(Extend_unittest.innerMostExtensionString),
        isTrue);
  });

  test(
      'ExtensionRegistry.reparseMessage reparses extensions in all nested subfields',
      () {
    final original = Outer()
      ..inner = (Inner()
        ..setExtension(Extend_unittest.innerExtensionString, "a")
        ..innerMost = (InnerMost()
          ..setExtension(Extend_unittest.innerMostExtensionString, 'a')));

    final withUnknownFields = Outer.fromBuffer(original.writeToBuffer());

    expect(
        withUnknownFields.inner
            .hasExtension(Extend_unittest.innerExtensionString),
        isFalse);
    expect(
        withUnknownFields.inner.innerMost
            .hasExtension(Extend_unittest.innerMostExtensionString),
        isFalse);

    final r = ExtensionRegistry()
      ..addAll([
        Extend_unittest.innerExtensionString,
        Extend_unittest.innerMostExtensionString
      ]);
    final reparsed = r.reparseMessage(withUnknownFields);

    expect(identical(reparsed.inner, withUnknownFields.inner), isFalse);
    expect(
        identical(reparsed.inner.innerMost, withUnknownFields.inner.innerMost),
        isFalse);
    expect(reparsed.inner.hasExtension(Extend_unittest.innerExtensionString),
        isTrue);
    expect(
        reparsed.inner.innerMost
            .hasExtension(Extend_unittest.innerMostExtensionString),
        isTrue);
  });

  test(
      'ExtensionRegistry.reparseMessage doesn\'t copy deepest subfield without extensions',
      () {
    final original = Outer()
      ..inner = (Inner()
        ..setExtension(Extend_unittest.innerExtensionString, "a")
        ..innerMost = InnerMost());

    final withUnknownFields = Outer.fromBuffer(original.writeToBuffer());

    expect(
        withUnknownFields.inner
            .hasExtension(Extend_unittest.innerExtensionString),
        false);

    final r = ExtensionRegistry()..add(Extend_unittest.innerExtensionString);
    final reparsed = r.reparseMessage(withUnknownFields);

    expect(identical(reparsed.inner, withUnknownFields.inner), isFalse);
    expect(
        identical(reparsed.inner.innerMost, withUnknownFields.inner.innerMost),
        isTrue);
    expect(reparsed.inner.hasExtension(Extend_unittest.innerExtensionString),
        isTrue);
  });

  test(
      'ExtensionRegistry.reparseMessage reparses extensions in repeated fields',
      () {
    final original = Outer()
      ..inners.addAll([
        (Inner()..setExtension(Extend_unittest.innerExtensionString, "a")),
        Inner()..value = 'value'
      ]);

    final withUnknownFields = Outer.fromBuffer(original.writeToBuffer());

    expect(
        withUnknownFields.inners.first
            .hasExtension(Extend_unittest.innerExtensionString),
        isFalse);

    final r = ExtensionRegistry()..add(Extend_unittest.innerExtensionString);
    final reparsed = r.reparseMessage(withUnknownFields);

    expect(
        reparsed.inners[0].hasExtension(Extend_unittest.innerExtensionString),
        isTrue);
    expect(identical(withUnknownFields.inners[1], reparsed.inners[1]), isTrue);
  });

  test('ExtensionRegistry.reparseMessage reparses extensions in map fields',
      () {
    final original = Outer()
      ..innerMap[0] =
          (Inner()..setExtension(Extend_unittest.innerExtensionString, "a"))
      ..innerMap[1] = (Inner());

    final withUnknownFields = Outer.fromBuffer(original.writeToBuffer());

    expect(
        withUnknownFields.innerMap[0]
            .hasExtension(Extend_unittest.innerExtensionString),
        isFalse);

    final r = ExtensionRegistry()..add(Extend_unittest.innerExtensionString);
    final reparsed = r.reparseMessage(withUnknownFields);

    expect(
        reparsed.innerMap[0].hasExtension(Extend_unittest.innerExtensionString),
        isTrue);
    expect(
        identical(withUnknownFields.innerMap[1], reparsed.innerMap[1]), isTrue);
  });
}
