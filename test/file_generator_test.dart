#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library file_generator_test;

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/src/descriptor.pb.dart';
import 'package:protoc_plugin/src/plugin.pb.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:test/test.dart';

import 'golden_file.dart';

FileDescriptorProto buildFileDescriptor(
    {phoneNumber = true, topLevelEnum = false}) {
  FileDescriptorProto fd = new FileDescriptorProto()..name = 'test';

  if (topLevelEnum) {
    fd.enumType.add(new EnumDescriptorProto()
      ..name = 'PhoneType'
      ..value.addAll([
        new EnumValueDescriptorProto()
          ..name = 'MOBILE'
          ..number = 0,
        new EnumValueDescriptorProto()
          ..name = 'HOME'
          ..number = 1,
        new EnumValueDescriptorProto()
          ..name = 'WORK'
          ..number = 2,
        new EnumValueDescriptorProto()
          ..name = 'BUSINESS'
          ..number = 2
      ]));
  }

  if (phoneNumber) {
    fd.messageType.add(new DescriptorProto()
      ..name = 'PhoneNumber'
      ..field.addAll([
        // required string number = 1;
        new FieldDescriptorProto()
          ..name = 'number'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_REQUIRED
          ..type = FieldDescriptorProto_Type.TYPE_STRING,
        // optional int32 type = 2;
        // OR
        // optional PhoneType type = 2;
        new FieldDescriptorProto()
          ..name = 'type'
          ..number = 2
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = topLevelEnum
              ? FieldDescriptorProto_Type.TYPE_ENUM
              : FieldDescriptorProto_Type.TYPE_INT32
          ..typeName = topLevelEnum ? '.PhoneType' : '',
        // optional string name = 3 [default = "$"];
        new FieldDescriptorProto()
          ..name = 'name'
          ..number = 3
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_STRING
          ..defaultValue = r'$'
      ]));
  }

  return fd;
}

