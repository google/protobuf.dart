// Copyright(c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library mock_util;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:protobuf/protobuf.dart'
    show GeneratedMessage, BuilderInfo, CreateBuilderFunc, PbFieldType;

BuilderInfo<M> mockInfo<M extends GeneratedMessage<M>>(String className, CreateBuilderFunc create) {
  return new BuilderInfo<M>(className)
    ..a(1, "val", PbFieldType.O3, 42)
    ..a(2, "str", PbFieldType.OS)
    ..a(3, "child", PbFieldType.OM, create, create)
    ..p<int>(4, "int32s", PbFieldType.P3)
    ..a(5, "int64", PbFieldType.O6);
}

/// A minimal protobuf implementation for testing.
abstract class MockMessage<T extends MockMessage<T>> extends GeneratedMessage<T> {
  // subclasses must provide these
  BuilderInfo<T> get info_;

  int get val => $_get(0, 42);
  set val(x) => setField(1, x);

  String get str => $_getS(1, "");
  set str(x) => $_setString(1, x);

  MockMessage get child => $_getN(2);
  set child(x) => setField(3, x);

  List<int> get int32s => $_getList(3);

  Int64 get int64 => $_get(4, new Int64(0));
  set int64(x) => setField(5, x);
}

class T extends MockMessage<T> {
  get info_ => _info;
  static final _info = mockInfo<T>("T", () => new T());
}
