// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: constant_identifier_names,non_constant_identifier_names
part of 'internal.dart';

/// Defines constants and functions for dealing with fieldType bits.
class PbFieldTypeInternal {
  static bool isRepeated(int fieldType) =>
      (fieldType & PbFieldTypeInternal.REPEATED_BIT) != 0;

  static bool isRequired(int fieldType) =>
      (fieldType & PbFieldTypeInternal.REQUIRED_BIT) != 0;

  static bool isEnum(int fieldType) =>
      PbFieldTypeInternal.baseType(fieldType) == PbFieldTypeInternal.ENUM_BIT;

  static bool isBytes(int fieldType) =>
      PbFieldTypeInternal.baseType(fieldType) == PbFieldTypeInternal.BYTES_BIT;

  static bool isGroupOrMessage(int fieldType) =>
      (fieldType &
          (PbFieldTypeInternal.GROUP_BIT | PbFieldTypeInternal.MESSAGE_BIT)) !=
      0;

  static bool isMapField(int fieldType) =>
      (fieldType & PbFieldTypeInternal.MAP_BIT) != 0;

  /// Returns the base field type without any of the required, repeated
  /// and packed bits.
  static int baseType(int fieldType) =>
      fieldType & ~(REQUIRED_BIT | REPEATED_BIT | PACKED_BIT | MAP_BIT);

  static MakeDefaultFunc? defaultForType(int type) {
    switch (type) {
      case OPTIONAL_BOOL:
      case REQUIRED_BOOL:
        return BOOL_FALSE;
      case OPTIONAL_BYTES:
      case REQUIRED_BYTES:
        return BYTES_EMPTY;
      case OPTIONAL_STRING:
      case REQUIRED_STRING:
        return STRING_EMPTY;
      case OPTIONAL_FLOAT:
      case REQUIRED_FLOAT:
      case OPTIONAL_DOUBLE:
      case REQUIRED_DOUBLE:
        return DOUBLE_ZERO;
      case OPTIONAL_INT32:
      case REQUIRED_INT32:
      case OPTIONAL_INT64:
      case REQUIRED_INT64:
      case OPTIONAL_SINT32:
      case REQUIRED_SINT32:
      case OPTIONAL_SINT64:
      case REQUIRED_SINT64:
      case OPTIONAL_UINT32:
      case REQUIRED_UINT32:
      case OPTIONAL_UINT64:
      case REQUIRED_UINT64:
      case OPTIONAL_FIXED32:
      case REQUIRED_FIXED32:
      case OPTIONAL_FIXED64:
      case REQUIRED_FIXED64:
      case OPTIONAL_SFIXED32:
      case REQUIRED_SFIXED32:
      case OPTIONAL_SFIXED64:
      case REQUIRED_SFIXED64:
        return INT_ZERO;
      default:
        return null;
    }
  }

  // Closures commonly used by initializers.
  static String STRING_EMPTY() => '';
  static List<int> BYTES_EMPTY() => <int>[];
  static bool BOOL_FALSE() => false;
  static int INT_ZERO() => 0;
  static double DOUBLE_ZERO() => 0.0;

  static const int REQUIRED_BIT = 0x1;
  static const int REPEATED_BIT = 0x2;
  static const int PACKED_BIT = 0x4;

  static const int BOOL_BIT = 0x10;
  static const int BYTES_BIT = 0x20;
  static const int STRING_BIT = 0x40;
  static const int DOUBLE_BIT = 0x80;
  static const int FLOAT_BIT = 0x100;
  static const int ENUM_BIT = 0x200;
  static const int GROUP_BIT = 0x400;
  static const int INT32_BIT = 0x800;
  static const int INT64_BIT = 0x1000;
  static const int SINT32_BIT = 0x2000;
  static const int SINT64_BIT = 0x4000;
  static const int UINT32_BIT = 0x8000;
  static const int UINT64_BIT = 0x10000;
  static const int FIXED32_BIT = 0x20000;
  static const int FIXED64_BIT = 0x40000;
  static const int SFIXED32_BIT = 0x80000;
  static const int SFIXED64_BIT = 0x100000;
  static const int MESSAGE_BIT = 0x200000;
  static const int MAP_BIT = 0x400000;

