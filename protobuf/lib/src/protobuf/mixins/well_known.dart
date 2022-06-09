// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';

import 'package:fixnum/fixnum.dart';
import 'package:jsontool/jsontool.dart';

import '../../../protobuf.dart';
import '../json_parsing_context.dart';

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
    target.typeUrl = '$typeUrlPrefix/${message.info_.qualifiedMessageName}';
  }

  // From google/protobuf/any.proto:
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
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    var any = message as AnyMixin;
    final BuilderInfo? info =
        typeRegistry.lookup(_typeNameFromUrl(any.typeUrl));
    if (info == null) {
      throw ArgumentError(
          'The type of the Any message (${any.typeUrl}) is not in the given typeRegistry.');
    }
    final GeneratedMessage unpacked = info.createEmptyInstance!()
      ..mergeFromBuffer(any.value);
    jsonSink.startObject();
    jsonSink.addKey('@type');
    jsonSink.addString(any.typeUrl);
    if (info.writeToProto3JsonSink == null) {
      unpacked.writeToProto3JsonSink(typeRegistry, jsonSink, newMessage: false);
    } else {
      jsonSink.addKey('value');
      unpacked.writeToProto3JsonSink(typeRegistry, jsonSink, newMessage: true);
    }
    jsonSink.endObject();
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    // TODO: We can avoid allocating JSON objects here by masking the `@type`
    // field in a `JsonReader` type
    Object? json;
    final JsonWriter<Object?> sink = jsonObjectWriter((result) {
      json = result;
    });
    jsonReader.expectAnyValue(sink);

    if (json is! Map<String, dynamic>) {
      throw context.parseException(
          'Expected Any message encoded as {@type,...},', json);
    }

    final Map<String, dynamic> object = json as Map<String, dynamic>;
    final typeUrl = object['@type'];

    if (typeUrl is! String) {
      throw context.parseException('Expected a string', json);
    }

    var any = message as AnyMixin;
    var info = typeRegistry.lookup(_typeNameFromUrl(typeUrl));
    if (info == null) {
      throw context.parseException(
          'Decoding Any of type $typeUrl not in TypeRegistry $typeRegistry',
          json);
    }

    Object? subJson = info.mergeFromProto3JsonReader == null
        // TODO(sigurdm): avoid cloning [object] here.
        ? (Map<String, dynamic>.from(object)..remove('@type'))
        : object['value'];
    // TODO(sigurdm): We lose [context.path].
    var packedMessage = info.createEmptyInstance!()
      ..mergeFromProto3Json(subJson,
          typeRegistry: typeRegistry,
          supportNamesWithUnderscores: context.supportNamesWithUnderscores,
          ignoreUnknownFields: context.ignoreUnknownFields,
          permissiveEnums: context.permissiveEnums);

    any.value = packedMessage.writeToBuffer();
    any.typeUrl = typeUrl;
  }
}

String _typeNameFromUrl(String typeUrl) {
  var index = typeUrl.lastIndexOf('/');
  return index < 0 ? '' : typeUrl.substring(index + 1);
}

abstract class TimestampMixin {
  static final RegExp finalGroupsOfThreeZeroes = RegExp(r'(?:000)*$');

  Int64 get seconds;
  set seconds(Int64 value);

  int get nanos;
  set nanos(int value);

  /// Converts an instance to [DateTime].
  ///
  /// The result is in UTC time zone and has microsecond precision, as
  /// [DateTime] does not support nanosecond precision.
  ///
  /// Use [toLocal] to convert to local time zone, instead of the default UTC.
  DateTime toDateTime({bool toLocal = false}) =>
      DateTime.fromMicrosecondsSinceEpoch(
          seconds.toInt() * Duration.microsecondsPerSecond + nanos ~/ 1000,
          isUtc: !toLocal);

  /// Updates [target] to be the time at [dateTime].
  ///
  /// Time zone information will not be preserved.
  static void setFromDateTime(TimestampMixin target, DateTime dateTime) {
    var micros = dateTime.microsecondsSinceEpoch;
    target.seconds = Int64((micros / Duration.microsecondsPerSecond).floor());
    target.nanos = (micros % Duration.microsecondsPerSecond).toInt() * 1000;
  }

  static String _twoDigits(int n) {
    if (n >= 10) return '$n';
    return '0$n';
  }

