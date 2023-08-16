// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'package:collection/collection.dart';
import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/generated/descriptor.pb.dart';
import 'package:protoc_plugin/src/generated/plugin.pb.dart';
import 'package:protoc_plugin/src/linker.dart';
import 'package:protoc_plugin/src/options.dart';
import 'package:test/test.dart';

import 'golden_file.dart';

void main() {
  late FileDescriptorProto fd;
  EnumDescriptorProto ed;
  late DescriptorProto md;
  setUp(() async {
    fd = FileDescriptorProto();
    ed = EnumDescriptorProto()
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
    md = DescriptorProto()
      ..name = 'PhoneNumber'
      ..field.addAll([
        // optional PhoneType type = 2 [default = HOME];
        FieldDescriptorProto()
          ..name = 'type'
          ..jsonName = 'type'
          ..number = 2
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_ENUM
          ..typeName = '.PhoneNumber.PhoneType',
        // required string number = 1;
        FieldDescriptorProto()
          ..name = 'number'
          ..jsonName = 'number'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_REQUIRED
          ..type = FieldDescriptorProto_Type.TYPE_STRING,
        FieldDescriptorProto()
          ..name = 'name'
          ..jsonName = 'name'
          ..number = 3
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_STRING
          ..defaultValue = r'$',
        FieldDescriptorProto()
          ..name = 'deprecated_field'
          ..jsonName = 'deprecatedField'
          ..number = 4
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_STRING
          ..options = (FieldOptions()..deprecated = true),
      ])
      ..enumType.add(ed);
  });
  test('testMessageGenerator', () {
    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;

    final fg = FileGenerator(fd, options);
    final mg = MessageGenerator.topLevel(md, fg, {}, null, <String>{}, 0);

    final ctx = GenerationContext(options);
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

  test('testMetadataIndices', () {
    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;
    final fg = FileGenerator(fd, options);
    final mg = MessageGenerator.topLevel(md, fg, {}, null, <String>{}, 0);

    final ctx = GenerationContext(options);
    mg.register(ctx);
    mg.resolve(ctx);

    final writer = IndentingWriter(filename: '');
    mg.generate(writer);

    final eq = ListEquality();
    final fieldStringsMap = HashMap(
        equals: eq.equals, hashCode: eq.hash, isValidKey: eq.isValidKey);
    fieldStringsMap[[4, 0]] = ['PhoneNumber'];
    fieldStringsMap[[4, 0, 2, 0]] = ['type', 'hasType', 'clearType'];
    fieldStringsMap[[4, 0, 2, 1]] = ['number', 'hasNumber', 'clearNumber'];
    fieldStringsMap[[4, 0, 2, 2]] = ['name', 'hasName', 'clearName'];
    fieldStringsMap[[4, 0, 2, 3]] = [
      'deprecatedField',
      'hasDeprecatedField',
      'clearDeprecatedField'
    ];

    final generatedContents = writer.toString();
    final metadata = writer.sourceLocationInfo;
    for (final annotation in metadata.annotation) {
      final annotatedName =
          generatedContents.substring(annotation.begin, annotation.end);
      final expectedStrings = fieldStringsMap[annotation.path];
      if (expectedStrings == null) {
        fail('The field path ${annotation.path} '
            'did not match any expected field path.');
      }
      expect(annotatedName, isIn(expectedStrings));
    }
  });
}
