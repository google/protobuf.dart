import 'dart:convert';

import 'package:fixnum/fixnum.dart';

import '../../../protobuf.dart';
import '../type_registry.dart';

abstract class AnyMixin implements GeneratedMessage {
  String get typeUrl;
  set typeUrl(String value);
  List<int> get value;
  set value(List<int> value);

  /// Returns `true` if the encoded message matches the type of [instance].
  ///
  /// Can be used with a default instance:
  /// `any.canUnpackInto(Message.getDefault())`
  bool canUnpackInto(GeneratedMessage instance) {
    return canUnpackIntoHelper(instance, typeUrl);
  }

  /// Unpacks the message in [value] into [instance].
  ///
  /// Throws a [InvalidProtocolBufferException] if [typeUrl] does not correspond
  /// to the type of [instance].
  ///
  /// A typical usage would be `any.unpackInto(Message())`.
  ///
  /// Returns [instance].
  T unpackInto<T extends GeneratedMessage>(T instance,
      {ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY}) {
    unpackIntoHelper(value, instance, typeUrl,
        extensionRegistry: extensionRegistry);
    return instance;
  }

  /// Updates [target] to be the packed representation of [message].
  ///
  /// The [typeUrl] will be [typeUrlPrefix]/`fullName` where `fullName` is
  /// the fully qualified name of the type of [message].
  static void packIntoAny(AnyMixin target, GeneratedMessage message,
      {String typeUrlPrefix = 'type.googleapis.com'}) {
    target.value = message.writeToBuffer();
    target.typeUrl = '${typeUrlPrefix}/${message.info_.qualifiedMessageName}';
  }

  // JSON
  // ====
  // The JSON representation of an `Any` value uses the regular
  // representation of the deserialized, embedded message, with an
  // additional field `@type` which contains the type URL. Example:
  //
  //     package google.profile;
  //     message Person {
  //       string first_name = 1;
  //       string last_name = 2;
  //     }
  //
  //     {
  //       "@type": "type.googleapis.com/google.profile.Person",
  //       "firstName": <string>,
  //       "lastName": <string>
  //     }
  //
  // If the embedded message type is well-known and has a custom JSON
  // representation, that representation will be embedded adding a field
  // `value` which holds the custom JSON in addition to the `@type`
  // field. Example (for message [google.protobuf.Duration][]):
  //
  //     {
  //       "@type": "type.googleapis.com/google.protobuf.Duration",
  //       "value": "1.212s"
  //     }
  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    AnyMixin any = message as AnyMixin;
    BuilderInfo info = typeRegistry.lookup(_typeNameFromUrl(any.typeUrl));
    if (info == null)
      throw InvalidProtocolBufferException.anyMessageNotInRegistry(any.typeUrl);
    GeneratedMessage unpacked = info.createEmptyInstance()
      ..mergeFromBuffer(any.value);
    Object proto3Json = unpacked.toProto3Json();
    if (info.toProto3Json == null) {
      Map<String, dynamic> map = proto3Json as Map<String, dynamic>;
      map['@type'] = any.typeUrl;
      return map;
    } else {
      return {'@type': any.typeUrl, 'value': proto3Json};
    }
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is! Map<String, dynamic>) {
      throw FormatException(
          'Expected Any message encoded as {@type,...}, found $json');
    }
    Map<String, dynamic> object = json as Map<String, dynamic>;
    final typeUrl = object['@type'];

    if (typeUrl is String) {
      AnyMixin any = message as AnyMixin;
      BuilderInfo info = typeRegistry.lookup(_typeNameFromUrl(typeUrl));
      if (info == null) {
        throw FormatException(
            'Decoding Any of type ${typeUrl} not in TypeRegistry');
      }

      Object subJson = info.fromProto3Json == null
          // TODO(sigurdm): avoid cloning [object] here.
          ? (Map<String, dynamic>.from(object)..remove('@type'))
          : object['value'];
      GeneratedMessage packedMessage = info.createEmptyInstance()
        ..mergeFromProto3Json(subJson, typeRegistry: typeRegistry);

      any.value = packedMessage.writeToBuffer();
      any.typeUrl = typeUrl;
    } else {
      throw FormatException('Expected a string');
    }
  }
}

String _typeNameFromUrl(String typeUrl) {
  int index = typeUrl.lastIndexOf('/');
  return index == -1 ? '' : typeUrl.substring(index + 1);
}

abstract class TimestampMixin {
  static final RegExp finalGroupsOfThreeZeroes = RegExp('(000)*\$');

  Int64 get seconds;
  set seconds(Int64 value);

  int get nanos;
  set nanos(int value);

  /// Converts an instance to [DateTime].
  ///
  /// The result is in UTC time zone and has microsecond precision, as
  /// [DateTime] does not support nanosecond precision.
  DateTime toDateTime() => new DateTime.fromMicrosecondsSinceEpoch(
      seconds.toInt() * Duration.microsecondsPerSecond + nanos ~/ 1000,
      isUtc: true);

