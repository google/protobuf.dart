#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library service_generator_test;

import 'package:protoc_plugin/src/descriptor.pb.dart';
import 'package:protoc_plugin/src/plugin.pb.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:unittest/unittest.dart';

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
  test('testServiceGenerator', () {
    // NOTE: Below > 80 cols because it is matching generated code > 80 cols.
    String expected = r'''
abstract class TestServiceBase extends GeneratedService {
  Future<SomeReply> aMethod(ServerContext ctx, SomeRequest request);
  Future<AnotherReply> anotherMethod(ServerContext ctx, EmptyMessage request);

  GeneratedMessage createRequest(String method) {
    switch (method) {
      case 'AMethod': return new SomeRequest();
      case 'AnotherMethod': return new EmptyMessage();
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

  Future<GeneratedMessage> handleCall(ServerContext ctx, String method, GeneratedMessage request) {
    switch (method) {
      case 'AMethod': return aMethod(ctx, request);
      case 'AnotherMethod': return anotherMethod(ctx, request);
      default: throw new ArgumentError('Unknown method: $method');
    }
  }

}

''';
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());
    var context =
        new GenerationContext(options, new DefaultOutputConfiguration());
    var fd = new FileDescriptorProto();
    var fg = new FileGenerator(fd, null, context);
    ServiceDescriptorProto sd = buildServiceDescriptor();
    MemoryWriter buffer = new MemoryWriter();
    IndentingWriter writer = new IndentingWriter('  ', buffer);
    var sg = new ServiceGenerator(sd, fg, context);
    sg.generate(writer);
    expect(buffer.toString(), expected);
  });
}
