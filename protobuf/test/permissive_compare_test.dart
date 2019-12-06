// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';
import 'package:protobuf/src/protobuf/permissive_compare.dart';

void main() {
  void symmetric(String a, String b, bool expected) {
    expect(permissiveCompare(a, b), expected);
    expect(permissiveCompare(b, a), expected);
  }

  test('permissive compare', () {
    symmetric('', '', true);
    symmetric('-', '', true);
    symmetric('_', '', true);
    symmetric('a', 'a', true);
    symmetric('A', 'a', true);
    symmetric('-a', 'a', true);
    symmetric('-a', '_a', true);
    symmetric('----a', '____a', true);
    symmetric('a-', 'a', true);
    symmetric('a-', 'a', true);
    symmetric('a-a', '_a_', false);
    symmetric('a-a', '_A_A', true);
    symmetric('aa', 'a', false);
    symmetric('', 'a', false);
    symmetric('_x', '_Y', false);
    symmetric('xx', 'YY', false);
  });
}
