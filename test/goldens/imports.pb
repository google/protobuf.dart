///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

import 'package1.pb.dart' as $p1;
import 'package2.pb.dart' as $p2;

class M extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('M')
    ..a<M>(1, 'm', PbFieldType.OM, M.getDefault, M.create)
    ..a<$p1.M>(2, 'm1', PbFieldType.OM, $p1.M.getDefault, $p1.M.create)
    ..a<$p2.M>(3, 'm2', PbFieldType.OM, $p2.M.getDefault, $p2.M.create)
    ..hasRequiredFields = false
  ;

  M() : super();
  M.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  M.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  M clone() => new M()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static M create() => new M();
  static PbList<M> createRepeated() => new PbList<M>();
  static M getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyM();
    return _defaultInstance;
  }
  static M _defaultInstance;
  static void $checkItem(M v) {
    if (v is! M) checkItemFailed(v, 'M');
  }

  M get m => $_getN(0);
  set m(M v) { setField(1, v); }
  bool hasM() => $_has(0);
  void clearM() => clearField(1);

  $p1.M get m1 => $_getN(1);
  set m1($p1.M v) { setField(2, v); }
  bool hasM1() => $_has(1);
  void clearM1() => clearField(2);

  $p2.M get m2 => $_getN(2);
  set m2($p2.M v) { setField(3, v); }
  bool hasM2() => $_has(2);
  void clearM2() => clearField(3);
}

class _ReadonlyM extends M with ReadonlyMessageMixin {}

