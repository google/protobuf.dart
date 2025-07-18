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
  switch (PbFieldTypeInternal.baseType(fieldType)) {
    case PbFieldTypeInternal.BOOL_BIT:
    case PbFieldTypeInternal.ENUM_BIT:
    case PbFieldTypeInternal.INT32_BIT:
    case PbFieldTypeInternal.INT64_BIT:
    case PbFieldTypeInternal.SINT32_BIT:
    case PbFieldTypeInternal.SINT64_BIT:
    case PbFieldTypeInternal.UINT32_BIT:
    case PbFieldTypeInternal.UINT64_BIT:
      return wireType == WIRETYPE_VARINT ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case PbFieldTypeInternal.FLOAT_BIT:
    case PbFieldTypeInternal.FIXED32_BIT:
    case PbFieldTypeInternal.SFIXED32_BIT:
      return wireType == WIRETYPE_FIXED32 ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case PbFieldTypeInternal.DOUBLE_BIT:
    case PbFieldTypeInternal.FIXED64_BIT:
    case PbFieldTypeInternal.SFIXED64_BIT:
      return wireType == WIRETYPE_FIXED64 ||
          wireType == WIRETYPE_LENGTH_DELIMITED;
    case PbFieldTypeInternal.BYTES_BIT:
    case PbFieldTypeInternal.STRING_BIT:
    case PbFieldTypeInternal.MESSAGE_BIT:
      return wireType == WIRETYPE_LENGTH_DELIMITED;
    case PbFieldTypeInternal.GROUP_BIT:
      return wireType == WIRETYPE_START_GROUP;
    default:
      return false;
  }
}
