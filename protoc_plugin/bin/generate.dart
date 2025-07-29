#!/usr/bin/env dart
// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A command line utility to allow easy generation of protobuf files.
library;

import 'package:protoc_plugin/generate.dart';

void main(List<String> args) {
  final generator = ProtoGen();
  generator.generate(args);
}
