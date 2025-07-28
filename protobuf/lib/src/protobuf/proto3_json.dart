// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'internal.dart';

Object? _writeToProto3Json(FieldSet fs, TypeRegistry typeRegistry) {
  String? convertToMapKey(dynamic key, int keyType) {
    final baseType = PbFieldType.baseType(keyType);

    assert(!PbFieldType.isRepeated(keyType));

    switch (baseType) {
      case PbFieldType.BOOL_BIT:
        return key ? 'true' : 'false';
      case PbFieldType.STRING_BIT:
        return key;
      case PbFieldType.UINT64_BIT:
        return (key as Int64).toStringUnsigned();
      case PbFieldType.INT32_BIT:
      case PbFieldType.SINT32_BIT:
      case PbFieldType.UINT32_BIT:
      case PbFieldType.FIXED32_BIT:
      case PbFieldType.SFIXED32_BIT:
      case PbFieldType.INT64_BIT:
      case PbFieldType.SINT64_BIT:
      case PbFieldType.SFIXED64_BIT:
      case PbFieldType.FIXED64_BIT:
        return key.toString();
      default:
        throw StateError('Not a valid key type $keyType');
    }
  }

  Object? valueToProto3Json(dynamic fieldValue, int? fieldType) {
    if (fieldValue == null) return null;

    if (PbFieldType.isGroupOrMessage(fieldType!)) {
      return _writeToProto3Json(
        (fieldValue as GeneratedMessage)._fieldSet,
        typeRegistry,
      );
    } else if (PbFieldType.isEnum(fieldType)) {
      return (fieldValue as ProtobufEnum).name;
    } else {
      final baseType = PbFieldType.baseType(fieldType);
      switch (baseType) {
        case PbFieldType.BOOL_BIT:
          return fieldValue as bool;
        case PbFieldType.STRING_BIT:
          return fieldValue;
        case PbFieldType.INT32_BIT:
        case PbFieldType.SINT32_BIT:
        case PbFieldType.UINT32_BIT:
        case PbFieldType.FIXED32_BIT:
        case PbFieldType.SFIXED32_BIT:
          return fieldValue;
        case PbFieldType.INT64_BIT:
        case PbFieldType.SINT64_BIT:
        case PbFieldType.SFIXED64_BIT:
        case PbFieldType.FIXED64_BIT:
          return fieldValue.toString();
        case PbFieldType.FLOAT_BIT:
        case PbFieldType.DOUBLE_BIT:
          final double value = fieldValue;
          if (value.isNaN) {
            return nan;
          }
          if (value.isInfinite) {
            return value.isNegative ? negativeInfinity : infinity;
          }
          if (value.toInt() == fieldValue) {
            return value.toInt();
          }
          return value;
        case PbFieldType.UINT64_BIT:
          return (fieldValue as Int64).toStringUnsigned();
        case PbFieldType.BYTES_BIT:
          return base64Encode(fieldValue);
        default:
          throw StateError(
            'Invariant violation: unexpected value type $fieldType',
          );
      }
    }
  }

  final meta = fs._meta;
  if (meta.toProto3Json != null) {
    return meta.toProto3Json!(fs._message!, typeRegistry);
  }

  final result = <String, dynamic>{};
  for (final fieldInfo in fs._infosSortedByTag) {
    final value = fs._values[fieldInfo.index!];
    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }
    dynamic jsonValue;
    if (fieldInfo.isMapField) {
      jsonValue = (value as PbMap).map((key, entryValue) {
        final mapEntryInfo = fieldInfo as MapFieldInfo;
        return MapEntry(
          convertToMapKey(key, mapEntryInfo.keyFieldType),
          valueToProto3Json(entryValue, mapEntryInfo.valueFieldType),
        );
      });
    } else if (fieldInfo.isRepeated) {
      jsonValue =
          (value as PbList)
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
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

/// Merge a JSON object representing a message in proto3 JSON format ([json])
/// to [fieldSet].
void _mergeFromProto3Json(
  Object? json,
  FieldSet fieldSet,
  TypeRegistry typeRegistry,
  bool ignoreUnknownFields,
  bool supportNamesWithUnderscores,
  bool permissiveEnums,
) {
  fieldSet._ensureWritable();
  final context = JsonParsingContext(
    ignoreUnknownFields,
    supportNamesWithUnderscores,
    permissiveEnums,
  );

  void recursionHelper(Object? json, FieldSet fieldSet) {
    Object? convertProto3JsonValue(Object value, FieldInfo fieldInfo) {
      final fieldType = fieldInfo.type;
      switch (PbFieldType.baseType(fieldType)) {
        case PbFieldType.BOOL_BIT:
          if (value is bool) {
            return value;
          }
          throw context.parseException('Expected bool value', json);
        case PbFieldType.BYTES_BIT:
          if (value is String) {
            Uint8List result;
            try {
              result = base64Decode(value);
            } on FormatException {
              throw context.parseException(
                'Expected bytes encoded as base64 String',
                json,
              );
            }
            return result;
          }
          throw context.parseException(
            'Expected bytes encoded as base64 String',
            value,
          );
        case PbFieldType.STRING_BIT:
          if (value is String) {
            return value;
          }
          throw context.parseException('Expected String value', value);
        case PbFieldType.FLOAT_BIT:
        case PbFieldType.DOUBLE_BIT:
          if (value is double) {
            return value;
          } else if (value is num) {
            return value.toDouble();
          } else if (value is String) {
            return double.tryParse(value) ??
                (throw context.parseException(
                  'Expected String to encode a double',
                  value,
                ));
          }
          throw context.parseException(
            'Expected a double represented as a String or number',
            value,
          );
        case PbFieldType.ENUM_BIT:
          if (value is String) {
            // TODO(sigurdm): Do we want to avoid linear search here? Measure...
            final result =
                permissiveEnums
                    ? fieldInfo.enumValues!.findFirst(
                      (e) => permissiveCompare(e.name, value),
                    )
                    : fieldInfo.enumValues!.findFirst((e) => e.name == value);
            if ((result != null) || ignoreUnknownFields) return result;
            throw context.parseException('Unknown enum value', value);
          } else if (value is int) {
            return fieldInfo.valueOf!(value) ??
                (ignoreUnknownFields
                    ? null
                    : (throw context.parseException(
                      'Unknown enum value',
                      value,
                    )));
          }
          throw context.parseException(
            'Expected enum as a string or integer',
            value,
          );
        case PbFieldType.UINT32_BIT:
        case PbFieldType.FIXED32_BIT:
          int result;
          if (value is int) {
            result = value;
          } else if (value is String) {
            result = _tryParse32BitProto3(value, context);
          } else {
            throw context.parseException(
              'Expected int or stringified int',
              value,
            );
          }
          return _check32BitUnsignedProto3(result, context);
        case PbFieldType.INT32_BIT:
        case PbFieldType.SINT32_BIT:
        case PbFieldType.SFIXED32_BIT:
          int result;
          if (value is int) {
            result = value;
          } else if (value is String) {
            result = _tryParse32BitProto3(value, context);
          } else {
            throw context.parseException(
              'Expected int or stringified int',
              value,
            );
          }
          _check32BitSignedProto3(result, context);
          return result;
        case PbFieldType.UINT64_BIT:
          Int64 result;
          if (value is int) {
            result = Int64(value);
          } else if (value is String) {
            result = _tryParse64BitProto3(json, value, context);
          } else {
            throw context.parseException(
              'Expected int or stringified int',
              value,
            );
          }
          return result;
        case PbFieldType.INT64_BIT:
        case PbFieldType.SINT64_BIT:
        case PbFieldType.FIXED64_BIT:
        case PbFieldType.SFIXED64_BIT:
          if (value is int) return Int64(value);
          if (value is String) {
            Int64 result;
            try {
              result = Int64.parseInt(value);
            } on FormatException {
              throw context.parseException(
                'Expected int or stringified int',
                value,
              );
            }
            return result;
          }
          throw context.parseException(
            'Expected int or stringified int',
            value,
          );
        case PbFieldType.GROUP_BIT:
        case PbFieldType.MESSAGE_BIT:
          final subMessage = fieldInfo.subBuilder!();
          recursionHelper(value, subMessage._fieldSet);
          return subMessage;
        default:
          throw StateError('Unknown type $fieldType');
      }
    }

    Object decodeMapKey(String key, int fieldType) {
      switch (PbFieldType.baseType(fieldType)) {
        case PbFieldType.BOOL_BIT:
          switch (key) {
            case 'true':
              return true;
            case 'false':
              return false;
            default:
              throw context.parseException(
                'Wrong boolean key, should be one of ("true", "false")',
                key,
              );
          }
        case PbFieldType.STRING_BIT:
          return key;
        case PbFieldType.UINT64_BIT:
          // TODO(sigurdm): We do not throw on negative values here.
          // That would probably require going via bignum.
          return _tryParse64BitProto3(json, key, context);
        case PbFieldType.INT64_BIT:
        case PbFieldType.SINT64_BIT:
        case PbFieldType.SFIXED64_BIT:
        case PbFieldType.FIXED64_BIT:
          return _tryParse64BitProto3(json, key, context);
        case PbFieldType.INT32_BIT:
        case PbFieldType.SINT32_BIT:
        case PbFieldType.FIXED32_BIT:
        case PbFieldType.SFIXED32_BIT:
          return _check32BitSignedProto3(
            _tryParse32BitProto3(key, context),
            context,
          );
        case PbFieldType.UINT32_BIT:
          return _check32BitUnsignedProto3(
            _tryParse32BitProto3(key, context),
            context,
          );
        default:
          throw StateError('Not a valid key type $fieldType');
      }
    }

    if (json == null) {
      // `null` represents the default value. Do nothing more.
      return;
    }

    final meta = fieldSet._meta;
    final wellKnownConverter = meta.fromProto3Json;
    if (wellKnownConverter != null) {
      wellKnownConverter(fieldSet._message!, json, typeRegistry, context);
    } else {
      if (json is Map) {
        final byName = meta.byName;

        json.forEach((key, Object? value) {
          if (value == null) {
            return;
          }
          if (key is! String) {
            throw context.parseException('Key was not a String', key);
          }
          context.addMapIndex(key);

          var fieldInfo = byName[key];
          if (fieldInfo == null && supportNamesWithUnderscores) {
            // We don't optimize for field names with underscores, instead do a
            // linear search for the index.
            fieldInfo = byName.values.findFirst(
              (FieldInfo info) => info.protoName == key,
            );
          }
          if (fieldInfo == null) {
            if (ignoreUnknownFields) {
              return;
            } else {
              throw context.parseException('Unknown field name \'$key\'', key);
            }
          }

          if (PbFieldType.isMapField(fieldInfo.type)) {
            if (value is Map) {
              final mapFieldInfo = fieldInfo as MapFieldInfo<dynamic, dynamic>;
              final Map fieldValues = fieldSet._ensureMapField(meta, fieldInfo);
              value.forEach((subKey, subValue) {
                if (subKey is! String) {
                  throw context.parseException('Expected a String key', subKey);
                }
                context.addMapIndex(subKey);
                fieldValues[decodeMapKey(
                  subKey,
                  mapFieldInfo.keyFieldType,
                )] = convertProto3JsonValue(
                  subValue,
                  mapFieldInfo.valueFieldInfo,
                );
                context.popIndex();
              });
            } else {
              throw context.parseException('Expected a map', value);
            }
          } else if (PbFieldType.isRepeated(fieldInfo.type)) {
            if (value is List) {
              final values = fieldSet._ensureRepeatedField(meta, fieldInfo);
              for (var i = 0; i < value.length; i++) {
                final entry = value[i];
                context.addListIndex(i);
                values.add(convertProto3JsonValue(entry, fieldInfo));
                context.popIndex();
              }
            } else {
              throw context.parseException('Expected a list', value);
            }
          } else if (PbFieldType.isGroupOrMessage(fieldInfo.type)) {
            // TODO(sigurdm) consider a cleaner separation between parsing and
            // merging.
            final parsedSubMessage =
                convertProto3JsonValue(value, fieldInfo) as GeneratedMessage;
            final GeneratedMessage? original =
                fieldSet._values[fieldInfo.index!];
            if (original == null) {
              fieldSet._setNonExtensionFieldUnchecked(
                meta,
                fieldInfo,
                parsedSubMessage,
              );
            } else {
              original.mergeFromMessage(parsedSubMessage);
            }
          } else {
            fieldSet._setFieldUnchecked(
              meta,
              fieldInfo,
              convertProto3JsonValue(value, fieldInfo),
            );
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
