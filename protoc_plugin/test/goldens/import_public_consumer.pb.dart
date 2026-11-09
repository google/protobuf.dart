// This is a generated file - do not edit.
//
// Generated from consumer.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'shim.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

class C extends $pb.GeneratedMessage {
  factory C() => C._();

  C._();

  factory C.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      C()..mergeFromBuffer(data, registry);
  factory C.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      C()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'C',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'c'),
      createEmptyInstance: C.$_createMessage)
    ..aOM<$0.M>(1, _omitFieldNames ? '' : 'm', subBuilder: $0.M.$_createMessage)
    ..aE<$0.E>(2, _omitFieldNames ? '' : 'e', enumValues: $0.E.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  C clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  C copyWith(void Function(C) updates) =>
      super.copyWith((message) => updates(message as C)) as C;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  @$core.Deprecated('Use C() / C.new instead')
  static C create() => C._();
  static $pb.GeneratedMessage $_createMessage() => C._();
  @$core.override
  C createEmptyInstance() => C._();
  @$core.pragma('dart2js:noInline')
  static C getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<C>(C.$_createMessage);
  static C? _defaultInstance;

  @$pb.TagNumber(1)
  $0.M get m => $_getN(0);
  @$pb.TagNumber(1)
  set m($0.M value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasM() => $_has(0);
  @$pb.TagNumber(1)
  void clearM() => $_clearField(1);
  @$pb.TagNumber(1)
  $0.M ensureM() => $_ensure(0);

  @$pb.TagNumber(2)
  $0.E get e => $_getN(1);
  @$pb.TagNumber(2)
  set e($0.E value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasE() => $_has(1);
  @$pb.TagNumber(2)
  void clearE() => $_clearField(2);
}

class SApi {
  final $pb.RpcClient _client;

  SApi(this._client);

  $async.Future<$0.M> get($pb.ClientContext? ctx, $0.M request) =>
      _client.invoke<$0.M>(ctx, 'S', 'Get', request, $0.M());
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
