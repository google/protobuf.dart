// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:test/test.dart';

import 'golden_file.dart';

void main() {
  test('Doc comment generation for messages', () {
    final actual = File('out/protos/doc_comments.pb.dart').readAsStringSync();
    expectMatchesGoldenFile(actual, 'test/goldens/doc_comments');
  });

  test('Doc comment generation for enums', () {
    final actual = File('out/protos/constructor_args/doc_comments.pbenum.dart')
        .readAsStringSync();
    expectMatchesGoldenFile(actual, 'test/goldens/doc_comments.pbenum');
  });
}
