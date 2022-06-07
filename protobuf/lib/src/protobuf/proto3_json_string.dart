part of protobuf;

void _writeToProto3JsonSink<S extends StringSink>(
    _FieldSet fs, TypeRegistry typeRegistry, S sink) {
  final wellKnownConverter = fs._meta.toProto3Json;
  if (wellKnownConverter != null) {
    // For now we allocate intermediate JSON for well-known types. In the
    // future we may want to add `toProto3JsonString` to well-known types.
    final json = wellKnownConverter(fs._message!, typeRegistry);
    sink.write(jsonEncode(json));
    return;
  }

  final JsonWriter<String> jsonWriter = jsonStringWriter(sink, indent: null);
  _writeToProto3JsonWriter(fs, typeRegistry, jsonWriter);
}

void _writeToProto3JsonWriter(
    _FieldSet fs, TypeRegistry typeRegistry, JsonWriter<String> jsonWriter) {
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

void _writeMapKey(dynamic key, int keyType, JsonWriter<String> jsonWriter) {
  var baseType = PbFieldType._baseType(keyType);

  assert(!_isRepeated(keyType));

  switch (baseType) {
    case PbFieldType._BOOL_BIT:
      jsonWriter.addBool(key as bool);
      break;
    case PbFieldType._STRING_BIT:
      jsonWriter.addString(key as String);
      break;
    case PbFieldType._UINT64_BIT:
      jsonWriter.addString((key as Int64).toStringUnsigned());
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
      jsonWriter.addString(key.toString());
      break;
    default:
      throw StateError('Not a valid key type $keyType');
  }
}

void _writeFieldValue(dynamic fieldValue, int fieldType,
    JsonWriter<String> jsonWriter, TypeRegistry typeRegistry) {
  if (fieldValue == null) {
    jsonWriter.addNull();
    return;
  }

  if (_isGroupOrMessage(fieldType)) {
    _writeToProto3JsonWriter(
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

////////////////////////////////////////////////////////////////////////////////////////////////////

class Proto3JsonParserParams {
  final TypeRegistry typeRegistry;
  final bool ignoreUnknownFields;
  final bool supportNamesWithUnderscores;
  final bool permissiveEnums;

  Proto3JsonParserParams(this.typeRegistry,
      {required this.ignoreUnknownFields,
      required this.supportNamesWithUnderscores,
      required this.permissiveEnums});
}

void _mergeFromProto3JsonString(String jsonString, _FieldSet fieldSet,
    TypeRegistry typeRegistry, Proto3JsonParserParams params) {
  final JsonReader<StringSlice> jsonReader = JsonReader.fromString(jsonString);

  var context = JsonParsingContext(params.ignoreUnknownFields,
      params.supportNamesWithUnderscores, params.permissiveEnums);

  _mergeFromProto3JsonStringReader(
      jsonReader, fieldSet, typeRegistry, context, params);
}

void _mergeFromProto3JsonStringReader(
    JsonReader<StringSlice> jsonReader,
    _FieldSet fieldSet,
    TypeRegistry typeRegistry,
    JsonParsingContext context,
    Proto3JsonParserParams params) {
  if (jsonReader.tryNull()) {
    return;
  }

  final meta = fieldSet._meta;

  final wellKnownConverter = meta.fromProto3Json;
  if (wellKnownConverter != null) {
    // For now we allocate intermediate JSON for well-known types. In the
    // future we may want to add `fromProto3JsonString` to well-known types.
    final StringSlice jsonSlice =
        jsonReader.expectAnyValueSource(); // TODO: catch exceptions
    final json = jsonDecode(jsonSlice.toString());
    wellKnownConverter(fieldSet._message!, json, typeRegistry, context);
    return;
  }

  if (!jsonReader.tryObject()) {
    // TODO: Check error message
    throw context.parseException('Expected JSON object', jsonString);
  }

  final Map<String, FieldInfo> fieldsByName = meta.byName;

  String? key = jsonReader.nextKey();
  while (key != null) {
    context.addMapIndex(key);
    final FieldInfo? fieldInfo = fieldsByName[key];

    if (fieldInfo == null) {
      if (params.ignoreUnknownFields) {
        return;
      } else {
        throw context.parseException('Unknown field name \'$key\'', key);
      }
    }

    if (_isMapField(fieldInfo.type)) {
      final mapFieldInfo = fieldInfo as MapFieldInfo<dynamic, dynamic>;
      final Map fieldValues = fieldSet._ensureMapField(meta, fieldInfo);
      if (!jsonReader.tryObject()) {
        // TODO: We don't have the JSON string to show in error messages
        throw context.parseException('Expected a map', 1);
      }
      String? key = jsonReader.nextKey();
      while (key != null) {
        String? keyStr = jsonReader.tryString();
        if (keyStr == null) {
          throw context.parseException('Expected a String key', keyStr);
        }
        context.addMapIndex(keyStr);
        Object mapKey =
            _decodeMapKey(keyStr, mapFieldInfo.keyFieldType, context);
        Object? value = _parseProto3JsonValue(jsonReader,
            mapFieldInfo.valueFieldInfo, typeRegistry, context, params);
        fieldValues[mapKey] = value;
        context.popIndex();

        key = jsonReader.nextKey();
      }
    } else if (_isRepeated(fieldInfo.type)) {
      if (!jsonReader.tryArray()) {
        // TODO: We don't have the JSON string to show in error messages
        throw context.parseException('Expected a list', 1);
      }
      List values = fieldSet._ensureRepeatedField(meta, fieldInfo);
      int i = 0;
      while (jsonReader.hasNext()) {
        context.addListIndex(i);
        values.add(_parseProto3JsonValue(
            jsonReader, fieldInfo, typeRegistry, context, params));
        context.popIndex();
        i += 1;
      }
    } else if (_isGroupOrMessage(fieldInfo.type)) {
      var parsedSubMessage = _parseProto3JsonValue(
              jsonReader, fieldInfo, typeRegistry, context, params)
          as GeneratedMessage;
      GeneratedMessage? original = fieldSet._values[fieldInfo.index!];
      if (original == null) {
        fieldSet._setNonExtensionFieldUnchecked(
            meta, fieldInfo, parsedSubMessage);
      } else {
        original.mergeFromMessage(parsedSubMessage);
      }
    } else {
      var value = _parseProto3JsonValue(
          jsonReader, fieldInfo, typeRegistry, context, params);
      fieldSet._setFieldUnchecked(meta, fieldInfo, value);
    }

    context.popIndex();
    key = jsonReader.nextKey();
  }
}

Object? _parseProto3JsonValue(
    JsonReader<StringSlice> jsonReader,
    FieldInfo fieldInfo,
    TypeRegistry typeRegistry,
    JsonParsingContext context,
    Proto3JsonParserParams params) {
  if (jsonReader.tryNull()) {
    return fieldInfo.makeDefault!();
  }

  final fieldType = fieldInfo.type;

  switch (PbFieldType._baseType(fieldType)) {
    case PbFieldType._BOOL_BIT:
      bool? b = jsonReader.tryBool();
      if (b == null) {
        // TODO: We don't have the JSON string to show in error messages
        throw context.parseException('Expected bool value', 1);
      }
      return b;

    case PbFieldType._BYTES_BIT:
      String? s = jsonReader.tryString();
      if (s == null) {
        // TODO: We don't have the JSON string to show in error messages
        throw context.parseException('Expected String value', 1);
      }
      try {
        return base64Decode(s);
      } on FormatException {
        // TODO: We don't have the JSON string to show in error messages
        throw context.parseException(
            'Expected bytes encoded as base64 String', 1);
      }

    case PbFieldType._STRING_BIT:
      String? s = jsonReader.tryString();
      if (s == null) {
        // TODO: We don't have the JSON string to show in error messages
        throw context.parseException('Expected String value', 1);
      }
      return s;

    case PbFieldType._FLOAT_BIT:
    case PbFieldType._DOUBLE_BIT:
      num? n = jsonReader.tryNum();
      if (n == null) {
        String? s = jsonReader.tryString();
        if (s == null) {
          // TODO: We don't have the JSON string to show in error messages
          throw context.parseException(
              'Expected a double represented as a String or number', 1);
        }
        return double.tryParse(s) ??
            (throw context.parseException(
                'Expected String to encode a double', s));
      }
      return n.toDouble();

    case PbFieldType._ENUM_BIT:
      String? s = jsonReader.tryString();
      if (s == null) {
        num? n = jsonReader.tryNum();
        if (n == null) {
          // TODO: We don't have the JSON string to show in error messages
          throw context.parseException(
              'Expected enum as a string or integer', 1);
        }
        return fieldInfo.valueOf!(n as int) ??
            (params.ignoreUnknownFields
                ? null
                : (throw context.parseException('Unknown enum value', n)));
      }
      // TODO(sigurdm): Do we want to avoid linear search here? Measure...
      final result = params.permissiveEnums
          ? fieldInfo.enumValues!.findFirst((e) => permissiveCompare(e.name, s))
          : fieldInfo.enumValues!.findFirst((e) => e.name == s);
      if ((result != null) || params.ignoreUnknownFields) {
        return result;
      }
      throw context.parseException('Unknown enum value', s);

    case PbFieldType._UINT32_BIT:
    case PbFieldType._FIXED32_BIT:
      num? n = jsonReader.tryNum();
      if (n == null) {
        String? s = jsonReader.tryString();
        if (s == null) {
          // TODO: We don't have the JSON string to show in error messages
          throw context.parseException('Expected int or stringified int', 1);
        }
        return _tryParse32BitProto3(s, context);
      }
      return n as int; // TODO: conversion needs to be checked?

    case PbFieldType._INT32_BIT:
    case PbFieldType._SINT32_BIT:
    case PbFieldType._SFIXED32_BIT:
      num? n = jsonReader.tryNum();
      if (n != null) {
        return n as int; // TODO: conversion needs to be checked?
      }
      String? s = jsonReader.tryString();
      if (s != null) {
        return _tryParse32BitProto3(s, context);
      }
      // TODO: We don't have the JSON string to show in error messages
      throw context.parseException('Expected int or stringified int', 1);

    case PbFieldType._UINT64_BIT:
      num? n = jsonReader.tryNum();
      if (n != null) {
        return Int64(n as int); // TODO: conversion needs to be checked?
      }
      String? s = jsonReader.tryString();
      if (s != null) {
        return _tryParse64BitProto3(1, s, context); // TODO: error value
      }
      // TODO: We don't have the JSON string to show in error messages
      throw context.parseException('Expected int or stringified int', 1);

    case PbFieldType._INT64_BIT:
    case PbFieldType._SINT64_BIT:
    case PbFieldType._FIXED64_BIT:
    case PbFieldType._SFIXED64_BIT:
      num? n = jsonReader.tryNum();
      if (n != null) {
        return Int64(n as int); // TODO: conversion needs to be checked?
      }
      String? s = jsonReader.tryString();
      if (s != null) {
        try {
          return Int64.parseInt(s);
        } on FormatException {
          throw context.parseException('Expected int or stringified int', s);
        }
      }
      // TODO: We don't have the JSON string to show in error messages
      throw context.parseException('Expected int or stringified int', 1);

    case PbFieldType._GROUP_BIT:
    case PbFieldType._MESSAGE_BIT:
      GeneratedMessage subMessage = fieldInfo.subBuilder!();
      _mergeFromProto3JsonStringReader(
          jsonReader, subMessage._fieldSet, typeRegistry, context, params);
      return subMessage;

    default:
      throw StateError('Unknown type $fieldType');
  }
}

Object _decodeMapKey(String key, int fieldType, JsonParsingContext context) {
  switch (PbFieldType._baseType(fieldType)) {
    case PbFieldType._BOOL_BIT:
      switch (key) {
        case 'true':
          return true;
        case 'false':
          return false;
        default:
          throw context.parseException(
              'Wrong boolean key, should be one of ("true", "false")', key);
      }
      // ignore: dead_code
      throw StateError('(Should have been) unreachable statement');
    case PbFieldType._STRING_BIT:
      return key;
    case PbFieldType._UINT64_BIT:
      // TODO(sigurdm): We do not throw on negative values here.
      // That would probably require going via bignum.
      return _tryParse64BitProto3(1, key, context); // TODO: Error json
    case PbFieldType._INT64_BIT:
    case PbFieldType._SINT64_BIT:
    case PbFieldType._SFIXED64_BIT:
    case PbFieldType._FIXED64_BIT:
      return _tryParse64BitProto3(1, key, context); // TODO: Error json
    case PbFieldType._INT32_BIT:
    case PbFieldType._SINT32_BIT:
    case PbFieldType._FIXED32_BIT:
    case PbFieldType._SFIXED32_BIT:
      return _check32BitSignedProto3(
          _tryParse32BitProto3(key, context), context);
    case PbFieldType._UINT32_BIT:
      return _check32BitUnsignedProto3(
          _tryParse32BitProto3(key, context), context);
    default:
      throw StateError('Not a valid key type $fieldType');
  }
}
