// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

void _writeToJsonMapSink(_FieldSet fs, JsonSink jsonSink) {
  dynamic convertToMap(dynamic fieldValue, int fieldType) {
    var baseType = PbFieldType._baseType(fieldType);

    if (_isRepeated(fieldType)) {
      jsonSink.startArray();
      for (final value in fieldValue as List) {
        convertToMap(value, baseType);
      }
      jsonSink.endArray();
      return;
    }

    switch (baseType) {
      case PbFieldType._BOOL_BIT:
        jsonSink.addBool(fieldValue);
        return;

      case PbFieldType._STRING_BIT:
        jsonSink.addString(fieldValue);
        return;

      case PbFieldType._INT32_BIT:
      case PbFieldType._SINT32_BIT:
      case PbFieldType._UINT32_BIT:
      case PbFieldType._FIXED32_BIT:
      case PbFieldType._SFIXED32_BIT:
        jsonSink.addNumber(fieldValue);
        return;

      case PbFieldType._FLOAT_BIT:
      case PbFieldType._DOUBLE_BIT:
        final value = fieldValue as double;
        if (value.isNaN) {
          jsonSink.addString(nan);
          return;
        }
        if (value.isInfinite) {
          jsonSink.addString(value.isNegative ? negativeInfinity : infinity);
          return;
        }
        if (fieldValue.toInt() == fieldValue) {
          jsonSink.addNumber(fieldValue.toInt());
          return;
        }
        jsonSink.addNumber(value);
        return;

      case PbFieldType._BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        jsonSink.addString(base64Encode(fieldValue as List<int>));
        return;

      case PbFieldType._ENUM_BIT:
        jsonSink.addNumber(fieldValue.value); // assume |value| < 2^52
        return;

      case PbFieldType._INT64_BIT:
      case PbFieldType._SINT64_BIT:
      case PbFieldType._SFIXED64_BIT:
        jsonSink.addString(fieldValue.toString());
        return;

      case PbFieldType._UINT64_BIT:
      case PbFieldType._FIXED64_BIT:
        jsonSink.addString(fieldValue.toStringUnsigned());
        return;

      case PbFieldType._GROUP_BIT:
      case PbFieldType._MESSAGE_BIT:
        (fieldValue as GeneratedMessage).writeToJsonSink(jsonSink);
        return;

      default:
        throw 'Unknown type $fieldType';
    }
  }

  void _writeMap(dynamic fieldValue, MapFieldInfo fi) {
    jsonSink.startArray();
    for (final e in fieldValue.entries) {
      jsonSink.startObject();

      jsonSink.addKey(PbMap._keyFieldNumberString);
      convertToMap(e.key, fi.keyFieldType);

      jsonSink.addKey(PbMap._valueFieldNumberString);
      convertToMap(e.value, fi.valueFieldType);

      jsonSink.endObject();
    }
    jsonSink.endArray();
  }

  jsonSink.startObject();

  for (var fi in fs._infosSortedByTag) {
    var value = fs._values[fi.index!];
    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }
    if (_isMapField(fi.type)) {
      jsonSink.addKey(fi.tagNumber.toString());
      _writeMap(value, fi as MapFieldInfo<dynamic, dynamic>);
      continue;
    }
    jsonSink.addKey(fi.tagNumber.toString());
    convertToMap(value, fi.type);
  }

  if (fs._hasExtensions) {
    for (var tagNumber in _sorted(fs._extensions!._tagNumbers)) {
      var value = fs._extensions!._values[tagNumber];
      if (value is List && value.isEmpty) {
        continue; // It's repeated or an empty byte array.
      }
      var fi = fs._extensions!._getInfoOrNull(tagNumber)!;
      jsonSink.addKey(tagNumber.toString());
      convertToMap(value, fi.type);
    }
  }

  jsonSink.endObject();
}
