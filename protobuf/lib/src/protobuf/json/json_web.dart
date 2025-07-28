// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
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
extension type _JSON._(JSObject _) implements JSObject {
  @JS('JSON.stringify')
  external static JSString _stringify(JSObject value);

  @JS('JSON.parse')
  external static JSAny? _parse(JSString text);
}

@JS('Number')
extension type _Number._(JSObject _) implements JSObject {
  @JS('Number.isInteger')
  external static bool _isInteger(JSAny value);
}

@JS('Object.keys')
external JSArray<JSString> _objectKeys(JSObject obj);

@JS('Object.prototype')
external JSObject get _objectPrototype;

@JS('Object.getPrototypeOf')
external JSObject _getPrototypeOf(JSAny obj);

extension on JSAny {
  /// Returns this typed as [T] while omitting the `as` cast. For use after an
  /// `isA` check.
  @pragma('dart2js:as:trust')
  @pragma('dart2js:prefer-inline')
  T _as<T extends JSAny>() => this as T;
}

String writeToJsonString(FieldSet fs) {
  final rawJs = _writeToRawJs(fs);
  return _JSON._stringify(rawJs).toDart;
}

JSObject _writeToRawJs(FieldSet fs) {
  JSAny convertToRawJs(dynamic fieldValue, int fieldType) {
    final baseType = PbFieldType.baseType(fieldType);

    if (PbFieldType.isRepeated(fieldType)) {
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
      case PbFieldType.INT32_BIT:
      case PbFieldType.SINT32_BIT:
      case PbFieldType.UINT32_BIT:
      case PbFieldType.FIXED32_BIT:
      case PbFieldType.SFIXED32_BIT:
        final int value = fieldValue;
        return value.toJS;

      case PbFieldType.BOOL_BIT:
        final bool value = fieldValue;
        return value.toJS;

      case PbFieldType.STRING_BIT:
        final String value = fieldValue;
        return value.toJS;

      case PbFieldType.FLOAT_BIT:
      case PbFieldType.DOUBLE_BIT:
        final double value = fieldValue;
        if (value.isNaN) {
          return nan.toJS;
        }
        if (value.isInfinite) {
          return value.isNegative ? negativeInfinity.toJS : infinity.toJS;
        }
        if (value.toInt() == value) {
          return value.toInt().toJS;
        }
        return value.toJS;

      case PbFieldType.BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        final List<int> value = fieldValue;
        return base64Encode(value).toJS;

      case PbFieldType.ENUM_BIT:
        final ProtobufEnum enum_ = fieldValue;
        return enum_.value.toJS; // assume |value| < 2^52

      case PbFieldType.INT64_BIT:
      case PbFieldType.SINT64_BIT:
      case PbFieldType.SFIXED64_BIT:
        final Int64 int_ = fieldValue;
        return int_.toString().toJS;

      case PbFieldType.UINT64_BIT:
      case PbFieldType.FIXED64_BIT:
        final Int64 int_ = fieldValue;
        return int_.toStringUnsigned().toJS;

      case PbFieldType.GROUP_BIT:
      case PbFieldType.MESSAGE_BIT:
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
    if (PbFieldType.isMapField(fi.type)) {
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
    parsed = _JSON._parse(json.toJS);
  } catch (e) {
    throw FormatException(e.toString());
  }
  if (parsed == null || !parsed.isA<JSObject>()) {
    throw ArgumentError.value(json, 'json', 'Does not parse to a JSON object.');
  }
  _mergeFromRawJsMap(fs, parsed._as<JSObject>(), registry);
}

void _mergeFromRawJsMap(
  FieldSet fs,
  JSObject json,
  ExtensionRegistry? registry,
) {
  fs.ensureWritable();

  final meta = fs.meta;
  final keys = _objectKeys(json);
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
  switch (PbFieldType.baseType(fieldType)) {
    case PbFieldType.BOOL_BIT:
      if (value.isA<JSBoolean>()) {
        return value._as<JSBoolean>().toDart;
      } else if (value.isA<JSString>()) {
        final dartStr = value._as<JSString>().toDart;
        if (dartStr == 'true') {
          return true;
        } else if (dartStr == 'false') {
          return false;
        }
      } else if (value.isA<JSNumber>()) {
        final dartNum = value._as<JSNumber>().toDartDouble;
        if (dartNum == 1) {
          return true;
        } else if (dartNum == 0) {
          return false;
        }
      }
      expectedType = 'bool (true, false, "true", "false", 1, 0)';
    case PbFieldType.BYTES_BIT:
      if (value.isA<JSString>()) {
        return base64Decode(value._as<JSString>().toDart);
      }
      expectedType = 'Base64 String';
    case PbFieldType.STRING_BIT:
      if (value.isA<JSString>()) {
        return value._as<JSString>().toDart;
      }
      expectedType = 'String';
    case PbFieldType.FLOAT_BIT:
    case PbFieldType.DOUBLE_BIT:
      // Allow quoted values, although we don't emit them.
      if (value.isA<JSNumber>()) {
        final jsNum = value._as<JSNumber>();
        return _Number._isInteger(jsNum) ? jsNum.toDartInt : jsNum.toDartDouble;
      } else if (value.isA<JSString>()) {
        return double.parse(value._as<JSString>().toDart);
      }
      expectedType = 'num or stringified num';
    case PbFieldType.ENUM_BIT:
      // Allow quoted values, although we don't emit them.
      if (value.isA<JSString>()) {
        value = int.parse(value._as<JSString>().toDart).toJS;
      }
      if (_Number._isInteger(value)) {
        // The following call will return null if the enum value is unknown.
        // In that case, we want the caller to ignore this value, so we return
        // null from this method as well.
        return meta.decodeEnum(
          tagNumber,
          registry,
          value._as<JSNumber>().toDartInt,
        );
      }
      expectedType = 'int or stringified int';
    case PbFieldType.INT32_BIT:
    case PbFieldType.SINT32_BIT:
    case PbFieldType.SFIXED32_BIT:
      if (_Number._isInteger(value)) {
        return value._as<JSNumber>().toDartInt;
      }
      if (value.isA<JSString>()) {
        return int.parse(value._as<JSString>().toDart);
      }
      expectedType = 'int or stringified int';
    case PbFieldType.UINT32_BIT:
    case PbFieldType.FIXED32_BIT:
      int? validatedValue;
      if (_Number._isInteger(value)) {
        validatedValue = value._as<JSNumber>().toDartInt;
      }
      if (value.isA<JSString>()) {
        validatedValue = int.parse(value._as<JSString>().toDart);
      }
      if (validatedValue != null && validatedValue < 0) {
        validatedValue += 2 * (1 << 31);
      }
      if (validatedValue != null) return validatedValue;
      expectedType = 'int or stringified int';
    case PbFieldType.INT64_BIT:
    case PbFieldType.SINT64_BIT:
    case PbFieldType.UINT64_BIT:
    case PbFieldType.FIXED64_BIT:
    case PbFieldType.SFIXED64_BIT:
      if (_Number._isInteger(value)) {
        return Int64(value._as<JSNumber>().toDartInt);
      }
      if (value.isA<JSString>()) {
        return Int64.parseInt(value._as<JSString>().toDart);
      }
      expectedType = 'int or stringified int';
    case PbFieldType.GROUP_BIT:
    case PbFieldType.MESSAGE_BIT:
      if (_getPrototypeOf(value).strictEquals(_objectPrototype).toDart) {
        final subMessage = meta.makeEmptyMessage(tagNumber, registry);
        _mergeFromRawJsMap(
          subMessage.fieldSet,
          value._as<JSObject>(),
          registry,
        );
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
