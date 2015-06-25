#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc_plugin_all_tests;

import 'client_generator_test.dart' as cgt;
import 'enum_generator_test.dart' as egt;
import 'file_generator_test.dart' as fgt;
import 'generated_message_test.dart' as gmt;
import 'hash_code_test.dart' as hct;
import 'indenting_writer_test.dart' as iwt;
import 'json_test.dart' as jt;
import 'map_test.dart' as map_test;
import 'message_generator_test.dart' as mgt;
import 'message_test.dart' as mt;
import 'protoc_options_test.dart' as pot;
import 'reserved_names_test.dart' as rnt;
import 'service_test.dart' as st;
import 'service_generator_test.dart' as sgt;
import 'unknown_field_set_test.dart' as ufst;
import 'validate_fail_test.dart' as vft;
import 'wire_format_test.dart' as wft;
import 'package:unittest/compact_vm_config.dart';

void main() {
  useCompactVMConfiguration();
  cgt.main();
  egt.main();
  fgt.main();
  gmt.main();
  hct.main();
  iwt.main();
  jt.main();
  map_test.main();
  mgt.main();
  mt.main();
  pot.main();
  rnt.main();
  st.main();
  sgt.main();
  ufst.main();
  vft.main();
  wft.main();
}
