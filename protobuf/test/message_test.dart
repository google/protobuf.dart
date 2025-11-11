// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Tests for GeneratedMessage methods.

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:matcher/matcher.dart';
import 'package:protobuf/protobuf.dart';
import 'package:protobuf/src/protobuf/internal.dart';
import 'package:test/test.dart' show Matcher, expect, isA, test, throwsA;

import 'mock_util.dart' show MockMessage, mockEmptyInfo, mockInfo;

class Rec extends MockMessage {
  @override
  BuilderInfo get info_ => _info;
  static final _info = mockInfo('Rec', Rec.new);

  @override
  Rec createEmptyInstance() => Rec();
}

class EmptyRec extends MockMessage {
  @override
  BuilderInfo get info_ => _info;
  static final _info = mockEmptyInfo('EmptyRec', EmptyRec.new);

  @override
  EmptyRec createEmptyInstance() => EmptyRec();
}

class Ext extends MockMessage {
  @override
  BuilderInfo get info_ => _info;
  static final _info = mockInfo('Ext', Ext.new);

  @override
  Ext createEmptyInstance() => Ext();

  static final Extension<int> count = Extension(
    'Rec',
    'count',
    101,
    PbFieldType.O3,
  );

  static final Extension<String> items = Extension.repeated(
    'Rec',
    'items',
    102,
    PbFieldType.PS,
    check: (value) => value is String,
  );

  static final Extension<List<int>> data = Extension(
    'Rec',
    'data',
    103,
    PbFieldType.OY,
  );
}

Matcher throwsError(String expectedMessage) => throwsA(
  isA<ArgumentError>().having((p0) => p0.message, 'message', expectedMessage),
);

void main() {
  final recProto =
      Rec()
        ..val = 123
        ..str = 'a\n\r\t"\\b'
        ..bytes = [0, 1, 2, 127, 128, 255]
        ..child = (Rec()..val = 456)
        ..int32s.addAll([1, 2, 3])
        ..int64 = Int64.MAX_VALUE
        ..stringMap['key "1"'] = '''value\n1'''
        ..stringMap['key 2'] = 'value 2';

  test('getField with invalid tag throws exception', () {
    final r = Rec();
    expect(() {
      r.getField(123);
    }, throwsError('tag 123 not defined in Rec'));
  });

  test('getDefaultForField with invalid tag throws exception', () {
    final r = Rec();
    expect(() {
      r.getDefaultForField(123);
    }, throwsError('tag 123 not defined in Rec'));
  });

  test('operator== and hashCode works for frozen message', () {
    final a =
        Rec()
          ..val = 123
          ..int32s.addAll([1, 2, 3])
          ..freeze();
    final b =
        Rec()
          ..val = 123
          ..int32s.addAll([1, 2, 3]);

    expect(a.hashCode, b.hashCode);
    expect(a == b, true);
    expect(b == a, true);
  });

  test('isFrozen works', () {
    final a =
        Rec()
          ..val = 123
          ..int32s.addAll([1, 2, 3])
          ..child = (Rec()..val = 100);
    expect(a.isFrozen, false);
    a.child.freeze();
    expect(a.child.isFrozen, true);
    expect(a.isFrozen, false);
    a.freeze();
    expect(a.isFrozen, true);
  });

  test('operator== and hashCode work for a simple record', () {
    final a = Rec();
    expect(a == a, true);

    final b = Rec();
    expect(a.info_ == b.info_, true, reason: 'BuilderInfo should be the same');
    expect(a == b, true);
    expect(a.hashCode, b.hashCode);

    a.val = 123;
    expect(a == b, false);
    b.val = 123;
    expect(a == b, true);
    expect(a.hashCode, b.hashCode);

    a.child = Rec();
    expect(a == b, false);
    b.child = Rec();
    expect(a == b, true);
    expect(a.hashCode, b.hashCode);
  });

  test('toTextFormatString works', () {
    expect(recProto.toTextFormat(), _EXPECTED_TEXT_PROTO);
  });

  test('toTextFormatString handles unknown JSON data', () {
    final a = Rec();
    a.mergeFromJson(
      '''{"1": 123, "2": "hello", "9": 456, "10": "UnknownFieldValue", '''
      '''"11": {"1": 999, "2": {"1": 1000, "2": "ab\\\\c\\""}}, "13": "'''
      // [bytes] in JSON are base64 encoded and we are not able to decode them
      // since we don't know if it's a string or bytes.
      '''AAECh/8="}''',
    );
    expect(a.toTextFormat(), _TEXT_FORMAT_PROTO_WITH_UNKNOWN_JSON_FIELDS);
  });

  test('toTextFormatString handles unknown fields', () {
    final buffer = recProto.writeToBuffer();
    final emptyRec = EmptyRec()..mergeFromBuffer(buffer);
    expect(emptyRec.toTextFormat(), _TEXT_FORMAT_PROTO_WITH_UNKNOWN_FIELDS);
  });

  test('toTextFormatString handles extensions fields', () {
    final a =
        Rec()
          ..val = 42
          ..setExtension(Ext.count, 123)
          ..addExtension(Ext.items, 'a')
          ..addExtension(Ext.items, 'b"c')
          ..setExtension(Ext.data, [0, 1, 2, 127, 128, 255]);

    expect(a.toTextFormat(), _EXPECTED_TEXT_PROTO_WITH_EXTENSIONS);
  });
}

const _EXPECTED_TEXT_PROTO = '''
val: 123
str: "a\\n\r\t\\"\\\\b"
child {
  val: 456
}
int32s: 1
int32s: 2
int32s: 3
int64: 9223372036854775807
string_map {
  key: "key \\"1\\""
  value: "value\\n1"
}
string_map {
  key: "key 2"
  value: "value 2"
}
bytes: "\\000\\001\\002\\177\\200\\377"
''';

const _EXPECTED_TEXT_PROTO_WITH_EXTENSIONS = '''
val: 42
[count]: 123
[items]: "a"
[items]: "b\\"c"
[data]: "\\000\\001\\002\\177\\200\\377"
''';

const _TEXT_FORMAT_PROTO_WITH_UNKNOWN_FIELDS = '''
1: 123
2: "a\\n\\r\\t\\"\\\\b"
3: {
  1: 456
}
4: 1
4: 2
4: 3
5: 9223372036854775807
8: {
  1: "key \\"1\\""
  2: "value\\n1"
}
8: {
  1: "key 2"
  2: "value 2"
}
12: "\\000\\001\\002\\177\\200\\377"
''';

const _TEXT_FORMAT_PROTO_WITH_UNKNOWN_JSON_FIELDS = '''
val: 123
str: "hello"
9: 456
10: "UnknownFieldValue"
11 {
  1: 999
  2 {
    1: 1000
    2: "ab\\\\c\\""
  }
}
13: "AAECh/8="
''';
