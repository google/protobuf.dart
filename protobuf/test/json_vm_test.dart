// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// VM-specific smoke tests for the GeneratedMessage JSON API.
//
// These tests will be skipped on js, as the dart2js platform
// does not support 64-bit ints.
@TestOn('!js')

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:test/test.dart';

import 'mock_util.dart' show T;

void main() {
  test('testInt64JsonEncoding', () {
    final value = Int64(1234567890123456789);
    final t = T()..int64 = value;
    final encoded = t.writeToJsonMap();
    expect(encoded['5'], '$value');
    final decoded = T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });
}
