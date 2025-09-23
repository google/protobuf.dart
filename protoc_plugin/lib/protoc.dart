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
import 'src/gen/google/protobuf/dart_edition_defaults.pb.dart';
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
part 'src/paths.dart';
part 'src/protobuf_field.dart';
part 'src/service_generator.dart';
part 'src/well_known_types.dart';

final FeatureSetDefaults pluginFeatureSetDefaults =
    FeatureSetDefaults.fromBuffer(
      base64Decode(ProtobufInternalDartEditionDefaults),
    );

int get pluginMinSupportedEdition {
  final minSupportedEdition = Edition.EDITION_PROTO2;

  // The edition defaults should always stay synchronized with the supported
  // edition range we report to protoc. It's not clear that the BUILD file
  // definitions are load-bearing though, so we explicitly set them above and
  // assert that the two are equal.
  assert(minSupportedEdition == pluginFeatureSetDefaults.minimumEdition);

  return Edition.EDITION_PROTO2.value;
}

int get pluginMaxSupportedEdition {
  final maxSupportedEdition = Edition.EDITION_2024;

  // Same as above, check that the plugin support is in sync with the feature
  // set defaults constant.
  assert(maxSupportedEdition == pluginFeatureSetDefaults.minimumEdition);

  return maxSupportedEdition.value;
}
