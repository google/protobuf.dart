#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library message_generator_test;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:test/test.dart';

import 'package:protoc_plugin/src/descriptor.pb.dart';
import 'package:protoc_plugin/src/plugin.pb.dart';

void main() {
  test('testMessageGenerator', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expectedEnums = r'''
class PhoneNumber_PhoneType extends ProtobufEnum {
  static const PhoneNumber_PhoneType MOBILE = const PhoneNumber_PhoneType._(0, 'MOBILE');
  static const PhoneNumber_PhoneType HOME = const PhoneNumber_PhoneType._(1, 'HOME');
  static const PhoneNumber_PhoneType WORK = const PhoneNumber_PhoneType._(2, 'WORK');

  static const PhoneNumber_PhoneType BUSINESS = WORK;

  static const List<PhoneNumber_PhoneType> values = const <PhoneNumber_PhoneType> [
    MOBILE,
    HOME,
    WORK,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static PhoneNumber_PhoneType valueOf(int value) => _byValue[value] as PhoneNumber_PhoneType;
  static void $checkItem(PhoneNumber_PhoneType v) {
    if (v is! PhoneNumber_PhoneType) checkItemFailed(v, 'PhoneNumber_PhoneType');
  }

  const PhoneNumber_PhoneType._(int v, String n) : super(v, n);
}

''';

    String expected = r'''
class PhoneNumber extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PhoneNumber')
    ..a/*<String>*/(1, 'number', PbFieldType.QS)
    ..e/*<PhoneNumber_PhoneType>*/(2, 'type', PbFieldType.OE, PhoneNumber_PhoneType.MOBILE, PhoneNumber_PhoneType.valueOf)
    ..a/*<String>*/(3, 'name', PbFieldType.OS, '\$')
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

  String get number => $_get(0, 1, '');
  set number(String v) { $_setString(0, 1, v); }
  bool hasNumber() => $_has(0, 1);
  void clearNumber() => clearField(1);

  PhoneNumber_PhoneType get type => $_get(1, 2, null);
  set type(PhoneNumber_PhoneType v) { setField(2, v); }
  bool hasType() => $_has(1, 2);
  void clearType() => clearField(2);

  String get name => $_get(2, 3, '\$');
  set name(String v) { $_setString(2, 3, v); }
  bool hasName() => $_has(2, 3);
  void clearName() => clearField(3);
}

class _ReadonlyPhoneNumber extends PhoneNumber with ReadonlyMessageMixin {}

''';
    FileDescriptorProto fd = new FileDescriptorProto();
    EnumDescriptorProto ed = new EnumDescriptorProto()
      ..name = 'PhoneType'
      ..value.addAll([
        new EnumValueDescriptorProto()
          ..name = 'MOBILE'
          ..number = 0,
        new EnumValueDescriptorProto()
          ..name = 'HOME'
          ..number = 1,
        new EnumValueDescriptorProto()
          ..name = 'WORK'
          ..number = 2,
        new EnumValueDescriptorProto()
          ..name = 'BUSINESS'
          ..number = 2
      ]);
    DescriptorProto md = new DescriptorProto()
      ..name = 'PhoneNumber'
      ..field.addAll([
        // optional PhoneType type = 2 [default = HOME];
        new FieldDescriptorProto()
          ..name = 'type'
          ..number = 2
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_ENUM
          ..typeName = '.PhoneNumber.PhoneType',
        // required string number = 1;
        new FieldDescriptorProto()
          ..name = 'number'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_REQUIRED
          ..type = FieldDescriptorProto_Type.TYPE_STRING,
        new FieldDescriptorProto()
          ..name = 'name'
          ..number = 3
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_STRING
          ..defaultValue = r'$'
      ])
      ..enumType.add(ed);
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());

    FileGenerator fg = new FileGenerator(fd, options);
    MessageGenerator mg = new MessageGenerator(md, fg, {}, null);

    var ctx = new GenerationContext(options);
    mg.register(ctx);
    mg.resolve(ctx);

    var writer = new IndentingWriter();
    mg.generate(writer);
    expect(writer.toString(), expected);

    writer = new IndentingWriter();
    mg.generateEnums(writer);
    expect(writer.toString(), expectedEnums);
  });
}
