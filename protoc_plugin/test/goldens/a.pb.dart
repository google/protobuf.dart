///
//  Generated code. Do not modify.
//  source: a.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class A extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('A', createEmptyInstance: create)
    ..hasRequiredFields = false
  ;

  A._() : super();
  factory A() => create();
  factory A.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory A.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  A clone() => A()..mergeFromMessage(this);
  A copyWith(void Function(A) updates) => super.copyWith((message) => updates(message as A));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static A create() => A._();
  A createEmptyInstance() => create();
  static $pb.PbList<A> createRepeated() => $pb.PbList<A>();
  @$core.pragma('dart2js:noInline')
  static A getDefault() => _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<A>(create);
  static A _defaultInstance;
}