  static const int OPTIONAL_BOOL = BOOL_BIT;
  static const int OPTIONAL_BYTES = BYTES_BIT;
  static const int OPTIONAL_STRING = STRING_BIT;
  static const int OPTIONAL_FLOAT = FLOAT_BIT;
  static const int OPTIONAL_DOUBLE = DOUBLE_BIT;
  static const int OPTIONAL_ENUM = ENUM_BIT;
  static const int OPTIONAL_GROUP = GROUP_BIT;
  static const int OPTIONAL_INT32 = INT32_BIT;
  static const int OPTIONAL_INT64 = INT64_BIT;
  static const int OPTIONAL_SINT32 = SINT32_BIT;
  static const int OPTIONAL_SINT64 = SINT64_BIT;
  static const int OPTIONAL_UINT32 = UINT32_BIT;
  static const int OPTIONAL_UINT64 = UINT64_BIT;
  static const int OPTIONAL_FIXED32 = FIXED32_BIT;
  static const int OPTIONAL_FIXED64 = FIXED64_BIT;
  static const int OPTIONAL_SFIXED32 = SFIXED32_BIT;
  static const int OPTIONAL_SFIXED64 = SFIXED64_BIT;
  static const int OPTIONAL_MESSAGE = MESSAGE_BIT;

  static const int REQUIRED_BOOL = REQUIRED_BIT | BOOL_BIT;
  static const int REQUIRED_BYTES = REQUIRED_BIT | BYTES_BIT;
  static const int REQUIRED_STRING = REQUIRED_BIT | STRING_BIT;
  static const int REQUIRED_FLOAT = REQUIRED_BIT | FLOAT_BIT;
  static const int REQUIRED_DOUBLE = REQUIRED_BIT | DOUBLE_BIT;
  static const int REQUIRED_ENUM = REQUIRED_BIT | ENUM_BIT;
  static const int REQUIRED_GROUP = REQUIRED_BIT | GROUP_BIT;
  static const int REQUIRED_INT32 = REQUIRED_BIT | INT32_BIT;
  static const int REQUIRED_INT64 = REQUIRED_BIT | INT64_BIT;
  static const int REQUIRED_SINT32 = REQUIRED_BIT | SINT32_BIT;
  static const int REQUIRED_SINT64 = REQUIRED_BIT | SINT64_BIT;
  static const int REQUIRED_UINT32 = REQUIRED_BIT | UINT32_BIT;
  static const int REQUIRED_UINT64 = REQUIRED_BIT | UINT64_BIT;
  static const int REQUIRED_FIXED32 = REQUIRED_BIT | FIXED32_BIT;
  static const int REQUIRED_FIXED64 = REQUIRED_BIT | FIXED64_BIT;
  static const int REQUIRED_SFIXED32 = REQUIRED_BIT | SFIXED32_BIT;
  static const int REQUIRED_SFIXED64 = REQUIRED_BIT | SFIXED64_BIT;
  static const int REQUIRED_MESSAGE = REQUIRED_BIT | MESSAGE_BIT;

  static const int REPEATED_BOOL = REPEATED_BIT | BOOL_BIT;
  static const int REPEATED_BYTES = REPEATED_BIT | BYTES_BIT;
  static const int REPEATED_STRING = REPEATED_BIT | STRING_BIT;
  static const int REPEATED_FLOAT = REPEATED_BIT | FLOAT_BIT;
  static const int REPEATED_DOUBLE = REPEATED_BIT | DOUBLE_BIT;
  static const int REPEATED_ENUM = REPEATED_BIT | ENUM_BIT;
  static const int REPEATED_GROUP = REPEATED_BIT | GROUP_BIT;
  static const int REPEATED_INT32 = REPEATED_BIT | INT32_BIT;
  static const int REPEATED_INT64 = REPEATED_BIT | INT64_BIT;
  static const int REPEATED_SINT32 = REPEATED_BIT | SINT32_BIT;
  static const int REPEATED_SINT64 = REPEATED_BIT | SINT64_BIT;
  static const int REPEATED_UINT32 = REPEATED_BIT | UINT32_BIT;
  static const int REPEATED_UINT64 = REPEATED_BIT | UINT64_BIT;
  static const int REPEATED_FIXED32 = REPEATED_BIT | FIXED32_BIT;
  static const int REPEATED_FIXED64 = REPEATED_BIT | FIXED64_BIT;
  static const int REPEATED_SFIXED32 = REPEATED_BIT | SFIXED32_BIT;
  static const int REPEATED_SFIXED64 = REPEATED_BIT | SFIXED64_BIT;
  static const int REPEATED_MESSAGE = REPEATED_BIT | MESSAGE_BIT;

