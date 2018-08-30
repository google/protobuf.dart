///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

class PhoneNumber extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('PhoneNumber')
    ..aQS(1, 'number')
    ..a<int>(2, 'type', $pb.PbFieldType.O3)
    ..a<String>(3, 'name', $pb.PbFieldType.OS, '\$')
  ;

  PhoneNumber() : super();
  PhoneNumber.fromBuffer(List<int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhoneNumber.fromJson(String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhoneNumber clone() => new PhoneNumber()..mergeFromMessage(this);
  PhoneNumber copyWith(void Function(PhoneNumber) updates) => super.copyWith((message) => updates(message as PhoneNumber));
  $pb.BuilderInfo get info_ => _i;
  static PhoneNumber create() => new PhoneNumber();
  static $pb.PbList<PhoneNumber> createRepeated() => new $pb.PbList<PhoneNumber>();
  static PhoneNumber getDefault() => _defaultInstance ??= create()..freeze();
  static PhoneNumber _defaultInstance;
  static void $checkItem(PhoneNumber v) {
    if (v is! PhoneNumber) $pb.checkItemFailed(v, 'PhoneNumber');
  }

  String get number => $_getS(0, '');
  set number(String v) { $_setString(0, v); }
  bool hasNumber() => $_has(0);
  void clearNumber() => clearField(1);

  int get type => $_get(1, 0);
  set type(int v) { $_setSignedInt32(1, v); }
  bool hasType() => $_has(1);
  void clearType() => clearField(2);

  String get name => $_getS(2, '\$');
  set name(String v) { $_setString(2, v); }
  bool hasName() => $_has(2);
  void clearName() => clearField(3);
}

