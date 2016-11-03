#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library service_generator_test;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:test/test.dart';
import 'service_util.dart';

void main() {
  test('testServiceGenerator', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
abstract class TestServiceBase extends GeneratedService {
  Future<SomeReply> aMethod(ServerContext ctx, SomeRequest request);
  Future<foo$bar.AnotherReply> anotherMethod(ServerContext ctx, foo$bar.EmptyMessage request);

  GeneratedMessage createRequest(String method) {
    switch (method) {
      case 'AMethod': return new SomeRequest();
      case 'AnotherMethod': return new foo$bar.EmptyMessage();
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

  Future<GeneratedMessage> handleCall(ServerContext ctx, String method, GeneratedMessage request) {
    switch (method) {
      case 'AMethod': return this.aMethod(ctx, request);
      case 'AnotherMethod': return this.anotherMethod(ctx, request);
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

  Map<String, dynamic> get $json => Test$json;
  Map<String, dynamic> get $messageJson => Test$messageJson;
}

''';

    var fd = buildFileDescriptor("testpkg", ["SomeRequest", "SomeReply"]);
    fd.service.add(buildServiceDescriptor());
    var fg = new FileGenerator(fd);

    var fd2 = buildFileDescriptor("foo.bar", ["EmptyMessage", "AnotherReply"]);
    var fg2 = new FileGenerator(fd2);

    link(new GenerationOptions(), [fg, fg2]);

    var writer = new IndentingWriter();
    fg.serviceGenerators[0].generate(writer);
    expect(writer.toString(), expected);
  });
}
