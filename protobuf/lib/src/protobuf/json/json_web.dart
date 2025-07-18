// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show base64Decode, base64Encode;
import 'dart:js_interop';
import 'dart:js_interop_unsafe';

import 'package:fixnum/fixnum.dart' show Int64;

import '../consts.dart';
import '../internal.dart';
import '../utils.dart';

@JS('JSON')
extension type JSON._(JSObject _) implements JSObject {
  external static JSString stringify(JSObject value);
  external static JSAny? parse(JSString text);
}

@JS('Number')
extension type Number._(JSObject _) implements JSObject {
  external static bool isInteger(JSAny value);
}

@JS('Object.keys')
external JSArray<JSString> objectKeys(JSObject obj);

@JS('Object.prototype')
external JSObject get objectPrototype;

@JS('Object.getPrototypeOf')
external JSObject getPrototypeOf(JSAny obj);

extension on JSAny {
  /// Returns this typed as [T] while omitting the `as` cast. For use after an
  /// `isA` check.
  @pragma('dart2js:as:trust')
  @pragma('dart2js:prefer-inline')
  T as<T extends JSAny>() => this as T;
}

String writeToJsonString(FieldSet fs) {
  final rawJs = _writeToRawJs(fs);
  return JSON.stringify(rawJs).toDart;
}

JSObject _writeToRawJs(FieldSet fs) {
  JSAny convertToRawJs(dynamic fieldValue, int fieldType) {
    final baseType = PbFieldTypeInternal.baseType(fieldType);

    if (PbFieldTypeInternal.isRepeated(fieldType)) {
      final PbList list = fieldValue;
      final length = list.length;
      final jsArray = JSArray.withLength(length);
      for (var i = 0; i < length; i++) {
        final entry = list[i];
        jsArray[i] = convertToRawJs(entry, baseType);
      }
      return jsArray;
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
          return nan.toJS;
        }
        if (value.isInfinite) {
          return value.isNegative ? negativeInfinity.toJS : infinity.toJS;
        }
        if (fieldValue.toInt() == fieldValue) {
          return fieldValue.toInt().toJS;
        }
        return value.toJS;
      case PbFieldTypeInternal.BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        return base64Encode(fieldValue as List<int>).toJS;
      case PbFieldTypeInternal.ENUM_BIT:
        final ProtobufEnum enum_ = fieldValue;
        return enum_.value.toJS; // assume |value| < 2^52
      case PbFieldTypeInternal.INT64_BIT:
      case PbFieldTypeInternal.SINT64_BIT:
      case PbFieldTypeInternal.SFIXED64_BIT:
        return fieldValue.toString().toJS;
      case PbFieldTypeInternal.UINT64_BIT:
      case PbFieldTypeInternal.FIXED64_BIT:
        final Int64 int_ = fieldValue;
        return int_.toStringUnsigned().toJS;
      case PbFieldTypeInternal.GROUP_BIT:
      case PbFieldTypeInternal.MESSAGE_BIT:
        final GeneratedMessage msg = fieldValue;
        return _writeToRawJs(msg.fieldSet);
      default:
        throw UnsupportedError('Unknown type $fieldType');
    }
  }

  JSArray writeMap(PbMap fieldValue, MapFieldInfo fi) {
    final length = fieldValue.entries.length;
    final jsArray = JSArray.withLength(length);
    var index = 0;
    for (final entry in fieldValue.entries) {
      final entryJsObj = JSObject();
      entryJsObj.setProperty(
        mapKeyFieldNumber.toJS,
        convertToRawJs(entry.key, fi.keyFieldType),
      );
      entryJsObj.setProperty(
        mapValueFieldNumber.toJS,
        convertToRawJs(entry.value, fi.valueFieldType),
      );
      jsArray[index] = entryJsObj;
      index++;
    }
    return jsArray;
  }

  final result = JSObject();
  for (final fi in fs.infosSortedByTag) {
    final value = fs.values[fi.index!];
    if (value == null || (value is List && value.isEmpty)) {
      continue; // It's missing, repeated, or an empty byte array.
    }
    if (PbFieldTypeInternal.isMapField(fi.type)) {
      result.setProperty(
        fi.tagNumber.toJS,
        writeMap(value, fi as MapFieldInfo<dynamic, dynamic>),
      );
      continue;
    }
    result.setProperty(fi.tagNumber.toJS, convertToRawJs(value, fi.type));
  }
  final extensions = fs.extensions;
  if (extensions != null) {
    for (final tagNumber in sorted(extensions.tagNumbers)) {
      final value = extensions.values[tagNumber];
      if (value is List && value.isEmpty) {
        continue; // It's repeated or an empty byte array.
      }
      final fi = extensions.getInfoOrNull(tagNumber)!;
      result.setProperty(tagNumber.toJS, convertToRawJs(value, fi.type));
    }
  }
  final unknownJsonData = fs.unknownJsonData;
  if (unknownJsonData != null) {
    unknownJsonData.forEach((key, value) {
      result.setProperty(key.toJS, value);
    });
  }
  return result;
}

