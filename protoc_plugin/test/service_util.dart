// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/src/generated/descriptor.pb.dart';

ServiceDescriptorProto buildServiceDescriptor() {
  final sd = ServiceDescriptorProto()
    ..name = 'Test'
    ..method.addAll([
      MethodDescriptorProto()
        ..name = 'AMethod'
        ..inputType = '.testpkg.SomeRequest'
        ..outputType = '.testpkg.SomeReply',
      MethodDescriptorProto()
        ..name = 'AnotherMethod'
        ..inputType = '.foo.bar.EmptyMessage'
        ..outputType = '.foo.bar.AnotherReply',
    ]);
  return sd;
}

FileDescriptorProto buildFileDescriptor(
    String package, String fileUri, List<String> messages) {
  final fd = FileDescriptorProto()
    ..package = package
    ..name = fileUri;
  for (final name in messages) {
    final md = DescriptorProto()..name = name;

    fd.messageType.add(md);
  }
  return fd;
}
