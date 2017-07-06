#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library enum_generator_test;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/descriptor.pb.dart';
import 'package:test/test.dart';

void main() {
  test('testEnumGenerator', () {
    String expected = r'''
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

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static PhoneType valueOf(int value) => _byValue[value] as PhoneType;
  static void $checkItem(PhoneType v) {
    if (v is! PhoneType) checkItemFailed(v, 'PhoneType');
  }

  const PhoneType._(int v, String n) : super(v, n);
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
          ..number = 2
      ]);
    IndentingWriter writer = new IndentingWriter();
    EnumGenerator eg = new EnumGenerator(ed, null);
    eg.generate(writer);
    expect(writer.toString(), expected);
  });
}
