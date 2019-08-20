///
//  Generated code. Do not modify.
//  source: test.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package1.pb.dart' as $1;
import 'package2.pb.dart' as $2;

class M extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('M')
    ..a<M>(1, 'm', $pb.PbFieldType.OM, defaultOrMaker: M.getDefault, subBuilder: M.create)
    ..a<$1.M>(2, 'm1', $pb.PbFieldType.OM, defaultOrMaker: $1.M.getDefault, subBuilder: $1.M.create)
    ..a<$2.M>(3, 'm2', $pb.PbFieldType.OM, defaultOrMaker: $2.M.getDefault, subBuilder: $2.M.create)
    ..hasRequiredFields = false
  ;

  M._() : super();
  factory M() => create();
  factory M.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory M.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  M clone() => M()..mergeFromMessage(this);
  M copyWith(void Function(M) updates) => super.copyWith((message) => updates(message as M));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static M create() => M._();
  M createEmptyInstance() => create();
  static $pb.PbList<M> createRepeated() => $pb.PbList<M>();
  static M getDefault() => _defaultInstance ??= create()..freeze();
  static M _defaultInstance;

  M get m => $_getN(0);
  set m(M v) { setField(1, v); }
  $core.bool hasM() => $_has(0);
  void clearM() => clearField(1);

  $1.M get m1 => $_getN(1);
  set m1($1.M v) { setField(2, v); }
  $core.bool hasM1() => $_has(1);
  void clearM1() => clearField(2);

  $2.M get m2 => $_getN(2);
  set m2($2.M v) { setField(3, v); }
  $core.bool hasM2() => $_has(2);
  void clearM2() => clearField(3);
}

