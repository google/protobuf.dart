// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

Object _writeToProto3Json(_FieldSet fs, TypeRegistry typeRegistry) {
  String convertToMapKey(dynamic key, int keyType) {
    int baseType = PbFieldType._baseType(keyType);

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
      int baseType = PbFieldType._baseType(fieldType);
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

  Map<String, dynamic> result = <String, dynamic>{};
  for (FieldInfo fieldInfo in fs._infosSortedByTag) {
    var value = fs._values[fieldInfo.index];
    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }
    dynamic jsonValue;
    if (fieldInfo.isMapField) {
      jsonValue = (value as PbMap).map((key, entryValue) {
        MapFieldInfo mapEntryInfo = fieldInfo as MapFieldInfo;
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
  // Extensions are thrown out by proto3 JSON.
  // Unknown fields are not encoded by proto3 JSON.
  return result;
}

void _mergeFromProto3Json(
    Object json,
    _FieldSet fieldSet,
    TypeRegistry typeRegistry,
    bool ignoreUnknownFields,
    bool supportNamesWithUnderscores) {
  List<String> path = [];

  Exception parseException(String message) {
    String formattedPath = path.map((s) => '[$s]').join();
    return FormatException(
        'Protobuf JSON decoding failed at: $formattedPath. $message');
  }

  void helper(Object json, _FieldSet fieldSet) {
    Object convertProto3JsonValue(Object value, FieldInfo fieldInfo) {
      if (value == null) {
        return fieldInfo.makeDefault();
      }
      int fieldType = fieldInfo.type;
      switch (PbFieldType._baseType(fieldType)) {
        case PbFieldType._BOOL_BIT:
          if (value is bool) {
            return value;
          }
          throw parseException('Expected bool value');
        case PbFieldType._BYTES_BIT:
          if (value is String) {
            return base64Decode(value);
          }
          throw parseException('Expected base64 encoded string value');
        case PbFieldType._STRING_BIT:
          if (value is String) {
            return value;
          }
          throw parseException('Expected String value');
        case PbFieldType._FLOAT_BIT:
        case PbFieldType._DOUBLE_BIT:
          if (value is double) {
            return value;
          } else if (value is num) {
            return value.toDouble();
          } else if (value is String) {
            return double.parse(value);
          }
          throw parseException(
              'Expected a double represented as a String or number');
        case PbFieldType._ENUM_BIT:
          if (value is String) {
            // TODO(sigurdm): Do we want to avoid linear search here? Measure...
            return fieldInfo.enumValues.firstWhere((e) => e.name == value,
                orElse: () =>
                    throw parseException('Unknown enum value: $value'));
          } else if (value is int) {
            return fieldInfo.valueOf(value) ??
                (throw parseException('Unknown enum value: $value'));
          }
          throw parseException('Expected enum as a string or integer');
        case PbFieldType._INT32_BIT:
        case PbFieldType._SINT32_BIT:
        case PbFieldType._UINT32_BIT:
        case PbFieldType._FIXED32_BIT:
        case PbFieldType._SFIXED32_BIT:
          if (value is int) return value;
          if (value is String) return int.parse(value);
          throw parseException('Expected int or stringified int');
          break;
        case PbFieldType._INT64_BIT:
        case PbFieldType._SINT64_BIT:
        case PbFieldType._UINT64_BIT:
        case PbFieldType._FIXED64_BIT:
        case PbFieldType._SFIXED64_BIT:
          if (value is int) return Int64(value);
          if (value is String) return Int64.parseInt(value);
          throw parseException('Expected int or stringified int');
        case PbFieldType._GROUP_BIT:
        case PbFieldType._MESSAGE_BIT:
          GeneratedMessage subMessage = fieldInfo.subBuilder();

          helper(value, subMessage._fieldSet);
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
              throw parseException(
                  'Wrong boolean key "$key", should be one of ("true", "false")');
          }
          // ignore: dead_code
          throw StateError('(Should have been) unreachable statement');
        case PbFieldType._STRING_BIT:
          return key;
        case PbFieldType._UINT64_BIT:
          // TODO(sigurdm): unsigned...
          return Int64.parseInt(key);
        case PbFieldType._INT64_BIT:
        case PbFieldType._SINT64_BIT:
        case PbFieldType._SFIXED64_BIT:
        case PbFieldType._FIXED64_BIT:
          return Int64.parseInt(key);
        case PbFieldType._INT32_BIT:
        case PbFieldType._SINT32_BIT:
        case PbFieldType._FIXED32_BIT:
        case PbFieldType._SFIXED32_BIT:
          // TODO(sigurdm): Restrict to 32 bits.
          return int.parse(key);
        case PbFieldType._UINT32_BIT:
          // TODO(sigurdm): unsigned...
          return int.parse(key);
        default:
          throw StateError('Not a valid key type $fieldType');
      }
    }

    if (json == null) {
      // `null` represents the default value. Do nothing more.
      return;
    }

    BuilderInfo info = fieldSet._meta;

    final wellKnownConverter = info.fromProto3Json;
    if (wellKnownConverter != null) {
      wellKnownConverter(fieldSet._message, json, typeRegistry);
    } else {
      if (json is Map) {
        Map<String, FieldInfo> byName = info.byName;

        json.forEach((key, value) {
          if (key is! String) {
            throw parseException('Key $key was not a String ');
          }
          path.add(key);

          FieldInfo fieldInfo = byName[key];
          if (fieldInfo == null && supportNamesWithUnderscores) {
            // We don't optimize for field names with underscores, instead do a
            // linear search for the index.
            fieldInfo = byName.values.firstWhere(
                (FieldInfo info) => info.protoName == key,
                orElse: () => null);
            print('byName ${byName.values.map((f) => f.protoName)}');
            print('trying $fieldInfo');
          }
          if (fieldInfo == null) {
            if (ignoreUnknownFields) {
              return;
            } else {
              throw parseException('unknown field name \'$key\'');
            }
          }

          if (_isMapField(fieldInfo.type)) {
            if (value is Map<String, Object>) {
              MapFieldInfo mapFieldInfo = fieldInfo;
              Map fieldValues = fieldSet._ensureMapField(fieldInfo);
              value.forEach((key, value) => fieldValues[
                      decodeMapKey(key, mapFieldInfo.keyFieldType)] =
                  convertProto3JsonValue(value, mapFieldInfo.valueFieldInfo));
            } else {
              throw parseException('Expected a map');
            }
          } else if (_isRepeated(fieldInfo.type)) {
            if (value == null) {
              // `null` is accepted as the empty list [].
              fieldSet._ensureRepeatedField(fieldInfo);
            } else if (value is List<Object>) {
              List values = fieldSet._ensureRepeatedField(fieldInfo);
              path.add(key);
              path.add('0');
              for (final entry in value) {
                path.last = entry.toString();
                values.add(convertProto3JsonValue(entry, fieldInfo));
              }
              path.removeLast();
            } else {
              throw parseException('Expected a list');
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
          path.removeLast();
        });
      } else {
        throw parseException('expected JSON object but found: $json');
      }
    }
  }

  helper(json, fieldSet);
}
