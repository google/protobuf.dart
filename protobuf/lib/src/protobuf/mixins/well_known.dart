import 'package:fixnum/fixnum.dart';

import '../../../protobuf.dart';

abstract class AnyMixin {
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
}

abstract class TimestampMixin {
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
}
