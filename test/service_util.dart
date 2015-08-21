// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library service_util;

import 'package:protoc_plugin/src/descriptor.pb.dart';

ServiceDescriptorProto buildServiceDescriptor() {
  ServiceDescriptorProto sd = new ServiceDescriptorProto()
    ..name = 'Test'
    ..method.addAll([
      new MethodDescriptorProto()
        ..name = 'AMethod'
        ..inputType = '.testpkg.SomeRequest'
        ..outputType = '.testpkg.SomeReply',
      new MethodDescriptorProto()
        ..name = 'AnotherMethod'
        ..inputType = '.foo.bar.EmptyMessage'
        ..outputType = '.foo.bar.AnotherReply',
    ]);
  return sd;
}

FileDescriptorProto buildFileDescriptor(String package, List<String> messages) {
  var fd = new FileDescriptorProto()
    ..package = package
    ..name = 'test';
  for (var name in messages) {
    var md = new DescriptorProto()..name = name;

    fd.messageType.add(md);
  }
  return fd;
}
