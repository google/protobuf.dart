// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/indenting_writer.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/generated/descriptor.pb.dart';
import 'package:protoc_plugin/src/generated/plugin.pb.dart';
import 'package:protoc_plugin/src/linker.dart';
import 'package:protoc_plugin/src/options.dart';
import 'package:test/test.dart';

import 'golden_file.dart';

FileDescriptorProto buildFileDescriptor(
    {bool phoneNumber = true, bool topLevelEnum = false}) {
  final fd = FileDescriptorProto()..name = 'test';

  if (topLevelEnum) {
    fd.enumType.add(EnumDescriptorProto()
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
          ..number = 2
      ]));
  }

  if (phoneNumber) {
    fd.messageType.add(DescriptorProto()
      ..name = 'PhoneNumber'
      ..field.addAll([
        // required string number = 1;
        FieldDescriptorProto()
          ..name = 'number'
          ..jsonName = 'number'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_REQUIRED
          ..type = FieldDescriptorProto_Type.TYPE_STRING,
        // optional int32 type = 2;
        // OR
        // optional PhoneType type = 2;
        FieldDescriptorProto()
          ..name = 'type'
          ..jsonName = 'type'
          ..number = 2
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = topLevelEnum
              ? FieldDescriptorProto_Type.TYPE_ENUM
              : FieldDescriptorProto_Type.TYPE_INT32
          ..typeName = topLevelEnum ? '.PhoneType' : '',
        // optional string name = 3 [default = "$"];
        FieldDescriptorProto()
          ..name = 'name'
          ..jsonName = 'name'
          ..number = 3
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_STRING
          ..defaultValue = r'$'
      ]));
  }
  return fd;
}

FileDescriptorProto createInt64Proto() {
  final fd = FileDescriptorProto()..name = 'test';
  fd.messageType.add(DescriptorProto()
    ..name = 'Int64'
    ..field.add(
      // optional int64 value = 1;
      FieldDescriptorProto()
        ..name = 'value'
        ..jsonName = 'value'
        ..number = 1
        ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
        ..type = FieldDescriptorProto_Type.TYPE_INT64,
    ));

  return fd;
}

