#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Unit tests for PbMapMixin.
// There are more tests in the dart-protoc-plugin package.
library map_mixin_test;

import 'dart:collection' show MapMixin;

import 'package:protobuf/src/protobuf/mixins/map_mixin.dart';
import 'package:test/test.dart' show test, expect, predicate, same;

import 'mock_util.dart' show MockMessage;

// A minimal protobuf implementation compatible with PbMapMixin.
class Rec extends MockMessage with MapMixin, PbMapMixin {
  get className => "Rec";
  Rec create() => new Rec();

  @override
  String toString() => "Rec(${val}, \"${str}\")";
}

main() {
  test('PbMapMixin methods return default field values', () {
    var r = new Rec();

    expect(r.isEmpty, false);
    expect(r.isNotEmpty, true);
    expect(r.keys, ["val", "str", "child"]);

    expect(r["val"], 0);
    expect(r["str"], "");
    expect(r["child"].runtimeType, Rec);
    expect(r["child"].toString(), 'Rec(0, "")');

    var v = r.values;
    expect(v.length, 3);
    expect(v.first, 0);
    expect(v.toList()[1], "");
    expect(v.last.toString(), 'Rec(0, "")');
  });

  test('operator []= sets record fields', () {
    var r = new Rec();

    r["val"] = 123;
    expect(r.val, 123);
    expect(r["val"], 123);

    r["str"] = "hello";
    expect(r.str, "hello");
    expect(r["str"], "hello");

    var child = new Rec();
    r["child"] = child;
    expect(r.child, same(child));
    expect(r["child"], same(child));
  });
}
