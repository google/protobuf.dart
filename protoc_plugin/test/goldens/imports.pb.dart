//
//  Generated code. Do not modify.
//  source: test.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package1.pb.dart' as $0;
import 'package2.pb.dart' as $1;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class M extends $pb.GeneratedMessage {
  factory M() => create();

  M._();

  factory M.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory M.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo(_omitMessageNames ? '' : 'M', createEmptyInstance: create)
        ..aOM<M>(1, _omitFieldNames ? '' : 'm', subBuilder: M.create)
        ..aOM<$0.M>(2, _omitFieldNames ? '' : 'm1', subBuilder: $0.M.create)
        ..aOM<$1.M>(3, _omitFieldNames ? '' : 'm2', subBuilder: $1.M.create)
        ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  M clone() => M()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  M copyWith(void Function(M) updates) =>
      super.copyWith((message) => updates(message as M)) as M;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static M create() => M._();
  @$core.override
  M createEmptyInstance() => create();
  static $pb.PbList<M> createRepeated() => $pb.PbList<M>();
  @$core.pragma('dart2js:noInline')
  static M getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<M>(create);
  static M? _defaultInstance;

  @$pb.TagNumber(1)
  M get m => $_getN(0);
  @$pb.TagNumber(1)
  set m(M value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasM() => $_has(0);
  @$pb.TagNumber(1)
  void clearM() => $_clearField(1);
  @$pb.TagNumber(1)
  M ensureM() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.M get m1 => $_getN(1);
  @$pb.TagNumber(2)
  set m1($0.M value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasM1() => $_has(1);
  @$pb.TagNumber(2)
  void clearM1() => $_clearField(2);
  @$pb.TagNumber(2)
  $0.M ensureM1() => $_ensure(1);

  @$pb.TagNumber(3)
  $1.M get m2 => $_getN(2);
  @$pb.TagNumber(3)
  set m2($1.M value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasM2() => $_has(2);
  @$pb.TagNumber(3)
  void clearM2() => $_clearField(3);
  @$pb.TagNumber(3)
  $1.M ensureM2() => $_ensure(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
