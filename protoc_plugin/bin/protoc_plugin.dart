#!/usr/bin/env dart
// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// This entry-point is expected to be called from the `protoc` command-line
/// tool.
///
/// It will read it's binary, protobuf encoded input from stdin and write its
/// cooresponding output to stdout.
///
/// See https://protobuf.dev/reference/other/ for more information about
/// Protobuf compiler plugins.
library;

import 'dart:io';

import 'package:protoc_plugin/protoc.dart';

void main() async {
  final generator = CodeGenerator(stdin, stdout);
  await generator.generate();
}
