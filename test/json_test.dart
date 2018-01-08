// Basic smoke tests for the GeneratedMessage JSON API.
//
// There are more JSON tests in the dart-protoc-plugin package.
library json_test;

import 'dart:convert';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import 'mock_util.dart' show MockMessage, mockInfo;

class T extends MockMessage {
  get info_ => _info;
  static final _info = mockInfo("T", () => new T());
}

main() {
  T example = new T()
    ..val = 123
    ..str = "hello";

  test('testWriteToJson', () {
    String json = example.writeToJson();
    checkJsonMap(JSON.decode(json));
  });

  test('testWriteToJsonNamed', () {
    String json = example.writeToJson(new JsonNameMapper());
    checkJsonMapNamed(JSON.decode(json));
  });

  test('writeToJsonMap', () {
    Map m = example.writeToJsonMap();
    checkJsonMap(m);
  });

  test('writeToJsonMapNamed', () {
    Map m = example.writeToJsonMap(new JsonNameMapper());
    checkJsonMapNamed(m);
  });

  test('testMergeFromJson', () {
    var t = new T();
    t.mergeFromJson('''{"1": 123, "2": "hello"}''');
    checkMessage(t);
  });

  test('testMergeFromJsonNamed', () {
    var t = new T();
    t.mergeFromJson('''{"val": 123, "str": "hello"}''', ExtensionRegistry.EMPTY,
        new JsonNameMapper());
    checkMessage(t);
  });

  test('testMergeFromJsonMap', () {
    var t = new T();
    t.mergeFromJsonMap({"1": 123, "2": "hello"});
    checkMessage(t);
  });

  test('testMergeFromJsonMapNamed', () {
    var t = new T();
    t.mergeFromJsonMap({"val": 123, "str": "hello"}, ExtensionRegistry.EMPTY,
        new JsonNameMapper());
    checkMessage(t);
  });

  test('testInt64JsonEncoding', () {
    final value = new Int64(1234567890123456789);
    final t = new T()..int64 = value;
    final encoded = t.writeToJsonMap();
    expect(encoded["5"], "$value");
    final decoded = new T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });

  test('testInt64JsonEncodingNamed', () {
    final value = new Int64(1234567890123456789);
    final t = new T()..int64 = value;
    final encoded = t.writeToJsonMap(new JsonNameMapper());
    expect(encoded["int64"], "$value");
    final decoded = new T()
      ..mergeFromJsonMap(
          encoded, ExtensionRegistry.EMPTY, new JsonNameMapper());
    expect(decoded.int64, value);
  });
}

checkJsonMap(Map m) {
  expect(m.length, 2);
  expect(m["1"], 123);
  expect(m["2"], "hello");
}

checkJsonMapNamed(Map m) {
  expect(m.length, 2);
  expect(m["val"], 123);
  expect(m["str"], "hello");
}

checkMessage(T t) {
  expect(t.val, 123);
  expect(t.str, "hello");
}
