///
//  Generated code. Do not modify.
//  source: benchmark.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME
import 'dart:core' show int, dynamic, String, List, Map;
import 'package:protobuf/protobuf.dart' as $pb;

class BenchmarkID extends $pb.ProtobufEnum {
  static const BenchmarkID READ_INT32_FIELDS_JSON = const BenchmarkID._(1, 'READ_INT32_FIELDS_JSON');
  static const BenchmarkID READ_INT32_REPEATED_JSON = const BenchmarkID._(2, 'READ_INT32_REPEATED_JSON');
  static const BenchmarkID READ_INT64_FIELDS_JSON = const BenchmarkID._(3, 'READ_INT64_FIELDS_JSON');
  static const BenchmarkID READ_INT64_REPEATED_JSON = const BenchmarkID._(4, 'READ_INT64_REPEATED_JSON');
  static const BenchmarkID READ_STRING_FIELDS_JSON = const BenchmarkID._(5, 'READ_STRING_FIELDS_JSON');
  static const BenchmarkID READ_STRING_REPEATED_JSON = const BenchmarkID._(6, 'READ_STRING_REPEATED_JSON');
  static const BenchmarkID GET_STRINGS = const BenchmarkID._(20, 'GET_STRINGS');
  static const BenchmarkID SET_STRINGS = const BenchmarkID._(21, 'SET_STRINGS');
  static const BenchmarkID HAS_STRINGS = const BenchmarkID._(22, 'HAS_STRINGS');

  static const List<BenchmarkID> values = const <BenchmarkID> [
    READ_INT32_FIELDS_JSON,
    READ_INT32_REPEATED_JSON,
    READ_INT64_FIELDS_JSON,
    READ_INT64_REPEATED_JSON,
    READ_STRING_FIELDS_JSON,
    READ_STRING_REPEATED_JSON,
    GET_STRINGS,
    SET_STRINGS,
    HAS_STRINGS,
  ];

  static final Map<int, BenchmarkID> _byValue = $pb.ProtobufEnum.initByValue(values);
  static BenchmarkID valueOf(int value) => _byValue[value];
  static void $checkItem(BenchmarkID v) {
    if (v is! BenchmarkID) $pb.checkItemFailed(v, 'BenchmarkID');
  }

  const BenchmarkID._(int v, String n) : super(v, n);
}

class Status extends $pb.ProtobufEnum {
  static const Status RUNNING = const Status._(1, 'RUNNING');
  static const Status DONE = const Status._(2, 'DONE');
  static const Status FAILED = const Status._(3, 'FAILED');

  static const List<Status> values = const <Status> [
    RUNNING,
    DONE,
    FAILED,
  ];

  static final Map<int, Status> _byValue = $pb.ProtobufEnum.initByValue(values);
  static Status valueOf(int value) => _byValue[value];
  static void $checkItem(Status v) {
    if (v is! Status) $pb.checkItemFailed(v, 'Status');
  }

  const Status._(int v, String n) : super(v, n);
}

class OSType extends $pb.ProtobufEnum {
  static const OSType LINUX = const OSType._(1, 'LINUX');
  static const OSType MAC = const OSType._(2, 'MAC');
  static const OSType WINDOWS = const OSType._(3, 'WINDOWS');
  static const OSType ANDROID = const OSType._(4, 'ANDROID');

  static const List<OSType> values = const <OSType> [
    LINUX,
    MAC,
    WINDOWS,
    ANDROID,
  ];

  static final Map<int, OSType> _byValue = $pb.ProtobufEnum.initByValue(values);
  static OSType valueOf(int value) => _byValue[value];
  static void $checkItem(OSType v) {
    if (v is! OSType) $pb.checkItemFailed(v, 'OSType');
  }

  const OSType._(int v, String n) : super(v, n);
}

