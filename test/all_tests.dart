#!/usr/bin/env dart
// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc_plugin_all_tests;

import 'enum_generator_test.dart' as egt;
import 'indenting_writer_test.dart' as iwt;
import 'message_generator_test.dart' as mgt;

void main() {
  egt.main();
  iwt.main();
  mgt.main();
}
