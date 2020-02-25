// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

Object _writeToProto3Json(_FieldSet fs, TypeRegistry typeRegistry) {
  String convertToMapKey(dynamic key, int keyType) {
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

  Object valueToProto3Json(dynamic fieldValue, int fieldType) {
    if (fieldValue == null) return null;

    if (_isGroupOrMessage(fieldType)) {
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
          if (value.isNaN) return 'NaN';
          if (value.isInfinite) {
            if (value.isNegative) {
              return '-Infinity';
            } else {
              return 'Infinity';
            }
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

  if (fs._meta.toProto3Json != null) {
    return fs._meta.toProto3Json(fs._message, typeRegistry);
  }

  var result = <String, dynamic>{};
  for (var fieldInfo in fs._infosSortedByTag) {
    var value = fs._values[fieldInfo.index];
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

void _mergeFromProto3Json(
    Object json,
    _FieldSet fieldSet,
    TypeRegistry typeRegistry,
    bool ignoreUnknownFields,
    bool supportNamesWithUnderscores,
    bool permissiveEnums) {
  var context = JsonParsingContext(
      ignoreUnknownFields, supportNamesWithUnderscores, permissiveEnums);

  void recursionHelper(Object json, _FieldSet fieldSet) {
    int tryParse32Bit(String s) {
      return int.tryParse(s) ??
          (throw context.parseException('expected integer', s));
    }

    int check32BitSigned(int n) {
      if (n < -2147483648 || n > 2147483647) {
        throw context.parseException('expected 32 bit unsigned integer', n);
      }
      return n;
    }

    int check32BitUnsigned(int n) {
      if (n < 0 || n > 0xFFFFFFFF) {
        throw context.parseException('expected 32 bit unsigned integer', n);
      }
      return n;
    }

    Int64 tryParse64Bit(String s) {
      Int64 result;
      try {
        result = Int64.parseInt(s);
      } on FormatException {
        throw context.parseException('expected integer', json);
      }
      return result;
    }

    Object convertProto3JsonValue(Object value, FieldInfo fieldInfo) {
      if (value == null) {
        return fieldInfo.makeDefault();
      }
      var fieldType = fieldInfo.type;
      switch (PbFieldType._baseType(fieldType)) {
        case PbFieldType._BOOL_BIT:
          if (value is bool) {
            return value;
          }
          throw context.parseException('Expected bool value', json);
        case PbFieldType._BYTES_BIT:
          if (value is String) {
            Uint8List result;
            try {
              result = base64Decode(value);
            } on FormatException {
              throw context.parseException(
                  'Expected bytes encoded as base64 String', json);
            }
            return result;
          }
          throw context.parseException(
              'Expected bytes encoded as base64 String', value);
        case PbFieldType._STRING_BIT:
          if (value is String) {
            return value;
          }
          throw context.parseException('Expected String value', value);
        case PbFieldType._FLOAT_BIT:
        case PbFieldType._DOUBLE_BIT:
          if (value is double) {
            return value;
          } else if (value is num) {
            return value.toDouble();
          } else if (value is String) {
            return double.tryParse(value) ??
                (throw context.parseException(
                    'Expected String to encode a double', value));
          }
          throw context.parseException(
              'Expected a double represented as a String or number', value);
        case PbFieldType._ENUM_BIT:
          if (value is String) {
            // TODO(sigurdm): Do we want to avoid linear search here? Measure...
            final result = permissiveEnums
                ? fieldInfo.enumValues.firstWhere(
                    (e) => permissiveCompare(e.name, value),
                    orElse: () => null)
                : fieldInfo.enumValues
                    .firstWhere((e) => e.name == value, orElse: () => null);
            if ((result != null) || ignoreUnknownFields) return result;
            throw context.parseException('Unknown enum value', value);
          } else if (value is int) {
            return fieldInfo.valueOf(value) ??
                (ignoreUnknownFields
                    ? null
                    : (throw context.parseException(
                        'Unknown enum value', value)));
          }
          throw context.parseException(
              'Expected enum as a string or integer', value);
        case PbFieldType._UINT32_BIT:
          int result;
          if (value is int) {
            result = value;
          } else if (value is String) {
            result = tryParse32Bit(value);
          } else {
            throw context.parseException(
                'Expected int or stringified int', value);
          }
          return check32BitUnsigned(result);
        case PbFieldType._INT32_BIT:
        case PbFieldType._SINT32_BIT:
        case PbFieldType._FIXED32_BIT:
        case PbFieldType._SFIXED32_BIT:
          int result;
          if (value is int) {
            result = value;
          } else if (value is String) {
            result = tryParse32Bit(value);
          } else {
            throw context.parseException(
                'Expected int or stringified int', value);
          }
          check32BitSigned(result);
          return result;
        case PbFieldType._UINT64_BIT:
          Int64 result;
          if (value is int) {
            result = Int64(value);
          } else if (value is String) {
            result = tryParse64Bit(value);
          } else {
            throw context.parseException(
                'Expected int or stringified int', value);
          }
          return result;
        case PbFieldType._INT64_BIT:
        case PbFieldType._SINT64_BIT:
        case PbFieldType._FIXED64_BIT:
        case PbFieldType._SFIXED64_BIT:
          if (value is int) return Int64(value);
          if (value is String) {
            Int64 result;
            try {
              result = Int64.parseInt(value);
            } on FormatException {
              throw context.parseException(
                  'Expected int or stringified int', value);
            }
            return result;
          }
          throw context.parseException(
              'Expected int or stringified int', value);
        case PbFieldType._GROUP_BIT:
        case PbFieldType._MESSAGE_BIT:
          var subMessage = fieldInfo.subBuilder();
          recursionHelper(value, subMessage._fieldSet);
          return subMessage;
        default:
          throw StateError('Unknown type $fieldType');
      }
    }

    Object decodeMapKey(String key, int fieldType) {
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
          return tryParse64Bit(key);
        case PbFieldType._INT64_BIT:
        case PbFieldType._SINT64_BIT:
        case PbFieldType._SFIXED64_BIT:
        case PbFieldType._FIXED64_BIT:
          return tryParse64Bit(key);
        case PbFieldType._INT32_BIT:
        case PbFieldType._SINT32_BIT:
        case PbFieldType._FIXED32_BIT:
        case PbFieldType._SFIXED32_BIT:
          return check32BitSigned(tryParse32Bit(key));
        case PbFieldType._UINT32_BIT:
          return check32BitUnsigned(tryParse32Bit(key));
        default:
          throw StateError('Not a valid key type $fieldType');
      }
    }

    if (json == null) {
      // `null` represents the default value. Do nothing more.
      return;
    }

    var info = fieldSet._meta;

    final wellKnownConverter = info.fromProto3Json;
    if (wellKnownConverter != null) {
      wellKnownConverter(fieldSet._message, json, typeRegistry, context);
    } else {
      if (json is Map) {
        var byName = info.byName;

        json.forEach((key, value) {
          if (key is! String) {
            throw context.parseException('Key was not a String', key);
          }
          context.addMapIndex(key);

          var fieldInfo = byName[key];
          if (fieldInfo == null && supportNamesWithUnderscores) {
            // We don't optimize for field names with underscores, instead do a
            // linear search for the index.
            fieldInfo = byName.values.firstWhere(
                (FieldInfo info) => info.protoName == key,
                orElse: () => null);
          }
          if (fieldInfo == null) {
            if (ignoreUnknownFields) {
              return;
            } else {
              throw context.parseException('Unknown field name \'$key\'', key);
            }
          }

          if (_isMapField(fieldInfo.type)) {
            if (value is Map) {
              MapFieldInfo mapFieldInfo = fieldInfo;
              Map fieldValues = fieldSet._ensureMapField(fieldInfo);
              value.forEach((subKey, subValue) {
                if (subKey is! String) {
                  throw context.parseException('Expected a String key', subKey);
                }
                context.addMapIndex(subKey);
                final result = fieldValues[
                        decodeMapKey(subKey, mapFieldInfo.keyFieldType)] =
                    convertProto3JsonValue(
                        subValue, mapFieldInfo.valueFieldInfo);
                context.popIndex();
                return result;
              });
            } else {
              throw context.parseException('Expected a map', value);
            }
          } else if (_isRepeated(fieldInfo.type)) {
            if (value == null) {
              // `null` is accepted as the empty list [].
              fieldSet._ensureRepeatedField(fieldInfo);
            } else if (value is List) {
              var values = fieldSet._ensureRepeatedField(fieldInfo);
              for (var i = 0; i < value.length; i++) {
                final entry = value[i];
                context.addListIndex(i);
                values.add(convertProto3JsonValue(entry, fieldInfo));
                context.popIndex();
              }
            } else {
              throw context.parseException('Expected a list', value);
            }
          } else if (_isGroupOrMessage(fieldInfo.type)) {
            // TODO(sigurdm) consider a cleaner separation between parsing and merging.
            GeneratedMessage parsedSubMessage =
                convertProto3JsonValue(value, fieldInfo);
            GeneratedMessage original = fieldSet._values[fieldInfo.index];
            if (original == null) {
              fieldSet._values[fieldInfo.index] = parsedSubMessage;
            } else {
              original.mergeFromMessage(parsedSubMessage);
            }
          } else {
            fieldSet._setFieldUnchecked(
                fieldInfo, convertProto3JsonValue(value, fieldInfo));
          }
          context.popIndex();
        });
      } else {
        throw context.parseException('Expected JSON object', json);
      }
    }
  }

  recursionHelper(json, fieldSet);
}
