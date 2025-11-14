// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=3.10

// Basic smoke tests for the GeneratedMessage JSON API.
//
// There are more JSON tests in the dart-protoc-plugin package.

import 'dart:convert';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:test/test.dart';

import 'mock_util.dart' show MockEnum, T;

void main() {
  test('mergeFromProto3Json unknown enum fields with names', () {
    final example = T();

    // No enum value specified.
    expect(example.hasEnm, isFalse);

    // Defaults to first when it doesn't exist.
    expect(example.enm, equals(MockEnum.values.first));
    expect((example..mergeFromProto3Json({'enm': 'a'})).enm.name, equals('a'));

    // Now it's explicitly set after merging.
    expect(example.hasEnm, isTrue);

    expect((example..mergeFromProto3Json({'enm': 'b'})).enm.name, equals('b'));

    // "c" is not a legal enum value.
    expect(
      () => example..mergeFromProto3Json({'enm': 'c'}),
      throwsA(
        allOf(
          isFormatException,
          predicate(
            (FormatException e) => e.message.contains('Unknown enum value'),
          ),
        ),
      ),
    );

    // `example` hasn't changed.
    expect(example.hasEnm, isTrue);
    expect(example.enm.name, equals('b'));

    // "c" is not a legal enum value, but we are ignoring unknown fields, so
    // `enm` value shouldn't change.
    expect(
      (example..mergeFromProto3Json({'enm': 'c'}, ignoreUnknownFields: true))
          .enm
          .name,
      equals('b'),
    );
    expect(example.hasEnm, isTrue);
  });

  test('mergeFromProto3Json unknown enum fields with indices', () {
    // Similar to above, but with indices.
    final example = T();

    expect((example..mergeFromProto3Json({'enm': 2})).enm.name, 'b');
    expect(
      () => example..mergeFromProto3Json({'enm': 3}),
      throwsA(
        allOf(
          isFormatException,
          predicate(
            (FormatException e) => e.message.contains('Unknown enum value'),
          ),
        ),
      ),
    );

    // `example` hasn't changed.
    expect(example.hasEnm, isTrue);
    expect(example.enm.name, equals('b'));

    // "c" is not a legal enum value, but we are ignoring unknown fields, so the
    // value shouldn't change.
    expect(
      (example..mergeFromProto3Json({'enm': 3}, ignoreUnknownFields: true))
          .enm
          .name,
      equals('b'),
    );
    expect(example.hasEnm, isTrue);
  });

  test('testWriteToJson', () {
    final json = makeTestJson().writeToJson();
    checkJsonMap(jsonDecode(json));
  });

  test('testWriteFrozenToJson', () {
    final frozen = makeTestJson()..freeze();
    final json = frozen.writeToJson();
    checkJsonMap(jsonDecode(json));
  });

  test('writeToJsonMap', () {
    final Map m = makeTestJson().writeToJsonMap();
    checkJsonMap(m);
  });

  test('testWriteToJsonMap', () {
    final t = T();
    t.mergeFromJson('''{"1": 123, "2": "hello"}''');
    checkMessage(t);
  });

  test('testMergeFromJsonMap', () {
    final t = T();
    t.mergeFromJsonMap({'1': 123, '2': 'hello'});
    checkMessage(t);
  });

  test('testInt64JsonEncoding', () {
    final value = Int64.parseInt('1234567890123456789');
    final t = T()..int64 = value;
    final encoded = t.writeToJsonMap();
    expect(encoded['5'], '$value');
    final decoded = T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });

  test('testFrozentInt64JsonEncoding', () {
    final value = Int64.parseInt('1234567890123456789');
    final frozen = T()
      ..int64 = value
      ..freeze();
    final encoded = frozen.writeToJsonMap();
    expect(encoded['5'], '$value');
    final decoded = T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });

  test('testJsonMapWithUnknown', () {
    final m = makeTestJson().writeToJsonMap();
    m['9999'] = 'world';
    final t = T()..mergeFromJsonMap(m);
    checkJsonMap(t.writeToJsonMap(), unknownFields: {'9999': 'world'});
  });

  test('testJspbLite2WithUnknown', () {
    final m = makeTestJson().writeToJson();
    final decoded = jsonDecode(m);
    decoded['9999'] = 'world';
    final encoded = jsonEncode(decoded);
    final t = T()..mergeFromJson(encoded);
    checkJsonMap(t.writeToJsonMap(), unknownFields: {'9999': 'world'});
  });

  test('mergeFromJspbLite2 unknown data should be converted to Dart', () {
    // Testing here is a bit indirect (via `toDebugString`) because
    // `unknownJsonData` is not exposed to the users.
    final decoded = {
      '9999': {
        '1': ['a', 'b', 'c'],
      },
    };
    final encoded = jsonEncode(decoded);
    final t = T()..mergeFromJson(encoded);
    // Without converting JS data to Dart we get `[object Object]` here for the
    // field value.
    expect(t.toDebugString(), '{9999: {1: [a, b, c]}}');
  });

  test('writeToJspbLite unknown data should be converted to JS', () {
    final m = makeTestJson().writeToJson();
    final decoded = jsonDecode(m);
    decoded['9999'] = {
      '1': ['a', 'b', 'c'],
    };
    final encoded = jsonEncode(decoded);
    final t = T()..mergeFromJson(encoded);
    // Without converting unknown data (converted to Dart when decoding) to JS,
    // the unknown field values in the output get weird as JS representation of
    // Dart data are serialized directly by the browser's `JSON.stringify`.
    expect(
      t.writeToJson(),
      '{"1":123,"2":"hello","4":[1,2,3],"9999":{"1":["a","b","c"]}}',
    );
  });
}

T makeTestJson() => T()
  ..val = 123
  ..str = 'hello'
  ..int32s.addAll(<int>[1, 2, 3]);

void checkJsonMap(Map m, {Map<String, dynamic>? unknownFields}) {
  expect(m.length, 3 + (unknownFields?.length ?? 0));
  expect(m['1'], 123);
  expect(m['2'], 'hello');
  expect(m['4'], [1, 2, 3]);
  unknownFields?.forEach((k, v) => expect(m[k], v));
}

void checkMessage(T t) {
  expect(t.val, 123);
  expect(t.str, 'hello');
}