/// Merge fields from a [json] string.
void mergeFromJsonString(
  FieldSet fs,
  String json,
  ExtensionRegistry? registry,
) {
  final JSAny? parsed;
  try {
    parsed = JSON.parse(json.toJS);
  } catch (e) {
    throw FormatException(e.toString());
  }
  if (parsed == null || !parsed.isA<JSObject>()) {
    throw ArgumentError.value(json, 'json', 'Does not parse to a JSON object.');
  }
  _mergeFromRawJsMap(fs, parsed.as<JSObject>(), registry);
}

void _mergeFromRawJsMap(
  FieldSet fs,
  JSObject json,
  ExtensionRegistry? registry,
) {
  fs.ensureWritable();

  final meta = fs.meta;
  final keys = objectKeys(json);
  final length = keys.length;
  for (var i = 0; i < length; i++) {
    final jsKey = keys[i];
    final key = jsKey.toDart;
    var fi = meta.byTagAsString[key];
    if (fi == null) {
      fi = registry?.getExtension(fs.messageName, int.parse(key));
      if (fi == null) {
        (fs.unknownJsonData ??= {})[key] = json.getProperty<JSAny>(jsKey);
        continue;
      }
    }
    if (fi.isMapField) {
      _appendRawJsMap(
        meta,
        fs,
        json.getProperty<JSArray<JSObject>>(jsKey),
        fi as MapFieldInfo<dynamic, dynamic>,
        registry,
      );
    } else if (fi.isRepeated) {
      _appendRawJsList(
        meta,
        fs,
        json.getProperty<JSArray<JSAny>>(jsKey),
        fi,
        registry,
      );
    } else {
      _setRawJsField(meta, fs, json.getProperty<JSAny>(jsKey), fi, registry);
    }
  }
}

