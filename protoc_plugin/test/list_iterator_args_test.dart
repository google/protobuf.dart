// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'gen/google/protobuf/unittest.pb.dart';

void main() {
  // If this test fails, it means we no longer have the "check" functions in
  // `PbList`, and half of the tests below can be removed.
  test("PbList checks value validity", () {
    expect(() {
      TestAllTypes().repeatedInt32.add(2147483647 + 1);
    }, throwsArgumentError);
  });

  // For every `PbList` method that updates the list with an `Iterable`
  // argument, check that the `Iterable` argument is iterated only once.
  test("addAll iterates iterator argument once (with check function)", () {
    var mapCount = 0;
    final list = TestAllTypes().repeatedInt32;
    list.addAll(
      [1, 2, 3].map((i) {
        mapCount += 1;
        return i;
      }),
    );
    expect(mapCount, 3);
    expect(list, [1, 2, 3]);
  });

  test("addAll iterates iterator argument once (without check function)", () {
    var mapCount = 0;
    final list = TestAllTypes().repeatedString;
    list.addAll(
      ["a", "b", "c"].map((i) {
        mapCount += 1;
        return i;
      }),
    );
    expect(mapCount, 3);
    expect(list, ["a", "b", "c"]);
  });

  test("insertAll iterates iterator argument once (with check function)", () {
    var mapCount = 0;
    final list = TestAllTypes().repeatedInt32..addAll([1, 2]);
    list.insertAll(
      1,
      [4, 5, 6].map((i) {
        mapCount += 1;
        return i;
      }),
    );
    expect(mapCount, 3);
    expect(list, [1, 4, 5, 6, 2]);
  });

  test(
    "insertAll iterates iterator argument once (without check function)",
    () {
      var mapCount = 0;
      final list = TestAllTypes().repeatedString..addAll(["a", "b"]);
      list.insertAll(
        1,
        ["c", "d", "e"].map((i) {
          mapCount += 1;
          return i;
        }),
      );
      expect(mapCount, 3);
      expect(list, ["a", "c", "d", "e", "b"]);
    },
  );

  test(
    "replaceRange iterates iterator argument once (with check function)",
    () {
      var mapCount = 0;
      final list = TestAllTypes().repeatedInt32..addAll([1, 2, 3]);
      list.replaceRange(
        1,
        2,
        [4, 5, 6].map((i) {
          mapCount += 1;
          return i;
        }),
      );
      expect(mapCount, 3);
      expect(list, [1, 4, 5, 6, 3]);
    },
  );

  test(
    "replaceRange iterates iterator argument once (without check function)",
    () {
      var mapCount = 0;
      final list = TestAllTypes().repeatedString..addAll(["a", "b", "c"]);
      list.replaceRange(
        1,
        2,
        ["d", "e", "f"].map((i) {
          mapCount += 1;
          return i;
        }),
      );
      expect(mapCount, 3);
      expect(list, ["a", "d", "e", "f", "c"]);
    },
  );

  test("setAll iterates iterator argument once (with check function)", () {
    var mapCount = 0;
    final list = TestAllTypes().repeatedInt32..addAll([1, 2, 3, 4]);
    list.setAll(
      1,
      [5, 6, 7].map((i) {
        mapCount += 1;
        return i;
      }),
    );
    expect(mapCount, 3);
    expect(list, [1, 5, 6, 7]);
  });

  test("setAll iterates iterator argument once (without check function)", () {
    var mapCount = 0;
    final list = TestAllTypes().repeatedString..addAll(["a", "b", "c", "d"]);
    list.setAll(
      1,
      ["e", "f", "g"].map((i) {
        mapCount += 1;
        return i;
      }),
    );
    expect(mapCount, 3);
    expect(list, ["a", "e", "f", "g"]);
  });

  test("setRange iterates iterator argument once (with check function)", () {
    var mapCount = 0;
    final list = TestAllTypes().repeatedInt32..addAll([1, 2, 3]);
    list.setRange(
      0,
      3,
      [4, 5, 6].map((i) {
        mapCount += 1;
        return i;
      }),
    );
    expect(mapCount, 3);
    expect(list, [4, 5, 6]);
  });

  test("setRange iterates iterator argument once (without check function)", () {
    var mapCount = 0;
    final list = TestAllTypes().repeatedString..addAll(["a", "b", "c"]);
    list.setRange(
      0,
      3,
      ["d", "e", "f"].map((i) {
        mapCount += 1;
        return i;
      }),
    );
    expect(mapCount, 3);
    expect(list, ["d", "e", "f"]);
  });
}