void main() {
  test('FileGenerator outputs a .pb.dart file for a proto with one message',
      () {
    final fd = buildFileDescriptor();
    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;
    final fg = FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateMainFile().toString(), 'test/goldens/oneMessage.pb');
  });

  test('FileGenerator outputs a .pb.dart file for an Int64 message', () {
    final fd = createInt64Proto();
    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;
    final fg = FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateMainFile().toString(), 'test/goldens/int64.pb');
  });

  test(
      'FileGenerator outputs a .pb.dart.meta file for a proto with one message',
      () {
    final fd = buildFileDescriptor();
    final options = parseGenerationOptions(
        CodeGeneratorRequest()
          ..parameter = 'generate_kythe_info,disable_constructor_args',
        CodeGeneratorResponse())!;
    final fg = FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(fg.generateMainFile().sourceLocationInfo.toString(),
        'test/goldens/oneMessage.pb.meta');
  });

  test('FileGenerator outputs a pbjson.dart file for a proto with one message',
      () {
    final fd = buildFileDescriptor();
    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;
    final fg = FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateJsonFile(), 'test/goldens/oneMessage.pbjson');
  });

  test('FileGenerator generates files for a top-level enum', () {
    final fd = buildFileDescriptor(phoneNumber: false, topLevelEnum: true);
    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;

    final fg = FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateMainFile().toString(), 'test/goldens/topLevelEnum.pb');
    expectMatchesGoldenFile(
        fg.generateEnumFile().toString(), 'test/goldens/topLevelEnum.pbenum');
  });

  test('FileGenerator generates metadata files for a top-level enum', () {
    final fd = buildFileDescriptor(phoneNumber: false, topLevelEnum: true);
    final options = parseGenerationOptions(
        CodeGeneratorRequest()
          ..parameter = 'generate_kythe_info,disable_constructor_args',
        CodeGeneratorResponse())!;
    final fg = FileGenerator(fd, options);
    link(options, [fg]);

    expectMatchesGoldenFile(fg.generateMainFile().sourceLocationInfo.toString(),
        'test/goldens/topLevelEnum.pb.meta');
    expectMatchesGoldenFile(fg.generateEnumFile().sourceLocationInfo.toString(),
        'test/goldens/topLevelEnum.pbenum.meta');
  });

  test('FileGenerator generates a .pbjson.dart file for a top-level enum', () {
    final fd = buildFileDescriptor(phoneNumber: false, topLevelEnum: true);
    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;

    final fg = FileGenerator(fd, options);
    link(options, [fg]);
    expectMatchesGoldenFile(
        fg.generateJsonFile(), 'test/goldens/topLevelEnum.pbjson');
  });

  test('FileGenerator outputs library for a .proto in a package', () {
    final fd = buildFileDescriptor();
    fd.package = 'pb_library';
    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;

    final fg = FileGenerator(fd, options);
    link(options, [fg]);

    final writer = IndentingWriter(filename: '');
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(
        writer.toString(), 'test/goldens/header_in_package.pb');
  });

  test('FileGenerator outputs a fixnum import when needed', () {
    final fd = FileDescriptorProto()
      ..name = 'test'
      ..messageType.add(DescriptorProto()
        ..name = 'Count'
        ..field.addAll([
          FieldDescriptorProto()
            ..name = 'count'
            ..jsonName = 'count'
            ..number = 1
            ..type = FieldDescriptorProto_Type.TYPE_INT64
        ]));

    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;

    final fg = FileGenerator(fd, options);
    link(options, [fg]);

    final writer = IndentingWriter(filename: '');
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(
        writer.toString(), 'test/goldens/header_with_fixnum.pb');
  });

  test('FileGenerator outputs files for a service', () {
    final empty = DescriptorProto()..name = 'Empty';

    final sd = ServiceDescriptorProto()
      ..name = 'Test'
      ..method.add(MethodDescriptorProto()
        ..name = 'Ping'
        ..inputType = '.Empty'
        ..outputType = '.Empty');

    final fd = FileDescriptorProto()
      ..name = 'test'
      ..messageType.add(empty)
      ..service.add(sd);

    final options = parseGenerationOptions(
        CodeGeneratorRequest()..parameter = 'disable_constructor_args',
        CodeGeneratorResponse())!;

    final fg = FileGenerator(fd, options);
    link(options, [fg]);

    final writer = IndentingWriter(filename: '');
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(
        fg.generateMainFile().toString(), 'test/goldens/service.pb');
    expectMatchesGoldenFile(
        fg.generateServerFile(), 'test/goldens/service.pbserver');
  });

  test('FileGenerator does not output legacy service stubs if gRPC is selected',
      () {
    final empty = DescriptorProto()..name = 'Empty';

    final sd = ServiceDescriptorProto()
      ..name = 'Test'
      ..method.add(MethodDescriptorProto()
        ..name = 'Ping'
        ..inputType = '.Empty'
        ..outputType = '.Empty');

    final fd = FileDescriptorProto()
      ..name = 'test'
      ..messageType.add(empty)
      ..service.add(sd);

    final options = GenerationOptions(useGrpc: true);

    final fg = FileGenerator(fd, options);
    link(options, [fg]);

    final writer = IndentingWriter(filename: '');
    fg.writeMainHeader(writer);
    expectMatchesGoldenFile(
        fg.generateMainFile().toString(), 'test/goldens/grpc_service.pb');
  });

  test('FileGenerator outputs gRPC stubs if gRPC is selected', () {
    final input = DescriptorProto()..name = 'Input';
    final output = DescriptorProto()..name = 'Output';

    final unary = MethodDescriptorProto()
      ..name = 'Unary'
      ..inputType = '.Input'
      ..outputType = '.Output'
      ..clientStreaming = false
      ..serverStreaming = false;
    final clientStreaming = MethodDescriptorProto()
      ..name = 'ClientStreaming'
      ..inputType = '.Input'
      ..outputType = '.Output'
      ..clientStreaming = true
      ..serverStreaming = false;
    final serverStreaming = MethodDescriptorProto()
      ..name = 'ServerStreaming'
      ..inputType = '.Input'
      ..outputType = '.Output'
      ..clientStreaming = false
      ..serverStreaming = true;
    final bidirectional = MethodDescriptorProto()
      ..name = 'Bidirectional'
      ..inputType = '.Input'
      ..outputType = '.Output'
      ..clientStreaming = true
      ..serverStreaming = true;

    final sd = ServiceDescriptorProto()
      ..name = 'Test'
      ..method.addAll([unary, clientStreaming, serverStreaming, bidirectional]);

    final fd = FileDescriptorProto()
      ..name = 'test'
      ..messageType.addAll([input, output])
      ..service.add(sd);

    final options = GenerationOptions(useGrpc: true);

    final fg = FileGenerator(fd, options);
    link(options, [fg]);

    final writer = IndentingWriter(filename: '');
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
    final md1 = DescriptorProto()
      ..name = 'M'
      ..field.addAll([
        // optional M m = 1;
        FieldDescriptorProto()
          ..name = 'm'
          ..jsonName = 'm'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = '.p1.M',
      ]);
    final fd1 = FileDescriptorProto()
      ..package = 'p1'
      ..name = 'package1.proto'
      ..messageType.add(md1);

    // Description of package1.proto.
    final md2 = DescriptorProto()
      ..name = 'M'
      ..field.addAll([
        // optional M m = 1;
        FieldDescriptorProto()
          ..name = 'x'
          ..jsonName = 'x'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = '.p2.M',
      ]);
    final fd2 = FileDescriptorProto()
      ..package = 'p2'
      ..name = 'package2.proto'
      ..messageType.add(md2);

    // Description of test.proto.
    final md = DescriptorProto()
      ..name = 'M'
      ..field.addAll([
        // optional M m = 1;
        FieldDescriptorProto()
          ..name = 'm'
          ..jsonName = 'm'
          ..number = 1
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = '.M',
        // optional p1.M m1 = 2;
        FieldDescriptorProto()
          ..name = 'm1'
          ..jsonName = 'm1'
          ..number = 2
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = '.p1.M',
        // optional p2.M m2 = 3;
        FieldDescriptorProto()
          ..name = 'm2'
          ..jsonName = 'm2'
          ..number = 3
          ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
          ..type = FieldDescriptorProto_Type.TYPE_MESSAGE
          ..typeName = '.p2.M',
      ]);
    final fd = FileDescriptorProto()
      ..name = 'test.proto'
      ..messageType.add(md);
    fd.dependency.addAll(['package1.proto', 'package2.proto']);
    final request = CodeGeneratorRequest()
      ..parameter = 'disable_constructor_args';
    final response = CodeGeneratorResponse();
    final options = parseGenerationOptions(request, response)!;

    final fg = FileGenerator(fd, options);
    link(options,
        [fg, FileGenerator(fd1, options), FileGenerator(fd2, options)]);
    expectMatchesGoldenFile(
        fg.generateMainFile().toString(), 'test/goldens/imports.pb');
    expectMatchesGoldenFile(
        fg.generateEnumFile().toString(), 'test/goldens/imports.pbjson');
  });
}
