// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:path/path.dart' as path;
import 'package:pub_semver/pub_semver.dart';
import 'package:test/test.dart';

/// Will test [actual] against the contests of the file at [file].
///
/// If the file doesn't exist, the file is instead created containing [actual].
void expectGolden(String actual, String file) {
  final goldens = Directory(path.join('test', 'goldens'));
  if (!goldens.existsSync()) {
    goldens.createSync();
  }

  // TODO(devoncarew): We should move the formatting logic out of this test;
  // perhaps into the generating code.
  if (file.endsWith('.dart')) {
    actual = format(actual);
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

String format(String source) {
  // TODO(devoncarew): Move this language version to a central location.
  // For tests, this version should match that of package:protoc_plugin.
  final formatter = DartFormatter(languageVersion: Version(3, 7, 0));
  return formatter.format(source);
}
