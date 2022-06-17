// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: constant_identifier_names

part of protobuf;

const int TAG_TYPE_BITS = 3;
const int TAG_TYPE_MASK = (1 << TAG_TYPE_BITS) - 1;

const int WIRETYPE_VARINT = 0;
const int WIRETYPE_FIXED64 = 1;
const int WIRETYPE_LENGTH_DELIMITED = 2;
const int WIRETYPE_START_GROUP = 3;
const int WIRETYPE_END_GROUP = 4;
const int WIRETYPE_FIXED32 = 5;

int getTagFieldNumber(int tag) => tag >> TAG_TYPE_BITS;

int getTagWireType(int tag) => tag & TAG_TYPE_MASK;

int makeTag(int fieldNumber, int tag) => (fieldNumber << TAG_TYPE_BITS) | tag;

/// Returns true if the wireType can be merged into the given fieldType.
bool _wireTypeMatches(FieldType fieldType, int wireType) {
  switch (fieldType.baseType) {
    case FieldBaseType.bool:
    case FieldBaseType.enum_:
    case FieldBaseType.int32:
    case FieldBaseType.int64:
    case FieldBaseType.sint32:
    case FieldBaseType.sint64:
    case FieldBaseType.uint32:
    case FieldBaseType.uint64:
      return wireType == WIRETYPE_VARINT ||
          wireType == WIRETYPE_LENGTH_DELIMITED;

    case FieldBaseType.float:
    case FieldBaseType.fixed32:
    case FieldBaseType.sfixed32:
      return wireType == WIRETYPE_FIXED32 ||
          wireType == WIRETYPE_LENGTH_DELIMITED;

    case FieldBaseType.double:
    case FieldBaseType.fixed64:
    case FieldBaseType.sfixed64:
      return wireType == WIRETYPE_FIXED64 ||
          wireType == WIRETYPE_LENGTH_DELIMITED;

    case FieldBaseType.bytes:
    case FieldBaseType.string:
    case FieldBaseType.message:
    case FieldBaseType.map:
      return wireType == WIRETYPE_LENGTH_DELIMITED;

    case FieldBaseType.group:
      return wireType == WIRETYPE_START_GROUP;
  }
}
