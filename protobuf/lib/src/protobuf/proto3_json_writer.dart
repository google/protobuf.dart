// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

Object? _writeToProto3Json(_FieldSet fs, TypeRegistry typeRegistry) {
  String? convertToMapKey(dynamic key, int keyType) {
    var baseType = PbFieldType._baseType(keyType);

    assert(!_isRepeated(keyType));

    switch (baseType) {
      case PbFieldType._BOOL_BIT:
        return key ? 'true' : 'false';
      case PbFieldType._STRING_BIT:
        return key;
      case PbFieldType._UINT64_BIT:
        return (key as Int64).toStringUnsigned();
      case PbFieldType._INT32_BIT:
      case PbFieldType._SINT32_BIT:
      case PbFieldType._UINT32_BIT:
      case PbFieldType._FIXED32_BIT:
      case PbFieldType._SFIXED32_BIT:
      case PbFieldType._INT64_BIT:
      case PbFieldType._SINT64_BIT:
      case PbFieldType._SFIXED64_BIT:
      case PbFieldType._FIXED64_BIT:
        return key.toString();
      default:
        throw StateError('Not a valid key type $keyType');
    }
  }

  Object? valueToProto3Json(dynamic fieldValue, int? fieldType) {
    if (fieldValue == null) return null;

    if (_isGroupOrMessage(fieldType!)) {
      return _writeToProto3Json(
          (fieldValue as GeneratedMessage)._fieldSet, typeRegistry);
    } else if (_isEnum(fieldType)) {
      return (fieldValue as ProtobufEnum).name;
    } else {
      var baseType = PbFieldType._baseType(fieldType);
      switch (baseType) {
        case PbFieldType._BOOL_BIT:
          return fieldValue ? true : false;
        case PbFieldType._STRING_BIT:
          return fieldValue;
        case PbFieldType._INT32_BIT:
        case PbFieldType._SINT32_BIT:
        case PbFieldType._UINT32_BIT:
        case PbFieldType._FIXED32_BIT:
        case PbFieldType._SFIXED32_BIT:
          return fieldValue;
        case PbFieldType._INT64_BIT:
        case PbFieldType._SINT64_BIT:
        case PbFieldType._SFIXED64_BIT:
        case PbFieldType._FIXED64_BIT:
          return fieldValue.toString();
        case PbFieldType._FLOAT_BIT:
        case PbFieldType._DOUBLE_BIT:
          double value = fieldValue;
          if (value.isNaN) {
            return nan;
          }
          if (value.isInfinite) {
            return value.isNegative ? negativeInfinity : infinity;
          }
          return value;
        case PbFieldType._UINT64_BIT:
          return (fieldValue as Int64).toStringUnsigned();
        case PbFieldType._BYTES_BIT:
          return base64Encode(fieldValue);
        default:
          throw StateError(
              'Invariant violation: unexpected value type $fieldType');
      }
    }
  }

  final meta = fs._meta;
  if (meta.toProto3Json != null) {
    return meta.toProto3Json!(fs._message!, typeRegistry);
  }

  var result = <String, dynamic>{};
  for (var fieldInfo in fs._infosSortedByTag) {
    var value = fs._values[fieldInfo.index!];
    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }
    dynamic jsonValue;
    if (fieldInfo.isMapField) {
      jsonValue = (value as PbMap).map((key, entryValue) {
        var mapEntryInfo = fieldInfo as MapFieldInfo;
        return MapEntry(convertToMapKey(key, mapEntryInfo.keyFieldType),
            valueToProto3Json(entryValue, mapEntryInfo.valueFieldType));
      });
    } else if (fieldInfo.isRepeated) {
      jsonValue = (value as PbList)
          .map((element) => valueToProto3Json(element, fieldInfo.type))
          .toList();
    } else {
      jsonValue = valueToProto3Json(value, fieldInfo.type);
    }
    result[fieldInfo.name] = jsonValue;
  }
  // Extensions and unknown fields are not encoded by proto3 JSON.
  return result;
}
