// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:dart_style/dart_style.dart';
import 'package:pub_semver/pub_semver.dart';

// Note: keep this in sync with the SDK constraint in pubspec.yaml.
final Version formatUsingVersion = Version(3, 7, 0);

final DartFormatter _formatter = DartFormatter(
  languageVersion: formatUsingVersion,
);

/// Return the Dart formatted version of the given source.
String format(String source) => _formatter.format(source);
