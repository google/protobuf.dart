#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library message_generator_test;

import 'package:protoc-plugin/src/descriptor.pb.dart';
import 'package:protoc-plugin/src/plugin.pb.dart';
import 'package:protoc-plugin/protoc.dart';
import 'package:unittest/unittest.dart';


void main() {
  test('testMessageGenerator', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
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

  static final Map<int, PhoneNumber_PhoneType> _byValue = ProtobufEnum.initByValue(values);
  static PhoneNumber_PhoneType valueOf(int value) => _byValue[value];

  const PhoneNumber_PhoneType._(int v, String n) : super(v, n);
}

class PhoneNumber extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PhoneNumber')
    ..a(1, 'number', GeneratedMessage.QS)
    ..e(2, 'type', GeneratedMessage.OE, () => PhoneNumber_PhoneType.MOBILE, (var v) => PhoneNumber_PhoneType.valueOf(v))
    ..a(3, 'name', GeneratedMessage.OS, () => '\$')
  ;

  PhoneNumber() : super();
  PhoneNumber.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhoneNumber.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhoneNumber clone() => new PhoneNumber()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;

  String get number => getField(1);
  void set number(String v) { setField(1, v); }
  bool hasNumber() => hasField(1);
  void clearNumber() => clearField(1);

  PhoneNumber_PhoneType get type => getField(2);
  void set type(PhoneNumber_PhoneType v) { setField(2, v); }
  bool hasType() => hasField(2);
  void clearType() => clearField(2);

  String get name => getField(3);
  void set name(String v) { setField(3, v); }
  bool hasName() => hasField(3);
  void clearName() => clearField(3);
}

''';
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
                ..number = 2]);
    DescriptorProto md = new DescriptorProto()
        ..name = 'PhoneNumber'
        ..field.addAll([
            // required string number = 1;
            new FieldDescriptorProto()
                ..name = 'number'
                ..number = 1
                ..label = FieldDescriptorProto_Label.LABEL_REQUIRED
                ..type = FieldDescriptorProto_Type.TYPE_STRING,
            // optional PhoneType type = 2 [default = HOME];
            new FieldDescriptorProto()
                ..name = 'type'
                ..number = 2
                ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
                ..type = FieldDescriptorProto_Type.TYPE_ENUM
                ..typeName = 'PhoneNumber.PhoneType',
            new FieldDescriptorProto()
                ..name = 'name'
                ..number = 3
                ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
                ..type = FieldDescriptorProto_Type.TYPE_STRING
                ..defaultValue = r'$'
            ])
        ..enumType.add(ed);
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    var options =
        new GenerationOptions(new CodeGeneratorRequest(),
                              new CodeGeneratorResponse());
    MessageGenerator mg =
        new MessageGenerator(
            md, null, new GenerationContext(options));
    mg.initializeFields();
    mg.generate(writer);
    expect(buffer.toString(), expected);
  });
}
