// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import '../out/protos/proto3_optional.pb.dart';

void main() {
  test('optional fields have presence', () {
    final f = Foo();
    expect(f.hasOptionalInt32(), false);
    expect(f.hasOptionalEnum(), false);
    expect(f.hasOptionalSubmessage(), false);
    expect(f.hasOptionalBytes(), false);
    expect(f.hasOptionalString(), false);

    f.optionalInt32 = 0;
    expect(f.hasOptionalInt32(), true);

    f.optionalEnum = Enum.A;
    expect(f.hasOptionalEnum(), true);

    f.optionalSubmessage = Submessage();
    expect(f.hasOptionalSubmessage(), true);

    f.optionalString = '';
    expect(f.hasOptionalString(), true);

    f.optionalBytes = <int>[];
    expect(f.hasOptionalBytes(), true);
  });
}
