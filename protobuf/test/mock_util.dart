// Copyright(c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';
import 'package:fixnum/fixnum.dart' show Int64;
import 'package:protobuf/protobuf.dart'
    show
        BuilderInfo,
        CreateBuilderFunc,
        FieldBaseType,
        FieldType,
        GeneratedMessage,
        ProtobufEnum;

final mockEnumValues = [ProtobufEnum(1, 'a'), ProtobufEnum(2, 'b')];
BuilderInfo mockInfo(String className, CreateBuilderFunc create) {
  return BuilderInfo(className, createEmptyInstance: create)
    ..a(1, 'val', FieldType.OPTIONAL_I32(), defaultOrMaker: 42)
    ..a(2, 'str', FieldType.OPTIONAL_STRING())
    ..a(3, 'child', FieldType.OPTIONAL_MESSAGE(),
        defaultOrMaker: create, subBuilder: create)
    ..p<int>(4, 'int32s', FieldType.REPEATED_I32())
    ..a(5, 'int64', FieldType.OPTIONAL_I64())
    // 6 is reserved for extensions in other tests.
    ..e(7, 'enm', FieldType.optional(FieldBaseType.enum_),
        defaultOrMaker: mockEnumValues.first,
        valueOf: (i) => mockEnumValues.firstWhereOrNull((e) => e.value == i),
        enumValues: mockEnumValues);
}

/// A minimal protobuf implementation for testing.
abstract class MockMessage extends GeneratedMessage {
  // subclasses must provide these
  @override
  BuilderInfo get info_;

  int get val => $_get(0, 42);
  set val(x) => setField(1, x);

  String get str => $_getS(1, '');
  set str(x) => $_setString(1, x);

  MockMessage get child => $_getN(2);
  set child(x) => setField(3, x);

  List<int> get int32s => $_getList(3);

  Int64 get int64 => $_get(4, Int64(0));
  set int64(x) => setField(5, x);

  ProtobufEnum get enm => $_getN(5);
  bool get hasEnm => $_has(5);

  @override
  GeneratedMessage clone() {
    var create = info_.byName['child']!.subBuilder!;
    return create()..mergeFromMessage(this);
  }
}

class T extends MockMessage {
  @override
  BuilderInfo get info_ => _info;
  static final _info = mockInfo('T', () => T());
  @override
  T createEmptyInstance() => T();
}
