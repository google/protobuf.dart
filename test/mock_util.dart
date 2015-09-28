// Copyright(c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library mock_util;

import 'package:protobuf/protobuf.dart'
    show GeneratedMessage, BuilderInfo, PbFieldType;

/// A minimal protobuf implementation for testing.
abstract class MockMessage extends GeneratedMessage {

  BuilderInfo _infoCache;

  // subclasses must provide these
  String get className;
  MockMessage create();

  int get val => getField(1);
  set val(x) => setField(1, x);

  String get str => getField(2);
  set str(x) => setField(2, x);

  MockMessage get child => getField(3);
  set child(x) => setField(3, x);

  List<int> get int32s => getField(4);

  @override
  BuilderInfo get info_ {
    if (_infoCache != null) return _infoCache;
    _infoCache = new BuilderInfo(className)
      ..a(1, "val", PbFieldType.O3, 42)
      ..a(2, "str", PbFieldType.OS)
      ..a(3, "child", PbFieldType.OM, create, create)
      ..p(4, "int32s", PbFieldType.P3);
    return _infoCache;
  }

  clone() => create()..mergeFromMessage(this);
}
