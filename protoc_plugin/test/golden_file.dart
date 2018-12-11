// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';
import 'package:test/test.dart';

/// Will test [actual] against the contests of the file at [goldenFilePath].
///
/// If the file doesn't exist, the file is instead created containing [actual].
void expectMatchesGoldenFile(String actual, String goldenFilePath) {
  File goldenFile = File(goldenFilePath);
  if (goldenFile.existsSync()) {
    expect(actual, equals(goldenFile.readAsStringSync()));
  } else {
    goldenFile
      ..createSync(recursive: true)
      ..writeAsStringSync(actual);
  }
}
