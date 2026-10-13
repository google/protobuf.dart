// Copyright (c) 2020, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:isolate';

import 'package:test/test.dart';

import 'gen/foo.pb.dart';
import 'gen/map_field.pb.dart' as map;
import 'gen/oneof.pb.dart' as oneof;

Future<T> sendReceive<T>(T object) async {
  final rp = ReceivePort();
  rp.sendPort.send(object);
  return (await rp.first) as T;
}

void main() async {
  test('Normal proto can be transferred via ports', () async {
    final object =
        Outer()
          ..inner = (Inner()..value = 'pip')
          ..inners.add(Inner()..value = 'pop');

    final clone = await sendReceive(object);

    // Ensure the clone is actually containing the same data.
    expect(clone, equals(object));
    expect(clone.toString(), equals(object.toString()));
    expect(clone.toDebugString(), equals(object.toDebugString()));
    expect(clone.writeToBuffer(), equals(object.writeToBuffer()));

    // Ensure the actual objects got transitively cloned, but the metadata in
    // the `_info_` did not get cloned.
    expect(!identical(object, clone), true);
    expect(!identical(object.inner, clone.inner), true);
    expect(identical(object.info_, clone.info_), true);
  }, onPlatform: {'js': Skip('dart:isolate only works on Dart VM')});

  test('Map-using proto can be transferred via ports', () async {
    final object =
        map.TestMap()
          ..int32ToMessageField[42] =
              (map.TestMap_MessageValue()
                ..value = 1
                ..secondValue = 2);

    final clone = await sendReceive(object);

    // Ensure the clone is actually containing the same data.
    expect(clone, equals(object));
    expect(clone.toString(), equals(object.toString()));
    expect(clone.toDebugString(), equals(object.toDebugString()));
    expect(clone.writeToBuffer(), equals(object.writeToBuffer()));

    // Ensure the actual objects got transitively cloned, but the metadata in
    // the `_info_` did not get cloned.
    expect(!identical(object, clone), true);
    expect(identical(object.info_, clone.info_), true);
  }, onPlatform: {'js': Skip('dart:isolate only works on Dart VM')});

  test('Oneof state survives transfer via ports', () async {
    final object =
        oneof.Foo()
          ..index = (oneof.Bar()..i = 1)
          ..green = 'g';

    final clone = await sendReceive(object);

    expect(clone, equals(object));
    expect(clone.whichOneofField(), oneof.Foo_OneofField.index_);
    expect(clone.whichColors(), oneof.Foo_Colors.green);

    clone.first = 'a';
    expect(clone.hasIndex(), isFalse);
    expect(object.whichOneofField(), oneof.Foo_OneofField.index_);
  }, onPlatform: {'js': Skip('dart:isolate only works on Dart VM')});

  test('Oneof state is derived the same way in another isolate', () async {
    final buffer =
        (oneof.Foo()
              ..first = 'a'
              ..second = 2
              ..red = 'r')
            .writeToBuffer();

    // The other isolate builds its own copy of the oneof metadata.
    final cases = await Isolate.run(() {
      final foo = oneof.Foo.fromBuffer(buffer);
      return [foo.whichOneofField().name, foo.whichColors().name];
    });
    expect(cases, ['second', 'red']);
  }, onPlatform: {'js': Skip('dart:isolate only works on Dart VM')});
}
