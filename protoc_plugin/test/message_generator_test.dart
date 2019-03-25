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
          ..defaultValue = r'$',
        new FieldDescriptorProto()
          ..name = 'deprecated_field'
          ..number = 4
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_STRING
          ..options = (new FieldOptions()..deprecated = true),
      ])
      ..enumType.add(ed);
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());

    FileGenerator fg = new FileGenerator(fd, options);
    MessageGenerator mg =
        new MessageGenerator.topLevel(md, fg, {}, null, new Set<String>(), 0);

    var ctx = new GenerationContext(options);
    mg.register(ctx);
    mg.resolve(ctx);

    var writer = new IndentingWriter(filename: '');
    mg.generate(writer);
    expectMatchesGoldenFile(writer.toString(), 'test/goldens/messageGenerator');
    expectMatchesGoldenFile(writer.sourceLocationInfo.toString(),
        'test/goldens/messageGenerator.meta');

    writer = new IndentingWriter(filename: '');
    mg.generateEnums(writer);
    expectMatchesGoldenFile(
        writer.toString(), 'test/goldens/messageGeneratorEnums');
    expectMatchesGoldenFile(writer.sourceLocationInfo.toString(),
        'test/goldens/messageGeneratorEnums.meta');
  });
}
