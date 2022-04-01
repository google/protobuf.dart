// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: constant_identifier_names,non_constant_identifier_names
part of protobuf;

class FieldType {
  final FieldBaseType baseType;
  final bool isGroup;
  final bool isPacked;
  final bool isRepeated;
  final bool isRequired;

  const FieldType.dummy()
      : baseType = FieldBaseType.int32,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  const FieldType.optional(this.baseType)
      : isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  const FieldType.required(this.baseType)
      : isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = true;

  const FieldType.repeated(this.baseType)
      : isGroup = false,
        isPacked = false,
        isRepeated = true,
        isRequired = false;

  const FieldType.packed(this.baseType)
      : isGroup = false,
        isPacked = true,
        isRepeated = false,
        isRequired = false;

  const FieldType.fromBaseType(this.baseType)
      : isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  const FieldType.MAP()
      : baseType = FieldBaseType.map,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  const FieldType.OPTIONAL_STRING()
      : baseType = FieldBaseType.string,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  const FieldType.REQUIRED_STRING()
      : baseType = FieldBaseType.string,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = true;

  // TODO: Can I implement this using `FieldType.repeated()`?
  const FieldType.REPEATED_STRING()
      : baseType = FieldBaseType.string,
        isGroup = false,
        isPacked = false,
        isRepeated = true,
        isRequired = false;

  // TODO: Can I implement this using `FieldType.repeated()`?
  const FieldType.REPEATED_I32()
      : baseType = FieldBaseType.int32,
        isGroup = false,
        isPacked = false,
        isRepeated = true,
        isRequired = false;

  // TODO: Can I implement this using `FieldType.optional()`?
  const FieldType.OPTIONAL_I32()
      : baseType = FieldBaseType.int32,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  // TODO: Can I implement this using `FieldType.optional()`?
  const FieldType.OPTIONAL_I64()
      : baseType = FieldBaseType.int64,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  // TODO: Can I implement this using `FieldType.optional()`?
  const FieldType.OPTIONAL_BOOL()
      : baseType = FieldBaseType.bool,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  // TODO: Can I implement this using `FieldType.optional()`?
  const FieldType.OPTIONAL_MESSAGE()
      : baseType = FieldBaseType.message,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = false;

  const FieldType.REQUIRED_MESSAGE()
      : baseType = FieldBaseType.message,
        isGroup = false,
        isPacked = false,
        isRepeated = false,
        isRequired = true;

  bool get isMap => baseType == FieldBaseType.map;
  bool get isMessage => baseType == FieldBaseType.message;
  bool get isEnum => baseType == FieldBaseType.enum_;
  bool get isGroupOrMessage =>
      baseType == FieldBaseType.group || baseType == FieldBaseType.message;
}

enum FieldBaseType {
  bool,
  bytes,
  string,
  double,
  float,
  enum_,
  int32,
  int64,
  sint32,
  sint64,
  uint32,
  uint64,
  fixed32,
  fixed64,
  sfixed32,
  sfixed64,
  message,
  map,
  group,
}

class PbFieldType {
  static MakeDefaultFunc? _defaultForType(FieldType type) {
    switch (type.baseType) {
      case FieldBaseType.bool:
        return _BOOL_FALSE;

      case FieldBaseType.bytes:
        return _BYTES_EMPTY;

      case FieldBaseType.string:
        return _STRING_EMPTY;

      case FieldBaseType.float:
      case FieldBaseType.double:
        return _DOUBLE_ZERO;

      case FieldBaseType.int32:
      case FieldBaseType.int64:
      case FieldBaseType.sint32:
      case FieldBaseType.sint64:
      case FieldBaseType.uint32:
      case FieldBaseType.uint64:
      case FieldBaseType.fixed32:
      case FieldBaseType.fixed64:
      case FieldBaseType.sfixed32:
      case FieldBaseType.sfixed64:
        return _INT_ZERO;

      case FieldBaseType.enum_:
      case FieldBaseType.message:
      case FieldBaseType.map:
      case FieldBaseType.group:
        return null;
    }
  }

  // Closures commonly used by initializers.
  static String _STRING_EMPTY() => '';
  static List<int> _BYTES_EMPTY() => <int>[];
  static bool _BOOL_FALSE() => false;
  static int _INT_ZERO() => 0;
  static double _DOUBLE_ZERO() => 0.0;

  // Short names for use in generated code.

