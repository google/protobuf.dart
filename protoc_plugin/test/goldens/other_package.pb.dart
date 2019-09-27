///
//  Generated code. Do not modify.
//  source: other_package.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package:abc/a.pb.dart' as $3;

class C extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('C', createEmptyInstance: create)
    ..aOM<$3.A>(1, 'a', subBuilder: $3.A.create)
    ..hasRequiredFields = false
  ;

  C._() : super();
  factory C() => create();
  factory C.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory C.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  C clone() => C()..mergeFromMessage(this);
  C copyWith(void Function(C) updates) => super.copyWith((message) => updates(message as C));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static C create() => C._();
  C createEmptyInstance() => create();
  static $pb.PbList<C> createRepeated() => $pb.PbList<C>();
  @$core.pragma('dart2js:noInline')
  static C getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<C>(create);
  static C _defaultInstance;

  @$pb.TagNumber(1)
  $3.A get a => $_getN(0);
  @$pb.TagNumber(1)
  set a($3.A v) { setField(1, v); }
  @$pb.TagNumber(1)
  $core.bool hasA() => $_has(0);
  @$pb.TagNumber(1)
  void clearA() => clearField(1);
  @$pb.TagNumber(1)
  $3.A ensureA() => $_ensure(0);
}

