// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

void _mergeFromProto3JsonString(
    String jsonString,
    _FieldSet fieldSet,
    TypeRegistry typeRegistry,
    bool ignoreUnknownFields,
    bool supportNamesWithUnderscores,
    bool permissiveEnums) {
  final JsonReader<StringSlice> jsonReader = JsonReader.fromString(jsonString);

  var context = JsonParsingContext(
      ignoreUnknownFields, supportNamesWithUnderscores, permissiveEnums);

  _mergeFromProto3JsonReader(jsonReader, fieldSet, typeRegistry, context);
}

void _mergeFromProto3JsonObject(
    Object? jsonObject,
    _FieldSet fieldSet,
    TypeRegistry typeRegistry,
    bool ignoreUnknownFields,
    bool supportNamesWithUnderscores,
    bool permissiveEnums) {
  final JsonReader<Object?> jsonReader = JsonReader.fromObject(jsonObject);

  var context = JsonParsingContext(
      ignoreUnknownFields, supportNamesWithUnderscores, permissiveEnums);

  _mergeFromProto3JsonReader(jsonReader, fieldSet, typeRegistry, context);
}

void _mergeFromProto3JsonReader(JsonReader jsonReader, _FieldSet fieldSet,
    TypeRegistry typeRegistry, JsonParsingContext context) {
  if (jsonReader.tryNull()) {
    return;
  }

  final meta = fieldSet._meta;

  final wellKnownConverter = meta.mergeFromProto3JsonReader;
  if (wellKnownConverter != null) {
    wellKnownConverter(fieldSet._message!, jsonReader, typeRegistry, context);
    return;
  }

  if (!jsonReader.tryObject()) {
    throw context.parseException(
        'Expected JSON object', nextJsonObject(jsonReader));
  }

  final Map<String, FieldInfo> fieldsByName = meta.byName;

  String? key = jsonReader.nextKey();
  while (key != null) {
    context.addMapIndex(key);
    FieldInfo? fieldInfo = fieldsByName[key];

    if (fieldInfo == null && context.supportNamesWithUnderscores) {
      // We don't optimize for field names with underscores, instead do a
      // linear search for the index.
      fieldInfo = meta.byName.values
          .findFirst((FieldInfo info) => info.protoName == key);
    }

    if (fieldInfo == null) {
      if (context.ignoreUnknownFields) {
        jsonReader.skipAnyValue();
        context.popIndex();
        key = jsonReader.nextKey();
        continue;
      } else {
        throw context.parseException('Unknown field name \'$key\'', key);
      }
    }

    if (_isMapField(fieldInfo.type)) {
      final mapFieldInfo = fieldInfo as MapFieldInfo<dynamic, dynamic>;
      final Map fieldValues = fieldSet._ensureMapField(meta, fieldInfo);
      if (!jsonReader.tryObject()) {
        throw context.parseException(
            'Expected a map', nextJsonObject(jsonReader));
      }
      String? mapKeyStr = jsonReader.nextKey();
      while (mapKeyStr != null) {
        context.addMapIndex(mapKeyStr);
        Object mapKey =
            _decodeMapKey(mapKeyStr, mapFieldInfo.keyFieldType, context);
        Object? value = _parseProto3JsonValue(
            jsonReader, mapFieldInfo.valueFieldInfo, typeRegistry, context);
        fieldValues[mapKey] = value;
        context.popIndex();

        mapKeyStr = jsonReader.nextKey();
      }
    } else if (_isRepeated(fieldInfo.type)) {
      if (jsonReader.tryNull()) {
        // `null` is accepted as the empty list [].
        fieldSet._ensureRepeatedField(meta, fieldInfo);
      } else {
        if (!jsonReader.tryArray()) {
          throw context.parseException(
              'Expected a list', nextJsonObject(jsonReader));
        }
        List values = fieldSet._ensureRepeatedField(meta, fieldInfo);
        int i = 0;
        while (jsonReader.hasNext()) {
          context.addListIndex(i);
          values.add(_parseProto3JsonValue(
              jsonReader, fieldInfo, typeRegistry, context));
          context.popIndex();
          i += 1;
        }
      }
    } else if (_isGroupOrMessage(fieldInfo.type)) {
      // TODO: Avoid allocating a message here
      var parsedSubMessage =
          _parseProto3JsonValue(jsonReader, fieldInfo, typeRegistry, context)
              as GeneratedMessage;
      GeneratedMessage? original = fieldSet._values[fieldInfo.index!];
      if (original == null) {
        fieldSet._setNonExtensionFieldUnchecked(
            meta, fieldInfo, parsedSubMessage);
      } else {
        original.mergeFromMessage(parsedSubMessage);
      }
    } else {
      var value =
          _parseProto3JsonValue(jsonReader, fieldInfo, typeRegistry, context);
      fieldSet._setFieldUnchecked(meta, fieldInfo, value);
    }

    context.popIndex();
    key = jsonReader.nextKey();
  }
}

