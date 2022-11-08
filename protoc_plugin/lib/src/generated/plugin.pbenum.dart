///
//  Generated code. Do not modify.
//  source: plugin.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types
// ignore_for_file: constant_identifier_names, directives_ordering
// ignore_for_file: library_prefixes, non_constant_identifier_names
// ignore_for_file: prefer_final_fields, return_of_invalid_type
// ignore_for_file: unnecessary_const, unnecessary_import, unnecessary_this
// ignore_for_file: unused_import, unused_shown_name

// ignore_for_file: undefined_shown_name
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class CodeGeneratorResponse_Feature extends $pb.ProtobufEnum {
  static const CodeGeneratorResponse_Feature FEATURE_NONE =
      CodeGeneratorResponse_Feature._(
          0,
          const $core.bool.fromEnvironment('protobuf.omit_enum_names')
              ? ''
              : 'FEATURE_NONE');
  static const CodeGeneratorResponse_Feature FEATURE_PROTO3_OPTIONAL =
      CodeGeneratorResponse_Feature._(
          1,
          const $core.bool.fromEnvironment('protobuf.omit_enum_names')
              ? ''
              : 'FEATURE_PROTO3_OPTIONAL');

  static const $core.List<CodeGeneratorResponse_Feature> values =
      <CodeGeneratorResponse_Feature>[
    FEATURE_NONE,
    FEATURE_PROTO3_OPTIONAL,
  ];

  static final $core.Map<$core.int, CodeGeneratorResponse_Feature> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static CodeGeneratorResponse_Feature? valueOf($core.int value) =>
      _byValue[value];

  const CodeGeneratorResponse_Feature._($core.int v, $core.String n)
      : super(v, n);
}
