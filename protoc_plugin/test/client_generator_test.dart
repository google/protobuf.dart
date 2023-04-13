// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/linker.dart';
import 'package:protoc_plugin/src/options.dart';
import 'package:test/test.dart';

import 'golden_file.dart';
import 'service_util.dart';

void main() {
  test('testClientGenerator', () {
    final options = GenerationOptions();
    final fd = buildFileDescriptor(
        'testpkg', 'testpkg.proto', ['SomeRequest', 'SomeReply']);
    fd.service.add(buildServiceDescriptor());
    final fg = FileGenerator(fd, options);

    final fd2 = buildFileDescriptor(
        'foo.bar', 'foobar.proto', ['EmptyMessage', 'AnotherReply']);
    final fg2 = FileGenerator(fd2, options);

    link(GenerationOptions(), [fg, fg2]);

    final cag = fg.clientApiGenerators[0];

    final writer = IndentingWriter();
    cag.generate(writer);
    expectMatchesGoldenFile(writer.toString(), 'test/goldens/client');
  });
}
