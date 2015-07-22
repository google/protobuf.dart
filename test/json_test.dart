// Basic smoke tests for the GeneratedMessage JSON API.
//
// There are more JSON tests in the dart-protoc-plugin package.
library json_test;

import 'dart:convert';
import 'package:test/test.dart';

import 'mock_util.dart' show MockMessage;

class T extends MockMessage {
  get className => "T";
  T create() => new T();
}

main() {
  T example = new T()
    ..val = 123
    ..str = "hello";

  test('testWriteToJson', () {
    String json = example.writeToJson();
    checkJsonMap(JSON.decode(json));
  });

  test('writeToJsonMap', () {
    Map m = example.writeToJsonMap();
    checkJsonMap(m);
  });

  test('testMergeFromJson', () {
    var t = new T();
    t.mergeFromJson('''{"1": 123, "2": "hello"}''');
    checkMessage(t);
  });

  test('testMergeFromJsonMap', () {
    var t = new T();
    t.mergeFromJsonMap({"1": 123, "2": "hello"});
    checkMessage(t);
  });
}

checkJsonMap(Map m) {
  expect(m.length, 2);
  expect(m["1"], 123);
  expect(m["2"], "hello");
}

checkMessage(T t) {
  expect(t.val, 123);
  expect(t.str, "hello");
}
