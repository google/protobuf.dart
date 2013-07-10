// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protobuf;

import 'dart:async';
import 'dart:collection';
import 'dart:json' as json;
import 'dart:math';
import 'dart:typed_data';
import 'dart:utf';

import 'package:crypto/crypto.dart';

part 'coded_buffer_reader.dart';
part 'coded_buffer_writer.dart';
part 'builder_info.dart';
part 'exceptions.dart';
part 'extension.dart';
part 'extension_registry.dart';
part 'field_info.dart';
part 'generated_message.dart';
part 'pb_list.dart';
part 'protobuf_enum.dart';
part 'unknown_field_set.dart';
part 'utils.dart';
part 'wire_format.dart';

makeLongInt(n) =>
    new ByteData(8)
        ..setUint32(0, n & 0xffffffff, Endianness.LITTLE_ENDIAN)
        ..setUint32(4, (n >> 32) & 0xffffffff, Endianness.LITTLE_ENDIAN);
