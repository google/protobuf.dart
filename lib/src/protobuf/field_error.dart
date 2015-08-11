// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// Returns the error message for an invalid field value,
/// or null if it's valid.
///
/// For enums and message fields, this check is only approximate,
/// because the exact type isn't included in [fieldType].
String _getFieldError(int fieldType, var value) {
  switch (FieldType._baseType(fieldType)) {
    case FieldType._BOOL_BIT:
      if (value is! bool) return 'not type bool';
      return null;
    case FieldType._BYTES_BIT:
      if (value is! List) return 'not List';
      return null;
    case FieldType._STRING_BIT:
      if (value is! String) return 'not type String';
      return null;
    case FieldType._FLOAT_BIT:
      if (value is! double) return 'not type double';
      if (!_isFloat32(value)) return 'out of range for float';
      return null;
    case FieldType._DOUBLE_BIT:
      if (value is! double) return 'not type double';
      return null;
    case FieldType._ENUM_BIT:
      if (value is! ProtobufEnum) return 'not type ProtobufEnum';
      return null;
    case FieldType._INT32_BIT:
      if (value is! int) return 'not type int';
      if (!_isSigned32(value)) return 'out of range for int32';
      return null;
    case FieldType._INT64_BIT:
      if (value is! Int64) return 'not Int64';
      if (!_isSigned64(value)) return 'out of range for int64';
      return null;
    case FieldType._SINT32_BIT:
      if (value is! int) return 'not type int';
      if (!_isSigned32(value)) return 'out of range for sint32';
      return null;
    case FieldType._SINT64_BIT:
      if (value is! Int64) return 'not Int64';
      if (!_isSigned64(value)) return 'out of range for sint64';
      return null;
    case FieldType._UINT32_BIT:
      if (value is! int) return 'not type int';
      if (!_isUnsigned32(value)) return 'out of range for uint32';
      return null;
    case FieldType._UINT64_BIT:
      if (value is! Int64) return 'not Int64';
      if (!_isUnsigned64(value)) return 'out of range for uint64';
      return null;
    case FieldType._FIXED32_BIT:
      if (value is! int) return 'not type int';
      if (!_isUnsigned32(value)) return 'out of range for fixed32';
      return null;
    case FieldType._FIXED64_BIT:
      if (value is! Int64) return 'not Int64';
      if (!_isUnsigned64(value)) return 'out of range for fixed64';
      return null;
    case FieldType._SFIXED32_BIT:
      if (value is! int) return 'not type int';
      if (!_isSigned32(value)) return 'out of range for sfixed32';
      return null;
    case FieldType._SFIXED64_BIT:
      if (value is! Int64) return 'not Int64';
      if (!_isSigned64(value)) return 'out of range for sfixed64';
      return null;
    case FieldType._GROUP_BIT:
    case FieldType._MESSAGE_BIT:
      if (value is! GeneratedMessage) return 'not a GeneratedMessage';
      return null;
    default:
      return 'field has unknown type $fieldType';
  }
}

// Checking functions for repeated fields.

void _checkNothing(x) {}

void _checkFloat(double val) {
  if (!_isFloat32(val)) {
    throw new ArgumentError(
        'Illegal to add value (${val}): out of range for float');
  }
}

void _checkSigned32(int val) {
  if (!_isSigned32(val)) {
    throw new ArgumentError(
        'Illegal to add value (${val}): out of range for int32');
  }
}

void _checkUnsigned32(int val) {
  if (!_isUnsigned32(val)) {
    throw new ArgumentError(
        'Illegal to add value (${val}): out of range for uint32');
  }
}

void _checkSigned64(Int64 val) {
  if (!_isSigned64(val)) {
    throw new ArgumentError(
        'Illegal to add value (${val}): out of range for sint64');
  }
}

void _checkUnsigned64(Int64 val) {
  if (!_isUnsigned64(val)) {
    throw new ArgumentError(
        'Illegal to add value (${val}): out of range for uint64');
  }
  // It is up to the caller to treat the Int64 as unsigned
  // even though we're using the signed type. (The full range is used.)
}

bool _inRange(min, value, max) => (min <= value) && (value <= max);

bool _isSigned32(int value) => _inRange(-2147483648, value, 2147483647);
bool _isUnsigned32(int value) => _inRange(0, value, 4294967295);
bool _isSigned64(Int64 value) => _isUnsigned64(value);
bool _isUnsigned64(Int64 value) => value is Int64;
bool _isFloat32(double value) => value.isNaN || value.isInfinite ||
_inRange(-3.4028234663852886E38, value, 3.4028234663852886E38);
