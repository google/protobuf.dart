// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Runtime library for Dart implementation of [protobufs][1].
///
/// [1]: https://developers.google.com/protocol-buffers
library;

import 'dart:collection' show ListBase, MapBase;
import 'dart:convert'
    show
        Utf8Decoder,
        Utf8Encoder,
        base64Decode,
        base64Encode,
        jsonDecode,
        jsonEncode;
import 'dart:math' as math;
import 'dart:typed_data' show ByteData, Endian, Uint8List;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:meta/meta.dart' show UseResult;

import 'json_parsing_context.dart';
import 'permissive_compare.dart';
import 'type_registry.dart';

export 'type_registry.dart' show TypeRegistry;

part 'annotations.dart';
part 'builder_info.dart';
part 'coded_buffer.dart';
part 'coded_buffer_reader.dart';
part 'coded_buffer_writer.dart';
part 'consts.dart';
part 'exceptions.dart';
part 'extension.dart';
part 'extension_field_set.dart';
part 'extension_registry.dart';
part 'field_error.dart';
part 'field_info.dart';
part 'field_set.dart';
part 'field_type.dart';
part 'generated_message.dart';
part 'generated_service.dart';
part 'json.dart';
part 'message_set.dart';
part 'pb_list.dart';
part 'pb_map.dart';
part 'proto3_json.dart';
part 'protobuf_enum.dart';
part 'rpc_client.dart';
part 'unknown_field_set.dart';
part 'unpack.dart';
part 'utils.dart';
part 'wire_format.dart';

// TODO(sra): Use `Int64.parse()` when available:
// https://github.com/dart-lang/fixnum/issues/18.
/// @nodoc
Int64 parseLongInt(String text) {
  if (text.startsWith('0x')) return Int64.parseHex(text.substring(2));
  if (text.startsWith('+0x')) return Int64.parseHex(text.substring(3));
  if (text.startsWith('-0x')) return -Int64.parseHex(text.substring(3));
  return Int64.parseInt(text);
}
