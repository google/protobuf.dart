// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/src/generated/descriptor.pb.dart';
import 'package:test/test.dart';

void main() {
  group('IndentingWriter', () {
    test('IndentingWriter can indent a block', () {
      final out = IndentingWriter(filename: '');
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
      final out = IndentingWriter(filename: 'sample.proto');
      out.print('13 characters');
      out.printAnnotated('sample text', [
        NamedLocation(name: 'text', fieldPathSegment: [1, 2, 3], start: 7)
      ]);
      final expected = GeneratedCodeInfo_Annotation()
        ..path.addAll([1, 2, 3])
        ..sourceFile = 'sample.proto'
        ..begin = 20
        ..end = 24;
      final annotation = out.sourceLocationInfo.annotation[0];
      expect(annotation, equals(expected));
    });

    test('IndentingWriter annotation counts indents correctly', () {
      final out = IndentingWriter(filename: '');
      out.addBlock('34 characters including newline {', '}', () {
        out.printlnAnnotated('sample text',
            [NamedLocation(name: 'sample', fieldPathSegment: [], start: 0)]);
      });
      final annotation = out.sourceLocationInfo.annotation[0];
      // The indent is 2 characters, so these should be shifted by 2.
      expect(annotation.begin, equals(36));
      expect(annotation.end, equals(42));
    });

    test('IndentingWriter annotations counts multiline output correctly', () {
      final out = IndentingWriter(filename: '');
      out.print('20 characters\ntotal\n');
      out.printlnAnnotated('20 characters before this',
          [NamedLocation(name: 'ch', fieldPathSegment: [], start: 3)]);
      final annotation = out.sourceLocationInfo.annotation[0];
      expect(annotation.begin, equals(23));
      expect(annotation.end, equals(25));
    });
  });

  group('ImportWriter', () {
    late ImportWriter importWriter;

    setUp(() {
      importWriter = ImportWriter();
    });

    test('sorting', () {
      importWriter.addImport('dart:typed_data');
      importWriter.addImport('dart:convert', prefix: 'convert');
      importWriter.addImport('dart:async');

      expect(importWriter.emit(), equals('''
import 'dart:async';
import 'dart:convert' as convert;
import 'dart:typed_data';
'''));
    });

    test('grouping', () {
      importWriter.addImport('string_utilities.dart');
      importWriter.addImport('package:path/path.dart', prefix: 'path');
      importWriter.addImport('dart:convert', prefix: 'convert');

      expect(importWriter.emit(), equals('''
import 'dart:convert' as convert;

import 'package:path/path.dart' as path;

import 'string_utilities.dart';
'''));
    });
  });
}
