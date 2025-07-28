// This is a generated file - do not edit.
//
// Generated from doc_comments.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// This is an enum.
class A extends $pb.ProtobufEnum {
  /// This is an enum variant.
  static const A A1 = A._(0, _omitEnumNames ? '' : 'A1');

  /// This is another enum variant.
  static const A A2 = A._(1, _omitEnumNames ? '' : 'A2');

  static const $core.List<A> values = <A>[
    A1,
    A2,
  ];

  static final $core.List<A?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 1);
  static A? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const A._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
