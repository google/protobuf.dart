// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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
}
