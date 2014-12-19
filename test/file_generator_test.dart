#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library file_generator_test;

import 'package:protoc_plugin/src/descriptor.pb.dart';
import 'package:protoc_plugin/src/plugin.pb.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:unittest/unittest.dart';


FileDescriptorProto buildFileDescriptor({topLevelEnum: false}) {
  EnumDescriptorProto ed;
  if (topLevelEnum) {
    ed = new EnumDescriptorProto()
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
  }

  DescriptorProto md = new DescriptorProto()
      ..name = 'PhoneNumber'
      ..field.addAll([
          // required string number = 1;
          new FieldDescriptorProto()
              ..name = 'number'
              ..number = 1
              ..label = FieldDescriptorProto_Label.LABEL_REQUIRED
              ..type = FieldDescriptorProto_Type.TYPE_STRING,
          // optional int32 type = 2;
          // OR
          // optional PhoneType type = 2;
          new FieldDescriptorProto()
              ..name = 'type'
              ..number = 2
              ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
              ..type = topLevelEnum ? FieldDescriptorProto_Type.TYPE_ENUM
                                    : FieldDescriptorProto_Type.TYPE_INT32
              ..typeName = topLevelEnum ? '.PhoneType' : '',
          // optional string name = 3 [default = "$"];
          new FieldDescriptorProto()
              ..name = 'name'
              ..number = 3
              ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
              ..type = FieldDescriptorProto_Type.TYPE_STRING
              ..defaultValue = r'$'
          ]);
  FileDescriptorProto fd = new FileDescriptorProto()
      ..name = 'test'
      ..messageType.add(md);
  if (topLevelEnum) fd.enumType.add(ed);
  return fd;
}

void main() {
  test('testMessageGenerator', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
///
//  Generated code. Do not modify.
///
library test;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class PhoneNumber extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PhoneNumber')
    ..a(1, 'number', GeneratedMessage.QS)
    ..a(2, 'type', GeneratedMessage.O3)
    ..a(3, 'name', GeneratedMessage.OS, '\$')
  ;

  PhoneNumber() : super();
  PhoneNumber.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhoneNumber.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhoneNumber clone() => new PhoneNumber()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PhoneNumber create() => new PhoneNumber();
  static PbList<PhoneNumber> createRepeated() => new PbList<PhoneNumber>();

  String get number => getField(1);
  void set number(String v) { setField(1, v); }
  bool hasNumber() => hasField(1);
  void clearNumber() => clearField(1);

  int get type => getField(2);
  void set type(int v) { setField(2, v); }
  bool hasType() => hasField(2);
  void clearType() => clearField(2);

  String get name => getField(3);
  void set name(String v) { setField(3, v); }
  bool hasName() => hasField(3);
  void clearName() => clearField(3);
}

''';
    FileDescriptorProto fd = buildFileDescriptor();
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());
    FileGenerator fg = new FileGenerator(fd, null,
        new GenerationContext(options, new DefaultOutputConfiguration()));
    fg.generate(writer);
    expect(buffer.toString(), expected);
  });

  test('testMessageGeneratorTopLevelEmun', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
///
//  Generated code. Do not modify.
///
library test;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class PhoneType extends ProtobufEnum {
  static const PhoneType MOBILE = const PhoneType._(0, 'MOBILE');
  static const PhoneType HOME = const PhoneType._(1, 'HOME');
  static const PhoneType WORK = const PhoneType._(2, 'WORK');

  static const PhoneType BUSINESS = WORK;

  static const List<PhoneType> values = const <PhoneType> [
    MOBILE,
    HOME,
    WORK,
  ];

  static final Map<int, PhoneType> _byValue = ProtobufEnum.initByValue(values);
  static PhoneType valueOf(int value) => _byValue[value];

  const PhoneType._(int v, String n) : super(v, n);
}

class PhoneNumber extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PhoneNumber')
    ..a(1, 'number', GeneratedMessage.QS)
    ..e(2, 'type', GeneratedMessage.OE, PhoneType.MOBILE, (var v) => PhoneType.valueOf(v))
    ..a(3, 'name', GeneratedMessage.OS, '\$')
  ;

  PhoneNumber() : super();
  PhoneNumber.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhoneNumber.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhoneNumber clone() => new PhoneNumber()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PhoneNumber create() => new PhoneNumber();
  static PbList<PhoneNumber> createRepeated() => new PbList<PhoneNumber>();

  String get number => getField(1);
  void set number(String v) { setField(1, v); }
  bool hasNumber() => hasField(1);
  void clearNumber() => clearField(1);

  PhoneType get type => getField(2);
  void set type(PhoneType v) { setField(2, v); }
  bool hasType() => hasField(2);
  void clearType() => clearField(2);

  String get name => getField(3);
  void set name(String v) { setField(3, v); }
  bool hasName() => hasField(3);
  void clearName() => clearField(3);
}

''';
    FileDescriptorProto fd = buildFileDescriptor(topLevelEnum: true);
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());
    FileGenerator fg = new FileGenerator(fd, null,
        new GenerationContext(options, new DefaultOutputConfiguration()));
    fg.generate(writer);
    expect(buffer.toString(), expected);
  });

  test('testMessageGeneratorPackage', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
///
//  Generated code. Do not modify.
///
library pb_library;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class PhoneNumber extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PhoneNumber')
    ..a(1, 'number', GeneratedMessage.QS)
    ..a(2, 'type', GeneratedMessage.O3)
    ..a(3, 'name', GeneratedMessage.OS, '\$')
  ;

  PhoneNumber() : super();
  PhoneNumber.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhoneNumber.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhoneNumber clone() => new PhoneNumber()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PhoneNumber create() => new PhoneNumber();
  static PbList<PhoneNumber> createRepeated() => new PbList<PhoneNumber>();

  String get number => getField(1);
  void set number(String v) { setField(1, v); }
  bool hasNumber() => hasField(1);
  void clearNumber() => clearField(1);

  int get type => getField(2);
  void set type(int v) { setField(2, v); }
  bool hasType() => hasField(2);
  void clearType() => clearField(2);

  String get name => getField(3);
  void set name(String v) { setField(3, v); }
  bool hasName() => hasField(3);
  void clearName() => clearField(3);
}

