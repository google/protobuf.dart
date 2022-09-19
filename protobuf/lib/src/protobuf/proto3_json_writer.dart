// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

void _writeToProto3JsonSink(
    _FieldSet fs, TypeRegistry typeRegistry, JsonSink jsonSink,
    {bool newMessage = true}) {
  final wellKnownConverter = fs._meta.toProto3Json;
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
      final MapFieldInfo mapFieldInfo = fieldInfo as dynamic;
      final Map mapValue = value;
      for (var entry in mapValue.entries) {
        final key = entry.key;
        final value = entry.value;
        _writeMapKey(key, mapFieldInfo.keyFieldType, jsonSink);
        _writeFieldValue(
            value, mapFieldInfo.valueFieldType, jsonSink, typeRegistry);
      }
      jsonSink.endObject(); // end map field
    } else if (fieldInfo.isRepeated) {
      jsonSink.startArray(); // start repeated field
      final List listValue = value;
      for (final element in listValue) {
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
      final bool boolKey = key;
      jsonSink.addKey(boolKey.toString());
      break;
    case PbFieldType._STRING_BIT:
      final String stringKey = key;
      jsonSink.addKey(stringKey);
      break;
    case PbFieldType._UINT64_BIT:
      final Int64 intKey = key;
      jsonSink.addKey(intKey.toStringUnsigned().toString());
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
    final GeneratedMessage messageValue = fieldValue;
    _writeToProto3JsonSink(messageValue._fieldSet, typeRegistry, jsonSink);
  } else if (_isEnum(fieldType)) {
    final ProtobufEnum enumValue = fieldValue;
    jsonSink.addString(enumValue.name);
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
          jsonSink.addString(_nan);
          break;
        }
        if (value.isInfinite) {
          jsonSink.addString(value.isNegative ? _negativeInfinity : _infinity);
          break;
        }
        final intValue = value.toInt();
        if (intValue == value) {
          jsonSink.addNumber(intValue);
          break;
        }
        jsonSink.addNumber(value);
        break;
      case PbFieldType._UINT64_BIT:
        final Int64 intValue = fieldValue;
        jsonSink.addString(intValue.toStringUnsigned());
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