  /// Updates [target] to be the time at [datetime].
  ///
  /// Time zone information will not be preserved.
  static void setFromDateTime(TimestampMixin target, DateTime dateTime) {
    int micros = dateTime.microsecondsSinceEpoch;
    target.seconds = Int64(micros ~/ Duration.microsecondsPerSecond);
    target.nanos = (micros % Duration.microsecondsPerSecond).toInt() * 1000;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return "${n}";
    return "0${n}";
  }

  static final DateTime _minTimestamp = DateTime.utc(1);
  static final DateTime _maxTimestamp = DateTime.utc(9999, 13, 31, 23, 59, 59);

  // # JSON Mapping
  //
  // In JSON format, the Timestamp type is encoded as a string in the
  // [RFC 3339](https://www.ietf.org/rfc/rfc3339.txt) format. That is, the
  // format is "{year}-{month}-{day}T{hour}:{min}:{sec}[.{frac_sec}]Z"
  // where {year} is always expressed using four digits while {month}, {day},
  // {hour}, {min}, and {sec} are zero-padded to two digits each. The fractional
  // seconds, which can go up to 9 digits (i.e. up to 1 nanosecond resolution),
  // are optional. The "Z" suffix indicates the timezone ("UTC"); the timezone
  // is required. A proto3 JSON serializer should always use UTC (as indicated by
  // "Z") when printing the Timestamp type and a proto3 JSON parser should be
  // able to accept both UTC and other timezones (as indicated by an offset).
  //
  // For example, "2017-01-15T01:30:15.01Z" encodes 15.01 seconds past
  // 01:30 UTC on January 15, 2017.
  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    TimestampMixin timestamp = message as TimestampMixin;
    DateTime dateTime = timestamp.toDateTime();

    if (timestamp.nanos < 0) {
      throw FormatException(
          'Timestamp with negative `nanos`: ${timestamp.nanos}');
    }
    if (timestamp.nanos > 999999999) {
      throw FormatException(
          'Timestamp with `nanos` out of range: ${timestamp.nanos}');
    }
    if (dateTime.isBefore(_minTimestamp) || dateTime.isAfter(_maxTimestamp)) {
      throw FormatException('Timestamp Must be from 0001-01-01T00:00:00Z to '
          '9999-12-31T23:59:59Z inclusive. Was: ${dateTime.toIso8601String()}');
    }

    // Because [DateTime] doesn't have nano-second precision, we cannot use
    // dateTime.toIso8601String().
    String y = '${dateTime.year}'.padLeft(4, '0');
    String m = _twoDigits(dateTime.month);
    String d = _twoDigits(dateTime.day);
    String h = _twoDigits(dateTime.hour);
    String min = _twoDigits(dateTime.minute);
    String sec = _twoDigits(dateTime.second);
    String secFrac = timestamp.nanos
        .toString()
        .padLeft(9, '0')
        .replaceFirst(finalGroupsOfThreeZeroes, '');
    if (secFrac != '') secFrac = '.$secFrac';
    return "$y-$m-${d}T$h:$min:$sec${secFrac}Z";
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is String) {
      Match fracSecsMatch = RegExp(r'\.(\d*)').firstMatch(json);
      String fracSecs = fracSecsMatch?.group(1) ?? '0';
      if (fracSecs.length > 9) {
        throw FormatException('Timestamp with more than 9 decimal digits '
            'does not fit into nanoseconds');
      }
      int nanos = int.tryParse(fracSecs.padRight(9, '0')) ?? 0;
      DateTime dateTimeWithoutFractionalSeconds;

      String jsonWithoutFracSec = fracSecsMatch == null
          ? json
          : json.replaceRange(fracSecsMatch.start, fracSecsMatch.end, '');
      dateTimeWithoutFractionalSeconds = DateTime.parse(jsonWithoutFracSec);

      TimestampMixin timestamp = message as TimestampMixin;
      setFromDateTime(timestamp, dateTimeWithoutFractionalSeconds);
      timestamp.nanos = nanos;
    } else {
      throw FormatException(
          'Expected timestamp represented as String, found: $json');
    }
  }
}

abstract class DurationMixin {
  Int64 get seconds;
  set seconds(Int64 value);

  int get nanos;
  set nanos(int value);

