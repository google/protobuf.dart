//
//  Generated code. Do not modify.
//  source: google/protobuf/compiler/plugin.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Sync with code_generator.h.
class CodeGeneratorResponse_Feature extends $pb.ProtobufEnum {
  static const CodeGeneratorResponse_Feature FEATURE_NONE =
      CodeGeneratorResponse_Feature._(0, _omitEnumNames ? '' : 'FEATURE_NONE');
  static const CodeGeneratorResponse_Feature FEATURE_PROTO3_OPTIONAL =
      CodeGeneratorResponse_Feature._(
          1, _omitEnumNames ? '' : 'FEATURE_PROTO3_OPTIONAL');
  static const CodeGeneratorResponse_Feature FEATURE_SUPPORTS_EDITIONS =
      CodeGeneratorResponse_Feature._(
          2, _omitEnumNames ? '' : 'FEATURE_SUPPORTS_EDITIONS');

  static const $core.List<CodeGeneratorResponse_Feature> values =
      <CodeGeneratorResponse_Feature>[
    FEATURE_NONE,
    FEATURE_PROTO3_OPTIONAL,
    FEATURE_SUPPORTS_EDITIONS,
  ];

  static final $core.List<CodeGeneratorResponse_Feature?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static CodeGeneratorResponse_Feature? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const CodeGeneratorResponse_Feature._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
