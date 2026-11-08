// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Tests for decoding map entries that leave out the key or the value. The
// wire format allows this, and some encoders (for example Rust's prost) omit
// a key or value that is the default, so the decoder must fill the default in.

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

/// The 64-bit integer field types, which are represented as [Int64].
const int64Types = {
  'int64': PbFieldType.O6,
  'uint64': PbFieldType.OU6,
  'sint64': PbFieldType.OS6,
  'fixed64': PbFieldType.OF6,
  'sfixed64': PbFieldType.OSF6,
};

/// Tag of the `map<string, T>` field for the [i]th type in [int64Types].
int valueMapTag(int i) => 1 + i;

/// Tag of the `map<T, string>` field for the [i]th type in [int64Types].
int keyMapTag(int i) => 1 + int64Types.length + i;

/// A message with a `map<string, T>` and a `map<T, string>` field for each
/// 64-bit integer type T.
class Int64Maps extends GeneratedMessage {
  static final _info = () {
    final info = BuilderInfo('Int64Maps', createEmptyInstance: Int64Maps.new);
    final types = int64Types.entries.toList();
    for (var i = 0; i < types.length; i++) {
      info.m<String, Int64>(
        valueMapTag(i),
        '${types[i].key}Values',
        keyFieldType: PbFieldType.OS,
        valueFieldType: types[i].value,
      );
    }
    for (var i = 0; i < types.length; i++) {
      info.m<Int64, String>(
        keyMapTag(i),
        '${types[i].key}Keys',
        keyFieldType: types[i].value,
        valueFieldType: PbFieldType.OS,
      );
    }
    return info;
  }();

  @override
  BuilderInfo get info_ => _info;

  @override
  Int64Maps createEmptyInstance() => Int64Maps();

  @override
  Int64Maps clone() => Int64Maps()..mergeFromMessage(this);
}

/// Encodes a map field with tag [tag] holding one entry whose bytes are
/// [entry].
List<int> mapField(int tag, List<int> entry) => [
  tag << 3 | WIRETYPE_LENGTH_DELIMITED,
  entry.length,
  ...entry,
];

/// Map entry bytes holding only the key, the string 'k'.
const keyOnlyEntry = [0x0a, 0x01, 0x6b];

/// Map entry bytes holding only the value, the string 'v'.
const valueOnlyEntry = [0x12, 0x01, 0x76];

void main() {
  final names = int64Types.keys.toList();

  for (var i = 0; i < names.length; i++) {
    test('map<string, ${names[i]}> entry without a value '
        'decodes the value as Int64.ZERO', () {
      final message =
          Int64Maps()..mergeFromBuffer(mapField(valueMapTag(i), keyOnlyEntry));
      final map = message.getField(valueMapTag(i)) as Map<String, Int64>;
      expect(map, {'k': Int64.ZERO});
    });

    test('map<${names[i]}, string> entry without a key '
        'decodes the key as Int64.ZERO', () {
      final message =
          Int64Maps()..mergeFromBuffer(mapField(keyMapTag(i), valueOnlyEntry));
      final map = message.getField(keyMapTag(i)) as Map<Int64, String>;
      expect(map, {Int64.ZERO: 'v'});
    });
  }

  test('empty entries decode to the default key and value', () {
    final message =
        Int64Maps()..mergeFromBuffer([
          ...mapField(valueMapTag(0), []),
          ...mapField(keyMapTag(0), []),
        ]);
    expect(message.getField(valueMapTag(0)), {'': Int64.ZERO});
    expect(message.getField(keyMapTag(0)), {Int64.ZERO: ''});
  });

  test('decoded defaults survive a round trip', () {
    final message =
        Int64Maps()..mergeFromBuffer([
          ...mapField(valueMapTag(0), keyOnlyEntry),
          ...mapField(keyMapTag(0), valueOnlyEntry),
        ]);
    final copy = Int64Maps()..mergeFromBuffer(message.writeToBuffer());
    expect(copy.getField(valueMapTag(0)), {'k': Int64.ZERO});
    expect(copy.getField(keyMapTag(0)), {Int64.ZERO: 'v'});
  });
}
