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

import 'golden_file.dart';

void main() {
  test('testMessageGenerator', () {
    FileDescriptorProto fd = FileDescriptorProto();
    EnumDescriptorProto ed = EnumDescriptorProto()
      ..name = 'PhoneType'
      ..value.addAll([
        EnumValueDescriptorProto()
          ..name = 'MOBILE'
          ..number = 0,
        EnumValueDescriptorProto()
          ..name = 'HOME'
          ..number = 1,
        EnumValueDescriptorProto()
          ..name = 'WORK'
          ..number = 2,
        EnumValueDescriptorProto()
          ..name = 'BUSINESS'
          ..number = 2
      ]);
    DescriptorProto md = DescriptorProto()
      ..name = 'PhoneNumber'
      ..field.addAll([
        // optional PhoneType type = 2 [default = HOME];
        FieldDescriptorProto()
          ..name = 'type'
          ..number = 2
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_ENUM
          ..typeName = '.PhoneNumber.PhoneType',
        // required string number = 1;
        FieldDescriptorProto()
          ..name = 'number'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_REQUIRED
          ..type = FieldDescriptorProto_Type.TYPE_STRING,
        FieldDescriptorProto()
          ..name = 'name'
          ..number = 3
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_STRING
          ..defaultValue = r'$'
      ])
      ..enumType.add(ed);
    var options = parseGenerationOptions(
        CodeGeneratorRequest(), CodeGeneratorResponse());

    FileGenerator fg = FileGenerator(fd, options);
    MessageGenerator mg =
        MessageGenerator.topLevel(md, fg, {}, null, Set<String>(), 0);

    var ctx = GenerationContext(options);
    mg.register(ctx);
    mg.resolve(ctx);

    var writer = IndentingWriter(filename: '');
    mg.generate(writer);
    expectMatchesGoldenFile(writer.toString(), 'test/goldens/messageGenerator');
    expectMatchesGoldenFile(writer.sourceLocationInfo.toString(),
        'test/goldens/messageGenerator.meta');

    writer = IndentingWriter(filename: '');
    mg.generateEnums(writer);
    expectMatchesGoldenFile(
        writer.toString(), 'test/goldens/messageGeneratorEnums');
    expectMatchesGoldenFile(writer.sourceLocationInfo.toString(),
        'test/goldens/messageGeneratorEnums.meta');
  });
}
