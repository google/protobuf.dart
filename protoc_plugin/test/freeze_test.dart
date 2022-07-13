// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import '../out/protos/nested_message.pb.dart';

void main() {
  test('testFreezingNestedFields', () {
    final top = Top()
      ..nestedMessageList.add(Nested()..a = 1)
      ..nestedMessageMap[1] = (Nested()..a = 2)
      ..nestedMessage = (Nested()..a = 3);

    // Create aliases to lists, maps, nested messages
    var list = top.nestedMessageList;
    var map = top.nestedMessageMap;
    var msg1 = top.nestedMessageList[0];
    var msg2 = top.nestedMessageMap[1]!;
    var msg3 = top.nestedMessage;

    top.freeze();

    expect(top.isFrozen, true);

    // Check list field
    expect(top.nestedMessageList.length, 1);
    expect(top.nestedMessageList[0].isFrozen, true);
    expect(() => top.nestedMessageList.add(Nested()..a = 0),
        throwsA(const TypeMatcher<UnsupportedError>()));

    // Check map field
    expect(top.nestedMessageMap.length, 1);
    expect(top.nestedMessageMap[1]!.isFrozen, true);
    expect(() => top.nestedMessageMap[2] = Nested()..a = 0,
        throwsA(const TypeMatcher<UnsupportedError>()));
    expect(() => map[0] = Nested()..a = 0,
        throwsA(const TypeMatcher<UnsupportedError>()));

    // Check message field
    expect(top.nestedMessage.isFrozen, true);

    // Check aliases
    expect(() => list.add(Nested()..a = 0),
        throwsA(const TypeMatcher<UnsupportedError>()));
    expect(() => map[123] = Nested()..a = 0,
        throwsA(const TypeMatcher<UnsupportedError>()));
    expect(list[0].isFrozen, true);
    expect(map[1]!.isFrozen, true);
    expect(msg1.isFrozen, true);
    expect(msg2.isFrozen, true);
    expect(msg3.isFrozen, true);
  });
}
