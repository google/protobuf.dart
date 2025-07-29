// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:protoc_plugin/src/generate_utils.dart';
import 'package:protoc_plugin/src/shared.dart';
import 'package:test/test.dart';

void main() {
  test('calculateDefaultProtosPath', () {
    final actual = calculateDefaultProtosPath();
    expect(actual, isNotNull);
  }, skip: noProtoc());

  group('TempExecScriptHelper', () {
    TempExecScriptHelper? helper;

    tearDown(() {
      helper?.dispose();
    });

    test('create', () {
      helper = TempExecScriptHelper();

      expect(helper!.execScript.existsSync(), true);
      expect(
        helper!.execScript.readAsStringSync(),
        contains('dart run protoc_plugin'),
      );
    });

    test('dispose', () {
      helper = TempExecScriptHelper();

      expect(helper!.execScript.existsSync(), true);
      helper!.dispose();
      expect(helper!.execScript.existsSync(), false);
    });
  });
}

String? noProtoc() => which('protoc') == null ? 'protoc not found' : null;
