#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library indenting_writer_test;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:test/test.dart';

void main() {
  test('IndentingWriter can indent a block', () {
    var out = new IndentingWriter();
    out.addBlock('class test {', '}', () {
      out.println('first;');
      out.println();
      out.println('second;');
    });

    expect(out.toString(), '''
class test {
  first;

  second;
}
''');
  });
}