Object? _parseProto3JsonValue(
  JsonReader jsonReader,
  FieldInfo fieldInfo,
  TypeRegistry typeRegistry,
  JsonParsingContext context,
) {
  if (jsonReader.tryNull()) {
    return fieldInfo.makeDefault!();
  }

  final fieldType = fieldInfo.type;

  switch (PbFieldType._baseType(fieldType)) {
    case PbFieldType._BOOL_BIT:
      bool? b = jsonReader.tryBool();
      if (b != null) {
        return b;
      }
      throw context.parseException(
          'Expected bool value', nextJsonObject(jsonReader));

    case PbFieldType._BYTES_BIT:
      String? s = jsonReader.tryString();
      if (s != null) {
        try {
          return base64Decode(s);
        } on FormatException {
          throw context.parseException(
              'Expected bytes encoded as base64 String', s);
        }
      }
      throw context.parseException(
          'Expected String value', nextJsonObject(jsonReader));

    case PbFieldType._STRING_BIT:
      String? s = jsonReader.tryString();
      if (s != null) {
        return s;
      }
      throw context.parseException(
          'Expected String value', nextJsonObject(jsonReader));

    case PbFieldType._FLOAT_BIT:
    case PbFieldType._DOUBLE_BIT:
      num? n = jsonReader.tryNum();
      if (n != null) {
        return n.toDouble();
      }
      String? s = jsonReader.tryString();
      if (s != null) {
        return double.tryParse(s) ??
            (throw context.parseException(
                'Expected String to encode a double', s));
      }
      throw context.parseException(
          'Expected a double represented as a String or number',
          nextJsonObject(jsonReader));

    case PbFieldType._ENUM_BIT:
      String? s = jsonReader.tryString();
      if (s != null) {
        // TODO(sigurdm): Do we want to avoid linear search here? Measure...
        final result = context.permissiveEnums
            ? fieldInfo.enumValues!
                .findFirst((e) => permissiveCompare(e.name, s))
            : fieldInfo.enumValues!.findFirst((e) => e.name == s);
        if ((result != null) || context.ignoreUnknownFields) {
          return result;
        }
        throw context.parseException('Unknown enum value', s);
      }
      num? n = jsonReader.tryNum();
      if (n != null) {
        return fieldInfo.valueOf!(n as int) ??
            (context.ignoreUnknownFields
                ? null
                : (throw context.parseException('Unknown enum value', n)));
      }
      throw context.parseException(
          'Expected enum as a string or integer', nextJsonObject(jsonReader));

    case PbFieldType._UINT32_BIT:
    case PbFieldType._FIXED32_BIT:
      num? n = jsonReader.tryNum();
      if (n != null) {
        if (n is int) {
          _check32BitUnsignedProto3(n, context);
          return n;
        }
        throw context.parseException('Expected 32-bit int', n);
      }
      String? s = jsonReader.tryString();
      if (s != null) {
        return _tryParse32BitProto3(s, context);
      }
      throw context.parseException(
          'Expected 32-bit int or stringified int', nextJsonObject(jsonReader));

    case PbFieldType._INT32_BIT:
    case PbFieldType._SINT32_BIT:
    case PbFieldType._SFIXED32_BIT:
      num? n = jsonReader.tryNum();
      if (n != null) {
        if (n is int) {
          _check32BitSignedProto3(n, context);
          return n;
        }
        throw context.parseException('Expected 32-bit int', n);
      }
      String? s = jsonReader.tryString();
      if (s != null) {
        return _tryParse32BitProto3(s, context);
      }
      throw context.parseException(
          'Expected 32-bit int or stringified int', nextJsonObject(jsonReader));

    case PbFieldType._UINT64_BIT:
      num? n = jsonReader.tryNum();
      if (n != null) {
        if (n is int) {
          return Int64(n);
        }
        throw context.parseException('Expected 64-bit int', n);
      }
      String? s = jsonReader.tryString();
      if (s != null) {
        return _tryParse64BitProto3(s, s, context);
      }
      throw context.parseException(
          'Expected 64-bit int or stringified int', nextJsonObject(jsonReader));

    case PbFieldType._INT64_BIT:
    case PbFieldType._SINT64_BIT:
    case PbFieldType._FIXED64_BIT:
    case PbFieldType._SFIXED64_BIT:
      num? n = jsonReader.tryNum();
      if (n != null) {
        if (n is int) {
          return Int64(n);
        }
        throw context.parseException('Expected 64-bit', n);
      }
      String? s = jsonReader.tryString();
      if (s != null) {
        try {
          return Int64.parseInt(s);
        } on FormatException {
          throw context.parseException(
              'Expected 64-bit int or stringified int', s);
        }
      }
      throw context.parseException(
          'Expected 64-bit int or stringified int', nextJsonObject(jsonReader));

    case PbFieldType._GROUP_BIT:
    case PbFieldType._MESSAGE_BIT:
      GeneratedMessage subMessage = fieldInfo.subBuilder!();
      _mergeFromProto3JsonReader(
          jsonReader, subMessage._fieldSet, typeRegistry, context);
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
      return _tryParse64BitProto3(key, key, context);
    case PbFieldType._INT64_BIT:
    case PbFieldType._SINT64_BIT:
    case PbFieldType._SFIXED64_BIT:
    case PbFieldType._FIXED64_BIT:
      return _tryParse64BitProto3(key, key, context);
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

int _tryParse32BitProto3(String s, JsonParsingContext context) {
  return int.tryParse(s) ??
      (throw context.parseException('expected integer', s));
}

int _check32BitSignedProto3(int n, JsonParsingContext context) {
  if (n < -2147483648 || n > 2147483647) {
    throw context.parseException('expected 32 bit signed integer', n);
  }
  return n;
}

int _check32BitUnsignedProto3(int n, JsonParsingContext context) {
  if (n < 0 || n > 0xFFFFFFFF) {
    throw context.parseException('expected 32 bit unsigned integer', n);
  }
  return n;
}

Int64 _tryParse64BitProto3(Object? json, String s, JsonParsingContext context) {
  try {
    return Int64.parseInt(s);
  } on FormatException {
    throw context.parseException('expected integer', json);
  }
}

/// TODO(paulberry): find a better home for this?
extension _FindFirst<E> on Iterable<E> {
  E? findFirst(bool Function(E) test) {
    for (var element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}