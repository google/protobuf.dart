// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show base64Decode, base64Encode;

import 'package:fixnum/fixnum.dart' show Int64;

import '../consts.dart';
import '../internal.dart';
import '../utils.dart';

export 'json_vm.dart' if (dart.library.js_interop) 'json_web.dart';

Map<String, dynamic> writeToJsonMap(FieldSet fs) {
  dynamic convertToMap(dynamic fieldValue, int fieldType) {
    final baseType = PbFieldTypeInternal.baseType(fieldType);

    if (PbFieldTypeInternal.isRepeated(fieldType)) {
      final PbList list = fieldValue;
      return List.from(list.map((e) => convertToMap(e, baseType)));
    }

    switch (baseType) {
      case PbFieldTypeInternal.BOOL_BIT:
      case PbFieldTypeInternal.STRING_BIT:
      case PbFieldTypeInternal.INT32_BIT:
      case PbFieldTypeInternal.SINT32_BIT:
      case PbFieldTypeInternal.UINT32_BIT:
      case PbFieldTypeInternal.FIXED32_BIT:
      case PbFieldTypeInternal.SFIXED32_BIT:
        return fieldValue;
      case PbFieldTypeInternal.FLOAT_BIT:
      case PbFieldTypeInternal.DOUBLE_BIT:
        final value = fieldValue as double;
        if (value.isNaN) {
          return nan;
        }
        if (value.isInfinite) {
          return value.isNegative ? negativeInfinity : infinity;
        }
        if (fieldValue.toInt() == fieldValue) {
          return fieldValue.toInt();
        }
        return value;
      case PbFieldTypeInternal.BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        return base64Encode(fieldValue as List<int>);
      case PbFieldTypeInternal.ENUM_BIT:
        final ProtobufEnum enum_ = fieldValue;
        return enum_.value; // assume |value| < 2^52
      case PbFieldTypeInternal.INT64_BIT:
      case PbFieldTypeInternal.SINT64_BIT:
      case PbFieldTypeInternal.SFIXED64_BIT:
        return fieldValue.toString();
      case PbFieldTypeInternal.UINT64_BIT:
      case PbFieldTypeInternal.FIXED64_BIT:
        final Int64 int_ = fieldValue;
        return int_.toStringUnsigned();
      case PbFieldTypeInternal.GROUP_BIT:
      case PbFieldTypeInternal.MESSAGE_BIT:
        final GeneratedMessage msg = fieldValue;
        return msg.writeToJsonMap();
      default:
        throw UnsupportedError('Unknown type $fieldType');
    }
  }

  List writeMap(PbMap fieldValue, MapFieldInfo fi) => List.from(
    fieldValue.entries.map(
      (MapEntry e) => {
        '$mapKeyFieldNumber': convertToMap(e.key, fi.keyFieldType),
        '$mapValueFieldNumber': convertToMap(e.value, fi.valueFieldType),
      },
    ),
  );

  final result = <String, dynamic>{};
  for (final fi in fs.infosSortedByTag) {
    final value = fs.values[fi.index!];
    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }
    if (PbFieldTypeInternal.isMapField(fi.type)) {
      result['${fi.tagNumber}'] = writeMap(
        value,
        fi as MapFieldInfo<dynamic, dynamic>,
      );
      continue;
    }
    result['${fi.tagNumber}'] = convertToMap(value, fi.type);
  }
  final extensions = fs.extensions;
  if (extensions != null) {
    for (final tagNumber in sorted(extensions.tagNumbers)) {
      final value = extensions.values[tagNumber];
      if (value is List && value.isEmpty) {
        continue; // It's repeated or an empty byte array.
      }
      final fi = extensions.getInfoOrNull(tagNumber)!;
      result['$tagNumber'] = convertToMap(value, fi.type);
    }
  }
  final unknownJsonData = fs.unknownJsonData;
  if (unknownJsonData != null) {
    unknownJsonData.forEach((key, value) {
      result[key] = value;
    });
  }
  return result;
}

