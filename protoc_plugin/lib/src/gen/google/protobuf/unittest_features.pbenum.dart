// This is a generated file - do not edit.
//
// Generated from google/protobuf/unittest_features.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class EnumFeature extends $pb.ProtobufEnum {
  static const EnumFeature TEST_ENUM_FEATURE_UNKNOWN =
      EnumFeature._(0, _omitEnumNames ? '' : 'TEST_ENUM_FEATURE_UNKNOWN');
  static const EnumFeature VALUE1 =
      EnumFeature._(1, _omitEnumNames ? '' : 'VALUE1');
  static const EnumFeature VALUE2 =
      EnumFeature._(2, _omitEnumNames ? '' : 'VALUE2');
  static const EnumFeature VALUE3 =
      EnumFeature._(3, _omitEnumNames ? '' : 'VALUE3');
  static const EnumFeature VALUE4 =
      EnumFeature._(4, _omitEnumNames ? '' : 'VALUE4');
  static const EnumFeature VALUE5 =
      EnumFeature._(5, _omitEnumNames ? '' : 'VALUE5');
  static const EnumFeature VALUE6 =
      EnumFeature._(6, _omitEnumNames ? '' : 'VALUE6');
  static const EnumFeature VALUE7 =
      EnumFeature._(7, _omitEnumNames ? '' : 'VALUE7');
  static const EnumFeature VALUE8 =
      EnumFeature._(8, _omitEnumNames ? '' : 'VALUE8');
  static const EnumFeature VALUE9 =
      EnumFeature._(9, _omitEnumNames ? '' : 'VALUE9');
  static const EnumFeature VALUE10 =
      EnumFeature._(10, _omitEnumNames ? '' : 'VALUE10');
  static const EnumFeature VALUE11 =
      EnumFeature._(11, _omitEnumNames ? '' : 'VALUE11');
  static const EnumFeature VALUE12 =
      EnumFeature._(12, _omitEnumNames ? '' : 'VALUE12');
  static const EnumFeature VALUE13 =
      EnumFeature._(13, _omitEnumNames ? '' : 'VALUE13');
  static const EnumFeature VALUE14 =
      EnumFeature._(14, _omitEnumNames ? '' : 'VALUE14');
  static const EnumFeature VALUE15 =
      EnumFeature._(15, _omitEnumNames ? '' : 'VALUE15');

  static const $core.List<EnumFeature> values = <EnumFeature>[
    TEST_ENUM_FEATURE_UNKNOWN,
    VALUE1,
    VALUE2,
    VALUE3,
    VALUE4,
    VALUE5,
    VALUE6,
    VALUE7,
    VALUE8,
    VALUE9,
    VALUE10,
    VALUE11,
    VALUE12,
    VALUE13,
    VALUE14,
    VALUE15,
  ];

  static final $core.List<EnumFeature?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 15);
  static EnumFeature? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const EnumFeature._(super.value, super.name);
}

class ValueLifetimeFeature extends $pb.ProtobufEnum {
  static const ValueLifetimeFeature TEST_VALUE_LIFETIME_UNKNOWN =
      ValueLifetimeFeature._(
          0, _omitEnumNames ? '' : 'TEST_VALUE_LIFETIME_UNKNOWN');
  static const ValueLifetimeFeature VALUE_LIFETIME_INHERITED =
      ValueLifetimeFeature._(
          1, _omitEnumNames ? '' : 'VALUE_LIFETIME_INHERITED');
  static const ValueLifetimeFeature VALUE_LIFETIME_SUPPORT =
      ValueLifetimeFeature._(2, _omitEnumNames ? '' : 'VALUE_LIFETIME_SUPPORT');
  static const ValueLifetimeFeature VALUE_LIFETIME_EMPTY_SUPPORT =
      ValueLifetimeFeature._(
          3, _omitEnumNames ? '' : 'VALUE_LIFETIME_EMPTY_SUPPORT');
  static const ValueLifetimeFeature VALUE_LIFETIME_FUTURE =
      ValueLifetimeFeature._(4, _omitEnumNames ? '' : 'VALUE_LIFETIME_FUTURE');
  static const ValueLifetimeFeature VALUE_LIFETIME_DEPRECATED =
      ValueLifetimeFeature._(
          5, _omitEnumNames ? '' : 'VALUE_LIFETIME_DEPRECATED');
  static const ValueLifetimeFeature VALUE_LIFETIME_REMOVED =
      ValueLifetimeFeature._(6, _omitEnumNames ? '' : 'VALUE_LIFETIME_REMOVED');

  static const $core.List<ValueLifetimeFeature> values = <ValueLifetimeFeature>[
    TEST_VALUE_LIFETIME_UNKNOWN,
    VALUE_LIFETIME_INHERITED,
    VALUE_LIFETIME_SUPPORT,
    VALUE_LIFETIME_EMPTY_SUPPORT,
    VALUE_LIFETIME_FUTURE,
    VALUE_LIFETIME_DEPRECATED,
    VALUE_LIFETIME_REMOVED,
  ];

  static final $core.List<ValueLifetimeFeature?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 6);
  static ValueLifetimeFeature? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ValueLifetimeFeature._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
