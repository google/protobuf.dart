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

    foo.first = 'oneof';
    expectFirstSet(foo);

    foo.clear();
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

  group('active member is derived from field values', () {
    test('a member set to its default value is active', () {
      expect((Foo()..first = '').whichOneofField(), Foo_OneofField.first);
      expect((Foo()..second = 0).whichOneofField(), Foo_OneofField.second);
      expect((Foo()..third = false).whichOneofField(), Foo_OneofField.third);
      expect((Foo()..fourth = []).whichOneofField(), Foo_OneofField.fourth);
      expect((Foo()..index = Bar()).whichOneofField(), Foo_OneofField.index_);
      expect(
        (Foo()..values = EnumType.DEFAULT).whichOneofField(),
        Foo_OneofField.values_,
      );
      expect((Foo()..red = '').whichColors(), Foo_Colors.red);
    });

    test('a member set to its default value survives a binary round trip', () {
      for (final foo in [
        Foo()..first = '',
        Foo()..second = 0,
        Foo()..third = false,
        Foo()..fourth = [],
        Foo()..index = Bar(),
        Foo()..values = EnumType.DEFAULT,
      ]) {
        final decoded = Foo.fromBuffer(foo.writeToBuffer());
        expect(decoded.whichOneofField(), foo.whichOneofField());
      }
    });

    test('reading an unset member does not make it active', () {
      final foo = Foo()..first = 'a';
      expect(foo.second, 0);
      expect(foo.fourth, isEmpty);
      expect(foo.index, Bar());
      expect(foo.values, EnumType.DEFAULT);
      expect(foo.whichOneofField(), Foo_OneofField.first);
      expect(foo.first, 'a');
    });

    test('setting a member clears the previously active member', () {
      final foo =
          Foo()
            ..first = 'a'
            ..second = 2;
      expect(foo.whichOneofField(), Foo_OneofField.second);
      expect(foo.hasFirst(), isFalse);
      expect(foo.getFieldOrNull(1), isNull);
      // The cleared member is not encoded.
      expect(foo.writeToBuffer(), (Foo()..second = 2).writeToBuffer());
    });

    test('setting the active member again keeps it active', () {
      final foo =
          Foo()
            ..second = 1
            ..second = 2;
      expect(foo.whichOneofField(), Foo_OneofField.second);
      expect(foo.second, 2);
    });

    test('clearing the active member unsets the oneof', () {
      final foo = Foo()..second = 2;
      foo.clearSecond();
      expect(foo.whichOneofField(), Foo_OneofField.notSet);

      foo.index = Bar();
      foo.clearField(8);
      expect(foo.whichOneofField(), Foo_OneofField.notSet);
    });

    test('clearing a member that is not active keeps the active member', () {
      final foo = Foo()..second = 2;
      foo.clearFirst();
      expect(foo.whichOneofField(), Foo_OneofField.second);
      expect(foo.second, 2);

      foo.clearField(8);
      expect(foo.whichOneofField(), Foo_OneofField.second);
      expect(foo.writeToBuffer(), (Foo()..second = 2).writeToBuffer());
    });

    test('clearing an unset oneof does nothing', () {
      final foo = Foo()..red = 'r';
      foo.clearOneofField();
      expect(foo.whichOneofField(), Foo_OneofField.notSet);
      expect(foo.whichColors(), Foo_Colors.red);
    });

    test('clear() unsets every oneof', () {
      final foo =
          Foo()
            ..index = (Bar()..i = 1)
            ..green = 'g';
      foo.clear();
      expectOneofNotSet(foo);
    });

    test('oneofs in one message are independent', () {
      final foo =
          Foo()
            ..first = 'a'
            ..red = 'r';
      foo.second = 2;
      expect(foo.whichColors(), Foo_Colors.red);
      expect(foo.red, 'r');

      foo.green = 'g';
      expect(foo.whichOneofField(), Foo_OneofField.second);
      expect(foo.second, 2);

      foo.clearColors();
      expect(foo.whichColors(), Foo_Colors.notSet);
      expect(foo.whichOneofField(), Foo_OneofField.second);
    });

    test('setField and clearField keep oneof semantics', () {
      final foo = Foo()..setField(1, 'a');
      expect(foo.whichOneofField(), Foo_OneofField.first);

      foo.setField(8, Bar()..i = 1);
      expect(foo.whichOneofField(), Foo_OneofField.index_);
      expect(foo.hasField(1), isFalse);

      foo.clearField(8);
      expect(foo.whichOneofField(), Foo_OneofField.notSet);
    });

    test('decoding two members of one oneof keeps the last one', () {
      final first = (Foo()..first = 'a').writeToBuffer();
      final second = (Foo()..second = 2).writeToBuffer();
      final third = (Foo()..third = true).writeToBuffer();

      expect(
        Foo.fromBuffer([...second, ...first]).whichOneofField(),
        Foo_OneofField.first,
      );

      final decoded = Foo.fromBuffer([...first, ...third, ...second]);
      expect(decoded.whichOneofField(), Foo_OneofField.second);
      expect(decoded.hasFirst(), isFalse);
      expect(decoded.hasThird(), isFalse);
      expect(decoded.writeToBuffer(), second);
    });

    test('a message member is merged on decode only while it is active', () {
      final withChild = (Foo()..index = (Bar()..i = 1)).writeToBuffer();
      final emptyChild = (Foo()..index = Bar()).writeToBuffer();
      final first = (Foo()..first = 'a').writeToBuffer();

      // The same member twice: the sub-messages are merged.
      expect(Foo.fromBuffer([...withChild, ...emptyChild]).index.i, 1);

      // Another member in between: the last sub-message starts empty.
      final decoded = Foo.fromBuffer([...withChild, ...first, ...emptyChild]);
      expect(decoded.whichOneofField(), Foo_OneofField.index_);
      expect(decoded.index.i, 0);
      expect(decoded.hasFirst(), isFalse);
    });

    test('decoding into a message replaces its active member', () {
      final foo =
          Foo()
            ..first = 'a'
            ..red = 'r';
      foo.mergeFromBuffer((Foo()..second = 2).writeToBuffer());
      expect(foo.whichOneofField(), Foo_OneofField.second);
      expect(foo.hasFirst(), isFalse);
      expect(foo.whichColors(), Foo_Colors.red);
    });

    test('mergeFromMessage takes the other message\'s active member', () {
      final foo =
          Foo()
            ..first = 'a'
            ..red = 'r';
      foo.mergeFromMessage(Foo()..second = 2);
      expect(foo.whichOneofField(), Foo_OneofField.second);
      expect(foo.hasFirst(), isFalse);
      // A oneof that is unset in the other message is kept.
      expect(foo.whichColors(), Foo_Colors.red);
    });

    test('mergeFromMessage merges a message member both have set', () {
      final child = Bar();
      final foo = Foo()..index = child;
      foo.mergeFromMessage(Foo()..index = (Bar()..i = 3));
      expect(foo.whichOneofField(), Foo_OneofField.index_);
      expect(foo.index, same(child));
      expect(foo.index.i, 3);
    });

    test('deepCopy keeps the oneof state and is independent', () {
      final foo =
          Foo()
            ..index = (Bar()..i = 1)
            ..green = 'g';
      final copy = foo.deepCopy();
      expect(copy.whichOneofField(), Foo_OneofField.index_);
      expect(copy.whichColors(), Foo_Colors.green);
      expect(copy, foo);

      copy.first = 'a';
      copy.clearColors();
      expect(copy.whichOneofField(), Foo_OneofField.first);
      expect(foo.whichOneofField(), Foo_OneofField.index_);
      expect(foo.whichColors(), Foo_Colors.green);
      expect(foo.index.i, 1);
    });

    test('a frozen message reports its oneof and rejects changes', () {
      final frozen =
          (Foo()
              ..first = 'a'
              ..red = 'r')
            ..freeze();
      expect(frozen.whichOneofField(), Foo_OneofField.first);
      expect(() => frozen.second = 2, throwsUnsupportedError);
      expect(() => frozen.index = Bar(), throwsUnsupportedError);
      expect(() => frozen.setField(5, 2), throwsUnsupportedError);
      expect(frozen.ensureIndex, throwsUnsupportedError);
      expect(frozen.clearFirst, throwsUnsupportedError);
      expect(frozen.clearOneofField, throwsUnsupportedError);
      expect(frozen.whichOneofField(), Foo_OneofField.first);
      expect(frozen.first, 'a');

      final rebuilt = frozen.rebuild((foo) => foo.second = 2);
      expect(rebuilt.whichOneofField(), Foo_OneofField.second);
      expect(rebuilt.whichColors(), Foo_Colors.red);
      expect(frozen.whichOneofField(), Foo_OneofField.first);

      final builder = frozen.toBuilder() as Foo;
      builder.clearFirst();
      expect(builder.whichOneofField(), Foo_OneofField.notSet);
      expect(frozen.whichOneofField(), Foo_OneofField.first);
    });

    test('messages that are equal have the same oneof state', () {
      final switched =
          Foo()
            ..first = 'a'
            ..index = Bar()
            ..second = 2;
      final direct = Foo()..second = 2;
      expect(switched, direct);
      expect(switched.hashCode, direct.hashCode);
      expect(switched.whichOneofField(), direct.whichOneofField());
      expect(Foo()..second = 0, isNot(Foo()));
    });

    test('JSON round trips keep the active member', () {
      for (final foo in [
        Foo()..first = 'a',
        Foo()..second = 2,
        Foo()..index = (Bar()..i = 1),
        Foo()..values = EnumType.A,
        Foo()..fourth = [1],
        Foo()..green = 'g',
      ]) {
        final fromJson = Foo.fromJson(foo.writeToJson());
        expect(fromJson.whichOneofField(), foo.whichOneofField());
        expect(fromJson.whichColors(), foo.whichColors());

        final fromProto3Json = Foo()..mergeFromProto3Json(foo.toProto3Json());
        expect(fromProto3Json.whichOneofField(), foo.whichOneofField());
        expect(fromProto3Json.whichColors(), foo.whichColors());
      }
    });

    test('JSON decoding into a message replaces its active member', () {
      final foo = Foo()..first = 'a';
      foo.mergeFromJson((Foo()..second = 2).writeToJson());
      expect(foo.whichOneofField(), Foo_OneofField.second);
      expect(foo.hasFirst(), isFalse);

      final proto3 = Foo()..first = 'a';
      proto3.mergeFromProto3Json({'second': 2});
      expect(proto3.whichOneofField(), Foo_OneofField.second);
      expect(proto3.hasFirst(), isFalse);
    });

    test('oneof members are never repeated or map fields', () {
      final info = Foo().info_;
      expect(info.oneofs, isNotEmpty);
      for (final tagNumber in info.oneofs.keys) {
        final fieldInfo = info.fieldInfo[tagNumber]!;
        expect(fieldInfo.isRepeated, isFalse);
        expect(fieldInfo.isMapField, isFalse);
      }
    });
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
