#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc_plugin_all_tests;

import 'enum_generator_test.dart' as egt;
import 'generated_message_test.dart' as gmt;
import 'indenting_writer_test.dart' as iwt;
import 'json_test.dart' as jt;
import 'message_generator_test.dart' as mgt;
import 'file_generator_test.dart' as fgt;
import 'message_test.dart' as mt;
import 'protoc_options_test.dart' as pot;
import 'unknown_field_set_test.dart' as ufst;
import 'validate_fail_test.dart' as vft;
import 'wire_format_test.dart' as wft;
import 'reserved_names_test.dart' as rnt;

void main() {
  egt.main();
  gmt.main();
  iwt.main();
  jt.main();
  mgt.main();
  fgt.main();
  mt.main();
  pot.main();
  ufst.main();
  vft.main();
  wft.main();
  rnt.main();
}
