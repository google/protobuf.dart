// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

void _writeToProto3JsonSink(
    _FieldSet fs, TypeRegistry typeRegistry, JsonSink jsonWriter) {
  final wellKnownConverter = fs._meta.toProto3Json;
  if (wellKnownConverter != null) {
    throw 'Well-known types not supported yet';
  }

  jsonWriter.startObject(); // start message

  for (FieldInfo fieldInfo in fs._infosSortedByTag) {
    var value = fs._values[fieldInfo.index!];

    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }

    jsonWriter.addKey(fieldInfo.name);

    if (fieldInfo.isMapField) {
      jsonWriter.startObject(); // start map field
      final MapFieldInfo mapEntryInfo = fieldInfo as MapFieldInfo;
      for (MapEntry entry in (value as PbMap).entries) {
        final key = entry.key;
        final value = entry.value;
        _writeMapKey(key, mapEntryInfo.keyFieldType, jsonWriter);
        _writeFieldValue(
            value, mapEntryInfo.valueFieldType, jsonWriter, typeRegistry);
      }
      jsonWriter.endObject(); // end map field
    } else if (fieldInfo.isRepeated) {
      jsonWriter.startArray(); // start repeated field
      for (final element in value as PbListBase) {
        _writeFieldValue(element, fieldInfo.type, jsonWriter, typeRegistry);
      }
      jsonWriter.endArray(); // end repeated field
    } else {
      _writeFieldValue(value, fieldInfo.type, jsonWriter, typeRegistry);
    }
  }

  jsonWriter.endObject(); // end message
}

void _writeMapKey(dynamic key, int keyType, JsonSink jsonWriter) {
  var baseType = PbFieldType._baseType(keyType);

  assert(!_isRepeated(keyType));

  switch (baseType) {
    case PbFieldType._BOOL_BIT:
      jsonWriter.addKey((key as bool).toString());
      break;
    case PbFieldType._STRING_BIT:
      jsonWriter.addKey(key as String);
      break;
    case PbFieldType._UINT64_BIT:
      jsonWriter.addKey((key as Int64).toStringUnsigned().toString());
      break;
    case PbFieldType._INT32_BIT:
    case PbFieldType._SINT32_BIT:
    case PbFieldType._UINT32_BIT:
    case PbFieldType._FIXED32_BIT:
    case PbFieldType._SFIXED32_BIT:
    case PbFieldType._INT64_BIT:
    case PbFieldType._SINT64_BIT:
    case PbFieldType._SFIXED64_BIT:
    case PbFieldType._FIXED64_BIT:
      jsonWriter.addKey(key.toString());
      break;
    default:
      throw StateError('Not a valid key type $keyType');
  }
}

void _writeFieldValue(dynamic fieldValue, int fieldType, JsonSink jsonWriter,
    TypeRegistry typeRegistry) {
  if (fieldValue == null) {
    jsonWriter.addNull();
    return;
  }

  if (_isGroupOrMessage(fieldType)) {
    _writeToProto3JsonSink(
        (fieldValue as GeneratedMessage)._fieldSet, typeRegistry, jsonWriter);
  } else if (_isEnum(fieldType)) {
    jsonWriter.addString((fieldValue as ProtobufEnum).name);
  } else {
    final baseType = PbFieldType._baseType(fieldType);
    switch (baseType) {
      case PbFieldType._BOOL_BIT:
        jsonWriter.addBool(fieldValue);
        break;
      case PbFieldType._STRING_BIT:
        jsonWriter.addString(fieldValue);
        break;
      case PbFieldType._INT32_BIT:
      case PbFieldType._SINT32_BIT:
      case PbFieldType._UINT32_BIT:
      case PbFieldType._FIXED32_BIT:
      case PbFieldType._SFIXED32_BIT:
        jsonWriter.addNumber(fieldValue);
        break;
      case PbFieldType._INT64_BIT:
      case PbFieldType._SINT64_BIT:
      case PbFieldType._SFIXED64_BIT:
      case PbFieldType._FIXED64_BIT:
        jsonWriter.addString(fieldValue.toString());
        break;
      case PbFieldType._FLOAT_BIT:
      case PbFieldType._DOUBLE_BIT:
        double value = fieldValue;
        if (value.isNaN) {
          jsonWriter.addString(nan);
        } else if (value.isInfinite) {
          jsonWriter.addString(value.isNegative ? negativeInfinity : infinity);
        } else {
          jsonWriter.addNumber(value);
        }
        break;
      case PbFieldType._UINT64_BIT:
        jsonWriter.addString((fieldValue as Int64).toStringUnsigned());
        break;
      case PbFieldType._BYTES_BIT:
        jsonWriter.addString(base64Encode(fieldValue));
        break;
      default:
        throw StateError(
            'Invariant violation: unexpected value type $fieldType');
    }
  }
}
