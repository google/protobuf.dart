// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import '../out/protos/entity.pb.dart';
import '../out/protos/nested_message.pb.dart';

void main() {
  test('testFreezingNestedFields', () {
    final top = Top()
      ..nestedMessageList.add(Nested()..a = 1)
      ..nestedMessageMap[1] = (Nested()..a = 2)
      ..nestedMessage = (Nested()..a = 3);

    // Create aliases to lists, maps, nested messages
    final list = top.nestedMessageList;
    final map = top.nestedMessageMap;
    final msg1 = top.nestedMessageList[0];
    final msg2 = top.nestedMessageMap[1]!;
    final msg3 = top.nestedMessage;

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

  test('frozen messages should not be updated by merge methods', () {
    final top = TopEntity()..freeze();

    expect(() => top.mergeFromBuffer(<int>[]),
        throwsA(TypeMatcher<UnsupportedError>()));

    expect(() => top.mergeFromJsonMap({}),
        throwsA(TypeMatcher<UnsupportedError>()));

    expect(() => top.mergeFromMessage(TopEntity()),
        throwsA(TypeMatcher<UnsupportedError>()));

    expect(() => top.mergeFromProto3Json({}),
        throwsA(TypeMatcher<UnsupportedError>()));
  });

  test('nested frozen messages should not be updated by merge methods', () {
    // Check that recursive calls to merge methods check mutability.
    // `mergeFromJsonMap` cannot be tested because of #726.

    {
      final top = TopEntity()..sub = (SubEntity()..freeze());

      top.mergeFromBuffer(<int>[
        (1 << 3) | 0, // tag = 1, type = varint
        123, // int64 id = 123
      ]);
      expect(top.id, Int64(123));

      expect(
          () => top.mergeFromBuffer(<int>[
                (4 << 3) | 2, // tag = 4, type = length delimited
                2, // length
                (1 << 3) | 0, // tag = 1, type = varint
                123, // int64 id = 123
              ]),
          throwsA(TypeMatcher<UnsupportedError>()));
    }

    {
      final top = TopEntity()..sub = (SubEntity()..freeze());

      top.mergeFromMessage(TopEntity()..id = Int64(123));
      expect(top.id, Int64(123));

      expect(
          () => top.mergeFromMessage(
              TopEntity()..sub = (SubEntity()..id = Int64(123))),
          throwsA(TypeMatcher<UnsupportedError>()));
    }

    {
      final top = TopEntity()..sub = (SubEntity()..freeze());

      top.mergeFromProto3Json({'id': 123});
      expect(top.id, Int64(123));

      expect(
          () => top.mergeFromProto3Json({
                'sub': {'id': 123}
              }),
          throwsA(TypeMatcher<UnsupportedError>()));
    }
  });
}
