#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library wire_format_test;

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';

import 'test_util.dart';

void main() {
  test('testSerialization', () {
    assertAllFieldsSet(
        new TestAllTypes.fromBuffer((getAllSet()).writeToBuffer()));
  });

  test('testSerializationPacked', () {
    assertPackedFieldsSet(
        new TestPackedTypes.fromBuffer(getPackedSet().writeToBuffer()));
  });

  test('testSerializeExtensions', () {
    assertAllFieldsSet(
        new TestAllTypes.fromBuffer(getAllExtensionsSet().writeToBuffer()));
  });

  test('testSerializePackedExtensions', () {
    expect(getPackedExtensionsSet().writeToBuffer(),
        getPackedSet().writeToBuffer());
  });

  test('testParseExtensions', () {
    // TestAllTypes and TestAllExtensions should have compatible wire formats,
    // so if we serialize a TestAllTypes then parse it as TestAllExtensions
    // it should work.
    List<int> rawBytes = getAllSet().writeToBuffer();
    ExtensionRegistry registry = getExtensionRegistry();

    assertAllExtensionsSet(
        new TestAllExtensions.fromBuffer(rawBytes, registry));
  });

  test('testParsePackedExtensions', () {
    // Ensure that packed extensions can be properly parsed.
    List<int> rawBytes = getPackedExtensionsSet().writeToBuffer();
    ExtensionRegistry registry = getExtensionRegistry();

    assertPackedExtensionsSet(
        new TestPackedExtensions.fromBuffer(rawBytes, registry));
  });

  test('testExtensionsSerialized', () {
    expect(getAllExtensionsSet().writeToBuffer(), getAllSet().writeToBuffer());
  });

  test('testParseMultipleExtensionRanges', () {
    // Make sure we can parse a message that contains multiple extensions
    // ranges.
    TestFieldOrderings source = new TestFieldOrderings()
      ..myInt = make64(1)
      ..myString = 'foo'
      ..myFloat = 1.0
      ..setExtension(Unittest.myExtensionInt, 23)
      ..setExtension(Unittest.myExtensionString, 'bar');

    ExtensionRegistry registry = new ExtensionRegistry()
      ..add(Unittest.myExtensionInt)
      ..add(Unittest.myExtensionString);

    TestFieldOrderings dest =
        new TestFieldOrderings.fromBuffer(source.writeToBuffer(), registry);

    expect(dest, source);
  });
}