  static final DateTime _minTimestamp = DateTime.utc(1);
  static final DateTime _maxTimestamp = DateTime.utc(9999, 13, 31, 23, 59, 59);

  // From google/protobuf/timestamp.proto:
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
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    var timestamp = message as TimestampMixin;
    var dateTime = timestamp.toDateTime();

    if (timestamp.nanos < 0) {
      throw ArgumentError(
          'Timestamp with negative `nanos`: ${timestamp.nanos}');
    }
    if (timestamp.nanos > 999999999) {
      throw ArgumentError(
          'Timestamp with `nanos` out of range: ${timestamp.nanos}');
    }
    if (dateTime.isBefore(_minTimestamp) || dateTime.isAfter(_maxTimestamp)) {
      throw ArgumentError('Timestamp Must be from 0001-01-01T00:00:00Z to '
          '9999-12-31T23:59:59Z inclusive. Was: ${dateTime.toIso8601String()}');
    }

    // Because [DateTime] doesn't have nano-second precision, we cannot use
    // dateTime.toIso8601String().
    var y = '${dateTime.year}'.padLeft(4, '0');
    var m = _twoDigits(dateTime.month);
    var d = _twoDigits(dateTime.day);
    var h = _twoDigits(dateTime.hour);
    var min = _twoDigits(dateTime.minute);
    var sec = _twoDigits(dateTime.second);
    var secFrac = '';
    if (timestamp.nanos > 0) {
      secFrac = '.' +
          timestamp.nanos
              .toString()
              .padLeft(9, '0')
              .replaceFirst(finalGroupsOfThreeZeroes, '');
    }
    jsonSink.addString('$y-$m-${d}T$h:$min:$sec${secFrac}Z');
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    String? str = jsonReader.tryString();
    if (str == null) {
      throw context.parseException(
          'Expected timestamp represented as String', 1); // TODO: Error json
    }

    final String json = str;

    var jsonWithoutFracSec = json;
    var nanos = 0;
    final Match? fracSecsMatch = RegExp(r'\.(\d+)').firstMatch(json);
    if (fracSecsMatch != null) {
      final fracSecs = fracSecsMatch[1]!;
      if (fracSecs.length > 9) {
        throw context.parseException(
            'Timestamp can have at most than 9 decimal digits', json);
      }
      nanos = int.parse(fracSecs.padRight(9, '0'));
      jsonWithoutFracSec =
          json.replaceRange(fracSecsMatch.start, fracSecsMatch.end, '');
    }
    final dateTimeWithoutFractionalSeconds =
        DateTime.tryParse(jsonWithoutFracSec) ??
            (throw context.parseException(
                'Timestamp not well formatted. ', 1)); // TODO: Error json

    final timestamp = message as TimestampMixin;
    setFromDateTime(timestamp, dateTimeWithoutFractionalSeconds);
    timestamp.nanos = nanos;
  }
}

abstract class DurationMixin {
  Int64 get seconds;
  set seconds(Int64 value);

  int get nanos;
  set nanos(int value);

  static final RegExp finalZeroes = RegExp(r'0+$');

  static toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    var duration = message as DurationMixin;
    var secFrac = duration.nanos
        // nanos and seconds should always have the same sign.
        .abs()
        .toString()
        .padLeft(9, '0')
        .replaceFirst(finalZeroes, '');
    var secPart = secFrac == '' ? '' : '.$secFrac';
    jsonSink.addString('${duration.seconds}${secPart}s');
  }

  static final RegExp durationPattern = RegExp(r'(-?\d*)(?:\.(\d*))?s$');

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    var duration = message as DurationMixin;

    String? str = jsonReader.tryString();
    if (str == null) {
      throw context.parseException(
          'Expected a String of the form `<seconds>.<nanos>s`',
          1); // TODO: error json
    }

    String json = str;

    var match = durationPattern.matchAsPrefix(json);
    if (match == null) {
      throw context.parseException(
          'Expected a String of the form `<seconds>.<nanos>s`', json);
    } else {
      var secondsString = match[1]!;
      var seconds =
          secondsString == '' ? Int64.ZERO : Int64.parseInt(secondsString);
      duration.seconds = seconds;
      var nanos = int.parse((match[2] ?? '').padRight(9, '0'));
      duration.nanos = seconds < 0 ? -nanos : nanos;
    }
  }
}

