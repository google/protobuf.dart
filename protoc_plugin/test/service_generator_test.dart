// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/linker.dart';
import 'package:protoc_plugin/src/options.dart';
import 'package:test/test.dart';

import 'src/golden_file.dart';
import 'src/service_util.dart';

void main() {
  test('testServiceGenerator', () {
    final options = GenerationOptions();
    final fd = buildFileDescriptor('testpkg', 'testpkg.proto', [
      'SomeRequest',
      'SomeReply',
    ]);
    fd.service.add(buildServiceDescriptor());
    final fg = FileGenerator(fd, options);

    final fd2 = buildFileDescriptor('foo.bar', 'foobar.proto', [
      'EmptyMessage',
      'AnotherReply',
    ]);
    final fg2 = FileGenerator(fd2, options);

    link(GenerationOptions(), [fg, fg2]);

    final serviceWriter = IndentingWriter();
    fg.serviceGenerators[0].generate(serviceWriter);
    expectGolden(
      serviceWriter.emitSource(format: true),
      'serviceGenerator.pb.dart',
    );
    expectGolden(fg.generateJsonFile(), 'serviceGenerator.pbjson.dart');
  });
}
