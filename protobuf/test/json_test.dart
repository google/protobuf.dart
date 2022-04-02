// Basic smoke tests for the GeneratedMessage JSON API.
//
// There are more JSON tests in the dart-protoc-plugin package.
library json_test;

import 'dart:convert';

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import 'mock_util.dart' show T, mockEnumValues;

void main() {
  var example = T()
    ..val = 123
    ..str = 'hello'
    ..int32s.addAll(<int>[1, 2, 3]);

  final double doubleZeroVal = 0;
  final exampleAllDefaults = T()
    ..val = 0
    ..str = ''
    ..child = T()
    ..int64 = Int64(0)
    ..enm = ProtobufEnum(1, 'a')
    ..dbl = doubleZeroVal
    ..bl = false
    ..byts = <int>[]
    ..int32s.addAll(<int>[]);
  exampleAllDefaults.mp.addAll(<String, String>{});

  final double doubleSetVal = 1.34;
  final exampleAllSet = T()
    ..val = 32
    ..str = 'the-string'
    ..child = example
    ..int64 = Int64(78)
    ..enm = ProtobufEnum(1, 'b')
    ..dbl = doubleSetVal
    ..bl = true
    ..byts = <int>[46, 28]
    ..int32s.addAll(<int>[3, 4, 6]);
  exampleAllSet.mp.addAll(<String, String>{'k1': 'v2'});

  test('testProto3JsonEnum', () {
    // No enum value specified.
    expect(example.hasEnm, isFalse);
    // Defaults to first when it doesn't exist.
    expect(example.enm, equals(mockEnumValues.first));
    expect((example..mergeFromProto3Json({'enm': 'a'})).enm.name, equals('a'));
    // Now it's explicitly set after merging.
    expect(example.hasEnm, isTrue);

    expect((example..mergeFromProto3Json({'enm': 'b'})).enm.name, equals('b'));
    // "c" is not a legal enum value.
    expect(
        () => example..mergeFromProto3Json({'enm': 'c'}),
        throwsA(allOf(
            isFormatException,
            predicate(
                (dynamic e) => e.message.contains('Unknown enum value')))));
    // `example` hasn't changed.
    expect(example.hasEnm, isTrue);
    expect(example.enm.name, equals('b'));

    // "c" is not a legal enum value, but we are ignoring unknown fields, so
    // default behavior is to unset `enm`, returning the default value "a"
    expect(
        (example..mergeFromProto3Json({'enm': 'c'}, ignoreUnknownFields: true))
            .enm
            .name,
        equals('a'));
    expect(example.hasEnm, isFalse);

    // Same for index values...
    expect((example..mergeFromProto3Json({'enm': 2})).enm.name, 'b');
    expect(
        () => example..mergeFromProto3Json({'enm': 3}),
        throwsA(allOf(
            isFormatException,
            predicate(
                (dynamic e) => e.message.contains('Unknown enum value')))));
    // `example` hasn't changed.
    expect(example.hasEnm, isTrue);
    expect(example.enm.name, equals('b'));

    // "c" is not a legal enum value, but we are ignoring unknown fields, so
    // default behavior is to unset `enm`, returning the default value "a"
    expect(
        (example..mergeFromProto3Json({'enm': 3}, ignoreUnknownFields: true))
            .enm
            .name,
        equals('a'));
    expect(example.hasEnm, isFalse);
  });

  test('testWriteToJson', () {
    var json = example.writeToJson();
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

  test('tesFrozentInt64JsonEncoding', () {
    final value = Int64.parseInt('1234567890123456789');
    final frozen = T()
      ..int64 = value
      ..freeze();
    final encoded = frozen.writeToJsonMap();
    expect(encoded['5'], '$value');
    final decoded = T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });

  test('testToProto3Json', () {
    var json = jsonEncode(example.toProto3Json());
    checkProto3JsonMap(jsonDecode(json), 3);
  });

  test('testToProto3JsonNoFieldsSet', () {
    final json = jsonEncode(T().toProto3Json());
    expect(json.contains('{}'), isTrue);
    final Map m = jsonDecode(json);
    expect(m.isEmpty, isTrue);
  });

  test('testToProto3JsonFieldsSetToDefaults', () {
    final json = jsonEncode(exampleAllDefaults.toProto3Json());
    expect(json.contains('"child":{}'), isTrue);
    final Map m = jsonDecode(json);
    expect(m.isEmpty, isFalse);
  });

  test('testToProto3JsonFieldsSetToValues', () {
    // verify the expected child is present
    final json = jsonEncode(exampleAllSet.toProto3Json());
    final expectedChild = '{"val":123,"str":"hello","int32s":[1,2,3]}';
    expect(json.contains('"child":$expectedChild'), isTrue);
    final jsonNoChild = json.replaceAll(expectedChild, '');

    // verify the remaining parent object is accurate
    checkExampleAllParentSetValues(jsonNoChild);
  });

  test('testToProto3JsonEmitDefaults', () {
    final json = jsonEncode(example.toProto3Json(emitDefaults: true));
    checkProto3JsonMap(jsonDecode(json), 10);
  });

  test('testToProto3JsonEmitDefaultsNoFieldsSet', () {
    final json = jsonEncode(T().toProto3Json(emitDefaults: true));
    expect(json.contains('"val":42,'), isTrue);
    expect(json.contains('"str":"",'), isTrue);
    expect(json.contains('"child":null,'), isTrue);
    expect(json.contains('"int32s":[],'), isTrue);
    expect(json.contains('"int64":"0",'), isTrue);
    expect(json.contains('"enm":"a",'), isTrue);
    expect(json.contains('"dbl":0.0,'), isTrue);
    expect(json.contains('"bl":false,'), isTrue);
    expect(json.contains('"byts":null'), isTrue);
    expect(json.contains('"mp":{}'), isTrue);
  });

  test('testToProto3JsonEmitDefaultsFieldsSetToDefaults', () {
    // verify the default child is present
    final json =
        jsonEncode(exampleAllDefaults.toProto3Json(emitDefaults: true));
    final defaultChild =
        '{"val":42,"str":"","child":null,"int32s":[],"int64":"0","enm":"a","dbl":0.0,"bl":false,"byts":null,"mp":{}}';
    expect(json.contains('"child":$defaultChild'), isTrue);
    final jsonNoChild = json.replaceAll(defaultChild, '');

    // verify the remaining parent object is accurate
    checkExampleAllParentSetDefaults(jsonNoChild);
  });

  test('testToProto3JsonEmitDefaultsFieldsSetToValues', () {
    // verify the expected child is present
    final json = jsonEncode(exampleAllSet.toProto3Json(emitDefaults: true));
    final expectedChild =
        '{"val":123,"str":"hello","child":null,"int32s":[1,2,3],"int64":"0","enm":"a","dbl":0.0,"bl":false,"byts":null,"mp":{}}';
    expect(json.contains('"child":$expectedChild'), isTrue);
    final jsonNoChild = json.replaceAll(expectedChild, '');

    // verify the remaining parent object is accurate
    checkExampleAllParentSetValues(jsonNoChild);
  });
}

void checkExampleAllParentSetDefaults(String json) {
  expect(json.contains('"val":0,'), isTrue);
  expect(json.contains('"str":"",'), isTrue);
  expect(json.contains('"int32s":[],'), isTrue);
  expect(json.contains('"int64":"0",'), isTrue);
  expect(json.contains('"enm":"a",'), isTrue);
  expect(json.contains('"dbl":0.0,'), isTrue);
  expect(json.contains('"bl":false,'), isTrue);
  expect(json.contains('"byts":null'), isTrue);
  expect(json.contains('"mp":{}'), isTrue);
}

void checkExampleAllParentSetValues(String json) {
  expect(json.contains('"val":32,'), isTrue);
  expect(json.contains('"str":"the-string",'), isTrue);
  expect(json.contains('"int32s":[3,4,6],'), isTrue);
  expect(json.contains('"int64":"78",'), isTrue);
  expect(json.contains('"enm":"b",'), isTrue);
  expect(json.contains('"dbl":1.34,'), isTrue);
  expect(json.contains('"bl":true,'), isTrue);
  expect(json.contains('"byts":"Lhw="'), isTrue);
  expect(json.contains('"mp":{"k1":"v2"}'), isTrue);
}

void checkProto3JsonMap(Map m, int expectedLength) {
  expect(m.length, expectedLength);
  expect(m['val'], 123);
  expect(m['str'], 'hello');
  expect(m['int32s'], [1, 2, 3]);
}

void checkJsonMap(Map m) {
  expect(m.length, 3);
  expect(m['1'], 123);
  expect(m['2'], 'hello');
  expect(m['4'], [1, 2, 3]);
}

void checkMessage(T t) {
  expect(t.val, 123);
  expect(t.str, 'hello');
}
