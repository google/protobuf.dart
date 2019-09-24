// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../out/protos/high_tagnumber.pb.dart';
import 'package:test/test.dart';

main() {
  test('round trip 29 bit tag number, binary encoding', () {
    expect(M.fromBuffer((M()..a = 42).writeToBuffer()), M()..a = 42);
    expect(M.fromBuffer((M()..b = 42).writeToBuffer()), M()..b = 42);
  });
  test('round trip 29 bit tag number, jspblite2', () {
    expect(M.fromJson((M()..a = 43).writeToJson()), M()..a = 43);
    expect(M.fromJson((M()..b = 43).writeToJson()), M()..b = 43);
  });
}
