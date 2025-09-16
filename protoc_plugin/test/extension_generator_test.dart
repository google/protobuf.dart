// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/gen/google/protobuf/compiler/plugin.pb.dart'
    as pb;
import 'package:protoc_plugin/src/gen/google/protobuf/descriptor.pb.dart' as pb;
import 'package:protoc_plugin/src/linker.dart';
import 'package:protoc_plugin/src/options.dart';
import 'package:test/test.dart';

import 'src/golden_file.dart';
import 'src/test_features.dart';

pb.FieldDescriptorProto makeExtension() {
  return pb.FieldDescriptorProto()
    ..name = 'client_info'
    ..jsonName = 'clientInfo'
    ..number = 261486461
    ..label = pb.FieldDescriptorProto_Label.LABEL_OPTIONAL
    ..type = pb.FieldDescriptorProto_Type.TYPE_STRING
    ..extendee = '.Card';
}

void main() {
  test('testExtensionGenerator', () {
    final extensionFieldDescriptor = makeExtension();
    final messageDescriptor =
        pb.DescriptorProto()
          ..name = 'Card'
          ..extension.add(extensionFieldDescriptor);
    final fileDescriptor =
        pb.FileDescriptorProto()
          ..messageType.add(messageDescriptor)
          ..extension.add(extensionFieldDescriptor);

    final fileGenerator = FileGenerator(
      testEditionDefaults,
      fileDescriptor,
      GenerationOptions(),
    );
    final options = parseGenerationOptions(
      pb.CodeGeneratorRequest(),
      pb.CodeGeneratorResponse(),
    );
    link(options, [fileGenerator]);
    final writer = IndentingWriter(
      generateMetadata: true,
      fileName: 'sample.proto',
    );
    fileGenerator.extensionGenerators.single.generate(writer);

    expectGolden(writer.emitSource(format: false), 'extension');
    expectGolden(writer.sourceLocationInfo.toString(), 'extension.meta');
  });

  test('ExtensionGenerator inherits from a parent file', () {
    final ed = makeExtension();
    final fd = setTestFeature(
      pb.FileDescriptorProto()
        ..edition = pb.Edition.EDITION_2023
        ..extension.add(ed),
      1,
    );
    final fg = FileGenerator(testEditionDefaults, fd, GenerationOptions());
    fg.resolve(GenerationContext(GenerationOptions()));

    expect(getTestFeature(fg.extensionGenerators.single.features), 1);
  });

  test('ExtensionGenerator can override parent file features', () {
    final ed = setTestFeature(makeExtension(), 2);
    final fd = setTestFeature(
      pb.FileDescriptorProto()
        ..edition = pb.Edition.EDITION_2023
        ..extension.add(ed),
      1,
    );
    final fg = FileGenerator(testEditionDefaults, fd, GenerationOptions());
    fg.resolve(GenerationContext(GenerationOptions()));

    expect(getTestFeature(fg.extensionGenerators.single.features), 2);
  });

  test('ExtensionGenerator inherits from a parent message', () {
    final ed = makeExtension();
    final md = setTestFeature(pb.DescriptorProto()..extension.add(ed), 1);
    final fd =
        pb.FileDescriptorProto()
          ..edition = pb.Edition.EDITION_2023
          ..messageType.add(md);
    final fg = FileGenerator(testEditionDefaults, fd, GenerationOptions());
    final mg = MessageGenerator.topLevel(md, fg, {}, null, <String>{}, 0);
    final eg = ExtensionGenerator.nested(ed, mg, {}, 0);
    eg.resolve(GenerationContext(GenerationOptions()));

    expect(getTestFeature(eg.features), 1);
  });

  test('ExtensionGenerator can override parent message features', () {
    final ed = setTestFeature(makeExtension(), 2);
    final md = setTestFeature(pb.DescriptorProto()..extension.add(ed), 1);
    final fd =
        pb.FileDescriptorProto()
          ..edition = pb.Edition.EDITION_2023
          ..messageType.add(md);
    final fg = FileGenerator(testEditionDefaults, fd, GenerationOptions());
    final mg = MessageGenerator.topLevel(md, fg, {}, null, <String>{}, 0);
    final eg = ExtensionGenerator.nested(ed, mg, {}, 0);
    eg.resolve(GenerationContext(GenerationOptions()));

    expect(getTestFeature(eg.features), 2);
  });
}
