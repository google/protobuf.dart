// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

void _writeToJsonMapSink(_FieldSet fs, JsonSink jsonSink) {
  dynamic convertToMap(dynamic fieldValue, int fieldType) {
    var baseType = PbFieldType._baseType(fieldType);

    if (_isRepeated(fieldType)) {
      final List listValue = fieldValue;
      jsonSink.startArray();
      for (final value in listValue) {
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
        final double doubleValue = fieldValue;
        if (doubleValue.isNaN) {
          jsonSink.addString(_nan);
          return;
        }
        if (doubleValue.isInfinite) {
          jsonSink.addString(
              doubleValue.isNegative ? _negativeInfinity : _infinity);
          return;
        }
        if (fieldValue.toInt() == fieldValue) {
          jsonSink.addNumber(fieldValue.toInt());
          return;
        }
        jsonSink.addNumber(doubleValue);
        return;

      case PbFieldType._BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        final List<int> listValue = fieldValue;
        jsonSink.addString(base64Encode(listValue));
        return;

      case PbFieldType._ENUM_BIT:
        final ProtobufEnum enum_ = fieldValue;
        jsonSink.addNumber(enum_.value); // assume |value| < 2^52
        return;

      case PbFieldType._INT64_BIT:
      case PbFieldType._SINT64_BIT:
      case PbFieldType._SFIXED64_BIT:
        jsonSink.addString(fieldValue.toString());
        return;

      case PbFieldType._UINT64_BIT:
      case PbFieldType._FIXED64_BIT:
        final Int64 int_ = fieldValue;
        jsonSink.addString(int_.toStringUnsigned());
        return;

      case PbFieldType._GROUP_BIT:
      case PbFieldType._MESSAGE_BIT:
        final GeneratedMessage messageValue = fieldValue;
        _writeToJsonMapSink(messageValue._fieldSet, jsonSink);
        return;

      default:
        throw 'Unknown type $fieldType';
    }
  }

  void _writeMap(PbMap fieldValue, MapFieldInfo fi) {
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
      final MapFieldInfo mapFi = fi as dynamic;
      jsonSink.addKey(fi.tagNumber.toString());
      _writeMap(value, mapFi);
      continue;
    }
    jsonSink.addKey(fi.tagNumber.toString());
    convertToMap(value, fi.type);
  }

  final extensions = fs._extensions;
  if (extensions != null) {
    for (var tagNumber in _sorted(extensions._tagNumbers)) {
      var value = extensions._values[tagNumber];
      if (value is List && value.isEmpty) {
        continue; // It's repeated or an empty byte array.
      }
      var fi = extensions._getInfoOrNull(tagNumber)!;
      jsonSink.addKey(tagNumber.toString());
      convertToMap(value, fi.type);
    }
  }

  jsonSink.endObject();
}
