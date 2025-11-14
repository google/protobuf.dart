// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=3.10

import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:protobuf/protobuf.dart'
    show
        BuilderInfo,
        CreateBuilderFunc,
        GeneratedMessage,
        PbFieldType,
        ProtobufEnum;

class MockEnum extends ProtobufEnum {
  static const values = [MockEnum(1, 'a'), MockEnum(2, 'b')];

  static MockEnum? valueOf(int value) =>
      values.firstWhereOrNull((e) => e.value == value);

  const MockEnum(super.value, super.name);
}

BuilderInfo mockEmptyInfo(String className, CreateBuilderFunc create) {
  return BuilderInfo(className, createEmptyInstance: create);
}

BuilderInfo mockInfo(String className, CreateBuilderFunc create) {
  return BuilderInfo(className, createEmptyInstance: create)
    ..a(1, 'val', PbFieldType.O3, defaultOrMaker: 42)
    ..a(2, 'str', PbFieldType.OS)
    ..a(3, 'child', PbFieldType.OM, defaultOrMaker: create, subBuilder: create)
    ..p<int>(4, 'int32s', PbFieldType.P3)
    ..a(5, 'int64', PbFieldType.O6)
    // 6 is reserved for extensions in tests.
    ..e<MockEnum>(
      7,
      'enm',
      PbFieldType.OE,
      defaultOrMaker: MockEnum.values.first,
      valueOf: MockEnum.valueOf,
      enumValues: MockEnum.values,
    )
    ..m<String, String>(
      8,
      'stringMap',
      keyFieldType: PbFieldType.OS,
      valueFieldType: PbFieldType.OS,
    )
    // 9, 10, 11 are reserved for unknown fields in tests.
    ..a(12, 'bytes', PbFieldType.OY);
  // 13 is reserved for unknown bytes fields in tests.
}

/// A minimal protobuf implementation for testing.
abstract class MockMessage extends GeneratedMessage {
  // subclasses must provide these
  @override
  BuilderInfo get info_;

  int get val => $_get(0, 42);
  set val(Object x) => setField(1, x);

  String get str => $_getS(1, '');
  set str(String x) => $_setString(1, x);

  MockMessage get child => $_getN(2);
  set child(Object x) => setField(3, x);

  List<int> get int32s => $_getList(3);

  Int64 get int64 => $_get(4, Int64(0));
  set int64(Object x) => setField(5, x);

  MockEnum get enm => $_getN(5);
  bool get hasEnm => $_has(5);

  Map<String, String> get stringMap => $_getMap(6);

  set bytes(List<int> x) => $_setBytes(7, x);

  @override
  GeneratedMessage clone() {
    final create = info_.byName['child']!.subBuilder!;
    return create()..mergeFromMessage(this);
  }
}

class T extends MockMessage {
  @override
  BuilderInfo get info_ => _info;
  static final _info = mockInfo('T', T.new);
  @override
  T createEmptyInstance() => T();
}
