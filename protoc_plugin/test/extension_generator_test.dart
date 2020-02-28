#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library extension_generator_test;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/descriptor.pb.dart' as pb;
import 'package:protoc_plugin/src/plugin.pb.dart' as pb;
import 'package:test/test.dart';

import 'golden_file.dart';

void main() {
  test('testExtensionGenerator', () {
    final extensionFieldDescriptor = pb.FieldDescriptorProto()
      ..name = 'client_info'
      ..number = 261486461
      ..label = pb.FieldDescriptorProto_Label.LABEL_OPTIONAL
      ..type = pb.FieldDescriptorProto_Type.TYPE_STRING
      ..extendee = 'Card';
    final messageDescriptor = pb.DescriptorProto()
      ..name = 'Card'
      ..extension.add(extensionFieldDescriptor);
    final fileDescriptor = pb.FileDescriptorProto()
      ..messageType.add(messageDescriptor);

    final fileGenerator = FileGenerator(fileDescriptor, GenerationOptions());
    final extensionGenerator = ExtensionGenerator.topLevel(
      extensionFieldDescriptor,
      fileGenerator,
      <String>{},
      0,
    );
    final options = parseGenerationOptions(
        pb.CodeGeneratorRequest(), pb.CodeGeneratorResponse());
    final generationContext = GenerationContext(options);
    extensionGenerator.resolve(generationContext);

    final writer = IndentingWriter(filename: 'sample.proto');
    extensionGenerator.generate(writer);

    expectMatchesGoldenFile(writer.toString(),
        'test/goldens/extension');
    expectMatchesGoldenFile(writer.sourceLocationInfo.toString(),
        'test/goldens/extension.meta');
  });
}
