// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

class Foo extends GeneratedMessage<Foo> {
  @override
  // TODO: implement info_
  BuilderInfo<Foo> get info_ => null;
}

main() {
  group('className', () {
    final qualifiedmessageName = 'proto.test.TestMessage';
    final expectedMessageName = 'TestMessage';
    test('truncates qualifiedMessageName containing dots', () {
      final info = new BuilderInfo<Foo>(qualifiedmessageName);
      expect(info.messageName, expectedMessageName);
    });

    test('uses qualifiedMessageName if it contains no dots', () {
      final info = new BuilderInfo<Foo>(expectedMessageName);
      expect(info.messageName, expectedMessageName);
    });
  });
}
