// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;
import 'package:test/test.dart';

/// Will test [actual] against the contests of the file at [file].
///
/// If the file doesn't exist, the file is instead created containing [actual].
void expectGolden(String actual, String file) {
  final goldens = Directory(path.join('test', 'goldens'));
  if (!goldens.existsSync()) {
    goldens.createSync();
  }

  var golden = File(path.join(goldens.path, file));
  if (golden.existsSync()) {
    expect(
      actual,
      equals(golden.readAsStringSync()),
      reason: 'golden: "${golden.path}"',
    );
  } else {
    // Writing the updated file if none exists.
    final workspace = Platform.environment['BUILD_WORKSPACE_DIRECTORY'];
    if (workspace != null) {
      golden = File(path.join(workspace, 'test', 'goldens', file));
    }
    golden.writeAsStringSync(actual);
  }
}
