///
//  Generated code. Do not modify.
//  source: same_package.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'a.pb.dart' as $3;

class B extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('B', createEmptyInstance: create)
    ..aOM<$3.A>(1, 'a', subBuilder: $3.A.create)
    ..hasRequiredFields = false
  ;

  B._() : super();
  factory B() => create();
  factory B.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory B.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  B clone() => B()..mergeFromMessage(this);
  B copyWith(void Function(B) updates) => super.copyWith((message) => updates(message as B));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static B create() => B._();
  B createEmptyInstance() => create();
  static $pb.PbList<B> createRepeated() => $pb.PbList<B>();
  @$core.pragma('dart2js:noInline')
  static B getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<B>(create);
  static B _defaultInstance;

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

