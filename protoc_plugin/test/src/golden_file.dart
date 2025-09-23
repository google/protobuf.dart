// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

/// Test [actual] against the contests of the file at [file].
///
/// When the `PROTOC_UPDATE_GOLDENS` environment variable is set, the [file]
/// will be crated (overwritten if already exists) with the [actual] as the
/// contents. This can be used to automatically update golden test expectations.
void expectGolden(String actual, String file) {
  var goldenFilePath = path.join('test', 'goldens', file);
  if (Platform.environment.containsKey('PROTOC_UPDATE_GOLDENS')) {
    final workspace = Platform.environment['BUILD_WORKSPACE_DIRECTORY'];
    if (workspace != null) {
      goldenFilePath = path.join(workspace, goldenFilePath);
    }
    File(goldenFilePath)
      ..createSync(recursive: true)
      ..writeAsStringSync(actual);
  } else {
    expect(
      actual,
      equals(File(goldenFilePath).readAsStringSync()),
      reason: 'golden: "$goldenFilePath"',
    );
  }
}
