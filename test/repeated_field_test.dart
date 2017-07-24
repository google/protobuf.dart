#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library repeated_field_test;

import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';
import 'test_util.dart';

// Suppress an analyzer warning for a deliberate type mismatch.
cast(x) => x;

void main() {
  test("checkItems works for messages", () {
    expect(() {
      TestAllTypes.$checkItem(new TestAllTypes());
    }, returnsNormally);

    expect(() {
      TestAllTypes.$checkItem(cast(new TestAllTypes_NestedMessage()));
    }, throwsATypeError);
  });

  test("checkItems works for groups", () {
    expect(() {
      TestAllTypes_RepeatedGroup.$checkItem(new TestAllTypes_RepeatedGroup());
    }, returnsNormally);

    expect(() {
      TestAllTypes_RepeatedGroup
          .$checkItem(cast(new TestAllTypes_OptionalGroup()));
    }, throwsATypeError);
  });

  test("checkItems works for enums", () {
    expect(() {
      TestAllTypes_NestedEnum.$checkItem(TestAllTypes_NestedEnum.FOO);
    }, returnsNormally);

    expect(() {
      TestAllTypes_NestedEnum.$checkItem(cast(ForeignEnum.FOREIGN_FOO));
    }, throwsATypeError);
  });

  test("check properties are initialized for repeated fields", () {
    var msg = new TestAllTypes();
    expect(msg.info_.byName["repeatedNestedMessage"].check,
        same(TestAllTypes_NestedMessage.$checkItem));

    expect(msg.info_.byName["repeatedGroup"].check,
        same(TestAllTypes_RepeatedGroup.$checkItem));

    expect(msg.info_.byName["repeatedNestedEnum"].check,
        same(TestAllTypes_NestedEnum.$checkItem));
  });
}
