// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/gen/google/protobuf/descriptor.pb.dart';
import 'package:protoc_plugin/src/options.dart';
import 'package:test/test.dart';

import 'src/golden_file.dart';

void main() {
  test('testEnumGenerator', () {
    final ed =
        EnumDescriptorProto()
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
              ..number = 2,
          ]);
    final writer = IndentingWriter(
      generateMetadata: true,
      fileName: 'sample.proto',
    );
    final fg = FileGenerator(FileDescriptorProto(), GenerationOptions());
    final eg = EnumGenerator.topLevel(ed, fg, <String>{}, 0);
    eg.generate(writer);
    expectGolden(writer.emitSource(format: false), 'enum.pbenum.dart');
    expectGolden(writer.sourceLocationInfo.toString(), 'enum.pbenum.dart.meta');
  });

  test('testEnumGeneratorWithProtobufEnumStyle', () {
    // Create an enum with protobuf-style names (enum name prefixed values)
    final ed =
        EnumDescriptorProto()
          ..name = 'PhoneType'
          ..value.addAll([
            EnumValueDescriptorProto()
              ..name = 'PHONE_TYPE_UNSPECIFIED'
              ..number = 0,
            EnumValueDescriptorProto()
              ..name = 'PHONE_TYPE_MOBILE'
              ..number = 1,
            EnumValueDescriptorProto()
              ..name = 'PHONE_TYPE_HOME'
              ..number = 2,
            EnumValueDescriptorProto()
              ..name = 'PHONE_TYPE_WORK'
              ..number = 3,
          ]);

    final writer = IndentingWriter(
      generateMetadata: true,
      fileName: 'sample.proto',
    );

    // Test with protobuf enum style enabled - this should strip prefixes
    final optionsWithProtobufStyle = GenerationOptions(protobufEnumStyle: true);
    final fg = FileGenerator(FileDescriptorProto(), optionsWithProtobufStyle);
    final eg = EnumGenerator.topLevel(ed, fg, <String>{}, 0);
    eg.generate(writer);

    expectGolden(
      writer.emitSource(format: false),
      'enum_protobuf_style.pbenum.dart',
    );
    expectGolden(
      writer.sourceLocationInfo.toString(),
      'enum_protobuf_style.pbenum.dart.meta',
    );
  });

  test('testEnumGeneratorWithoutProtobufEnumStyle', () {
    // Same enum with protobuf-style names but without the flag
    final ed =
        EnumDescriptorProto()
          ..name = 'PhoneType'
          ..value.addAll([
            EnumValueDescriptorProto()
              ..name = 'PHONE_TYPE_UNSPECIFIED'
              ..number = 0,
            EnumValueDescriptorProto()
              ..name = 'PHONE_TYPE_MOBILE'
              ..number = 1,
          ]);

    final writer = IndentingWriter(
      generateMetadata: true,
      fileName: 'sample.proto',
    );

    // Test without protobuf enum style - should use names as-is
    final optionsWithoutProtobufStyle = GenerationOptions(
      protobufEnumStyle: false,
    );
    final fg = FileGenerator(
      FileDescriptorProto(),
      optionsWithoutProtobufStyle,
    );
    final eg = EnumGenerator.topLevel(ed, fg, <String>{}, 0);
    eg.generate(writer);

    expectGolden(
      writer.emitSource(format: false),
      'enum_without_protobuf_style.pbenum.dart',
    );
    expectGolden(
      writer.sourceLocationInfo.toString(),
      'enum_without_protobuf_style.pbenum.dart.meta',
    );
  });

  test('testEnumGeneratorWithComplexProtobufEnumStyle', () {
    // Test with more complex enum names to verify camelCase conversion
    final ed =
        EnumDescriptorProto()
          ..name = 'HTTPStatusCode'
          ..value.addAll([
            EnumValueDescriptorProto()
              ..name = 'HTTP_STATUS_CODE_UNSPECIFIED'
              ..number = 0,
            EnumValueDescriptorProto()
              ..name = 'HTTP_STATUS_CODE_NOT_FOUND'
              ..number = 1,
            EnumValueDescriptorProto()
              ..name = 'HTTP_STATUS_CODE_INTERNAL_SERVER_ERROR'
              ..number = 2,
            EnumValueDescriptorProto()
              ..name = 'HTTP_STATUS_CODE_OK'
              ..number = 3,
          ]);

    final writer = IndentingWriter(
      generateMetadata: true,
      fileName: 'sample.proto',
    );

    // Test with protobuf enum style enabled
    final optionsWithProtobufStyle = GenerationOptions(protobufEnumStyle: true);
    final fg = FileGenerator(FileDescriptorProto(), optionsWithProtobufStyle);
    final eg = EnumGenerator.topLevel(ed, fg, <String>{}, 0);
    eg.generate(writer);

    expectGolden(
      writer.emitSource(format: false),
      'enum_complex_protobuf_style.pbenum.dart',
    );
    expectGolden(
      writer.sourceLocationInfo.toString(),
      'enum_complex_protobuf_style.pbenum.dart.meta',
    );
  });
}