void _appendRawJsList(
  BuilderInfo meta,
  FieldSet fs,
  JSArray<JSAny> jsonList,
  FieldInfo fi,
  ExtensionRegistry? registry,
) {
  final repeated = fi.ensureRepeatedField(meta, fs);
  // Micro optimization. Using "for in" generates the following and iterator
  // alloc:
  //   for (t1 = J.get$iterator$ax(json), t2 = fi.tagNumber, t3 = fi.type,
  //       t4 = J.getInterceptor$ax(repeated); t1.moveNext$0();)
  final length = jsonList.length;
  for (var i = 0; i < length; i++) {
    final value = jsonList[i];
    var convertedValue = _convertRawJsValue(
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

void _appendRawJsMap(
  BuilderInfo meta,
  FieldSet fs,
  JSArray<JSObject> jsonList,
  MapFieldInfo fi,
  ExtensionRegistry? registry,
) {
  final entryMeta = fi.mapEntryBuilderInfo;
  final map = fi.ensureMapField(meta, fs);
  final length = jsonList.length;

  for (var i = 0; i < length; i++) {
    final value = jsonList[i];
    final entryFieldSet = FieldSet(null, entryMeta);

    final convertedKey = _convertRawJsValue(
      entryMeta,
      entryFieldSet,
      value.getProperty<JSAny>(mapKeyFieldNumber.toJS),
      mapKeyFieldNumber,
      fi.keyFieldType,
      registry,
    );
    var convertedValue = _convertRawJsValue(
      entryMeta,
      entryFieldSet,
      value.getProperty<JSAny>(mapValueFieldNumber.toJS),
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

void _setRawJsField(
  BuilderInfo meta,
  FieldSet fs,
  JSAny json,
  FieldInfo fi,
  ExtensionRegistry? registry,
) {
  final value = _convertRawJsValue(
    meta,
    fs,
    json,
    fi.tagNumber,
    fi.type,
    registry,
  );
  if (value == null) return;
  // _convertRawJsValue throws exception when it fails to do conversion.
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
Object? _convertRawJsValue(
  BuilderInfo meta,
  FieldSet fs,
  JSAny value,
  int tagNumber,
  int fieldType,
  ExtensionRegistry? registry,
) {
  String expectedType; // for exception message
  switch (PbFieldTypeInternal.baseType(fieldType)) {
    case PbFieldTypeInternal.BOOL_BIT:
      if (value.isA<JSBoolean>()) {
        return value.as<JSBoolean>().toDart;
      } else if (value.isA<JSString>()) {
        final dartStr = value.as<JSString>().toDart;
        if (dartStr == 'true') {
          return true;
        } else if (dartStr == 'false') {
          return false;
        }
      } else if (value.isA<JSNumber>()) {
        final dartNum = value.as<JSNumber>().toDartDouble;
        if (dartNum == 1) {
          return true;
        } else if (dartNum == 0) {
          return false;
        }
      }
      expectedType = 'bool (true, false, "true", "false", 1, 0)';
    case PbFieldTypeInternal.BYTES_BIT:
      if (value.isA<JSString>()) {
        return base64Decode(value.as<JSString>().toDart);
      }
      expectedType = 'Base64 String';
    case PbFieldTypeInternal.STRING_BIT:
      if (value.isA<JSString>()) {
        return value.as<JSString>().toDart;
      }
      expectedType = 'String';
    case PbFieldTypeInternal.FLOAT_BIT:
    case PbFieldTypeInternal.DOUBLE_BIT:
      // Allow quoted values, although we don't emit them.
      if (value.isA<JSNumber>()) {
        final jsNum = value.as<JSNumber>();
        return Number.isInteger(jsNum) ? jsNum.toDartInt : jsNum.toDartDouble;
      } else if (value.isA<JSString>()) {
        return double.parse(value.as<JSString>().toDart);
      }
      expectedType = 'num or stringified num';
    case PbFieldTypeInternal.ENUM_BIT:
      // Allow quoted values, although we don't emit them.
      if (value.isA<JSString>()) {
        value = int.parse(value.as<JSString>().toDart).toJS;
      }
      if (Number.isInteger(value)) {
        // The following call will return null if the enum value is unknown.
        // In that case, we want the caller to ignore this value, so we return
        // null from this method as well.
        return meta.decodeEnum(
          tagNumber,
          registry,
          value.as<JSNumber>().toDartInt,
        );
      }
      expectedType = 'int or stringified int';
    case PbFieldTypeInternal.INT32_BIT:
    case PbFieldTypeInternal.SINT32_BIT:
    case PbFieldTypeInternal.SFIXED32_BIT:
      if (Number.isInteger(value)) {
        return value.as<JSNumber>().toDartInt;
      }
      if (value.isA<JSString>()) {
        return int.parse(value.as<JSString>().toDart);
      }
      expectedType = 'int or stringified int';
    case PbFieldTypeInternal.UINT32_BIT:
    case PbFieldTypeInternal.FIXED32_BIT:
      int? validatedValue;
      if (Number.isInteger(value)) {
        validatedValue = value.as<JSNumber>().toDartInt;
      }
      if (value.isA<JSString>()) {
        validatedValue = int.parse(value.as<JSString>().toDart);
      }
      if (validatedValue != null && validatedValue < 0) {
        validatedValue += 2 * (1 << 31);
      }
      if (validatedValue != null) return validatedValue;
      expectedType = 'int or stringified int';
    case PbFieldTypeInternal.INT64_BIT:
    case PbFieldTypeInternal.SINT64_BIT:
    case PbFieldTypeInternal.UINT64_BIT:
    case PbFieldTypeInternal.FIXED64_BIT:
    case PbFieldTypeInternal.SFIXED64_BIT:
      if (Number.isInteger(value)) {
        return Int64(value.as<JSNumber>().toDartInt);
      }
      if (value.isA<JSString>()) {
        return Int64.parseInt(value.as<JSString>().toDart);
      }
      expectedType = 'int or stringified int';
    case PbFieldTypeInternal.GROUP_BIT:
    case PbFieldTypeInternal.MESSAGE_BIT:
      if (getPrototypeOf(value).strictEquals(objectPrototype).toDart) {
        final subMessage = meta.makeEmptyMessage(tagNumber, registry);
        _mergeFromRawJsMap(subMessage.fieldSet, value.as<JSObject>(), registry);
        return subMessage;
      }
      expectedType = 'nested message or group';
    default:
      throw ArgumentError(
        'Unknown type $fieldType when decoding a '
        '${meta.qualifiedMessageName} message field with tag $tagNumber.',
      );
  }
  throw ArgumentError(
    'Expected type $expectedType, got $value when decoding a '
    '${meta.qualifiedMessageName} message field with tag $tagNumber.',
  );
}