void main() {
  test('FileGenerator outputs a .pb.dart file for a proto with one message',
      () {
    FileDescriptorProto fd = buildFileDescriptor();
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());
    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateMainFile(), 'test/goldens/oneMessage.pb');
  });

  test('FileGenerator outputs a pbjson.dart file for a proto with one message',
      () {
    FileDescriptorProto fd = buildFileDescriptor();
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());
    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateJsonFile(), 'test/goldens/oneMessage.pbjson');
  });

  test('FileGenerator generates files for a top-level enum', () {
    FileDescriptorProto fd =
        buildFileDescriptor(phoneNumber: false, topLevelEnum: true);
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());

    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateMainFile(), 'test/goldens/topLevelEnum.pb');
    expectMatchesGoldenFile(
        fg.generateEnumFile(), 'test/goldens/topLevelEnum.pbenum');
  });

  test('FileGenerator generates a .pbjson.dart file for a top-level enum', () {
    FileDescriptorProto fd =
        buildFileDescriptor(phoneNumber: false, topLevelEnum: true);
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());

    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateJsonFile(), 'test/goldens/topLevelEnum.pbjson');
  });

  test('FileGenerator outputs library for a .proto in a package', () {
    FileDescriptorProto fd = buildFileDescriptor();
    fd.package = "pb_library";
    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());

    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);

    var writer = new IndentingWriter();
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(
        writer.toString(), 'test/goldens/header_in_package.pb');
  });

  test('FileGenerator outputs a fixnum import when needed', () {
    FileDescriptorProto fd = new FileDescriptorProto()
      ..name = 'test'
      ..messageType.add(new DescriptorProto()
        ..name = 'Count'
        ..field.addAll([
          new FieldDescriptorProto()
            ..name = 'count'
            ..number = 1
            ..type = FieldDescriptorProto_Type.TYPE_INT64
        ]));

    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());

    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);

    var writer = new IndentingWriter();
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(
        writer.toString(), 'test/goldens/header_with_fixnum.pb');
  });

  test('FileGenerator outputs files for a service', () {
    DescriptorProto empty = new DescriptorProto()..name = "Empty";

    ServiceDescriptorProto sd = new ServiceDescriptorProto()
      ..name = 'Test'
      ..method.add(new MethodDescriptorProto()
        ..name = 'Ping'
        ..inputType = '.Empty'
        ..outputType = '.Empty');

    FileDescriptorProto fd = new FileDescriptorProto()
      ..name = 'test'
      ..messageType.add(empty)
      ..service.add(sd);

    var options = parseGenerationOptions(
        new CodeGeneratorRequest(), new CodeGeneratorResponse());

    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);

    var writer = new IndentingWriter();
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(fg.generateMainFile(), 'test/goldens/service.pb');
    expectMatchesGoldenFile(
        fg.generateServerFile(), 'test/goldens/service.pbserver');
  });

  test('FileGenerator does not output legacy service stubs if gRPC is selected',
      () {
    DescriptorProto empty = new DescriptorProto()..name = "Empty";

    ServiceDescriptorProto sd = new ServiceDescriptorProto()
      ..name = 'Test'
      ..method.add(new MethodDescriptorProto()
        ..name = 'Ping'
        ..inputType = '.Empty'
        ..outputType = '.Empty');

    FileDescriptorProto fd = new FileDescriptorProto()
      ..name = 'test'
      ..messageType.add(empty)
      ..service.add(sd);

    var options = new GenerationOptions(useGrpc: true);

    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);

    var writer = new IndentingWriter();
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(
        fg.generateMainFile(), 'test/goldens/grpc_service.pb');
  });

  test('FileGenerator outputs gRPC stubs if gRPC is selected', () {
    final input = new DescriptorProto()..name = 'Input';
    final output = new DescriptorProto()..name = 'Output';

    final unary = new MethodDescriptorProto()
      ..name = 'Unary'
      ..inputType = '.Input'
      ..outputType = '.Output'
      ..clientStreaming = false
      ..serverStreaming = false;
    final clientStreaming = new MethodDescriptorProto()
      ..name = 'ClientStreaming'
      ..inputType = '.Input'
      ..outputType = '.Output'
      ..clientStreaming = true
      ..serverStreaming = false;
    final serverStreaming = new MethodDescriptorProto()
      ..name = 'ServerStreaming'
      ..inputType = '.Input'
      ..outputType = '.Output'
      ..clientStreaming = false
      ..serverStreaming = true;
    final bidirectional = new MethodDescriptorProto()
      ..name = 'Bidirectional'
      ..inputType = '.Input'
      ..outputType = '.Output'
      ..clientStreaming = true
      ..serverStreaming = true;

    ServiceDescriptorProto sd = new ServiceDescriptorProto()
      ..name = 'Test'
      ..method.addAll([unary, clientStreaming, serverStreaming, bidirectional]);

    FileDescriptorProto fd = new FileDescriptorProto()
      ..name = 'test'
      ..messageType.addAll([input, output])
      ..service.add(sd);

    var options = new GenerationOptions(useGrpc: true);

    FileGenerator fg = new FileGenerator(fd, options);
    link(options, [fg]);

    var writer = new IndentingWriter();
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(
        fg.generateGrpcFile(), 'test/goldens/grpc_service.pbgrpc');
  });

  test('FileGenerator generates imports for .pb.dart files', () {
    // This defines three .proto files package1.proto, package2.proto and
    // test.proto with the following content:
    //
    // package1.proto:
    // ---------------
    // package p1;
    // message M {
    //   optional M m = 2;
    // }
    //
    // package2.proto:
    // ---------------
    // package p2;
    // message M {
    //   optional M m = 2;
    // }
    //
    // test.proto:
    // ---------------
    // package test;
    // import "package1.proto";
    // import "package2.proto";
    // message M {
    //   optional M m = 1;
    //   optional p1.M m1 = 2;
    //   optional p2.M m2 = 3;
    // }

    // Description of package1.proto.
    DescriptorProto md1 = new DescriptorProto()
      ..name = 'M'
      ..field.addAll([
        // optional M m = 1;
        new FieldDescriptorProto()
          ..name = 'm'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = ".p1.M",
      ]);
    FileDescriptorProto fd1 = new FileDescriptorProto()
      ..package = 'p1'
      ..name = 'package1.proto'
      ..messageType.add(md1);

    // Description of package1.proto.
    DescriptorProto md2 = new DescriptorProto()
      ..name = 'M'
      ..field.addAll([
        // optional M m = 1;
        new FieldDescriptorProto()
          ..name = 'x'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = ".p2.M",
      ]);
    FileDescriptorProto fd2 = new FileDescriptorProto()
      ..package = 'p2'
      ..name = 'package2.proto'
      ..messageType.add(md2);

    // Description of test.proto.
    DescriptorProto md = new DescriptorProto()
      ..name = 'M'
      ..field.addAll([
        // optional M m = 1;
        new FieldDescriptorProto()
          ..name = 'm'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = ".M",
        // optional p1.M m1 = 2;
        new FieldDescriptorProto()
          ..name = 'm1'
          ..number = 2
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = ".p1.M",
        // optional p2.M m2 = 3;
        new FieldDescriptorProto()
          ..name = 'm2'
          ..number = 3
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = ".p2.M",
      ]);
    FileDescriptorProto fd = new FileDescriptorProto()
      ..name = 'test.proto'
      ..messageType.add(md);
    fd.dependency.addAll(['package1.proto', 'package2.proto']);
    var request = new CodeGeneratorRequest();
    var response = new CodeGeneratorResponse();
    var options = parseGenerationOptions(request, response);

    FileGenerator fg = new FileGenerator(fd, options);
    link(options,
        [fg, new FileGenerator(fd1, options), new FileGenerator(fd2, options)]);
    expectMatchesGoldenFile(fg.generateMainFile(), 'test/goldens/imports.pb');
    expectMatchesGoldenFile(
        fg.generateEnumFile(), 'test/goldens/imports.pbjson');
  });
}
