#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Unit tests for PbMapMixin.
// There are more tests in the dart-protoc-plugin package.
library map_mixin_test;

import 'dart:collection' show MapMixin;

import 'package:protobuf/protobuf.dart'
    show GeneratedMessage, PbMapMixin, BuilderInfo;
import 'package:protobuf/src/protobuf/mixins/map_mixin.dart';
import 'package:test/test.dart' show test, expect, predicate, same;

// A minimal protobuf implementation compatible with PbMapMixin.
class Rec extends GeneratedMessage with MapMixin, PbMapMixin {
  int val = 0;
  String str = "";
  Rec child;

  @override
  BuilderInfo info_ = new BuilderInfo("rec")
    ..a(1, "val", null)
    ..a(2, "str", null)
    ..a(3, "child", null);

  @override
  void clear() {
    val = 0;
    str = "";
    child = null;
  }

  @override
  int getTagNumber(String fieldName) {
    switch (fieldName) {
      case 'val':
        return 1;
      case 'str':
        return 2;
      case 'child':
        return 3;
      default:
        return null;
    }
  }

  @override
  getField(int tagNumber) {
    switch (tagNumber) {
      case 1:
        return val;
      case 2:
        return str;
      case 3:
        // lazy initializaton
        if (child == null) {
          child = new Rec();
        }
        return child;
      default:
        return null;
    }
  }

  @override
  void setField(int tagNumber, var value, [int fieldType = null]) {
    switch (tagNumber) {
      case 1:
        val = value;
        return;
      case 2:
        str = value;
        return;
      case 3:
        child = value;
        return;
      default:
        throw new ArgumentError("Rec doesn't support tag: ${tagNumber}");
    }
  }

  @override
  String toString() {
    return "Rec(${val}, \"${str}\", ${child})";
  }
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
    expect(r["child"].toString(), 'Rec(0, "", null)');

    var v = r.values;
    expect(v.length, 3);
    expect(v.first, 0);
    expect(v.toList()[1], "");
    expect(v.last.toString(), 'Rec(0, "", null)');
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
