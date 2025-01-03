//
//  Generated code. Do not modify.
//  source: plugin.proto
//

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// Sync with code_generator.h.
enum CodeGeneratorResponse_Feature implements $pb.ProtobufEnum {
  FEATURE_NONE(0, _omitEnumNames ? '' : 'FEATURE_NONE'),

  FEATURE_PROTO3_OPTIONAL(1, _omitEnumNames ? '' : 'FEATURE_PROTO3_OPTIONAL'),
  ;

  static final $core.Map<$core.int, CodeGeneratorResponse_Feature> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static CodeGeneratorResponse_Feature? valueOf($core.int value) =>
      _byValue[value];

  @$core.override
  final $core.int value;

  @$core.override
  final $core.String name;

  const CodeGeneratorResponse_Feature(this.value, this.name);

  /// Returns this enum's [name] or the [value] if names are not represented.
  @$core.override
  $core.String toString() => name == '' ? value.toString() : name;
}

const _omitEnumNames = $core.bool.fromEnvironment('protobuf.omit_enum_names');