''';
    FileDescriptorProto fd = buildFileDescriptor();
    fd.package = "pb_library";
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());
    FileGenerator fg = new FileGenerator(fd, null,
        new GenerationContext(options, new DefaultOutputConfiguration()));
    fg.generate(writer);
    expect(buffer.toString(), expected);
  });

  test('testMessageGeneratorFieldNameOption', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
///
//  Generated code. Do not modify.
///
library test;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class PhoneNumber extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('PhoneNumber')
    ..a(1, 'no', GeneratedMessage.QS)
    ..a(2, 'the_type', GeneratedMessage.O3)
    ..a(3, 'name_', GeneratedMessage.OS, '\$')
  ;

  PhoneNumber() : super();
  PhoneNumber.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  PhoneNumber.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  PhoneNumber clone() => new PhoneNumber()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static PhoneNumber create() => new PhoneNumber();
  static PbList<PhoneNumber> createRepeated() => new PbList<PhoneNumber>();

  String get no => getField(1);
  void set no(String v) { setField(1, v); }
  bool hasNo() => hasField(1);
  void clearNo() => clearField(1);

  int get the_type => getField(2);
  void set the_type(int v) { setField(2, v); }
  bool hasThe_type() => hasField(2);
  void clearThe_type() => clearField(2);

  String get name_ => getField(3);
  void set name_(String v) { setField(3, v); }
  bool hasName_() => hasField(3);
  void clearName_() => clearField(3);
}

''';
    FileDescriptorProto fd = buildFileDescriptor();
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    var request = new CodeGeneratorRequest();
    request.parameter = 'field_name=PhoneNumber.number|No,'
                        'field_name=PhoneNumber.name|Name_,'
                        'field_name=PhoneNumber.type|The_type';
    var options = parseGenerationOptions(
        request, new CodeGeneratorResponse());
    FileGenerator fg = new FileGenerator(fd, null,
        new GenerationContext(options, new DefaultOutputConfiguration()));
    fg.generate(writer);
    expect(buffer.toString(), expected);
  });

  test('testMessageGeneratorFieldNameOption', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
///
//  Generated code. Do not modify.
///
library test;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package1.pb.dart' as p1;
import 'package2.pb.dart' as p2;

class M extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('M')
    ..a(1, 'm', GeneratedMessage.OM, M.create, M.create)
    ..a(2, 'm1', GeneratedMessage.OM, p1.M.create, p1.M.create)
    ..a(3, 'm2', GeneratedMessage.OM, p2.M.create, p2.M.create)
    ..hasRequiredFields = false
  ;

  M() : super();
  M.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  M.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  M clone() => new M()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static M create() => new M();
  static PbList<M> createRepeated() => new PbList<M>();

  M get m => getField(1);
  void set m(M v) { setField(1, v); }
  bool hasM() => hasField(1);
  void clearM() => clearField(1);

  p1.M get m1 => getField(2);
  void set m1(p1.M v) { setField(2, v); }
  bool hasM1() => hasField(2);
  void clearM1() => clearField(2);

  p2.M get m2 => getField(3);
  void set m2(p2.M v) { setField(3, v); }
  bool hasM2() => hasField(3);
  void clearM2() => clearField(3);
}