// Merge fields from a previously decoded JSON object.
// (Called recursively on nested messages.)
void mergeFromJsonMap(
  FieldSet fs,
  Map<String, dynamic> json,
  ExtensionRegistry? registry,
) {
  fs.ensureWritable();
  final keys = json.keys;
  final meta = fs.meta;
  for (final key in keys) {
    var fi = meta.byTagAsString[key];
    if (fi == null) {
      fi = registry?.getExtension(fs.messageName, int.parse(key));
      if (fi == null) {
        (fs.unknownJsonData ??= {})[key] = json[key];
        continue;
      }
    }
    if (fi.isMapField) {
      _appendJsonMap(
        meta,
        fs,
        json[key],
        fi as MapFieldInfo<dynamic, dynamic>,
        registry,
      );
    } else if (fi.isRepeated) {
      _appendJsonList(meta, fs, json[key], fi, registry);
    } else {
      _setJsonField(meta, fs, json[key], fi, registry);
    }
  }
}

void _appendJsonList(
  BuilderInfo meta,
  FieldSet fs,
  List jsonList,
  FieldInfo fi,
  ExtensionRegistry? registry,
) {
  final repeated = fi.ensureRepeatedField(meta, fs);
  // Micro optimization. Using "for in" generates the following and iterator
  // alloc:
  //   for (t1 = J.get$iterator$ax(json), t2 = fi.tagNumber, t3 = fi.type,
  //       t4 = J.getInterceptor$ax(repeated); t1.moveNext$0();)
  for (var i = 0, len = jsonList.length; i < len; i++) {
    final value = jsonList[i];
    var convertedValue = _convertJsonValue(
      meta,
      fs,
      value,
      fi.tagNumber,
      fi.type,
      registry,
    );
    // In the case of an unknown enum value, the converted value may return
    // null. The default enum value should be used in these cases, which is
    // stored in the FieldInfo.
    convertedValue ??= fi.defaultEnumValue;
    repeated.add(convertedValue);
  }
}

void _appendJsonMap(
  BuilderInfo meta,
  FieldSet fs,
  List jsonList,
  MapFieldInfo fi,
  ExtensionRegistry? registry,
) {
  final entryMeta = fi.mapEntryBuilderInfo;
  final map = fi.ensureMapField(meta, fs);
  for (final jsonEntryDynamic in jsonList) {
    final jsonEntry = jsonEntryDynamic as Map<String, dynamic>;
    final entryFieldSet = FieldSet(null, entryMeta);
    final convertedKey = _convertJsonValue(
      entryMeta,
      entryFieldSet,
      jsonEntry['$mapKeyFieldNumber'],
      mapKeyFieldNumber,
      fi.keyFieldType,
      registry,
    );
    var convertedValue = _convertJsonValue(
      entryMeta,
      entryFieldSet,
      jsonEntry['$mapValueFieldNumber'],
      mapValueFieldNumber,
      fi.valueFieldType,
      registry,
    );
    // In the case of an unknown enum value, the converted value may return
    // null. The default enum value should be used in these cases, which is
    // stored in the FieldInfo.
    convertedValue ??= fi.defaultEnumValue;
    map[convertedKey] = convertedValue;
  }
}

void _setJsonField(
  BuilderInfo meta,
  FieldSet fs,
  json,
  FieldInfo fi,
  ExtensionRegistry? registry,
) {
  final value = _convertJsonValue(
    meta,
    fs,
    json,
    fi.tagNumber,
    fi.type,
    registry,
  );
  if (value == null) return;
  // _convertJsonValue throws exception when it fails to do conversion.
  // Therefore we run _validateField for debug builds only to validate
  // correctness of conversion.
  assert(() {
    fs.validateField(fi, value);
    return true;
  }());
  fs.setFieldUnchecked(meta, fi, value);
}

