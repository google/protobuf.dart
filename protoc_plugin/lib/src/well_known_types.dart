// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../protoc.dart';

PbMixin? wellKnownMixinForFullName(String qualifiedName) =>
    _wellKnownMixins[qualifiedName];

const _wellKnownImportPath =
    'package:protobuf/src/protobuf/mixins/well_known.dart';

const _wellKnownMixins = {
  'google.protobuf.Any': PbMixin(
    'AnyMixin',
    importFrom: _wellKnownImportPath,
    injectedHelpers: [
      '''
/// Creates a new [Any] encoding [message].
///
/// The [typeUrl] will be [typeUrlPrefix]/`fullName` where `fullName` is
/// the fully qualified name of the type of [message].
static Any pack($protobufImportPrefix.GeneratedMessage message,
{$coreImportPrefix.String typeUrlPrefix = 'type.googleapis.com'}) {
  final result = create();
  $mixinImportPrefix.AnyMixin.packIntoAny(result, message,
      typeUrlPrefix: typeUrlPrefix);
  return result;
}''',
    ],
    wellKnownType: 'any',
  ),
  'google.protobuf.Timestamp': PbMixin(
    'TimestampMixin',
    importFrom: _wellKnownImportPath,
    injectedHelpers: [
      '''
/// Creates a new instance from [dateTime].
///
/// Time zone information will not be preserved.
static Timestamp fromDateTime($coreImportPrefix.DateTime dateTime) {
  final result = create();
  $mixinImportPrefix.TimestampMixin.setFromDateTime(result, dateTime);
  return result;
}''',
    ],
    wellKnownType: 'timestamp',
  ),
  'google.protobuf.Duration': PbMixin(
    'DurationMixin',
    importFrom: _wellKnownImportPath,
    injectedHelpers: [
      '''
/// Converts the [Duration] to [$coreImportPrefix.Duration].
///
/// This is a lossy conversion, as [$coreImportPrefix.Duration] is limited to [int]
/// microseconds and also does not support nanosecond precision.
$coreImportPrefix.Duration toDart() =>
  $coreImportPrefix.Duration(
    seconds: seconds.toInt(),
    microseconds: nanos ~/ 1000,
  );

/// Creates a new instance from [$coreImportPrefix.Duration].
static Duration fromDart($coreImportPrefix.Duration duration) => Duration()
  ..seconds = $fixnumImportPrefix.Int64(duration.inSeconds)
  ..nanos = (duration.inMicroseconds % $coreImportPrefix.Duration.microsecondsPerSecond) * 1000;
''',
    ],
    wellKnownType: 'duration',
  ),
  'google.protobuf.Struct': PbMixin(
    'StructMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'struct',
  ),
  'google.protobuf.Value': PbMixin(
    'ValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'value',
  ),
  'google.protobuf.ListValue': PbMixin(
    'ListValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'listValue',
  ),
  'google.protobuf.DoubleValue': PbMixin(
    'DoubleValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'doubleValue',
  ),
  'google.protobuf.FloatValue': PbMixin(
    'FloatValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'floatValue',
  ),
  'google.protobuf.Int64Value': PbMixin(
    'Int64ValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'int64Value',
  ),
  'google.protobuf.UInt64Value': PbMixin(
    'UInt64ValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'uint64Value',
  ),
  'google.protobuf.Int32Value': PbMixin(
    'Int32ValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'int32Value',
  ),
  'google.protobuf.UInt32Value': PbMixin(
    'UInt32ValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'uint32Value',
  ),
  'google.protobuf.BoolValue': PbMixin(
    'BoolValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'boolValue',
  ),
  'google.protobuf.StringValue': PbMixin(
    'StringValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'stringValue',
  ),
  'google.protobuf.BytesValue': PbMixin(
    'BytesValueMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'bytesValue',
  ),
  'google.protobuf.FieldMask': PbMixin(
    'FieldMaskMixin',
    importFrom: _wellKnownImportPath,
    wellKnownType: 'fieldMask',
  ),
};
