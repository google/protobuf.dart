// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Tests event delivery using PbEventMixin.
library event_test;

import 'dart:typed_data' show Uint8List;

import 'package:protobuf/protobuf.dart' show GeneratedMessage;
import 'package:protobuf/src/protobuf/mixins/event_mixin.dart'
    show PbEventMixin, PbFieldChange;
import 'package:test/test.dart' show test, expect, predicate, same;

import 'mock_util.dart' show MockMessage;

class Rec extends MockMessage with PbEventMixin {
  get className => "Rec";
  Rec create() => new Rec();
}

main() {
  test('Events are sent when setting and clearing a non-repeated field', () {
    var log = makeLog();
    var r = new Rec();
    r.changes.listen((List<PbFieldChange> changes) {
      log.add(changes);
    });

    r.val = 123;
    checkLog(log, [[[1, 42, 123]]]);

    r.val = 456;
    checkLog(log, [[[1, 123, 456]]]);

    r.val = 456; // no change
    checkLog(log, []);

    r.clearField(1);
    checkLog(log, [[[1, 456, 42]]]);

    r.clearField(1);
    checkLog(log, []); // no change
  });

  test('Events are sent when creating and clearing a repeated field', () {
    var log = makeLog();
    var r = new Rec();
    r.changes.listen((List<PbFieldChange> changes) {
      log.add(changes);
    });

    // Accessing a repeated field replaces the default,
    // read-only [] with a mutable [],
    // which counts as a change.
    var list = r.int32s;
    checkLog(log, [[[4, [], []]]]);

    // No event yet for modifying a repeated field.
    list.add(123);
    checkLog(log, []);

    r.clearField(4);
    checkLog(log, [[[4, [123], []]]]);
  });

  test('Events are sent when clearing multiple fields', () {
    var log = makeLog();
    var r = new Rec()
      ..val = 123
      ..str = "hello"
      ..child = new Rec()
      ..int32s.add(456);

    r.changes.listen((List<PbFieldChange> changes) {
      // verify that we are not called until all fields are cleared
      checkHasAllFields(r, false);
      log.add(changes);
    });

    r.clear();
    expect(r.eventPlugin.groupStack, []);
    checkLog(log, [
      [[1, 123, 42], [2, "hello", ''], [3, "<msg>", "<msg>"], [4, [456], []]]
    ]);
  });

  test('Events are sent when merging from another protobuf', () {
    var log = makeLog();
    var src = new Rec()
      ..val = 123
      ..str = "hello"
      ..child = new Rec()
      ..int32s.add(456);

    var dest = new Rec();
    dest.changes.listen((List<PbFieldChange> changes) {
      checkHasAllFields(dest, true);
      log.add(changes);
    });

    dest.mergeFromMessage(src);
    checkLog(log, [
      [[1, 42, 123], [2, '', "hello"], [3, "<msg>", "<msg>"], [4, [], [456]]]
    ]);
  });

  test('Events are sent when merging JSON', () {
    var log = makeLog();
    var r = new Rec();
    r.changes.listen((List<PbFieldChange> changes) {
      // verify that we are not called until all fields are set
      checkHasAllFields(r, true);
      log.add(changes);
    });

    r.mergeFromJson('{"1": 123, "2": "hello", "3": {}, "4": [456]}');
    // The changes should not include the repeated message.
    checkLog(log, [
      [[1, 42, 123], [2, '', "hello"], [3, "<msg>", "<msg>"], [4, [], [456]]]
    ]);
  });

  test('Events are sent when merging binary', () {
    var log = makeLog();

    Uint8List bytes = (new Rec()
      ..val = 123
      ..str = "hello"
      ..child = new Rec()
      ..int32s.add(456)).writeToBuffer();

    var r = new Rec();
    r.changes.listen((List<PbFieldChange> changes) {
      // verify that we are not called until all fields are set
      checkHasAllFields(r, true);
      log.add(changes);
    });

    r.mergeFromBuffer(bytes);
    // The changes should not include the repeated message.
    checkLog(log, [
      [[1, 42, 123], [2, '', "hello"], [3, "<msg>", "<msg>"], [4, [], [456]]]
    ]);
  });
}

List<List<PbFieldChange>> makeLog() => <List<PbFieldChange>>[];

void checkLog(List<List<PbFieldChange>> log, List<List<List>> expected) {
  var actual = <List<List>>[];
  for (var list in log) {
    actual.add(list.map(toTuple).toList());
  }
  log.clear();
  expect(actual, expected);
}

void checkHasAllFields(Rec r, bool expected) {
  expect(r.hasField(1), expected);
  expect(r.hasField(2), expected);
  expect(r.hasField(3), expected);
  expect(r.hasField(4), expected);
}

List toTuple(PbFieldChange fc) {
  fixValue(v) {
    if (v is GeneratedMessage) {
      return "<msg>";
    }
    return v;
  }
  return [fc.tag, fixValue(fc.oldValue), fixValue(fc.newValue)];
}