/// Converts [value] from the JSON format to the Dart data type suitable for
/// inserting into the corresponding [GeneratedMessage] field.
///
/// Returns the converted value. Returns `null` if it is an unknown enum value,
/// in which case the caller should figure out the default enum value to return
/// instead.
///
/// Throws [ArgumentError] if it cannot convert the value.
dynamic _convertJsonValue(
  BuilderInfo meta,
  FieldSet fs,
  value,
  int tagNumber,
  int fieldType,
  ExtensionRegistry? registry,
) {
  String expectedType; // for exception message
  switch (PbFieldTypeInternal.baseType(fieldType)) {
    case PbFieldTypeInternal.BOOL_BIT:
      if (value is bool) {
        return value;
      } else if (value is String) {
        if (value == 'true') {
          return true;
        } else if (value == 'false') {
          return false;
        }
      } else if (value is num) {
        if (value == 1) {
          return true;
        } else if (value == 0) {
          return false;
        }
      }
      expectedType = 'bool (true, false, "true", "false", 1, 0)';
      break;
    case PbFieldTypeInternal.BYTES_BIT:
      if (value is String) {
        return base64Decode(value);
      }
      expectedType = 'Base64 String';
      break;
    case PbFieldTypeInternal.STRING_BIT:
      if (value is String) {
        return value;
      }
      expectedType = 'String';
      break;
    case PbFieldTypeInternal.FLOAT_BIT:
    case PbFieldTypeInternal.DOUBLE_BIT:
      // Allow quoted values, although we don't emit them.
      if (value is double) {
        return value;
      } else if (value is num) {
        return value.toDouble();
      } else if (value is String) {
        return double.parse(value);
      }
      expectedType = 'num or stringified num';
      break;
    case PbFieldTypeInternal.ENUM_BIT:
      // Allow quoted values, although we don't emit them.
      if (value is String) {
        value = int.parse(value);
      }
      if (value is int) {
        // The following call will return null if the enum value is unknown.
        // In that case, we want the caller to ignore this value, so we return
        // null from this method as well.
        return meta.decodeEnum(tagNumber, registry, value);
      }
      expectedType = 'int or stringified int';
      break;
    case PbFieldTypeInternal.INT32_BIT:
    case PbFieldTypeInternal.SINT32_BIT:
    case PbFieldTypeInternal.SFIXED32_BIT:
      if (value is int) return value;
      if (value is String) return int.parse(value);
      expectedType = 'int or stringified int';
      break;
    case PbFieldTypeInternal.UINT32_BIT:
    case PbFieldTypeInternal.FIXED32_BIT:
      int? validatedValue;
      if (value is int) validatedValue = value;
      if (value is String) validatedValue = int.parse(value);
      if (validatedValue != null && validatedValue < 0) {
        validatedValue += 2 * (1 << 31);
      }
      if (validatedValue != null) return validatedValue;
      expectedType = 'int or stringified int';
      break;
    case PbFieldTypeInternal.INT64_BIT:
    case PbFieldTypeInternal.SINT64_BIT:
    case PbFieldTypeInternal.UINT64_BIT:
    case PbFieldTypeInternal.FIXED64_BIT:
    case PbFieldTypeInternal.SFIXED64_BIT:
      if (value is int) return Int64(value);
      if (value is String) return Int64.parseInt(value);
      expectedType = 'int or stringified int';
      break;
    case PbFieldTypeInternal.GROUP_BIT:
    case PbFieldTypeInternal.MESSAGE_BIT:
      if (value is Map) {
        final messageValue = value as Map<String, dynamic>;
        final subMessage = meta.makeEmptyMessage(tagNumber, registry);
        mergeFromJsonMap(subMessage.fieldSet, messageValue, registry);
        return subMessage;
      }
      expectedType = 'nested message or group';
      break;
    default:
      throw ArgumentError('Unknown type $fieldType');
  }
  throw ArgumentError('Expected type $expectedType, got $value');
}
