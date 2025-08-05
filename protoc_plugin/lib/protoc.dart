// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:protobuf/protobuf.dart';

import 'const_generator.dart' show writeJsonConst;
import 'indenting_writer.dart';
import 'mixins.dart';
import 'names.dart';
import 'src/code_generator.dart';
import 'src/gen/dart_options.pb.dart';
import 'src/gen/google/api/client.pb.dart';
import 'src/gen/google/protobuf/compiler/plugin.pb.dart';
import 'src/gen/google/protobuf/descriptor.pb.dart';
import 'src/linker.dart';
import 'src/options.dart';
import 'src/output_config.dart';
import 'src/shared.dart';
import 'string_escape.dart';

export 'src/code_generator.dart';

part 'src/base_type.dart';
part 'src/client_generator.dart';
part 'src/enum_generator.dart';
part 'src/extension_generator.dart';
part 'src/file_generator.dart';
part 'src/grpc_generator.dart';
part 'src/message_generator.dart';
part 'src/protobuf_field.dart';
part 'src/service_generator.dart';
part 'src/well_known_types.dart';
