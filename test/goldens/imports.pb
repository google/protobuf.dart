///
//  Generated code. Do not modify.
//  source: test.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'package1.pb.dart' as $0;
import 'package2.pb.dart' as $1;

class M extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('M')
    ..a<M>(1, 'm', $pb.PbFieldType.OM, M.getDefault, M.create)
    ..a<$0.M>(2, 'm1', $pb.PbFieldType.OM, $0.M.getDefault, $0.M.create)
    ..a<$1.M>(3, 'm2', $pb.PbFieldType.OM, $1.M.getDefault, $1.M.create)
    ..hasRequiredFields = false
  ;

  M() : super();
  M.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  M.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  M clone() => new M()..mergeFromMessage(this);
  M copyWith(void Function(M) updates) => super.copyWith((message) => updates(message as M));
  $pb.BuilderInfo get info_ => _i;
  static M create() => new M();
  static $pb.PbList<M> createRepeated() => new $pb.PbList<M>();
  static M getDefault() => _defaultInstance ??= create()..freeze();
  static M _defaultInstance;
  static void $checkItem(M v) {
    if (v is! M) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  M get m => $_getN(0);
  set m(M v) { setField(1, v); }
  bool hasM() => $_has(0);
  void clearM() => clearField(1);

  $0.M get m1 => $_getN(1);
  set m1($0.M v) { setField(2, v); }
  bool hasM1() => $_has(1);
  void clearM1() => clearField(2);

  $1.M get m2 => $_getN(2);
  set m2($1.M v) { setField(3, v); }
  bool hasM2() => $_has(2);
  void clearM2() => clearField(3);
}

