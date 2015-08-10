// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

const int TAG_TYPE_BITS = 3;
const int TAG_TYPE_MASK = (1 << TAG_TYPE_BITS) - 1;

const int WIRETYPE_VARINT = 0;
const int WIRETYPE_FIXED64 = 1;
const int WIRETYPE_LENGTH_DELIMITED = 2;
const int WIRETYPE_START_GROUP = 3;
const int WIRETYPE_END_GROUP = 4;
const int WIRETYPE_FIXED32 = 5;

int getTagFieldNumber(int tag) => (tag & 0x7fffffff) >> TAG_TYPE_BITS;

int getTagWireType(int tag) => tag & TAG_TYPE_MASK;

int makeTag(int fieldNumber, int tag) => (fieldNumber << TAG_TYPE_BITS) | tag;

/// Returns true if the wireType can be merged into the given fieldType.
bool _wireTypeMatches(int fieldType, int wireType) {
  switch (FieldType._baseType(fieldType)) {
    case FieldType._BOOL_BIT:
    case FieldType._ENUM_BIT:
    case FieldType._INT32_BIT:
    case FieldType._INT64_BIT:
    case FieldType._SINT32_BIT:
    case FieldType._SINT64_BIT:
    case FieldType._UINT32_BIT:
    case FieldType._UINT64_BIT:
      return wireType == WIRETYPE_VARINT ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case FieldType._FLOAT_BIT:
    case FieldType._FIXED32_BIT:
    case FieldType._SFIXED32_BIT:
      return wireType == WIRETYPE_FIXED32 ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case FieldType._DOUBLE_BIT:
    case FieldType._FIXED64_BIT:
    case FieldType._SFIXED64_BIT:
      return wireType == WIRETYPE_FIXED64 ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case FieldType._BYTES_BIT:
    case FieldType._STRING_BIT:
    case FieldType._MESSAGE_BIT:
      return wireType == WIRETYPE_LENGTH_DELIMITED;
    case FieldType._GROUP_BIT:
      return wireType == WIRETYPE_START_GROUP;
    default:
      return false;
  }
}
