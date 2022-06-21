// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

Map<String, dynamic> _writeToJsonMap(_FieldSet fs) {
  dynamic convertToMap(dynamic fieldValue, int fieldType) {
    var baseType = PbFieldType._baseType(fieldType);

    if (_isRepeated(fieldType)) {
      return List.from(fieldValue.map((e) => convertToMap(e, baseType)));
    }

    switch (baseType) {
      case PbFieldType._BOOL_BIT:
      case PbFieldType._STRING_BIT:
      case PbFieldType._INT32_BIT:
      case PbFieldType._SINT32_BIT:
      case PbFieldType._UINT32_BIT:
      case PbFieldType._FIXED32_BIT:
      case PbFieldType._SFIXED32_BIT:
        return fieldValue;
      case PbFieldType._FLOAT_BIT:
      case PbFieldType._DOUBLE_BIT:
        final value = fieldValue as double;
        if (value.isNaN) {
          return nan;
        }
        if (value.isInfinite) {
          return value.isNegative ? negativeInfinity : infinity;
        }
        if (fieldValue.toInt() == fieldValue) {
          return fieldValue.toInt();
        }
        return value;
      case PbFieldType._BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        return base64Encode(fieldValue as List<int>);
      case PbFieldType._ENUM_BIT:
        return fieldValue.value; // assume |value| < 2^52
      case PbFieldType._INT64_BIT:
      case PbFieldType._SINT64_BIT:
      case PbFieldType._SFIXED64_BIT:
        return fieldValue.toString();
      case PbFieldType._UINT64_BIT:
      case PbFieldType._FIXED64_BIT:
        return fieldValue.toStringUnsigned();
      case PbFieldType._GROUP_BIT:
      case PbFieldType._MESSAGE_BIT:
        return fieldValue.writeToJsonMap();
      default:
        throw 'Unknown type $fieldType';
    }
  }

  List _writeMap(dynamic fieldValue, MapFieldInfo fi) =>
      List.from(fieldValue.entries.map((MapEntry e) => {
            '${PbMap._keyFieldNumber}': convertToMap(e.key, fi.keyFieldType),
            '${PbMap._valueFieldNumber}':
                convertToMap(e.value, fi.valueFieldType)
          }));

  var result = <String, dynamic>{};
  for (var fi in fs._infosSortedByTag) {
    var value = fs._values[fi.index!];
    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }
    if (_isMapField(fi.type)) {
      result['${fi.tagNumber}'] =
          _writeMap(value, fi as MapFieldInfo<dynamic, dynamic>);
      continue;
    }
    result['${fi.tagNumber}'] = convertToMap(value, fi.type);
  }
  if (fs._hasExtensions) {
    for (var tagNumber in _sorted(fs._extensions!._tagNumbers)) {
      var value = fs._extensions!._values[tagNumber];
      if (value is List && value.isEmpty) {
        continue; // It's repeated or an empty byte array.
      }
      var fi = fs._extensions!._getInfoOrNull(tagNumber)!;
      result['$tagNumber'] = convertToMap(value, fi.type);
    }
  }
  return result;
}
