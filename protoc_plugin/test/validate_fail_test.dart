// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'gen/google/protobuf/unittest.pb.dart';

const int minI32 = -2147483648;

const int maxI32 = 2147483647;

const int maxU32 = 4294967295;

const List<double> invalidFloats = [
  -3.4028234663852886E39,
  3.4028234663852886E39,
];

const isTypeError = TypeMatcher<TypeError>();

// ignore: deprecated_member_use
const Matcher throwsTypeError = Throws(isTypeError);

void main() {
  test('Fields validate values', () {
    // Nullability and type checks
    expect(() {
      (TestAllTypes() as dynamic).optionalNestedMessage = null;
    }, throwsTypeError);

    expect(() {
      (TestAllTypes() as dynamic).optionalBool = null;
    }, throwsTypeError);

    expect(() {
      (TestAllTypes() as dynamic).optionalNestedMessage = 123;
    }, throwsTypeError);

    expect(() {
      (TestAllTypes() as dynamic).optionalBool = 123;
    }, throwsTypeError);

    // int32
    TestAllTypes().optionalInt32 = minI32;
    TestAllTypes().optionalInt32 = -123;
    TestAllTypes().optionalInt32 = maxI32;
    TestAllTypes().optionalInt32 = 123;

    expect(() {
      TestAllTypes().optionalInt32 = minI32 - 1;
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().optionalInt32 = maxI32 + 1;
    }, throwsArgumentError);

    // sint32
    TestAllTypes().optionalSint32 = minI32;
    TestAllTypes().optionalSint32 = -123;
    TestAllTypes().optionalSint32 = maxI32;
    TestAllTypes().optionalSint32 = 123;

    expect(() {
      TestAllTypes().optionalSint32 = minI32 - 1;
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().optionalSint32 = maxI32 + 1;
    }, throwsArgumentError);

    // sfixed32
    TestAllTypes().optionalSfixed32 = minI32;
    TestAllTypes().optionalSfixed32 = -123;
    TestAllTypes().optionalSfixed32 = maxI32;
    TestAllTypes().optionalSfixed32 = 123;

    expect(() {
      TestAllTypes().optionalSfixed32 = minI32 - 1;
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().optionalSfixed32 = maxI32 + 1;
    }, throwsArgumentError);

    // uint32
    TestAllTypes().optionalUint32 = maxU32;
    TestAllTypes().optionalUint32 = 123;

    expect(() {
      TestAllTypes().optionalUint32 = -1;
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().optionalUint32 = maxU32 + 1;
    }, throwsArgumentError);

    // fixed32
    TestAllTypes().optionalFixed32 = maxU32;
    TestAllTypes().optionalFixed32 = 123;

    expect(() {
      TestAllTypes().optionalFixed32 = -1;
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().optionalFixed32 = maxU32 + 1;
    }, throwsArgumentError);

    // float
    TestAllTypes().optionalFloat = 1.2;

    for (double invalid in invalidFloats) {
      expect(() {
        TestAllTypes().optionalFloat = invalid;
      }, throwsArgumentError);
    }
  });

  test('Repeated fields validate values', () {
    // Nullability and type checks
    expect(() {
      (TestAllTypes() as dynamic).repeatedNestedMessage.add(null);
    }, throwsTypeError);

    expect(() {
      (TestAllTypes() as dynamic).repeatedBool.add(null);
    }, throwsTypeError);

    expect(() {
      (TestAllTypes() as dynamic).repeatedNestedMessage.add(123);
    }, throwsTypeError);

    expect(() {
      (TestAllTypes() as dynamic).repeatedBool.add(123);
    }, throwsTypeError);

    // int32
    TestAllTypes().repeatedInt32.add(minI32);
    TestAllTypes().repeatedInt32.add(-123);
    TestAllTypes().repeatedInt32.add(maxI32);
    TestAllTypes().repeatedInt32.add(123);

    expect(() {
      TestAllTypes().repeatedInt32.add(minI32 - 1);
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().repeatedInt32.add(maxI32 + 1);
    }, throwsArgumentError);

    // sint32
    TestAllTypes().repeatedSint32.add(minI32);
    TestAllTypes().repeatedSint32.add(-123);
    TestAllTypes().repeatedSint32.add(maxI32);
    TestAllTypes().repeatedSint32.add(123);

    expect(() {
      TestAllTypes().repeatedSint32.add(minI32 - 1);
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().repeatedSint32.add(maxI32 + 1);
    }, throwsArgumentError);

    // sfixed32
    TestAllTypes().repeatedSfixed32.add(minI32);
    TestAllTypes().repeatedSfixed32.add(-123);
    TestAllTypes().repeatedSfixed32.add(maxI32);
    TestAllTypes().repeatedSfixed32.add(123);

    expect(() {
      TestAllTypes().repeatedSfixed32.add(minI32 - 1);
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().repeatedSfixed32.add(maxI32 + 1);
    }, throwsArgumentError);

    // uint32
    TestAllTypes().repeatedUint32.add(maxU32);
    TestAllTypes().repeatedUint32.add(123);

    expect(() {
      TestAllTypes().repeatedUint32.add(-1);
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().repeatedUint32.add(maxU32 + 1);
    }, throwsArgumentError);

    // fixed32
    TestAllTypes().repeatedFixed32.add(maxU32);
    TestAllTypes().repeatedFixed32.add(123);

    expect(() {
      TestAllTypes().repeatedFixed32.add(-1);
    }, throwsArgumentError);

    expect(() {
      TestAllTypes().repeatedFixed32.add(maxU32 + 1);
    }, throwsArgumentError);

    // float
    TestAllTypes().repeatedFloat.add(1.2);

    for (double invalid in invalidFloats) {
      expect(() {
        TestAllTypes().repeatedFloat.add(invalid);
      }, throwsArgumentError);
    }
  });

  test('Extension fields validate values', () {
    // Type checks
    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalNestedMessageExtension,
        123,
      );
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().setExtension(Unittest.optionalBoolExtension, 123);
    }, throwsArgumentError);

    // int32
    TestAllExtensions().setExtension(Unittest.optionalInt32Extension, minI32);
    TestAllExtensions().setExtension(Unittest.optionalInt32Extension, -123);
    TestAllExtensions().setExtension(Unittest.optionalInt32Extension, maxI32);
    TestAllExtensions().setExtension(Unittest.optionalInt32Extension, 123);

    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalInt32Extension,
        minI32 - 1,
      );
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalInt32Extension,
        maxI32 + 1,
      );
    }, throwsArgumentError);

    // sint32
    TestAllExtensions().setExtension(Unittest.optionalSint32Extension, minI32);
    TestAllExtensions().setExtension(Unittest.optionalSint32Extension, -123);
    TestAllExtensions().setExtension(Unittest.optionalSint32Extension, maxI32);
    TestAllExtensions().setExtension(Unittest.optionalSint32Extension, 123);

    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalSint32Extension,
        minI32 - 1,
      );
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalSint32Extension,
        maxI32 + 1,
      );
    }, throwsArgumentError);

    // sfixed32
    TestAllExtensions().setExtension(
      Unittest.optionalSfixed32Extension,
      minI32,
    );
    TestAllExtensions().setExtension(Unittest.optionalSfixed32Extension, -123);
    TestAllExtensions().setExtension(
      Unittest.optionalSfixed32Extension,
      maxI32,
    );
    TestAllExtensions().setExtension(Unittest.optionalSfixed32Extension, 123);

    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalSfixed32Extension,
        minI32 - 1,
      );
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalSfixed32Extension,
        maxI32 + 1,
      );
    }, throwsArgumentError);

    // uint32
    TestAllExtensions().setExtension(Unittest.optionalUint32Extension, maxU32);
    TestAllExtensions().setExtension(Unittest.optionalUint32Extension, 123);

    expect(() {
      TestAllExtensions().setExtension(Unittest.optionalUint32Extension, -1);
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalUint32Extension,
        maxU32 + 1,
      );
    }, throwsArgumentError);

    // fixed32
    TestAllExtensions().setExtension(Unittest.optionalFixed32Extension, maxU32);
    TestAllExtensions().setExtension(Unittest.optionalFixed32Extension, 123);

    expect(() {
      TestAllExtensions().setExtension(Unittest.optionalFixed32Extension, -1);
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().setExtension(
        Unittest.optionalFixed32Extension,
        maxU32 + 1,
      );
    }, throwsArgumentError);

    // float
    TestAllExtensions().setExtension(Unittest.optionalFloatExtension, 1.2);

    for (double invalid in invalidFloats) {
      expect(() {
        TestAllExtensions().setExtension(
          Unittest.optionalFloatExtension,
          invalid,
        );
      }, throwsArgumentError);
    }
  });

  test('Repeated extension fields validate values', () {
    // Nullability and type checks
    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedNestedMessageExtension,
        null,
      );
    }, throwsTypeError);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedNestedMessageExtension,
        123,
      );
    }, throwsTypeError);

    expect(() {
      TestAllExtensions().addExtension(Unittest.repeatedBoolExtension, null);
    }, throwsTypeError);

    expect(() {
      TestAllExtensions().addExtension(Unittest.repeatedBoolExtension, 123);
    }, throwsTypeError);

    // int32
    TestAllExtensions().addExtension(Unittest.repeatedInt32Extension, minI32);
    TestAllExtensions().addExtension(Unittest.repeatedInt32Extension, -123);
    TestAllExtensions().addExtension(Unittest.repeatedInt32Extension, maxI32);
    TestAllExtensions().addExtension(Unittest.repeatedInt32Extension, 123);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedInt32Extension,
        minI32 - 1,
      );
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedInt32Extension,
        maxI32 + 1,
      );
    }, throwsArgumentError);

    // sint32
    TestAllExtensions().addExtension(Unittest.repeatedSint32Extension, minI32);
    TestAllExtensions().addExtension(Unittest.repeatedSint32Extension, -123);
    TestAllExtensions().addExtension(Unittest.repeatedSint32Extension, maxI32);
    TestAllExtensions().addExtension(Unittest.repeatedSint32Extension, 123);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedSint32Extension,
        minI32 - 1,
      );
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedSint32Extension,
        maxI32 + 1,
      );
    }, throwsArgumentError);

    // sfixed32
    TestAllExtensions().addExtension(
      Unittest.repeatedSfixed32Extension,
      minI32,
    );
    TestAllExtensions().addExtension(Unittest.repeatedSfixed32Extension, -123);
    TestAllExtensions().addExtension(
      Unittest.repeatedSfixed32Extension,
      maxI32,
    );
    TestAllExtensions().addExtension(Unittest.repeatedSfixed32Extension, 123);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedSfixed32Extension,
        minI32 - 1,
      );
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedSfixed32Extension,
        maxI32 + 1,
      );
    }, throwsArgumentError);

    // uint32
    TestAllExtensions().addExtension(Unittest.repeatedUint32Extension, maxU32);
    TestAllExtensions().addExtension(Unittest.repeatedUint32Extension, 123);

    expect(() {
      TestAllExtensions().addExtension(Unittest.repeatedUint32Extension, -1);
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedUint32Extension,
        maxU32 + 1,
      );
    }, throwsArgumentError);

    // fixed32
    TestAllExtensions().addExtension(Unittest.repeatedFixed32Extension, maxU32);
    TestAllExtensions().addExtension(Unittest.repeatedFixed32Extension, 123);

    expect(() {
      TestAllExtensions().addExtension(Unittest.repeatedFixed32Extension, -1);
    }, throwsArgumentError);

    expect(() {
      TestAllExtensions().addExtension(
        Unittest.repeatedFixed32Extension,
        maxU32 + 1,
      );
    }, throwsArgumentError);

    // float
    TestAllExtensions().addExtension(Unittest.repeatedFloatExtension, 1.2);

    for (double invalid in invalidFloats) {
      expect(() {
        TestAllExtensions().addExtension(
          Unittest.repeatedFloatExtension,
          invalid,
        );
      }, throwsArgumentError);
    }
  });
}
