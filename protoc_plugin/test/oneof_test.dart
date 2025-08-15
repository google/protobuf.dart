// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'gen/oneof.pb.dart';

void main() {
  test('empty oneof', () {
    final foo = Foo();
    expectOneofNotSet(foo);
  });

  test('set oneof', () {
    final foo = Foo();
    foo.first = 'oneof';
    expectFirstSet(foo);

    foo.second = 1;
    expectSecondSet(foo);

    foo.third = true;
    expect(foo.whichOneofField(), Foo_OneofField.third);
    expect(foo.hasFirst(), false);
    expect(foo.first, '');
    expect(foo.hasSecond(), false);
    expect(foo.second, 0);
    expect(foo.hasThird(), true);
    expect(foo.third, true);
    expect(foo.hasFourth(), false);
    expect(foo.fourth, []);
    expect(foo.hasIndex(), false);
    expect(foo.index, Bar());
    expect(foo.hasValues(), false);
    expect(foo.values, EnumType.DEFAULT);

    foo.fourth = [1, 2];
    expect(foo.whichOneofField(), Foo_OneofField.fourth);
    expect(foo.hasFirst(), false);
    expect(foo.first, '');
    expect(foo.hasSecond(), false);
    expect(foo.second, 0);
    expect(foo.hasThird(), false);
    expect(foo.third, false);
    expect(foo.hasFourth(), true);
    expect(foo.fourth, [1, 2]);
    expect(foo.hasIndex(), false);
    expect(foo.index, Bar());
    expect(foo.hasValues(), false);
    expect(foo.values, EnumType.DEFAULT);

    foo.index = Bar()..i = 1;
    expect(foo.whichOneofField(), Foo_OneofField.index_);
    expect(foo.hasFirst(), false);
    expect(foo.first, '');
    expect(foo.hasSecond(), false);
    expect(foo.second, 0);
    expect(foo.hasThird(), false);
    expect(foo.third, false);
    expect(foo.hasFourth(), false);
    expect(foo.fourth, []);
    expect(foo.hasIndex(), true);
    expect(foo.index, Bar()..i = 1);
    expect(foo.hasValues(), false);
    expect(foo.values, EnumType.DEFAULT);

    foo.values = EnumType.A;
    expect(foo.whichOneofField(), Foo_OneofField.values_);
    expect(foo.hasFirst(), false);
    expect(foo.first, '');
    expect(foo.hasSecond(), false);
    expect(foo.second, 0);
    expect(foo.hasThird(), false);
    expect(foo.third, false);
    expect(foo.hasFourth(), false);
    expect(foo.fourth, []);
    expect(foo.hasIndex(), false);
    expect(foo.index, Bar());
    expect(foo.hasValues(), true);
    expect(foo.values, EnumType.A);
  });

  test('set and clear oneof', () {
    final foo = Foo()..first = 'oneof';
    expectFirstSet(foo);

    foo.clearOneofField();
    expectOneofNotSet(foo);

    foo.first = 'oneof';
    expectFirstSet(foo);

    foo.clearFirst();
    expectOneofNotSet(foo);
  });

  test('serialize and parse oneof', () {
    var foo = Foo()..first = 'oneof';
    expectFirstSet(foo);

    foo = Foo.fromBuffer(foo.writeToBuffer());
    expectFirstSet(foo);
  });

  test('JSON serialize and parse oneof', () {
    var foo = Foo()..second = 1;
    expectSecondSet(foo);

    foo = Foo.fromJson(foo.writeToJson());
    expect(foo.whichOneofField(), Foo_OneofField.second);
    expectSecondSet(foo);
  });

  test('serialize and parse concat oneof', () {
    final foo1 = Foo()..first = 'oneof';
    expectFirstSet(foo1);

    final foo2 = Foo()..second = 1;
    expectSecondSet(foo2);

    final concat = [...foo1.writeToBuffer(), ...foo2.writeToBuffer()];
    expectSecondSet(Foo.fromBuffer(concat));
  });

  test('JSON serialize and parse concat oneof', () {
    final foo1 = Foo()..first = 'oneof';
    expectFirstSet(foo1);

    final foo2 = Foo()..second = 1;
    expectSecondSet(foo2);

    final jsonConcat =
        '${foo2.writeToJson().substring(0, foo2.writeToJson().length - 1)}, '
        '${foo1.writeToJson().substring(1)}';

    final decoded = Foo.fromJson(jsonConcat);

    // It's unclear how to handle the input `{5:..., 1:...}` in this format. In
    // the browsers we want to use the browser's JSON decoder, for performance.
    // However numeric properties in JS objects are always iterated in ascending
    // order, so that makes `5` override the previous oneof value, regardless of
    // the orders of keys in the JSON string. In the backends that have their
    // own map types (VM and Wasm) the key that comes later override the
    // previous one.
    if (identical(1.0, 1)) {
      // In JS: '5' comes last during object key iteration.
      expectSecondSet(decoded);
    } else {
      // In VM and Wasm: '1' comes last during object iteration.
      expectFirstSet(decoded);
    }
  });

  test('set and clear second oneof field', () {
    final foo = Foo();
    expectOneofNotSet(foo);

    foo.red = 'r';
    expect(foo.whichColors(), Foo_Colors.red);
    expect(foo.hasRed(), true);
    expect(foo.red, 'r');
    expect(foo.hasGreen(), false);
    expect(foo.green, '');

    foo.green = 'g';
    expect(foo.whichColors(), Foo_Colors.green);
    expect(foo.hasRed(), false);
    expect(foo.red, '');
    expect(foo.hasGreen(), true);
    expect(foo.green, 'g');
  });

  test('copyWith preserves oneof state', () {
    final foo = Foo();
    expectOneofNotSet(foo);
    final copy1 = foo.deepCopy().freeze().rebuild((_) {}) as Foo;
    expectOneofNotSet(copy1);
    foo.first = 'oneof';
    expectFirstSet(foo);
    final copy2 = foo.deepCopy();
    expectFirstSet(copy2);
  });

  test('oneof semantics is preserved when using ensure method', () {
    final foo = Foo();
    foo.first = 'oneof';
    expectFirstSet(foo);
    foo.ensureIndex();
    expect(foo.hasFirst(), false);
    expect(foo.first, '');
    expect(foo.whichOneofField(), Foo_OneofField.index_);
    expect(foo.hasIndex(), true);
    expect(foo.index, Bar());
  });
}

