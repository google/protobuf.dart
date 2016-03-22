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

  int get val => $_get(0, 1, 42);
  set val(x) => setField(1, x);

  String get str => $_get(1, 2, "");
  set str(x) => $_setString(1, 2, x);

  MockMessage get child => $_get(2, 3, null);
  set child(x) => setField(3, x);

  List<int> get int32s => $_get(3, 4, null) as List<int>;

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
