// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import '../out/protos/google/protobuf/unittest.pb.dart';

void main() {
  test('testValidationFailureMessages', () {
    var builder = TestAllTypes();

    expect(() {
      builder.optionalInt32 = -2147483649;
    }, throwsArgumentError);

    expect(() {
      builder.optionalInt32 = 2147483648;
    }, throwsArgumentError);

    expect(() {
      builder.optionalUint32 = -1;
    }, throwsArgumentError);

    expect(() {
      builder.optionalUint32 = 4294967296;
    }, throwsArgumentError);

    expect(() {
      builder.optionalSint32 = -2147483649;
    }, throwsArgumentError);

    expect(() {
      builder.optionalSint32 = 2147483648;
    }, throwsArgumentError);

    expect(() {
      builder.optionalFixed32 = -1;
    }, throwsArgumentError);

    expect(() {
      builder.optionalFixed32 = 4294967296;
    }, throwsArgumentError);

    expect(() {
      builder.optionalSfixed32 = -2147483649;
    }, throwsArgumentError);

    expect(() {
      builder.optionalSfixed32 = 2147483648;
    }, throwsArgumentError);

    expect(() {
      builder.optionalFloat = -3.4028234663852886E39;
    }, throwsArgumentError);

    expect(() {
      builder.optionalFloat = 3.4028234663852886E39;
    }, throwsArgumentError);

    // Set repeating value (no setter should exist).
    expect(() {
      (builder as dynamic).repeatedInt32 = 201;
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
