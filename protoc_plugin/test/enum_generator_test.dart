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
import 'src/test_features.dart';

void main() {
  late FileDescriptorProto fd;
  late EnumDescriptorProto ed;
  late DescriptorProto md;

  setUp(() async {
    fd = FileDescriptorProto();
    ed =
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
    md = DescriptorProto()..enumType.add(ed);
  });

  test('testEnumGenerator', () {
    final writer = IndentingWriter(
      generateMetadata: true,
      fileName: 'sample.proto',
    );
    final fg = FileGenerator(
      testEditionDefaults,
      FileDescriptorProto(),
      GenerationOptions(),
    );
    final eg = EnumGenerator.topLevel(ed, fg, <String>{}, 0);
    eg.generate(writer);
    expectGolden(writer.emitSource(format: false), 'enum.pbenum.dart');
    expectGolden(writer.sourceLocationInfo.toString(), 'enum.pbenum.dart.meta');
  });

  test('EnumGenerator inherits from a parent file', () {
    setTestFeature(fd, 1);
    final fg = FileGenerator(testEditionDefaults, fd, GenerationOptions());
    final eg = EnumGenerator.topLevel(ed, fg, <String>{}, 0);

    expect(getTestFeature(eg.features), 1);
  });

  test('EnumGenerator inherits from a parent message', () {
    setTestFeature(md, 1);
    final fg = FileGenerator(testEditionDefaults, fd, GenerationOptions());
    final mg = MessageGenerator.nested(md, fg, {}, null, <String>{}, 0);
    final eg = EnumGenerator.nested(ed, mg, <String>{}, 0);

    expect(getTestFeature(eg.features), 1);
  });

  test('EnumGenerator can override parent file features', () {
    setTestFeature(fd, 1);
    setTestFeature(ed, 2);
    final fg = FileGenerator(testEditionDefaults, fd, GenerationOptions());
    final eg = EnumGenerator.topLevel(ed, fg, <String>{}, 0);

    expect(getTestFeature(eg.features), 2);
  });

  test('EnumGenerator can override parent message features', () {
    setTestFeature(md, 1);
    setTestFeature(ed, 2);
    final fg = FileGenerator(testEditionDefaults, fd, GenerationOptions());
    final mg = MessageGenerator.nested(md, fg, {}, null, <String>{}, 0);
    final eg = EnumGenerator.nested(ed, mg, <String>{}, 0);

    expect(getTestFeature(eg.features), 2);
  });
}
