///
//  Generated code. Do not modify.
//  source: benchmark.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

const BenchmarkID$json = const {
  '1': 'BenchmarkID',
  '2': const [
    const {'1': 'READ_INT32_FIELDS_JSON', '2': 1},
    const {'1': 'READ_INT32_REPEATED_JSON', '2': 2},
    const {'1': 'READ_INT64_FIELDS_JSON', '2': 3},
    const {'1': 'READ_INT64_REPEATED_JSON', '2': 4},
    const {'1': 'READ_STRING_FIELDS_JSON', '2': 5},
    const {'1': 'READ_STRING_REPEATED_JSON', '2': 6},
    const {'1': 'GET_STRINGS', '2': 20},
    const {'1': 'SET_STRINGS', '2': 21},
    const {'1': 'HAS_STRINGS', '2': 22},
  ],
};

const Status$json = const {
  '1': 'Status',
  '2': const [
    const {'1': 'RUNNING', '2': 1},
    const {'1': 'DONE', '2': 2},
    const {'1': 'FAILED', '2': 3},
  ],
};

const OSType$json = const {
  '1': 'OSType',
  '2': const [
    const {'1': 'LINUX', '2': 1},
    const {'1': 'MAC', '2': 2},
    const {'1': 'WINDOWS', '2': 3},
    const {'1': 'ANDROID', '2': 4},
  ],
};

const Suite$json = const {
  '1': 'Suite',
  '2': const [
    const {'1': 'requests', '3': 1, '4': 3, '5': 11, '6': '.benchmark.Request', '10': 'requests'},
  ],
};

const Request$json = const {
  '1': 'Request',
  '2': const [
    const {'1': 'id', '3': 1, '4': 1, '5': 14, '6': '.benchmark.BenchmarkID', '10': 'id'},
    const {'1': 'params', '3': 2, '4': 1, '5': 11, '6': '.benchmark.Params', '10': 'params'},
    const {'1': 'samples', '3': 3, '4': 1, '5': 5, '10': 'samples'},
    const {'1': 'duration', '3': 4, '4': 1, '5': 5, '10': 'duration'},
  ],
};

const Params$json = const {
  '1': 'Params',
  '2': const [
    const {'1': 'message_count', '3': 1, '4': 1, '5': 5, '10': 'messageCount'},
    const {'1': 'int32_field_count', '3': 2, '4': 1, '5': 5, '10': 'int32FieldCount'},
    const {'1': 'int32_repeat_count', '3': 3, '4': 1, '5': 5, '10': 'int32RepeatCount'},
    const {'1': 'int64_field_count', '3': 4, '4': 1, '5': 5, '10': 'int64FieldCount'},
    const {'1': 'int64_repeat_count', '3': 5, '4': 1, '5': 5, '10': 'int64RepeatCount'},
    const {'1': 'string_field_count', '3': 6, '4': 1, '5': 5, '10': 'stringFieldCount'},
    const {'1': 'string_repeat_count', '3': 7, '4': 1, '5': 5, '10': 'stringRepeatCount'},
    const {'1': 'string_size', '3': 8, '4': 1, '5': 5, '10': 'stringSize'},
    const {'1': 'string_value', '3': 9, '4': 1, '5': 9, '10': 'stringValue'},
  ],
};

const Report$json = const {
  '1': 'Report',
  '2': const [
    const {'1': 'status', '3': 1, '4': 1, '5': 14, '6': '.benchmark.Status', '10': 'status'},
    const {'1': 'message', '3': 2, '4': 1, '5': 9, '10': 'message'},
    const {'1': 'env', '3': 3, '4': 1, '5': 11, '6': '.benchmark.Env', '10': 'env'},
    const {'1': 'responses', '3': 4, '4': 3, '5': 11, '6': '.benchmark.Response', '10': 'responses'},
  ],
};

const Env$json = const {
  '1': 'Env',
  '2': const [
    const {'1': 'script', '3': 1, '4': 1, '5': 9, '10': 'script'},
    const {'1': 'page', '3': 2, '4': 1, '5': 9, '10': 'page'},
    const {'1': 'platform', '3': 10, '4': 1, '5': 11, '6': '.benchmark.Platform', '10': 'platform'},
    const {'1': 'packages', '3': 11, '4': 1, '5': 11, '6': '.benchmark.Packages', '10': 'packages'},
  ],
};

const Platform$json = const {
  '1': 'Platform',
  '2': const [
    const {'1': 'hostname', '3': 1, '4': 1, '5': 9, '10': 'hostname'},
    const {'1': 'os_type', '3': 2, '4': 1, '5': 14, '6': '.benchmark.OSType', '10': 'osType'},
    const {'1': 'dart_version', '3': 3, '4': 1, '5': 9, '10': 'dartVersion'},
    const {'1': 'user_agent', '3': 10, '4': 1, '5': 9, '10': 'userAgent'},
    const {'1': 'checked_mode', '3': 20, '4': 1, '5': 8, '10': 'checkedMode'},
    const {'1': 'dart_VM', '3': 21, '4': 1, '5': 8, '10': 'dartVM'},
  ],
};

const Packages$json = const {
  '1': 'Packages',
  '2': const [
    const {'1': 'version', '3': 1, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'packages', '3': 2, '4': 3, '5': 11, '6': '.benchmark.PackageVersion', '10': 'packages'},
  ],
};

const PackageVersion$json = const {
  '1': 'PackageVersion',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9, '10': 'name'},
    const {'1': 'source', '3': 2, '4': 1, '5': 9, '10': 'source'},
    const {'1': 'version', '3': 3, '4': 1, '5': 9, '10': 'version'},
    const {'1': 'path', '3': 4, '4': 1, '5': 9, '10': 'path'},
  ],
};

const Response$json = const {
  '1': 'Response',
  '2': const [
    const {'1': 'request', '3': 1, '4': 1, '5': 11, '6': '.benchmark.Request', '10': 'request'},
    const {'1': 'samples', '3': 2, '4': 3, '5': 11, '6': '.benchmark.Sample', '10': 'samples'},
  ],
};

const Sample$json = const {
  '1': 'Sample',
  '2': const [
    const {'1': 'duration', '3': 1, '4': 1, '5': 5, '10': 'duration'},
    const {'1': 'loop_count', '3': 2, '4': 1, '5': 5, '10': 'loopCount'},
    const {'1': 'counts', '3': 3, '4': 1, '5': 11, '6': '.benchmark.Counts', '10': 'counts'},
  ],
};

const Counts$json = const {
  '1': 'Counts',
  '2': const [
    const {'1': 'int32Reads', '3': 1, '4': 1, '5': 5, '10': 'int32Reads'},
    const {'1': 'int64Reads', '3': 2, '4': 1, '5': 5, '10': 'int64Reads'},
    const {'1': 'stringReads', '3': 4, '4': 1, '5': 5, '10': 'stringReads'},
    const {'1': 'stringWrites', '3': 5, '4': 1, '5': 5, '10': 'stringWrites'},
  ],
};