abstract class StructMixin implements GeneratedMessage {
  Map<String, ValueMixin> get fields;
  static const _fieldsFieldTagNumber = 1;

  // From google/protobuf/struct.proto:
  // The JSON representation for `Struct` is JSON object.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    var struct = message as StructMixin;

    jsonSink.startObject();
    for (var entry in struct.fields.entries) {
      jsonSink.addKey(entry.key);
      ValueMixin.toProto3JsonHelper(entry.value, typeRegistry, jsonSink);
    }
    jsonSink.endObject();
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    if (!jsonReader.tryObject()) {
      throw context.parseException(
          'Expected a JSON object literal (map)', 1); // TODO: error json
    }

    // Check for emptiness to avoid setting `.fields` if there are no
    // values.
    String? nextKey = jsonReader.nextKey();
    if (nextKey != null) {
      var fields = (message as StructMixin).fields;
      var valueCreator =
          (message.info_.fieldInfo[_fieldsFieldTagNumber] as MapFieldInfo)
              .valueCreator!;

      while (nextKey != null) {
        final key = nextKey;
        final v = valueCreator() as ValueMixin;
        context.addMapIndex(key);
        ValueMixin.fromProto3JsonHelper(v, jsonReader, typeRegistry, context);
        context.popIndex();
        fields[key] = v;
        nextKey = jsonReader.nextKey();
      }
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

  // From google/protobuf/struct.proto:
  // The JSON representation for `Value` is JSON value
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    var value = message as ValueMixin;
    // This would ideally be a switch, but we cannot import the enum we are
    // switching over.
    if (value.hasNullValue()) {
      jsonSink.addNull();
    } else if (value.hasNumberValue()) {
      jsonSink.addNumber(value.numberValue);
    } else if (value.hasStringValue()) {
      jsonSink.addString(value.stringValue);
    } else if (value.hasBoolValue()) {
      jsonSink.addBool(value.boolValue);
    } else if (value.hasStructValue()) {
      return StructMixin.toProto3JsonHelper(
          value.structValue, typeRegistry, jsonSink);
    } else if (value.hasListValue()) {
      return ListValueMixin.toProto3JsonHelper(
          value.listValue, typeRegistry, jsonSink);
    } else {
      throw ArgumentError('Serializing google.protobuf.Value with no value');
    }
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    final value = message as ValueMixin;

    if (jsonReader.tryNull()) {
      // Rely on the getter retrieving the default to provide an instance.
      value.nullValue = value.nullValue;
      return;
    }

    num? num_ = jsonReader.tryNum();
    if (num_ != null) {
      value.numberValue = num_.toDouble();
      return;
    }

    String? str = jsonReader.tryString();
    if (str != null) {
      value.stringValue = str;
      return;
    }

    bool? bool_ = jsonReader.tryBool();
    if (bool_ != null) {
      value.boolValue = bool_;
      return;
    }

    // Copy the reader first as `StructMixin` will be entering the object.
    // TODO: This should be cheap?
    if (jsonReader.copy().tryObject()) {
      // Clone because the default instance is frozen.
      final structValue = value.structValue.deepCopy();
      StructMixin.fromProto3JsonHelper(
          structValue, jsonReader, typeRegistry, context);
      value.structValue = structValue;
      return;
    }

    if (jsonReader.tryArray()) {
      while (jsonReader.hasNext()) {
        final listValue = value.listValue.deepCopy();
        ListValueMixin.fromProto3JsonHelper(
            listValue, jsonReader, typeRegistry, context);
        value.listValue = listValue;
      }
      jsonReader.endArray();
      return;
    }

    throw context.parseException(
        'Expected a json-value (Map, List, String, number, bool or null)',
        1); // TODO: error json
  }
}

abstract class ListValueMixin implements GeneratedMessage {
  List<ValueMixin> get values;

