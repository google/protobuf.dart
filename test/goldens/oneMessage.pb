///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

class PhoneNumber extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PhoneNumber')
    ..aQS(1, 'number')
    ..a<int>(2, 'type', PbFieldType.O3)
    ..a<String>(3, 'name', PbFieldType.OS, '\$')
  ;

  PhoneNumber() : super();
  PhoneNumber.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhoneNumber.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhoneNumber clone() => new PhoneNumber()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PhoneNumber create() => new PhoneNumber();
  static PbList<PhoneNumber> createRepeated() => new PbList<PhoneNumber>();
  static PhoneNumber getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyPhoneNumber();
    return _defaultInstance;
  }
  static PhoneNumber _defaultInstance;
  static void $checkItem(PhoneNumber v) {
    if (v is! PhoneNumber) checkItemFailed(v, 'PhoneNumber');
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

class _ReadonlyPhoneNumber extends PhoneNumber with ReadonlyMessageMixin {}

