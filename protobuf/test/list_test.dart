// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'mock_util.dart';

void main() {
  test('testPbList handles basic operations', () {
    final lb1 = T().int32s;
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

    expect(lb1.firstWhere((e) => e.isEven), 0);

    expect(lb1.last, 99);
    final last = lb1.removeLast();
    expect(last, 99);
    expect(lb1.last, 6);

    var count = 0;
    for (final i in lb1) {
      count += i;
    }
    expect(count, 108);

    bool isEven(int i) => i.isEven;
    final evens = List<int>.from(lb1.where(isEven));
    expect(evens, [0, 2, 6]);

    expect(lb1.any(isEven), isTrue);

    bool isNonNegative(int i) => i >= 0;
    expect(lb1.every(isNonNegative), isTrue);

    lb1.clear();
    expect(lb1, []);
  });

  test('PbList handles range operations', () {
    final lb2 = T().int32s;

    lb2.addAll([1, 2, 3, 4, 5, 6, 7, 8, 9]);
    expect(lb2.sublist(3, 7), [4, 5, 6, 7]);

    lb2.setRange(3, 7, [9, 8, 7, 6]);
    expect(lb2, [1, 2, 3, 9, 8, 7, 6, 8, 9]);

    lb2.removeRange(5, 8);
    expect(lb2, [1, 2, 3, 9, 8, 9]);

    expect(() => lb2.setRange(5, 7, [88, 99].take(2)), throwsRangeError);
    expect(lb2, [1, 2, 3, 9, 8, 9]);

    expect(() => lb2.setRange(5, 7, [88, 99].take(2), 1), throwsRangeError);
    expect(lb2, [1, 2, 3, 9, 8, 9]);

    expect(() => lb2.setRange(4, 6, [88, 99].take(1), 1), throwsStateError);
    expect(lb2, [1, 2, 3, 9, 8, 9]);

    lb2.setRange(5, 6, [88, 99].take(2));
    expect(lb2, [1, 2, 3, 9, 8, 88]);

    lb2.setRange(5, 6, [88, 99].take(2), 1);
    expect(lb2, [1, 2, 3, 9, 8, 99]);
  });
}
