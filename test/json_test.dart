// Basic smoke tests for the GeneratedMessage JSON API.
//
// There are more JSON tests in the dart-protoc-plugin package.
library json_test;

import 'dart:convert';
import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

main() {
  T example = new T()
    ..a = 123
    ..b = "hello";

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
  expect(t.a, 123);
  expect(t.b, "hello");
}

/// This is generated code based on:
/// dart-protoc-plugin/test/protos/toplevel.proto
/// (Copied to avoid a circular dependency.)
///
/// message T {
///   optional int32 a = 1;
///   optional string b = 2;
/// }
class T extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('T')
    ..a(1, 'a', GeneratedMessage.O3)
    ..a(2, 'b', GeneratedMessage.OS)
    ..hasRequiredFields = false;

  T() : super();
  T.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  T.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  T clone() => new T()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static T create() => new T();
  static PbList<T> createRepeated() => new PbList<T>();

  int get a => getField(1);
  void set a(int v) {
    setField(1, v);
  }
  bool hasA() => hasField(1);
  void clearA() => clearField(1);

  String get b => getField(2);
  void set b(String v) {
    setField(2, v);
  }
  bool hasB() => hasField(2);
  void clearB() => clearField(2);
}