  static const int PACKED_BOOL = REPEATED_BIT | PACKED_BIT | BOOL_BIT;
  static const int PACKED_FLOAT = REPEATED_BIT | PACKED_BIT | FLOAT_BIT;
  static const int PACKED_DOUBLE = REPEATED_BIT | PACKED_BIT | DOUBLE_BIT;
  static const int PACKED_ENUM = REPEATED_BIT | PACKED_BIT | ENUM_BIT;
  static const int PACKED_INT32 = REPEATED_BIT | PACKED_BIT | INT32_BIT;
  static const int PACKED_INT64 = REPEATED_BIT | PACKED_BIT | INT64_BIT;
  static const int PACKED_SINT32 = REPEATED_BIT | PACKED_BIT | SINT32_BIT;
  static const int PACKED_SINT64 = REPEATED_BIT | PACKED_BIT | SINT64_BIT;
  static const int PACKED_UINT32 = REPEATED_BIT | PACKED_BIT | UINT32_BIT;
  static const int PACKED_UINT64 = REPEATED_BIT | PACKED_BIT | UINT64_BIT;
  static const int PACKED_FIXED32 = REPEATED_BIT | PACKED_BIT | FIXED32_BIT;
  static const int PACKED_FIXED64 = REPEATED_BIT | PACKED_BIT | FIXED64_BIT;
  static const int PACKED_SFIXED32 = REPEATED_BIT | PACKED_BIT | SFIXED32_BIT;
  static const int PACKED_SFIXED64 = REPEATED_BIT | PACKED_BIT | SFIXED64_BIT;

  static const int MAP = MAP_BIT | MESSAGE_BIT;
  // Short names for use in generated code.

  // _O_ptional.
  static const int OB = OPTIONAL_BOOL;
  static const int OY = OPTIONAL_BYTES;
  static const int OS = OPTIONAL_STRING;
  static const int OF = OPTIONAL_FLOAT;
  static const int OD = OPTIONAL_DOUBLE;
  static const int OE = OPTIONAL_ENUM;
  static const int OG = OPTIONAL_GROUP;
  static const int O3 = OPTIONAL_INT32;
  static const int O6 = OPTIONAL_INT64;
  static const int OS3 = OPTIONAL_SINT32;
  static const int OS6 = OPTIONAL_SINT64;
  static const int OU3 = OPTIONAL_UINT32;
  static const int OU6 = OPTIONAL_UINT64;
  static const int OF3 = OPTIONAL_FIXED32;
  static const int OF6 = OPTIONAL_FIXED64;
  static const int OSF3 = OPTIONAL_SFIXED32;
  static const int OSF6 = OPTIONAL_SFIXED64;
  static const int OM = OPTIONAL_MESSAGE;

  // re_Q_uired.
  static const int QB = REQUIRED_BOOL;
  static const int QY = REQUIRED_BYTES;
  static const int QS = REQUIRED_STRING;
  static const int QF = REQUIRED_FLOAT;
  static const int QD = REQUIRED_DOUBLE;
  static const int QE = REQUIRED_ENUM;
  static const int QG = REQUIRED_GROUP;
  static const int Q3 = REQUIRED_INT32;
  static const int Q6 = REQUIRED_INT64;
  static const int QS3 = REQUIRED_SINT32;
  static const int QS6 = REQUIRED_SINT64;
  static const int QU3 = REQUIRED_UINT32;
  static const int QU6 = REQUIRED_UINT64;
  static const int QF3 = REQUIRED_FIXED32;
  static const int QF6 = REQUIRED_FIXED64;
  static const int QSF3 = REQUIRED_SFIXED32;
  static const int QSF6 = REQUIRED_SFIXED64;
  static const int QM = REQUIRED_MESSAGE;

  // re_P_eated.
  static const int PB = REPEATED_BOOL;
  static const int PY = REPEATED_BYTES;
  static const int PS = REPEATED_STRING;
  static const int PF = REPEATED_FLOAT;
  static const int PD = REPEATED_DOUBLE;
  static const int PE = REPEATED_ENUM;
  static const int PG = REPEATED_GROUP;
  static const int P3 = REPEATED_INT32;
  static const int P6 = REPEATED_INT64;
  static const int PS3 = REPEATED_SINT32;
  static const int PS6 = REPEATED_SINT64;
  static const int PU3 = REPEATED_UINT32;
  static const int PU6 = REPEATED_UINT64;
  static const int PF3 = REPEATED_FIXED32;
  static const int PF6 = REPEATED_FIXED64;
  static const int PSF3 = REPEATED_SFIXED32;
  static const int PSF6 = REPEATED_SFIXED64;
  static const int PM = REPEATED_MESSAGE;

  // pac_K_ed.
  static const int KB = PACKED_BOOL;
  static const int KE = PACKED_ENUM;
  static const int KF = PACKED_FLOAT;
  static const int KD = PACKED_DOUBLE;
  static const int K3 = PACKED_INT32;
  static const int K6 = PACKED_INT64;
  static const int KS3 = PACKED_SINT32;
  static const int KS6 = PACKED_SINT64;
  static const int KU3 = PACKED_UINT32;
  static const int KU6 = PACKED_UINT64;
  static const int KF3 = PACKED_FIXED32;
  static const int KF6 = PACKED_FIXED64;
  static const int KSF3 = PACKED_SFIXED32;
  static const int KSF6 = PACKED_SFIXED64;

  static const int M = MAP;
}
