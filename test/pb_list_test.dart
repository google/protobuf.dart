#!/usr/bin/env dart
// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library pb_list_tests;

import 'package:protobuf/protobuf.dart';
import 'package:unittest/unittest.dart';

void main() {
  test('testPbList', () {
    PbList<int> lb1 = new PbList();
    expect(lb1, []);

    lb1.add(1);
    expect(lb1, [1]);

    lb1.addAll([0, 2, 4, 6, 99]);
    expect(lb1, [1, 0, 2, 4, 6, 99]);

    expect(lb1[3], 4);
    expect(lb1.contains(4), isTrue);

    lb1[3] = 99;
    expect(lb1, [1, 0, 2, 99, 6, 99]);

    expect(lb1.indexOf(99), 3);

    expect(lb1.lastIndexOf(99), 5);

    expect(lb1.firstWhere((e) => e % 2 == 0), 0);

    expect(lb1.last, 99);
    var last = lb1.removeLast();
    expect(last, 99);
    expect(lb1.last, 6);

    int count = 0;
    lb1.forEach((int i) {count += i;});
    expect(count, 108);

    List<int> evens = new List<int>.from(
        lb1.where((int i) { return i % 2 == 0; }));
    expect(evens, [0, 2, 6]);

    expect(lb1.any((int i) { return i % 2 == 0; }), isTrue);
    expect(lb1.every((int i) { return i >= 0; }), isTrue);

    lb1.clear();
    expect(lb1, []);

    PbList<int> lb2 = new PbList();

    lb2.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    expect(lb2.sublist(3, 7), [4, 5, 6, 7]);

    lb2.setRange(3, 7, [9, 8, 7, 6]);
    expect(lb2, [1, 2, 3, 9, 8, 7, 6, 8, 9]);

    lb2.removeRange(5, 8);
    expect(lb2, [1, 2, 3, 9, 8, 9]);

    expect(() { (new PbList<int>() as dynamic).add('hello'); }, throws);

    PbSint32List listSint32 = new PbSint32List();

    expect(() { listSint32.add(-2147483649); }, throwsArgumentError);

    expect(() { listSint32.add(-2147483648); },
        returnsNormally,
        reason: 'could not add min_sint32 to PbSint32List');

    expect(() { listSint32.add(2147483648); }, throwsArgumentError);

    expect(() { listSint32.add(2147483647); },
        returnsNormally,
        reason: 'could not add max_sint32 to PbSint32List');

    PbUint32List listUint32 = new PbUint32List();

    expect(() { listUint32.add(-1); }, throwsArgumentError);

    expect(() { listUint32.add(0); },
        returnsNormally,
        reason: 'could not add 0 PbSint32List');

    expect(() { listUint32.add(4294967296); }, throwsArgumentError);

    expect(() { listUint32.add(4294967295); },
        returnsNormally,
        reason: 'could not add max_uint32 to PbUint32List');

    PbFloatList listFloat = new PbFloatList();

    expect(() { listFloat.add(3.4028234663852886E39); }, throwsArgumentError);

    expect(() { listFloat.add(-3.4028234663852886E39); }, throwsArgumentError);

    expect(() { listFloat.add(3.4028234663852886E38); },
        returnsNormally,
        reason: 'could not add max_float to PbUint64List');

    expect(() { listFloat.add(-3.4028234663852886E38); },
        returnsNormally,
        reason: 'could not add max_float to PbUint64List');
  });
}