void expectSecondSet(Foo foo) {
  expect(foo.whichOneofField(), Foo_OneofField.second);
  expect(foo.hasFirst(), false);
  expect(foo.first, '');
  expect(foo.hasSecond(), true);
  expect(foo.second, 1);
  expect(foo.hasThird(), false);
  expect(foo.third, false);
  expect(foo.hasFourth(), false);
  expect(foo.fourth, []);
  expect(foo.hasIndex(), false);
  expect(foo.index, Bar());
  expect(foo.hasValues(), false);
  expect(foo.values, EnumType.DEFAULT);
}

void expectFirstSet(Foo foo) {
  expect(foo.whichOneofField(), Foo_OneofField.first);
  expect(foo.hasFirst(), true);
  expect(foo.first, 'oneof');
  expect(foo.hasSecond(), false);
  expect(foo.second, 0);
  expect(foo.hasThird(), false);
  expect(foo.third, false);
  expect(foo.hasFourth(), false);
  expect(foo.fourth, []);
  expect(foo.hasIndex(), false);
  expect(foo.index, Bar());
  expect(foo.hasValues(), false);
  expect(foo.values, EnumType.DEFAULT);
}

void expectOneofNotSet(Foo foo) {
  expect(foo.whichOneofField(), Foo_OneofField.notSet);
  expect(foo.hasFirst(), false);
  expect(foo.first, '');
  expect(foo.hasSecond(), false);
  expect(foo.second, 0);
  expect(foo.hasThird(), false);
  expect(foo.third, false);
  expect(foo.hasFourth(), false);
  expect(foo.fourth, []);
  expect(foo.hasIndex(), false);
  expect(foo.index, Bar());
  expect(foo.hasValues(), false);
  expect(foo.values, EnumType.DEFAULT);

  expect(foo.whichColors(), Foo_Colors.notSet);
  expect(foo.hasRed(), false);
  expect(foo.red, '');
  expect(foo.hasGreen(), false);
  expect(foo.green, '');
}
