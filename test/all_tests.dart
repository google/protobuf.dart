#!/usr/bin/env dart
// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protobuf_lib_all_tests;

import 'codec_test.dart' as codec;
import 'coded_buffer_reader_test.dart' as reader;
import 'json_test.dart' as json;
import 'map_mixin_test.dart' as map_mixin;
import 'pb_list_test.dart' as pb_list;

void main() {
  codec.main();
  reader.main();
  json.main();
  map_mixin.main();
  pb_list.main();
}
