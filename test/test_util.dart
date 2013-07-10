// Copyright(c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library test_util;

import 'dart:typed_data';

import 'package:unittest/unittest.dart';

make64(lo, [hi = null]) {
  if (hi == null) hi = lo < 0 ? -1 : 0;
  return new ByteData(8)
      ..setUint32(0, lo, Endianness.LITTLE_ENDIAN)
      ..setUint32(4, hi, Endianness.LITTLE_ENDIAN);
}

expect64(lo, [hi = null]) {
  final expected = make64(lo, hi);
  return predicate((actual) {
    get(data, offset) => data.getUint32(offset, Endianness.LITTLE_ENDIAN);
    return get(actual, 0) == get(expected, 0) &&
        get(actual, 4) == get(expected, 4);
  });
}
