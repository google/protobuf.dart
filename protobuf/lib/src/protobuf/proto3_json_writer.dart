// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

void _writeToProto3JsonSink(
    _FieldSet fs, TypeRegistry typeRegistry, JsonSink jsonSink,
    {bool newMessage = true}) {
  final wellKnownConverter = fs._meta.writeToProto3JsonSink;
  if (wellKnownConverter != null) {
    wellKnownConverter(fs._message!, typeRegistry, jsonSink);
    return;
  }

  if (newMessage) {
    jsonSink.startObject(); // start message
  }

  for (var fieldInfo in fs._infosSortedByTag) {
    var value = fs._values[fieldInfo.index!];

    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }

    jsonSink.addKey(fieldInfo.name);

    if (fieldInfo.isMapField) {
      jsonSink.startObject(); // start map field
      final mapEntryInfo = fieldInfo as MapFieldInfo;
      for (var entry in (value as PbMap).entries) {
        final key = entry.key;
        final value = entry.value;
        _writeMapKey(key, mapEntryInfo.keyFieldType, jsonSink);
        _writeFieldValue(
            value, mapEntryInfo.valueFieldType, jsonSink, typeRegistry);
      }
      jsonSink.endObject(); // end map field
    } else if (fieldInfo.isRepeated) {
      jsonSink.startArray(); // start repeated field
      for (final element in value as PbList) {
        _writeFieldValue(element, fieldInfo.type, jsonSink, typeRegistry);
      }
      jsonSink.endArray(); // end repeated field
    } else {
      _writeFieldValue(value, fieldInfo.type, jsonSink, typeRegistry);
    }
  }

  if (newMessage) {
    jsonSink.endObject(); // end message
  }
}

void _writeMapKey(dynamic key, int keyType, JsonSink jsonSink) {
  var baseType = PbFieldType._baseType(keyType);

  assert(!_isRepeated(keyType));

  switch (baseType) {
    case PbFieldType._BOOL_BIT:
      jsonSink.addKey((key as bool).toString());
      break;
    case PbFieldType._STRING_BIT:
      jsonSink.addKey(key as String);
      break;
    case PbFieldType._UINT64_BIT:
      jsonSink.addKey((key as Int64).toStringUnsigned().toString());
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
      jsonSink.addKey(key.toString());
      break;
    default:
      throw StateError('Not a valid key type $keyType');
  }
}

void _writeFieldValue(dynamic fieldValue, int fieldType, JsonSink jsonSink,
    TypeRegistry typeRegistry) {
  if (fieldValue == null) {
    jsonSink.addNull();
    return;
  }

  if (_isGroupOrMessage(fieldType)) {
    _writeToProto3JsonSink(
        (fieldValue as GeneratedMessage)._fieldSet, typeRegistry, jsonSink);
  } else if (_isEnum(fieldType)) {
    jsonSink.addString((fieldValue as ProtobufEnum).name);
  } else {
    final baseType = PbFieldType._baseType(fieldType);
    switch (baseType) {
      case PbFieldType._BOOL_BIT:
        jsonSink.addBool(fieldValue);
        break;
      case PbFieldType._STRING_BIT:
        jsonSink.addString(fieldValue);
        break;
      case PbFieldType._INT32_BIT:
      case PbFieldType._SINT32_BIT:
      case PbFieldType._UINT32_BIT:
      case PbFieldType._FIXED32_BIT:
      case PbFieldType._SFIXED32_BIT:
        jsonSink.addNumber(fieldValue);
        break;
      case PbFieldType._INT64_BIT:
      case PbFieldType._SINT64_BIT:
      case PbFieldType._SFIXED64_BIT:
      case PbFieldType._FIXED64_BIT:
        jsonSink.addString(fieldValue.toString());
        break;
      case PbFieldType._FLOAT_BIT:
      case PbFieldType._DOUBLE_BIT:
        double value = fieldValue;
        if (value.isNaN) {
          jsonSink.addString(nan);
        } else if (value.isInfinite) {
          jsonSink.addString(value.isNegative ? negativeInfinity : infinity);
        } else {
          jsonSink.addNumber(value);
        }
        break;
      case PbFieldType._UINT64_BIT:
        jsonSink.addString((fieldValue as Int64).toStringUnsigned());
        break;
      case PbFieldType._BYTES_BIT:
        jsonSink.addString(base64Encode(fieldValue));
        break;
      default:
        throw StateError(
            'Invariant violation: unexpected value type $fieldType');
    }
  }
}
