// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=3.10

part of 'internal.dart';

// Public because this is called from the mixins library.
Object writeToProto3JsonAny(
  FieldSet fs,
  String typeUrl,
  TypeRegistry typeRegistry,
) {
  final result = _writeToProto3Json(fs, typeRegistry);
  final wellKnownType = fs._meta._wellKnownType;
  if (wellKnownType != null) {
    switch (wellKnownType) {
      case WellKnownType.any:
      case WellKnownType.timestamp:
      case WellKnownType.duration:
      case WellKnownType.struct:
      case WellKnownType.value:
      case WellKnownType.listValue:
      case WellKnownType.fieldMask:
      case WellKnownType.doubleValue:
      case WellKnownType.floatValue:
      case WellKnownType.int64Value:
      case WellKnownType.uint64Value:
      case WellKnownType.int32Value:
      case WellKnownType.uint32Value:
      case WellKnownType.boolValue:
      case WellKnownType.stringValue:
      case WellKnownType.bytesValue:
        return {'@type': typeUrl, 'value': result};
    }
  }

  (result as Map<String, dynamic>)['@type'] = typeUrl;
  return result;
}

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
  final wellKnownType = meta._wellKnownType;
  if (wellKnownType != null) {
    switch (wellKnownType) {
      case WellKnownType.any:
        return AnyMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.timestamp:
        return TimestampMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.duration:
        return DurationMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.struct:
        return StructMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.value:
        return ValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.listValue:
        return ListValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.fieldMask:
        return FieldMaskMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.doubleValue:
        return DoubleValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.floatValue:
        return FloatValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.int64Value:
        return Int64ValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.uint64Value:
        return UInt64ValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.int32Value:
        return Int32ValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.uint32Value:
        return UInt32ValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.boolValue:
        return BoolValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.stringValue:
        return StringValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
      case WellKnownType.bytesValue:
        return BytesValueMixin.toProto3JsonHelper(fs._message!, typeRegistry);
    }
    // [WellKnownType] could be used to for messages which have special
    // encodings in other codecs. The set of messages which special encodings in
    // proto3json is handled here, so we intentionally fall through to the
    // default message handling rather than throwing.
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

/// TODO(paulberry): find a better home for this?
extension _FindFirst<E> on Iterable<E> {
  E? findFirst(bool Function(E) test) {
    for (final element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

// Public because this is called from the mixins library.
void mergeFromProto3JsonAny(
  Object? json,
  FieldSet fieldSet,
  TypeRegistry typeRegistry,
  JsonParsingContext context,
) {
  if (json is! Map<String, dynamic>) {
    throw context.parseException('Expected JSON object', json);
  }

  final wellKnownType = fieldSet._meta._wellKnownType;
  if (wellKnownType != null) {
    switch (wellKnownType) {
      case WellKnownType.any:
      case WellKnownType.timestamp:
      case WellKnownType.duration:
      case WellKnownType.struct:
      case WellKnownType.value:
      case WellKnownType.listValue:
      case WellKnownType.fieldMask:
      case WellKnownType.doubleValue:
      case WellKnownType.floatValue:
      case WellKnownType.int64Value:
      case WellKnownType.uint64Value:
      case WellKnownType.int32Value:
      case WellKnownType.uint32Value:
      case WellKnownType.boolValue:
      case WellKnownType.stringValue:
      case WellKnownType.bytesValue:
        final value = json['value'];
        return _mergeFromProto3JsonWithContext(
          value,
          fieldSet,
          typeRegistry,
          context,
        );
    }
  }

  // TODO(sigurdm): avoid cloning [object] here.
  final withoutType = Map<String, dynamic>.from(json)..remove('@type');
  return _mergeFromProto3JsonWithContext(
    withoutType,
    fieldSet,
    typeRegistry,
    context,
  );
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
  final context = JsonParsingContext(
    ignoreUnknownFields,
    supportNamesWithUnderscores,
    permissiveEnums,
  );
  return _mergeFromProto3JsonWithContext(json, fieldSet, typeRegistry, context);
}

/// Merge a JSON object representing a message in proto3 JSON format ([json])
/// to [fieldSet].
void _mergeFromProto3JsonWithContext(
  Object? json,
  FieldSet fieldSet,
  TypeRegistry typeRegistry,
  JsonParsingContext context,
) {
  fieldSet._ensureWritable();

  void recursionHelper(Object? json, FieldSet fieldSet) {
    // Convert a JSON object to proto object. Returns `null` on unknown enum
    // values when [ignoreUnknownFields] is [true].
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
            try {
              return base64Decode(value);
            } on FormatException {
              throw context.parseException(
                'Expected bytes encoded as base64 String',
                json,
              );
            }
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
            final result = context.permissiveEnums
                ? fieldInfo.enumValues!.findFirst(
                    (e) => permissiveCompare(e.name, value),
                  )
                : fieldInfo.enumValues!.findFirst((e) => e.name == value);
            if ((result != null) || context.ignoreUnknownFields) return result;
            throw context.parseException('Unknown enum value', value);
          } else if (value is int) {
            return fieldInfo.valueOf!(value) ??
                (context.ignoreUnknownFields
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
            result = Proto3ParseUtils.tryParse32Bit(value, context);
          } else {
            throw context.parseException(
              'Expected int or stringified int',
              value,
            );
          }
          return Proto3ParseUtils.check32BitUnsigned(result, context);
        case PbFieldType.INT32_BIT:
        case PbFieldType.SINT32_BIT:
        case PbFieldType.SFIXED32_BIT:
          int result;
          if (value is int) {
            result = value;
          } else if (value is String) {
            result = Proto3ParseUtils.tryParse32Bit(value, context);
          } else {
            throw context.parseException(
              'Expected int or stringified int',
              value,
            );
          }
          Proto3ParseUtils.check32BitSigned(result, context);
          return result;
        case PbFieldType.UINT64_BIT:
          Int64 result;
          if (value is int) {
            result = Int64(value);
          } else if (value is String) {
            result = Proto3ParseUtils.tryParse64Bit(json, value, context);
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
            try {
              return Int64.parseInt(value);
            } on FormatException {
              throw context.parseException(
                'Expected int or stringified int',
                value,
              );
            }
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
          return Proto3ParseUtils.tryParse64Bit(json, key, context);
        case PbFieldType.INT64_BIT:
        case PbFieldType.SINT64_BIT:
        case PbFieldType.SFIXED64_BIT:
        case PbFieldType.FIXED64_BIT:
          return Proto3ParseUtils.tryParse64Bit(json, key, context);
        case PbFieldType.INT32_BIT:
        case PbFieldType.SINT32_BIT:
        case PbFieldType.FIXED32_BIT:
        case PbFieldType.SFIXED32_BIT:
          return Proto3ParseUtils.check32BitSigned(
            Proto3ParseUtils.tryParse32Bit(key, context),
            context,
          );
        case PbFieldType.UINT32_BIT:
          return Proto3ParseUtils.check32BitUnsigned(
            Proto3ParseUtils.tryParse32Bit(key, context),
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
    final wellKnownType = meta._wellKnownType;
    if (wellKnownType != null) {
      switch (wellKnownType) {
        case WellKnownType.any:
          AnyMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.timestamp:
          TimestampMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.duration:
          DurationMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.struct:
          StructMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.value:
          ValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.listValue:
          ListValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.fieldMask:
          FieldMaskMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.doubleValue:
          DoubleValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.floatValue:
          FloatValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.int64Value:
          Int64ValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.uint64Value:
          UInt64ValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.int32Value:
          Int32ValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.uint32Value:
          UInt32ValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.boolValue:
          BoolValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.stringValue:
          StringValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
        case WellKnownType.bytesValue:
          BytesValueMixin.fromProto3JsonHelper(
            fieldSet._message!,
            json,
            typeRegistry,
            context,
          );
          return;
      }

      // [WellKnownType] could be used to for messages which have special
      // encodings in other codecs. The set of messages which special encodings
      // in proto3json is handled here, so we intentionally fall through to the
      // default message handling rather than throwing.
    }

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
        if (fieldInfo == null && context.supportNamesWithUnderscores) {
          // We don't optimize for field names with underscores, instead do a
          // linear search for the index.
          fieldInfo = byName.values.findFirst(
            (FieldInfo info) => info.protoName == key,
          );
        }
        if (fieldInfo == null) {
          if (context.ignoreUnknownFields) {
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
              final key = decodeMapKey(subKey, mapFieldInfo.keyFieldType);
              final value = convertProto3JsonValue(
                subValue,
                mapFieldInfo.valueFieldInfo,
              );
              if (value != null) {
                fieldValues[key] = value;
              }
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
              final parsedValue = convertProto3JsonValue(entry, fieldInfo);
              if (parsedValue != null) {
                values.add(parsedValue);
              }
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
          final GeneratedMessage? original = fieldSet._values[fieldInfo.index!];
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
          final parsedValue = convertProto3JsonValue(value, fieldInfo);
          if (parsedValue == null) {
            // Unknown enum
            if (!context.ignoreUnknownFields) {
              throw context.parseException('Unknown enum value', value);
            }
          } else {
            fieldSet._setFieldUnchecked(meta, fieldInfo, parsedValue);
          }
        }
        context.popIndex();
      });
    } else {
      throw context.parseException('Expected JSON object', json);
    }
  }

  recursionHelper(json, fieldSet);
}