''';

    // This defines three .proto files package1.proto, package2.proto and
    // test.proto with the following content:
    //
    // package1.proto:
    // ---------------
    // package p1;
    // message M {
    //   optional M m = 2;
    // }
    //
    // package2.proto:
    // ---------------
    // package p2;
    // message M {
    //   optional M m = 2;
    // }
    //
    // test.proto:
    // ---------------
    // package test;
    // import "package1.proto";
    // import "package2.proto";
    // message M {
    //   optional M m = 1;
    //   optional p1.M m1 = 2;
    //   optional p2.M m2 = 3;
    // }

    // Description of package1.proto.
    DescriptorProto md1 = new DescriptorProto()
        ..name = 'M'
        ..field.addAll([
            // optional M m = 1;
            new FieldDescriptorProto()
                ..name = 'm'
                ..number = 1
                ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
                ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
                ..typeName = ".p1.M",
            ]);
    FileDescriptorProto fd1 = new FileDescriptorProto()
        ..package = 'p1'
        ..name = 'package1.proto'
        ..messageType.add(md1);

    // Description of package1.proto.
    DescriptorProto md2 = new DescriptorProto()
        ..name = 'M'
        ..field.addAll([
            // optional M m = 1;
            new FieldDescriptorProto()
                ..name = 'x'
                ..number = 1
                ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
                ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
                ..typeName = ".p2.M",
            ]);
    FileDescriptorProto fd2 = new FileDescriptorProto()
        ..package = 'p2'
        ..name = 'package2.proto'
        ..messageType.add(md2);

    // Description of test.proto.
    DescriptorProto md = new DescriptorProto()
        ..name = 'M'
        ..field.addAll([
            // optional M m = 1;
            new FieldDescriptorProto()
                ..name = 'm'
                ..number = 1
                ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
                ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
                ..typeName = ".M",
            // optional p1.M m1 = 2;
            new FieldDescriptorProto()
                ..name = 'm1'
                ..number = 2
                ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
                ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
                ..typeName = ".p1.M",
            // optional p2.M m2 = 3;
            new FieldDescriptorProto()
                ..name = 'm2'
                ..number = 3
                ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
                ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
                ..typeName = ".p2.M",
            ]);
    FileDescriptorProto fd = new FileDescriptorProto()
        ..name = 'test.proto'
        ..messageType.add(md);
    fd.dependency.addAll(['package1.proto', 'package2.proto']);
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    var request = new CodeGeneratorRequest();
    var response = new CodeGeneratorResponse();
    var options = parseGenerationOptions(request, response);
    var context = new GenerationContext(options,
        new DefaultOutputConfiguration());
    new FileGenerator(fd1, null, context);
    new FileGenerator(fd2, null, context);
    FileGenerator fg = new FileGenerator(fd, null, context);
    fg.generate(writer);
    expect(buffer.toString(), expected);
  });
}
