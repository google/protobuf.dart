// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: constant_identifier_names

part of 'internal.dart';

const int _TAG_TYPE_BITS = 3;
const int _TAG_TYPE_MASK = (1 << _TAG_TYPE_BITS) - 1;

/// @nodoc
const int WIRETYPE_VARINT = 0;

/// @nodoc
const int WIRETYPE_FIXED64 = 1;

/// @nodoc
const int WIRETYPE_LENGTH_DELIMITED = 2;

/// @nodoc
const int WIRETYPE_START_GROUP = 3;

/// @nodoc
const int WIRETYPE_END_GROUP = 4;

/// @nodoc
const int WIRETYPE_FIXED32 = 5;

/// @nodoc
int getTagFieldNumber(int tag) => tag >> _TAG_TYPE_BITS;

/// @nodoc
int getTagWireType(int tag) => tag & _TAG_TYPE_MASK;

/// @nodoc
int makeTag(int fieldNumber, int tag) => (fieldNumber << _TAG_TYPE_BITS) | tag;

/// Returns true if the wireType can be merged into the given fieldType.
bool _wireTypeMatches(int fieldType, int wireType) {
  switch (PbFieldType._baseType(fieldType)) {
    case PbFieldType._BOOL_BIT:
    case PbFieldType._ENUM_BIT:
    case PbFieldType._INT32_BIT:
    case PbFieldType._INT64_BIT:
    case PbFieldType._SINT32_BIT:
    case PbFieldType._SINT64_BIT:
    case PbFieldType._UINT32_BIT:
    case PbFieldType._UINT64_BIT:
      return wireType == WIRETYPE_VARINT ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case PbFieldType._FLOAT_BIT:
    case PbFieldType._FIXED32_BIT:
    case PbFieldType._SFIXED32_BIT:
      return wireType == WIRETYPE_FIXED32 ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case PbFieldType._DOUBLE_BIT:
    case PbFieldType._FIXED64_BIT:
    case PbFieldType._SFIXED64_BIT:
      return wireType == WIRETYPE_FIXED64 ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case PbFieldType._BYTES_BIT:
    case PbFieldType._STRING_BIT:
    case PbFieldType._MESSAGE_BIT:
      return wireType == WIRETYPE_LENGTH_DELIMITED;
    case PbFieldType._GROUP_BIT:
      return wireType == WIRETYPE_START_GROUP;
    default:
      return false;
  }
}