  // _O_ptional.
  static const FieldType OB = FieldType.optional(FieldBaseType.bool);
  static const FieldType OY = FieldType.optional(FieldBaseType.bytes);
  static const FieldType OS = FieldType.optional(FieldBaseType.string);
  static const FieldType OF = FieldType.optional(FieldBaseType.float);
  static const FieldType OD = FieldType.optional(FieldBaseType.double);
  static const FieldType OE = FieldType.optional(FieldBaseType.enum_);
  static const FieldType OG = FieldType.optional(FieldBaseType.group);
  static const FieldType O3 = FieldType.optional(FieldBaseType.int32);
  static const FieldType O6 = FieldType.optional(FieldBaseType.int64);
  static const FieldType OS3 = FieldType.optional(FieldBaseType.sint32);
  static const FieldType OS6 = FieldType.optional(FieldBaseType.sint64);
  static const FieldType OU3 = FieldType.optional(FieldBaseType.uint32);
  static const FieldType OU6 = FieldType.optional(FieldBaseType.uint64);
  static const FieldType OF3 = FieldType.optional(FieldBaseType.fixed32);
  static const FieldType OF6 = FieldType.optional(FieldBaseType.fixed64);
  static const FieldType OSF3 = FieldType.optional(FieldBaseType.sfixed32);
  static const FieldType OSF6 = FieldType.optional(FieldBaseType.sfixed64);
  static const FieldType OM = FieldType.optional(FieldBaseType.message);

  // re_Q_uired.
  static const FieldType QB = FieldType.required(FieldBaseType.bool);
  static const FieldType QY = FieldType.required(FieldBaseType.bytes);
  static const FieldType QS = FieldType.required(FieldBaseType.string);
  static const FieldType QF = FieldType.required(FieldBaseType.float);
  static const FieldType QD = FieldType.required(FieldBaseType.double);
  static const FieldType QE = FieldType.required(FieldBaseType.enum_);
  static const FieldType QG = FieldType.required(FieldBaseType.group);
  static const FieldType Q3 = FieldType.required(FieldBaseType.int32);
  static const FieldType Q6 = FieldType.required(FieldBaseType.int64);
  static const FieldType QS3 = FieldType.required(FieldBaseType.sint32);
  static const FieldType QS6 = FieldType.required(FieldBaseType.sint64);
  static const FieldType QU3 = FieldType.required(FieldBaseType.uint32);
  static const FieldType QU6 = FieldType.required(FieldBaseType.uint64);
  static const FieldType QF3 = FieldType.required(FieldBaseType.fixed32);
  static const FieldType QF6 = FieldType.required(FieldBaseType.fixed64);
  static const FieldType QSF3 = FieldType.required(FieldBaseType.sfixed32);
  static const FieldType QSF6 = FieldType.required(FieldBaseType.sfixed64);
  static const FieldType QM = FieldType.required(FieldBaseType.message);

  // re_P_eated.
  static const FieldType PB = FieldType.repeated(FieldBaseType.bool);
  static const FieldType PY = FieldType.repeated(FieldBaseType.bytes);
  static const FieldType PS = FieldType.repeated(FieldBaseType.string);
  static const FieldType PF = FieldType.repeated(FieldBaseType.float);
  static const FieldType PD = FieldType.repeated(FieldBaseType.double);
  static const FieldType PE = FieldType.repeated(FieldBaseType.enum_);
  static const FieldType PG = FieldType.repeated(FieldBaseType.group);
  static const FieldType P3 = FieldType.repeated(FieldBaseType.int32);
  static const FieldType P6 = FieldType.repeated(FieldBaseType.int64);
  static const FieldType PS3 = FieldType.repeated(FieldBaseType.sint32);
  static const FieldType PS6 = FieldType.repeated(FieldBaseType.sint64);
  static const FieldType PU3 = FieldType.repeated(FieldBaseType.uint32);
  static const FieldType PU6 = FieldType.repeated(FieldBaseType.uint64);
  static const FieldType PF3 = FieldType.repeated(FieldBaseType.fixed32);
  static const FieldType PF6 = FieldType.repeated(FieldBaseType.fixed64);
  static const FieldType PSF3 = FieldType.repeated(FieldBaseType.sfixed32);
  static const FieldType PSF6 = FieldType.repeated(FieldBaseType.sfixed64);
  static const FieldType PM = FieldType.repeated(FieldBaseType.message);

  // pac_K_ed.
  static const FieldType KB = FieldType.packed(FieldBaseType.bool);
  static const FieldType KE = FieldType.packed(FieldBaseType.enum_);
  static const FieldType KF = FieldType.packed(FieldBaseType.float);
  static const FieldType KD = FieldType.packed(FieldBaseType.double);
  static const FieldType K3 = FieldType.packed(FieldBaseType.int32);
  static const FieldType K6 = FieldType.packed(FieldBaseType.int64);
  static const FieldType KS3 = FieldType.packed(FieldBaseType.sint32);
  static const FieldType KS6 = FieldType.packed(FieldBaseType.sint64);
  static const FieldType KU3 = FieldType.packed(FieldBaseType.uint32);
  static const FieldType KU6 = FieldType.packed(FieldBaseType.uint64);
  static const FieldType KF3 = FieldType.packed(FieldBaseType.fixed32);
  static const FieldType KF6 = FieldType.packed(FieldBaseType.fixed64);
  static const FieldType KSF3 = FieldType.packed(FieldBaseType.sfixed32);
  static const FieldType KSF6 = FieldType.packed(FieldBaseType.sfixed64);

  static const FieldType M = FieldType.MAP();
}
