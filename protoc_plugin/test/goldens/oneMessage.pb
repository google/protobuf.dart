///
//  Generated code. Do not modify.
//  source: test
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core show bool, Deprecated, double, int, List, Map, override, pragma, String;

import 'package:protobuf/protobuf.dart' as $pb;

class PhoneNumber extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('PhoneNumber')
    ..aQS(1, 'number')
    ..a<$core.int>(2, 'type', $pb.PbFieldType.O3)
    ..a<$core.String>(3, 'name', $pb.PbFieldType.OS, '\$')
  ;

  PhoneNumber._() : super();
  factory PhoneNumber() => create();
  factory PhoneNumber.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromBuffer(i, r);
  factory PhoneNumber.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) => create()..mergeFromJson(i, r);
  PhoneNumber clone() => PhoneNumber()..mergeFromMessage(this);
  PhoneNumber copyWith(void Function(PhoneNumber) updates) => super.copyWith((message) => updates(message as PhoneNumber)) as PhoneNumber;
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static PhoneNumber create() => PhoneNumber._();
  PhoneNumber createEmptyInstance() => create();
  static $pb.PbList<PhoneNumber> createRepeated() => $pb.PbList<PhoneNumber>();
  static PhoneNumber getDefault() => _defaultInstance ??= create()..freeze();
  static PhoneNumber _defaultInstance;

  $core.String get number => $_getS(0, '');
  set number($core.String v) { $_setString(0, v); }
  $core.bool hasNumber() => $_has(0);
  void clearNumber() => clearField(1);

  $core.int get type => $_get(1, 0);
  set type($core.int v) { $_setSignedInt32(1, v); }
  $core.bool hasType() => $_has(1);
  void clearType() => clearField(2);

  $core.String get name => $_getS(2, '\$');
  set name($core.String v) { $_setString(2, v); }
  $core.bool hasName() => $_has(2);
  void clearName() => clearField(3);
}

