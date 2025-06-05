//
//  Generated code. Do not modify.
//  source: test
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class PhoneType extends $pb.ProtobufEnum {
  static const PhoneType MOBILE =
      PhoneType._(0, _omitEnumNames ? '' : 'MOBILE');
  static const PhoneType HOME = PhoneType._(1, _omitEnumNames ? '' : 'HOME');
  static const PhoneType WORK = PhoneType._(2, _omitEnumNames ? '' : 'WORK');

  static const PhoneType BUSINESS = WORK;

  static const $core.List<PhoneType> values = <PhoneType>[
    MOBILE,
    HOME,
    WORK,
  ];

  static final $core.List<PhoneType?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 2);
  static PhoneType? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const PhoneType._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
