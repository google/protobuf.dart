// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protobuf;

import 'dart:collection' show ListMixin;
import 'dart:convert' show JSON, Utf8Codec;
import 'dart:math' as math;
import 'dart:typed_data' show TypedData, Uint8List, ByteData, Endianness;

import 'package:crypto/crypto.dart' show CryptoUtils;
import 'package:fixnum/fixnum.dart' show Int64;

part 'src/protobuf/coded_buffer_reader.dart';
part 'src/protobuf/coded_buffer_writer.dart';
part 'src/protobuf/builder_info.dart';
part 'src/protobuf/exceptions.dart';
part 'src/protobuf/extension.dart';
part 'src/protobuf/extension_registry.dart';
part 'src/protobuf/field_info.dart';
part 'src/protobuf/generated_message.dart';
part 'src/protobuf/pb_list.dart';
part 'src/protobuf/protobuf_enum.dart';
part 'src/protobuf/unknown_field_set.dart';
part 'src/protobuf/utils.dart';
part 'src/protobuf/wire_format.dart';

Int64 makeLongInt(int n) => new Int64(n);

const _UTF8 = const Utf8Codec(allowMalformed: true);
