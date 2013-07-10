#!/usr/bin/env dart
// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protobuf_lib_all_tests;

import 'codec_test.dart' as ct;
import 'coded_buffer_reader_test.dart' as cbrt;
import 'pb_list_test.dart' as plt;

void main() {
  ct.main();
  cbrt.main();
  plt.main();
}