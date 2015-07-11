#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library validate_fail_test;

import 'dart:typed_data';

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest_import.pb.dart';
import '../out/protos/google/protobuf/unittest.pb.dart';

// [ArgumentError] in production mode, [TypeError] in checked.
final invalidArgumentException = predicate(
    (e) => e is ArgumentError || e is TypeError);
final badArgument = throwsA(invalidArgumentException);

void main() {
  test('testValidatePbListTypes', () {

    PbList<int> lSint32 = new PbSint32List();
    expect(() { lSint32.add(-2147483649); }, throwsArgumentError);
    expect(() { lSint32.add(2147483648); }, throwsArgumentError);

    PbList<int> lUint32 = new PbUint32List();
    expect(() { lUint32.add(-1); }, throwsArgumentError);
    expect(() { lUint32.add(4294967296); }, throwsArgumentError);

    PbList<Int64> lSint64 = new PbSint64List();
    expect(() { lSint64.add(-9223372036854775809); }, badArgument);
    expect(() { lSint64.add(9223372036854775808); }, badArgument);

    PbList<Int64> lUint64 = new PbUint64List();
    expect(() { lUint64.add(-1); }, badArgument);
    expect(() { lUint64.add(18446744073709551616); }, badArgument);

    PbList<double> lFloat = new PbFloatList();
    expect(() { lFloat.add(-3.4028234663852886E39); }, throwsArgumentError);
    expect(() { lFloat.add(3.4028234663852886E39); }, throwsArgumentError);
  });

  test('testValidationFailureMessages', () {
    TestAllTypes builder = new TestAllTypes();

    expect(() { builder.optionalInt32 = null; }, throwsArgumentError);

    expect(() { builder.optionalInt32 = '101'; }, badArgument);
    expect(() { builder.optionalInt32 = -2147483649; }, throwsArgumentError);
    expect(() { builder.optionalInt32 = 2147483648; }, throwsArgumentError);

    expect(() { builder.optionalInt64 = '102'; }, badArgument);
    expect(() { builder.optionalInt64 = -9223372036854775809; },
           badArgument);
    expect(() { builder.optionalInt64 = 9223372036854775808; },
           badArgument);

    expect(() { builder.optionalUint32 = '103'; }, badArgument);
    expect(() { builder.optionalUint32 = -1; }, throwsArgumentError);
    expect(() { builder.optionalUint32 = 4294967296; }, throwsArgumentError);

    expect(() { builder.optionalUint64 = '104'; }, badArgument);
    expect(() { builder.optionalUint64 = -1; }, badArgument);
    expect(() { builder.optionalUint64 = 18446744073709551616; },
           badArgument);

    expect(() { builder.optionalSint32 = '105'; }, badArgument);
    expect(() { builder.optionalSint32 = -2147483649; }, throwsArgumentError);
    expect(() { builder.optionalSint32 = 2147483648; }, throwsArgumentError);

    expect(() { builder.optionalSint64 = '106'; }, badArgument);
    expect(() { builder.optionalSint64 = -9223372036854775809; },
           badArgument);
    expect(() { builder.optionalSint64 = 9223372036854775808; },
           badArgument);

    expect(() { builder.optionalFixed32 = '107'; }, badArgument);
    expect(() { builder.optionalFixed32 = -1; }, throwsArgumentError);
    expect(() { builder.optionalFixed32 = 4294967296; }, throwsArgumentError);

    expect(() { builder.optionalFixed64 = '108'; }, badArgument);
    expect(() { builder.optionalFixed64 = -1; }, badArgument);
    expect(() { builder.optionalFixed64 = 18446744073709551616; },
           badArgument);

    expect(() { builder.optionalSfixed32 = '109'; }, badArgument);
    expect(() { builder.optionalSfixed32 = -2147483649; }, throwsArgumentError);
    expect(() { builder.optionalSfixed32 = 2147483648; }, throwsArgumentError);

    expect(() { builder.optionalSfixed64 = '110'; }, badArgument);
    expect(() { builder.optionalSfixed64 = -9223372036854775809; },
           badArgument);
    expect(() { builder.optionalSfixed64 = 9223372036854775808; },
           badArgument);

    expect(() { builder.optionalFloat = '111'; }, badArgument);
    expect(() { builder.optionalFloat = -3.4028234663852886E39; },
           throwsArgumentError);
    expect(() { builder.optionalFloat = 3.4028234663852886E39; },
           throwsArgumentError);

    expect(() { builder.optionalDouble = '112'; }, badArgument);

    expect(() { builder.optionalBool = '113'; }, badArgument);

    expect(() { builder.optionalString = false; }, badArgument);

    expect(() { builder.optionalBytes = '115'; }, badArgument);

    expect(() { builder.optionalNestedMessage = '118'; }, badArgument);

    expect(() { builder.optionalNestedEnum = '121'; }, badArgument);

    // Set repeating value (no setter should exist).
    expect(() { builder.repeatedInt32 = 201; }, throwsNoSuchMethodError);

    // Unknown tag.
    expect(() { builder.setField(999, 'field'); }, throwsArgumentError);

    // Unknown type.
    expect(() { builder.setField(1, 1, 24); }, throwsArgumentError);

    expect(() {
      new TestAllExtensions()
          .setExtension(Unittest.optionalInt32Extension, '101');
    }, throwsArgumentError);
  });
}
