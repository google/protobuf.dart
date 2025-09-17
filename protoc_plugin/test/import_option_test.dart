// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'gen/custom_option.pb.dart';
import 'gen/import_option.pbjson.dart';
import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protoc_plugin/src/gen/google/protobuf/descriptor.pb.dart';
import 'package:test/test.dart';

void main() {
  test('can read custom options from linked import option', () {
    final registry = ExtensionRegistry()..add(Custom_option.myOption);
    final descriptor = DescriptorProto.fromBuffer(
      messageWithOptionsDescriptor,
      registry,
    );
    final option = descriptor.options.getExtension(Custom_option.myOption);
    expect(option, 'Hello world!');
  });

  test('unlinked options are in unknown fields', () {
    final registry = ExtensionRegistry()..add(Custom_option.myOption);
    final descriptor = DescriptorProto.fromBuffer(
      messageWithOptionsDescriptor,
      registry,
    );
    final ufs = descriptor.options.unknownFields;
    expect(ufs.hasField(51235), true);
    expect(ufs.getField(51235)!.varints.length, 1);
    expect(ufs.getField(51235)!.varints.first, Int64(99));
  });
}