  static final RegExp finalZeroes = RegExp('(0)*\$');

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    DurationMixin duration = message as DurationMixin;
    String secFrac = duration.nanos
        // nanos and seconds should always have the same sign.
        .abs()
        .toString()
        .padLeft(9, '0')
        .replaceFirst(finalZeroes, '');
    String secPart = secFrac == '' ? '' : '.$secFrac';
    return "${duration.seconds}${secPart}s";
  }

  static final RegExp durationPattern = RegExp(r'(-?\d*)(?:\.(\d*))?s$');

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    DurationMixin duration = message as DurationMixin;
    if (json is String) {
      Match match = durationPattern.matchAsPrefix(json);
      if (match == null) {
        throw FormatException(
            'Expected a String of the form `<seconds>.<nanos>s` but found $json');
      } else {
        String secondsString = match.group(1);
        Int64 seconds =
            secondsString == '' ? Int64.ZERO : Int64.parseInt(secondsString);
        duration.seconds = seconds;
        int nanos = int.parse((match.group(2) ?? '').padRight(9, '0'));
        duration.nanos = seconds < 0 ? -nanos : nanos;
      }
    } else {
      throw FormatException(
          'Expected a String of the form `<seconds>.<nanos>s`, but found $json');
    }
  }
}

abstract class StructMixin implements GeneratedMessage {
  Map<String, ValueMixin> get fields;
  static const _fieldsFieldTagNumber = 1;

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    StructMixin struct = message as StructMixin;
    return struct.fields.map((key, value) =>
        MapEntry(key, ValueMixin.toProto3JsonHelper(value, typeRegistry)));
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is Map) {
      // Check for emptiness to avoid setting `.fields` if there are no
      // values.
      if (json.isNotEmpty) {
        Map<String, ValueMixin> fields = (message as StructMixin).fields;
        GeneratedMessage Function() valueCreator =
            (message.info_.fieldInfo[_fieldsFieldTagNumber] as MapFieldInfo)
                .valueCreator;

        json.forEach((key, value) {
          if (key is! String) {
            throw FormatException('Expected String key. Found $json.');
          }
          ValueMixin v = valueCreator();
          ValueMixin.fromProto3JsonHelper(v, value, typeRegistry);
          fields[key] = v;
        });
      }
    } else {
      throw FormatException(
          'Expected a JSON object literal (map). Found $json.');
    }
  }
}

abstract class ValueMixin implements GeneratedMessage {
  bool hasNullValue();
  ProtobufEnum get nullValue;
  set nullValue(covariant ProtobufEnum value);
  bool hasNumberValue();
  double get numberValue;
  set numberValue(double v);
  bool hasStringValue();
  String get stringValue;
  set stringValue(String v);
  bool hasBoolValue();
  bool get boolValue;
  set boolValue(bool v);
  bool hasStructValue();
  StructMixin get structValue;
  set structValue(covariant StructMixin v);
  bool hasListValue();
  ListValueMixin get listValue;
  set listValue(covariant ListValueMixin v);

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    ValueMixin value = message as ValueMixin;
    // This would ideally be a switch, but we cannot import the enum we are
    // switching over.
    if (value.hasNullValue()) {
      return null;
    } else if (value.hasNumberValue()) {
      return value.numberValue;
    } else if (value.hasStringValue()) {
      return value.stringValue;
    } else if (value.hasBoolValue()) {
      return value.boolValue;
    } else if (value.hasStructValue()) {
      return StructMixin.toProto3JsonHelper(value.structValue, typeRegistry);
    } else if (value.hasListValue()) {
      return ListValueMixin.toProto3JsonHelper(value.listValue, typeRegistry);
    } else {
      throw InvalidProtocolBufferException.noValueSet();
    }
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    ValueMixin value = message as ValueMixin;
    if (json == null) {
      // Rely on the getter retrieving the default to provide an instance.
      value.nullValue = value.nullValue;
    } else if (json is num) {
      value.numberValue = json.toDouble();
    } else if (json is String) {
      value.stringValue = json;
    } else if (json is bool) {
      value.boolValue = json;
    } else if (json is Map) {
      // Clone to get a non-frozen instance.
      StructMixin structValue = value.structValue.clone();
      StructMixin.fromProto3JsonHelper(structValue, json, typeRegistry);
      value.structValue = structValue;
    } else if (json is List) {
      // Clone to get a non-frozen instance.
      ListValueMixin listValue = value.listValue.clone();
      ListValueMixin.fromProto3JsonHelper(listValue, json, typeRegistry);
      value.listValue = listValue;
    } else {
      throw FormatException(
          'Expected a json-value (Map, List, String, number, bool or null). Found $json');
    }
  }
}

abstract class ListValueMixin implements GeneratedMessage {
  List<ValueMixin> get values;
  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    ListValueMixin list = message as ListValueMixin;
    return list.values
        .map((value) => ValueMixin.toProto3JsonHelper(value, typeRegistry))
        .toList();
  }

  static const _valueFieldTagNumber = 1;

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    ListValueMixin list = message as ListValueMixin;
    if (json is List) {
      CreateBuilderFunc subBuilder =
          message.info_.subBuilder(_valueFieldTagNumber);
      for (final element in json) {
        ValueMixin v = subBuilder();
        ValueMixin.fromProto3JsonHelper(v, element, typeRegistry);
        list.values.add(v);
      }
    } else {
      throw FormatException('Expected a json-List. Found: $json');
    }
  }
}

