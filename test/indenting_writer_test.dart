#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library indenting_writer_test;

import 'package:protoc_plugin/protoc.dart';
import 'package:test/test.dart';

void main() {
  test('testIndentingWriter', () {
    String blockExpected = r'''class test{
  body;
}
''';

    var iob = new MemoryWriter();
    var writer = new IndentingWriter('  ', iob);
    writer.addBlock('class test{', '}', () {
      writer.println('body;');
    });
    expect(iob.toString(), blockExpected);
  });
}
