#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.11

import 'any_test.dart' as any;
import 'bazel_test.dart' as bazel;
import 'client_generator_test.dart' as client_generator;
import 'const_generator_test.dart' as const_generator;
import 'default_value_escape_test.dart' as default_value_escape;
import 'descriptor_test.dart' as descriptor_test;
import 'enum_generator_test.dart' as enum_generator;
import 'extension_generator_test.dart' as extension_generator_test;
import 'extension_test.dart' as extension_test;
import 'file_generator_test.dart' as file_generator;
import 'generated_message_test.dart' as generated_message;
import 'hash_code_test.dart' as hash_code;
import 'high_tagnumber_test.dart' as high_tagnumber;
import 'import_public_test.dart' as import_public;
import 'import_test.dart' as import_prefix;
import 'indenting_writer_test.dart' as indenting_writer;
import 'json_test.dart' as json;
import 'leading_underscores_test.dart' as leading_underscores;
import 'map_field_test.dart' as map_field;
import 'map_test.dart' as map;
import 'merge_test.dart' as merge;
import 'message_generator_test.dart' as message_generator;
import 'message_test.dart' as message;
import 'mixin_test.dart' as mixin_test;
import 'names_test.dart' as names;
import 'omit_enum_names_test.dart' as omit_enum_names;
import 'omit_field_names_test.dart' as omit_field_names;
import 'omit_message_names_test.dart' as omit_message_names;
import 'oneof_test.dart' as oneof;
import 'proto3_optional_test.dart' as proto3_optional;
import 'protoc_options_test.dart' as protoc_options;
import 'repeated_field_test.dart' as repeated_field;
import 'reserved_names_test.dart' as reserved_names;
import 'send_protos_via_sendports_test.dart' as send_protos_via_sendports_test;
import 'service_generator_test.dart' as service_generator;
import 'service_test.dart' as service;
import 'to_builder_test.dart' as to_builder;
import 'unknown_field_set_test.dart' as unknown_field_set;
import 'validate_fail_test.dart' as validate_fail;
import 'wire_format_test.dart' as wire_format;

void main() {
  any.main();
  bazel.main();
  client_generator.main();
  const_generator.main();
  default_value_escape.main();
  descriptor_test.main();
  enum_generator.main();
  extension_generator_test.main();
  extension_test.main();
  file_generator.main();
  generated_message.main();
  hash_code.main();
  high_tagnumber.main();
  import_prefix.main();
  import_public.main();
  indenting_writer.main();
  json.main();
  leading_underscores.main();
  map.main();
  map_field.main();
  merge.main();
  message.main();
  message_generator.main();
  mixin_test.main();
  names.main();
  omit_enum_names.main();
  omit_field_names.main();
  omit_message_names.main();
  oneof.main();
  proto3_optional.main();
  protoc_options.main();
  repeated_field.main();
  reserved_names.main();
  send_protos_via_sendports_test.main();
  service.main();
  service_generator.main();
  to_builder.main();
  unknown_field_set.main();
  validate_fail.main();
  wire_format.main();
}
