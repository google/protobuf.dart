#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library validate_fail_test;

import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';

// [ArgumentError] in production mode, [TypeError] in checked.
final invalidArgumentException =
    predicate((e) => e is ArgumentError || e is TypeError);
final badArgument = throwsA(invalidArgumentException);

// Suppress an analyzer warning for a deliberate type mismatch.
cast(x) => x;

void main() {
  test('testValidationFailureMessages', () {
    TestAllTypes builder = TestAllTypes();

    expect(() {
      builder.optionalInt32 = null;
    }, throwsArgumentError);

    expect(() {
      builder.optionalInt32 = cast('101');
    }, badArgument);
    expect(() {
      builder.optionalInt32 = -2147483649;
    }, throwsArgumentError);
    expect(() {
      builder.optionalInt32 = 2147483648;
    }, throwsArgumentError);

    expect(() {
      builder.optionalInt64 = cast('102');
    }, badArgument);
    expect(() {
      builder.optionalInt64 = cast(-9223372036854775808);
    }, badArgument);
    expect(() {
      builder.optionalInt64 = cast(9223372036854775807);
    }, badArgument);

    expect(() {
      builder.optionalUint32 = cast('103');
    }, badArgument);
    expect(() {
      builder.optionalUint32 = -1;
    }, throwsArgumentError);
    expect(() {
      builder.optionalUint32 = 4294967296;
    }, throwsArgumentError);

    expect(() {
      builder.optionalUint64 = cast('104');
    }, badArgument);
    expect(() {
      builder.optionalUint64 = cast(-1);
    }, badArgument);
    expect(() {
      builder.optionalUint64 = cast(8446744073709551616);
    }, badArgument);

    expect(() {
      builder.optionalSint32 = cast('105');
    }, badArgument);
    expect(() {
      builder.optionalSint32 = -2147483649;
    }, throwsArgumentError);
    expect(() {
      builder.optionalSint32 = 2147483648;
    }, throwsArgumentError);

    expect(() {
      builder.optionalSint64 = cast('106');
    }, badArgument);
    expect(() {
      builder.optionalSint64 = cast(-9223372036854775808);
    }, badArgument);
    expect(() {
      builder.optionalSint64 = cast(9223372036854775807);
    }, badArgument);

    expect(() {
      builder.optionalFixed32 = cast('107');
    }, badArgument);
    expect(() {
      builder.optionalFixed32 = -1;
    }, throwsArgumentError);
    expect(() {
      builder.optionalFixed32 = 4294967296;
    }, throwsArgumentError);

    expect(() {
      builder.optionalFixed64 = cast('108');
    }, badArgument);
    expect(() {
      builder.optionalFixed64 = cast(-1);
    }, badArgument);
    expect(() {
      builder.optionalFixed64 = cast(8446744073709551616);
    }, badArgument);

    expect(() {
      builder.optionalSfixed32 = cast('109');
    }, badArgument);
    expect(() {
      builder.optionalSfixed32 = -2147483649;
    }, throwsArgumentError);
    expect(() {
      builder.optionalSfixed32 = 2147483648;
    }, throwsArgumentError);

    expect(() {
      builder.optionalSfixed64 = cast('110');
    }, badArgument);
    expect(() {
      builder.optionalSfixed64 = cast(-9223372036854775808);
    }, badArgument);
    expect(() {
      builder.optionalSfixed64 = cast(9223372036854775807);
    }, badArgument);

    expect(() {
      builder.optionalFloat = cast('111');
    }, badArgument);
    expect(() {
      builder.optionalFloat = -3.4028234663852886E39;
    }, throwsArgumentError);
    expect(() {
      builder.optionalFloat = 3.4028234663852886E39;
    }, throwsArgumentError);

    expect(() {
      builder.optionalDouble = cast('112');
    }, badArgument);

    expect(() {
      builder.optionalBool = cast('113');
    }, badArgument);

    expect(() {
      builder.optionalString = cast(false);
    }, badArgument);

    // Can't test this easily in strong mode.
    // expect(() {
    //   builder.optionalBytes = cast('115');
    // }, badArgument);

    expect(() {
      builder.optionalNestedMessage = cast('118');
    }, badArgument);

    expect(() {
      builder.optionalNestedEnum = cast('121');
    }, badArgument);

    // Set repeating value (no setter should exist).
    expect(() {
      cast(builder).repeatedInt32 = 201;
    }, throwsNoSuchMethodError);

    // Unknown tag.
    expect(() {
      builder.setField(999, 'field');
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().setExtension(Unittest.optionalInt32Extension, '101');
    }, throwsArgumentError);
  });
}
