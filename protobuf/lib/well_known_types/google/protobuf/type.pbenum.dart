// This is a generated file - do not edit.
//
// Generated from google/protobuf/type.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// The syntax in which a protocol buffer element is defined.
class Syntax extends $pb.ProtobufEnum {
  /// Syntax `proto2`.
  static const Syntax SYNTAX_PROTO2 =
      Syntax._(0, _omitEnumNames ? '' : 'SYNTAX_PROTO2');

  /// Syntax `proto3`.
  static const Syntax SYNTAX_PROTO3 =
      Syntax._(1, _omitEnumNames ? '' : 'SYNTAX_PROTO3');

  /// Syntax `editions`.
  static const Syntax SYNTAX_EDITIONS =
      Syntax._(2, _omitEnumNames ? '' : 'SYNTAX_EDITIONS');

  static const $core.List<Syntax> values = <Syntax>[
    SYNTAX_PROTO2,
    SYNTAX_PROTO3,
    SYNTAX_EDITIONS,
  ];

  static final $core.List<Syntax?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static Syntax? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Syntax._(super.value, super.name);
}

/// Basic field types.
class Field_Kind extends $pb.ProtobufEnum {
  /// Field type unknown.
  static const Field_Kind TYPE_UNKNOWN =
      Field_Kind._(0, _omitEnumNames ? '' : 'TYPE_UNKNOWN');

  /// Field type double.
  static const Field_Kind TYPE_DOUBLE =
      Field_Kind._(1, _omitEnumNames ? '' : 'TYPE_DOUBLE');

  /// Field type float.
  static const Field_Kind TYPE_FLOAT =
      Field_Kind._(2, _omitEnumNames ? '' : 'TYPE_FLOAT');

  /// Field type int64.
  static const Field_Kind TYPE_INT64 =
      Field_Kind._(3, _omitEnumNames ? '' : 'TYPE_INT64');

  /// Field type uint64.
  static const Field_Kind TYPE_UINT64 =
      Field_Kind._(4, _omitEnumNames ? '' : 'TYPE_UINT64');

  /// Field type int32.
  static const Field_Kind TYPE_INT32 =
      Field_Kind._(5, _omitEnumNames ? '' : 'TYPE_INT32');

  /// Field type fixed64.
  static const Field_Kind TYPE_FIXED64 =
      Field_Kind._(6, _omitEnumNames ? '' : 'TYPE_FIXED64');

  /// Field type fixed32.
  static const Field_Kind TYPE_FIXED32 =
      Field_Kind._(7, _omitEnumNames ? '' : 'TYPE_FIXED32');

  /// Field type bool.
  static const Field_Kind TYPE_BOOL =
      Field_Kind._(8, _omitEnumNames ? '' : 'TYPE_BOOL');

  /// Field type string.
  static const Field_Kind TYPE_STRING =
      Field_Kind._(9, _omitEnumNames ? '' : 'TYPE_STRING');

  /// Field type group. Proto2 syntax only, and deprecated.
  static const Field_Kind TYPE_GROUP =
      Field_Kind._(10, _omitEnumNames ? '' : 'TYPE_GROUP');

  /// Field type message.
  static const Field_Kind TYPE_MESSAGE =
      Field_Kind._(11, _omitEnumNames ? '' : 'TYPE_MESSAGE');

  /// Field type bytes.
  static const Field_Kind TYPE_BYTES =
      Field_Kind._(12, _omitEnumNames ? '' : 'TYPE_BYTES');

  /// Field type uint32.
  static const Field_Kind TYPE_UINT32 =
      Field_Kind._(13, _omitEnumNames ? '' : 'TYPE_UINT32');

  /// Field type enum.
  static const Field_Kind TYPE_ENUM =
      Field_Kind._(14, _omitEnumNames ? '' : 'TYPE_ENUM');

  /// Field type sfixed32.
  static const Field_Kind TYPE_SFIXED32 =
      Field_Kind._(15, _omitEnumNames ? '' : 'TYPE_SFIXED32');

  /// Field type sfixed64.
  static const Field_Kind TYPE_SFIXED64 =
      Field_Kind._(16, _omitEnumNames ? '' : 'TYPE_SFIXED64');

  /// Field type sint32.
  static const Field_Kind TYPE_SINT32 =
      Field_Kind._(17, _omitEnumNames ? '' : 'TYPE_SINT32');

  /// Field type sint64.
  static const Field_Kind TYPE_SINT64 =
      Field_Kind._(18, _omitEnumNames ? '' : 'TYPE_SINT64');

  static const $core.List<Field_Kind> values = <Field_Kind>[
    TYPE_UNKNOWN,
    TYPE_DOUBLE,
    TYPE_FLOAT,
    TYPE_INT64,
    TYPE_UINT64,
    TYPE_INT32,
    TYPE_FIXED64,
    TYPE_FIXED32,
    TYPE_BOOL,
    TYPE_STRING,
    TYPE_GROUP,
    TYPE_MESSAGE,
    TYPE_BYTES,
    TYPE_UINT32,
    TYPE_ENUM,
    TYPE_SFIXED32,
    TYPE_SFIXED64,
    TYPE_SINT32,
    TYPE_SINT64,
  ];

  static final $core.List<Field_Kind?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 18);
  static Field_Kind? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Field_Kind._(super.value, super.name);
}

/// Whether a field is optional, required, or repeated.
class Field_Cardinality extends $pb.ProtobufEnum {
  /// For fields with unknown cardinality.
  static const Field_Cardinality CARDINALITY_UNKNOWN =
      Field_Cardinality._(0, _omitEnumNames ? '' : 'CARDINALITY_UNKNOWN');

  /// For optional fields.
  static const Field_Cardinality CARDINALITY_OPTIONAL =
      Field_Cardinality._(1, _omitEnumNames ? '' : 'CARDINALITY_OPTIONAL');

  /// For required fields. Proto2 syntax only.
  static const Field_Cardinality CARDINALITY_REQUIRED =
      Field_Cardinality._(2, _omitEnumNames ? '' : 'CARDINALITY_REQUIRED');

  /// For repeated fields.
  static const Field_Cardinality CARDINALITY_REPEATED =
      Field_Cardinality._(3, _omitEnumNames ? '' : 'CARDINALITY_REPEATED');

  static const $core.List<Field_Cardinality> values = <Field_Cardinality>[
    CARDINALITY_UNKNOWN,
    CARDINALITY_OPTIONAL,
    CARDINALITY_REQUIRED,
    CARDINALITY_REPEATED,
  ];

  static final $core.List<Field_Cardinality?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 3);
  static Field_Cardinality? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const Field_Cardinality._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
