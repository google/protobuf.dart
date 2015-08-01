#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library client_generator_test;

import 'package:protoc_plugin/src/descriptor.pb.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:test/test.dart';

ServiceDescriptorProto buildServiceDescriptor() {
  ServiceDescriptorProto sd = new ServiceDescriptorProto()
    ..name = 'Test'
    ..method.addAll([
      new MethodDescriptorProto()
        ..name = 'AMethod'
        ..inputType = 'SomeRequest'
        ..outputType = 'SomeReply',
      new MethodDescriptorProto()
        ..name = 'AnotherMethod'
        ..inputType = '.foo.bar.EmptyMessage'
        ..outputType = '.foo.bar.AnotherReply',
    ]);
  return sd;
}

void main() {
  test('testClientGenerator', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
class TestApi {
  RpcClient _client;
  TestApi(this._client);

  Future<SomeReply> aMethod(ClientContext ctx, SomeRequest request) {
    var emptyResponse = new SomeReply();
    return _client.invoke(ctx, 'Test', 'AMethod', request, emptyResponse);
  }
  Future<AnotherReply> anotherMethod(ClientContext ctx, EmptyMessage request) {
    var emptyResponse = new AnotherReply();
    return _client.invoke(ctx, 'Test', 'AnotherMethod', request, emptyResponse);
  }
}

''';
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    ClientApiGenerator cag = new ClientApiGenerator(buildServiceDescriptor());
    cag.generate(writer);
    expect(buffer.toString(), expected);
  });
}