  // From google/protobuf/struct.proto:
  // The JSON representation for `ListValue` is JSON array.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    final list = message as ListValueMixin;
    jsonSink.startArray();
    for (final value in list.values) {
      ValueMixin.toProto3JsonHelper(value, typeRegistry, jsonSink);
    }
    jsonSink.endArray();
  }

  static const _valueFieldTagNumber = 1;

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    final list = message as ListValueMixin;

    if (!jsonReader.tryArray()) {
      throw context.parseException('Expected a json-List', json);
    }

    var subBuilder = message.info_.subBuilder(_valueFieldTagNumber)!;
    var i = 0;
    while (jsonReader.hasNext()) {
      final v = subBuilder() as ValueMixin;
      context.addListIndex(i);
      ValueMixin.fromProto3JsonHelper(v, jsonReader, typeRegistry, context);
      context.popIndex();
      list.values.add(v);
      i += 1;
    }
  }
}

abstract class FieldMaskMixin {
  List<String> get paths;

  // From google/protobuf/field_mask.proto:
  // # JSON Encoding of Field Masks
  //
  // In JSON, a field mask is encoded as a single string where paths are
  // separated by a comma. Fields name in each path are converted
  // to/from lower-camel naming conventions.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    var fieldMask = message as FieldMaskMixin;
    for (var path in fieldMask.paths) {
      if (path.contains(RegExp('[A-Z]|_[^a-z]'))) {
        throw ArgumentError(
            'Bad fieldmask $path. Does not round-trip to json.');
      }
    }
    jsonSink.addString(fieldMask.paths.map(_toCamelCase).join(','));
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    String? str = jsonReader.tryString();
    if (str == null) {
      throw context.parseException(
          'Expected String formatted as FieldMask', 1); // TODO: error json
    }

    if (str.contains('_')) {
      throw context.parseException('Invalid Character `_` in FieldMask', json);
    }
    if (str == '') {
      // The empty string splits to a single value. So this is a special case.
      return;
    }
    (message as FieldMaskMixin)
        .paths
        .addAll(str.split(',').map(_fromCamelCase));
  }

  static String _toCamelCase(String name) {
    return name.replaceAllMapped(
        RegExp('_([a-z])'), (Match m) => m.group(1)!.toUpperCase());
  }

  static String _fromCamelCase(String name) {
    return name.replaceAllMapped(
        RegExp('[A-Z]'), (Match m) => '_${m.group(0)!.toLowerCase()}');
  }
}

abstract class DoubleValueMixin {
  double get value;
  set value(double value);

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `DoubleValue` is JSON number.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    return jsonSink.addNumber((message as DoubleValueMixin).value);
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    num? num_ = jsonReader.tryNum();
    if (num_ != null) {
      (message as DoubleValueMixin).value = num_.toDouble();
      return;
    }

    String? str = jsonReader.tryString();
    if (str != null) {
      (message as DoubleValueMixin).value = double.tryParse(str) ??
          (throw context.parseException(
              'Expected string to encode a double', 1)); // TODO error json
      return;
    }

    throw context.parseException(
        'Expected a double as a String or number', 1); // TODO: error json
  }
}

abstract class FloatValueMixin {
  double get value;
  set value(double value);

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `FloatValue` is JSON number.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    jsonSink.addNumber((message as FloatValueMixin).value);
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    num? num_ = jsonReader.tryNum();
    if (num_ != null) {
      (message as FloatValueMixin).value = num_.toDouble();
      return;
    }

    String? str = jsonReader.tryString();
    if (str != null) {
      (message as FloatValueMixin).value = double.tryParse(str) ??
          (throw context.parseException(
              'Expected a float as a String or number', 1)); // TODO: error json
      return;
    }

    throw context.parseException(
        'Expected a float as a String or number', 1); // TODO: error json
  }
}

abstract class Int64ValueMixin {
  Int64 get value;
  set value(Int64 value);

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `Int64Value` is JSON string.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    jsonSink.addString((message as Int64ValueMixin).value.toString());
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    num? num_ = jsonReader.tryNum();
    if (num_ != null) {
      if (num_ is int) {
        (message as Int64ValueMixin).value = Int64(num_);
        return;
      }
      throw context.parseException(
          'Expected an integer encoded as a String or number', json);
    }

    String? str = jsonReader.tryString();
    if (str != null) {
      try {
        (message as Int64ValueMixin).value = Int64.parseInt(str);
        return;
      } on FormatException {
        throw context.parseException(
            'Expected string to encode integer', 1); // TODO: error json
      }
    }

    throw context.parseException(
        'Expected an integer encoded as a String or number', json);
  }
}

