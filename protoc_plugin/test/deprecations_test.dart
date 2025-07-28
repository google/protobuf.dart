// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:io';

import 'package:test/test.dart';

import 'src/golden_file.dart';

void main() {
  test('Deprecated annotation generation for messages', () {
    final actual = File('test/gen/deprecations.pb.dart').readAsStringSync();
    expectGolden(actual, 'deprecations.pb.dart');
  });

  test('Deprecated annotation generation for enums', () {
    final actual = File('test/gen/deprecations.pbenum.dart').readAsStringSync();
    expectGolden(actual, 'deprecations.pbenum.dart');
  });
}
