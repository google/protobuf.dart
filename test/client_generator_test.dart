#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library client_generator_test;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:test/test.dart';

import 'service_util.dart';

void main() {
  test('testClientGenerator', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
class TestApi {
  RpcClient _client;
  TestApi(this._client);

  Future<SomeReply> aMethod(ClientContext ctx, SomeRequest request) {
    var emptyResponse = new SomeReply();
    return _client.invoke<SomeReply>(ctx, 'Test', 'AMethod', request, emptyResponse);
  }
  Future<$foo$bar.AnotherReply> anotherMethod(ClientContext ctx, $foo$bar.EmptyMessage request) {
    var emptyResponse = new $foo$bar.AnotherReply();
    return _client.invoke<$foo$bar.AnotherReply>(ctx, 'Test', 'AnotherMethod', request, emptyResponse);
  }
}

''';
    var options = new GenerationOptions();
    var fd = buildFileDescriptor("testpkg", ["SomeRequest", "SomeReply"]);
    fd.service.add(buildServiceDescriptor());
    var fg = new FileGenerator(fd, options);

    var fd2 = buildFileDescriptor("foo.bar", ["EmptyMessage", "AnotherReply"]);
    var fg2 = new FileGenerator(fd2, options);

    link(new GenerationOptions(), [fg, fg2]);

    ClientApiGenerator cag = fg.clientApiGenerators[0];

    IndentingWriter writer = new IndentingWriter();
    cag.generate(writer);
    expect(writer.toString(), expected);
  });
}
