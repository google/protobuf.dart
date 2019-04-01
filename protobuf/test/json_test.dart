// Basic smoke tests for the GeneratedMessage JSON API.
//
// There are more JSON tests in the dart-protoc-plugin package.
library json_test;

import 'dart:convert';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:test/test.dart';

import 'mock_util.dart' show T;

main() {
  T example = T()
    ..val = 123
    ..str = "hello"
    ..int32s.addAll(<int>[1, 2, 3]);

  test('testWriteToJson', () {
    String json = example.writeToJson();
    checkJsonMap(jsonDecode(json));
  });

  test('testWriteFrozenToJson', () {
    final frozen = example.clone()..freeze();
    final json = frozen.writeToJson();
    checkJsonMap(jsonDecode(json));
  });

  test('writeToJsonMap', () {
    Map m = example.writeToJsonMap();
    checkJsonMap(m);
  });

  test('testMergeFromJson', () {
    var t = T();
    t.mergeFromJson('''{"1": 123, "2": "hello"}''');
    checkMessage(t);
  });

  test('testMergeFromJsonMap', () {
    var t = T();
    t.mergeFromJsonMap({"1": 123, "2": "hello"});
    checkMessage(t);
  });

  test('testInt64JsonEncoding', () {
    final value = Int64.parseInt('1234567890123456789');
    final t = T()..int64 = value;
    final encoded = t.writeToJsonMap();
    expect(encoded["5"], "$value");
    final decoded = T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });

  test('tesFrozentInt64JsonEncoding', () {
    final value = Int64.parseInt('1234567890123456789');
    final frozen = T()
      ..int64 = value
      ..freeze();
    final encoded = frozen.writeToJsonMap();
    expect(encoded["5"], "$value");
    final decoded = T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });
}

checkJsonMap(Map m) {
  expect(m.length, 3);
  expect(m["1"], 123);
  expect(m["2"], "hello");
  expect(m["4"], [1, 2, 3]);
}

checkMessage(T t) {
  expect(t.val, 123);
  expect(t.str, "hello");
}
