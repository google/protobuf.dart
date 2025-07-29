// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/src/shared.dart';
import 'package:test/test.dart';

void main() {
  group('toDartComment', () {
    test('empty', () {
      expect(toDartComment(''), null);
    });

    test('just space', () {
      expect(toDartComment(' '), null);
    });

    test('indent', () {
      expect(
        toDartComment('''
 A line is nice
 
 with one indent - trailing whitespace removed
 
 
'''),
        '''
/// A line is nice
///
/// with one indent - trailing whitespace removed''',
      );
    });

    test('indent with blank lines', () {
      expect(
        toDartComment('''
 This is indented.

 This is indented.
'''),
        '''
/// This is indented.
///
/// This is indented.''',
      );
    });
  });

  group('which', () {
    test('can locate a command', () {
      final actual = which('dart');
      expect(actual, isNotNull);
    });

    test('missing command returns null', () {
      final actual = which('foo-bar-command');
      expect(actual, isNull);
    });
  });
}