abstract class FieldMaskMixin {
  List<String> get paths;
  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    FieldMaskMixin fieldMask = message as FieldMaskMixin;
    for (String path in fieldMask.paths) {
      if (path.indexOf(RegExp('[A-Z]|_[^a-z]')) != -1) {
        throw FormatException(
            'Bad fieldmask $path. Does not round-trip to json.');
      }
    }
    return fieldMask.paths.map(_toCamelCase).join(',');
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is String) {
      if (json.indexOf('_') != -1) {
        throw FormatException('Invalid Character `_` in FieldMask');
      }
      if (json == '') {
        // The empty string splits to a single value. So this is a special case.
        return;
      }
      (message as FieldMaskMixin).paths
        ..addAll(json.split(',').map(_fromCamelCase));
    } else {
      throw FormatException(
          'Expected String formatted as FieldMask, found $json');
    }
  }

  static String _toCamelCase(String name) {
    return name.replaceAllMapped(
        RegExp('_([a-z])'), (Match m) => '${m.group(1).toUpperCase()}');
  }

  static String _fromCamelCase(String name) {
    return name.replaceAllMapped(
        RegExp('[A-Z]'), (Match m) => '_${m.group(0).toLowerCase()}');
  }
}

abstract class DoubleValueMixin {
  double get value;
  set value(double value);

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return (message as DoubleValueMixin).value;
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is num) {
      (message as DoubleValueMixin).value = json.toDouble();
    } else if (json is String) {
      (message as DoubleValueMixin).value = double.parse(json);
    } else {
      throw FormatException(
          'Expected a double as a String or number, found $json');
    }
  }
}

abstract class FloatValueMixin {
  double get value;
  set value(double value);

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return (message as FloatValueMixin).value;
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is num) {
      (message as FloatValueMixin).value = json.toDouble();
    } else if (json is String) {
      (message as FloatValueMixin).value = double.parse(json);
    } else {
      throw FormatException(
          'Expected a float as a String or number, found $json');
    }
  }
}

abstract class Int64ValueMixin {
  Int64 get value;
  set value(Int64 value);

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return (message as Int64ValueMixin).value.toString();
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is int) {
      (message as Int64ValueMixin).value = Int64(json);
    } else if (json is String) {
      (message as Int64ValueMixin).value = Int64.parseInt(json);
    } else {
      throw FormatException(
          'Expected an integer as a String or integer, found $json');
    }
  }
}

abstract class UInt64ValueMixin {
  Int64 get value;
  set value(Int64 value);
  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return (message as UInt64ValueMixin).value.toStringUnsigned();
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is int) {
      (message as UInt64ValueMixin).value = Int64(json);
    } else if (json is String) {
      (message as UInt64ValueMixin).value = Int64.parseInt(json);
    } else {
      throw FormatException(
          'Expected an unsigned integer as a String or integer, found $json');
    }
  }
}

abstract class Int32ValueMixin {
  int get value;
  set value(int value);
  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return (message as Int32ValueMixin).value;
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is int) {
      (message as Int32ValueMixin).value = json;
    } else if (json is String) {
      (message as Int32ValueMixin).value = int.parse(json);
    } else {
      throw FormatException(
          'Expected an integer as a String or integer, found $json');
    }
  }
}

abstract class UInt32ValueMixin {
  int get value;
  set value(int value);
  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return (message as UInt32ValueMixin).value;
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is int) {
      (message as UInt32ValueMixin).value = json;
    } else if (json is String) {
      (message as UInt32ValueMixin).value = int.parse(json);
    } else {
      throw FormatException(
          'Expected an unsigned integer as a String or integer, found $json');
    }
  }
}

abstract class BoolValueMixin {
  bool get value;
  set value(bool value);

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return (message as BoolValueMixin).value;
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is bool) {
      (message as BoolValueMixin).value = json;
    } else {
      throw FormatException('Expected a bool, found $json');
    }
  }
}

abstract class StringValueMixin {
  String get value;
  set value(String value);

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return (message as StringValueMixin).value;
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is String) {
      (message as StringValueMixin).value = json;
    } else {
      throw FormatException('Expected a String, found $json');
    }
  }
}

abstract class BytesValueMixin {
  List<int> get value;
  set value(List<int> value);

  static Object toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry) {
    return base64.encode((message as BytesValueMixin).value);
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message, Object json, TypeRegistry typeRegistry) {
    if (json is String) {
      (message as BytesValueMixin).value = base64.decode(json);
    } else {
      throw FormatException(
          'Expected bytes encoded as base64 String. Found $json');
    }
  }
}
