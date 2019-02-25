#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library indenting_writer_test;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/src/descriptor.pb.dart';
import 'package:test/test.dart';

void main() {
  test('IndentingWriter can indent a block', () {
    var out = new IndentingWriter(filename: '');
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

  test('IndentingWriter annotation tracks previous output', () {
    var out = new IndentingWriter(filename: 'sample.proto');
    out.print('13 characters');
    out.print('sample text');
    out.addAnnotation([1, 2, 3], 'text', 7);
    GeneratedCodeInfo_Annotation expected = new GeneratedCodeInfo_Annotation()
      ..path.addAll([1, 2, 3])
      ..sourceFile = 'sample.proto'
      ..begin = 20
      ..end = 24;
    GeneratedCodeInfo_Annotation annotation =
        out.sourceLocationInfo.annotation[0];
    expect(annotation, equals(expected));
  });

  test('IndentingWriter annotation counts indents correctly', () {
    var out = new IndentingWriter(filename: '');
    out.addBlock('34 characters including newline {', '}', () {
      out.println('sample text');
      out.addAnnotation([], 'sample', 0);
    });
    GeneratedCodeInfo_Annotation annotation =
        out.sourceLocationInfo.annotation[0];
    expect(annotation.begin, equals(34));
    expect(annotation.end, equals(40));
  });

  test('IndentingWriter annotations counts multiline output correctly', () {
    var out = new IndentingWriter(filename: '');
    out.print('20 characters\ntotal\n');
    out.println('20 characters before this');
    out.addAnnotation([], 'ch', 3);
    GeneratedCodeInfo_Annotation annotation =
        out.sourceLocationInfo.annotation[0];
    expect(annotation.begin, equals(23));
    expect(annotation.end, equals(25));
  });

  test('IndentingWriter does not break when making annotation for null file',
      () {});
}