abstract class UInt64ValueMixin {
  Int64 get value;
  set value(Int64 value);

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `UInt64Value` is JSON string.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    jsonSink.addString((message as UInt64ValueMixin).value.toStringUnsigned());
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    num? num_ = jsonReader.tryNum();
    if (num_ != null) {
      if (num_ is int) {
        (message as UInt64ValueMixin).value = Int64(num_);
        return;
      }
      throw context.parseException(
          'Expected an unsigned integer as a String or integer',
          1); // TODO: error json
    }

    String? str = jsonReader.tryString();
    if (str != null) {
      try {
        (message as UInt64ValueMixin).value = Int64.parseInt(str);
        return;
      } on FormatException {
        throw context.parseException(
            'Expected string to encode unsigned integer',
            1); // TODO: error json
      }
    }

    throw context.parseException(
        'Expected an unsigned integer as a String or integer',
        1); // TODO: error json
  }
}

abstract class Int32ValueMixin {
  int get value;
  set value(int value);

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `Int32Value` is JSON number.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    jsonSink.addNumber((message as Int32ValueMixin).value);
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    num? num_ = jsonReader.tryNum();
    if (num_ != null) {
      if (num_ is int) {
        (message as Int32ValueMixin).value = num_;
        return;
      }
      throw context.parseException(
          'Expected an integer encoded as a String or number',
          1); // TODO: error json
    }

    String? str = jsonReader.tryString();
    if (str != null) {
      (message as Int32ValueMixin).value = int.tryParse(str) ??
          (throw context.parseException(
              'Expected string to encode integer', 1)); // TODO: error json
      return;
    }

    throw context.parseException(
        'Expected an integer encoded as a String or number',
        1); // TODO: error json
  }
}

abstract class UInt32ValueMixin {
  int get value;
  set value(int value);

  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    jsonSink.addNumber((message as UInt32ValueMixin).value);
  }

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `UInt32Value` is JSON number.
  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    num? num_ = jsonReader.tryNum();
    if (num_ != null) {
      if (num_ is int) {
        (message as UInt32ValueMixin).value = num_;
        return;
      }
      throw context.parseException(
          'Expected an unsigned integer as a String or integer',
          1); // TODO: error json
    }

    String? str = jsonReader.tryString();
    if (str != null) {
      (message as UInt32ValueMixin).value = int.tryParse(str) ??
          (throw context.parseException(
              'Expected String to encode an integer', 1)); // TODO: error json
      return;
    }

    throw context.parseException(
        'Expected an unsigned integer as a String or integer',
        1); // TODO: error json
  }
}

abstract class BoolValueMixin {
  bool get value;
  set value(bool value);

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `BoolValue` is JSON `true` and `false`
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    jsonSink.addBool((message as BoolValueMixin).value);
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    bool? b = jsonReader.tryBool();
    if (b != null) {
      (message as BoolValueMixin).value = b;
      return;
    }

    throw context.parseException('Expected a bool', 1); // TODO: error json
  }
}

abstract class StringValueMixin {
  String get value;
  set value(String value);

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `StringValue` is JSON string.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    jsonSink.addString((message as StringValueMixin).value);
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    String? str = jsonReader.tryString();
    if (str != null) {
      (message as StringValueMixin).value = str;
      return;
    }
    throw context.parseException('Expected a String', 1); // TODO: error json
  }
}

abstract class BytesValueMixin {
  List<int> get value;
  set value(List<int> value);

  // From google/protobuf/wrappers.proto:
  // The JSON representation for `BytesValue` is JSON string.
  static void toProto3JsonHelper(
      GeneratedMessage message, TypeRegistry typeRegistry, JsonSink jsonSink) {
    jsonSink.addString(base64.encode((message as BytesValueMixin).value));
  }

  static void fromProto3JsonHelper(
      GeneratedMessage message,
      JsonReader jsonReader,
      TypeRegistry typeRegistry,
      JsonParsingContext context) {
    String? str = jsonReader.tryString();
    if (str != null) {
      try {
        (message as BytesValueMixin).value = base64.decode(str);
        return;
      } on FormatException {
        throw context.parseException(
            'Expected bytes encoded as base64 String', 1); // TODO: error json
      }
    }

    throw context.parseException(
        'Expected bytes encoded as base64 String', 1); // TODO: error json
  }
}
