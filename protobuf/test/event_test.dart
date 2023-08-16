// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// Tests event delivery using PbEventMixin.

import 'package:protobuf/protobuf.dart';
import 'package:protobuf/src/protobuf/mixins/event_mixin.dart'
    show PbEventMixin, PbFieldChange;
import 'package:test/test.dart' show expect, test;

import 'mock_util.dart' show MockMessage, mockInfo;

class Rec extends MockMessage with PbEventMixin {
  @override
  BuilderInfo get info_ => _info;
  static final _info = mockInfo('Rec', Rec.new);
  @override
  Rec createEmptyInstance() => Rec();
}

Extension comment = Extension('Rec', 'comment', 6, PbFieldType.OS);

void main() {
  test('Events are sent when setting and clearing a non-repeated field', () {
    final log = makeLog();
    final r = Rec();
    r.changes.listen(log.add);

    r.val = 123;
    r.deliverChanges();
    checkLogOnce(log, [1, 42, 123]);

    r.val = 456;
    r.deliverChanges();
    checkLogOnce(log, [1, 123, 456]);

    r.val = 456; // no change
    r.deliverChanges();
    checkLog(log, []);

    r.clearField(1);
    r.deliverChanges();
    checkLogOnce(log, [1, 456, 42]);

    r.clearField(1); // no change
    r.deliverChanges();
    checkLog(log, []);
  });

  test('Events are sent when creating and clearing a repeated field', () {
    final log = makeLog();
    final r = Rec();
    r.changes.listen(log.add);

    // Accessing a repeated field replaces the default,
    // read-only [] with a mutable [],
    // which counts as a change.
    final list = r.int32s;
    r.deliverChanges();
    checkLogOnce(log, [4, [], []]);

    // No event yet for modifying a repeated field.
    list.add(123);
    r.deliverChanges();
    checkLog(log, []);

    r.clearField(4);
    r.deliverChanges();
    checkLogOnce(log, [
      4,
      [123],
      []
    ]);
  });

  test('Events are sent when clearing multiple fields', () {
    final log = makeLog();
    final r = Rec()
      ..val = 123
      ..str = 'hello'
      ..child = Rec()
      ..int32s.add(456);

    r.changes.listen((List<PbFieldChange> changes) {
      // verify that we are not called until all fields are cleared
      checkHasAllFields(r, false);
      log.add(changes);
    });

    r.clear();
    r.deliverChanges();
    checkLog(log, [
      [
        [1, 123, 42],
        [2, 'hello', ''],
        [3, '<msg>', '<msg>'],
        [
          4,
          [456],
          []
        ]
      ]
    ]);
  });

  test('Events are sent when merging from another protobuf', () {
    final log = makeLog();
    final src = Rec()
      ..val = 123
      ..str = 'hello'
      ..child = Rec()
      ..int32s.add(456);

    final dest = Rec();
    dest.changes.listen((List<PbFieldChange> changes) {
      checkHasAllFields(dest, true);
      log.add(changes);
    });

    dest.mergeFromMessage(src);
    dest.deliverChanges();
    checkLog(log, [
      [
        [1, 42, 123],
        [2, '', 'hello'],
        [3, '<msg>', '<msg>'],
        [
          4,
          [],
          [456]
        ]
      ]
    ]);
  });

  test('Events are sent when merging JSON', () {
    final log = makeLog();
    final r = Rec();
    r.changes.listen((List<PbFieldChange> changes) {
      // verify that we are not called until all fields are set
      checkHasAllFields(r, true);
      log.add(changes);
    });

    r.mergeFromJson('{"1": 123, "2": "hello", "3": {}, "4": [456]}');
    // The changes should not include the repeated message.
    r.deliverChanges();
    checkLog(log, [
      [
        [1, 42, 123],
        [2, '', 'hello'],
        [3, '<msg>', '<msg>'],
        [
          4,
          [],
          [456]
        ]
      ]
    ]);
  });

  test('Events are sent when merging binary', () {
    final log = makeLog();

    final bytes = (Rec()
          ..val = 123
          ..str = 'hello'
          ..child = Rec()
          ..int32s.add(456))
        .writeToBuffer();

    final r = Rec();
    r.changes.listen((List<PbFieldChange> changes) {
      // verify that we are not called until all fields are set
      checkHasAllFields(r, true);
      log.add(changes);
    });

    r.mergeFromBuffer(bytes);
    // The changes should not include the repeated message.
    r.deliverChanges();
    checkLog(log, [
      [
        [1, 42, 123],
        [2, '', 'hello'],
        [3, '<msg>', '<msg>'],
        [
          4,
          [],
          [456]
        ]
      ]
    ]);
  });

  test('Events are sent for extensions', () {
    final log = makeLog();
    final r = Rec();
    r.changes.listen(log.add);

    final tag = comment.tagNumber;
    void setComment(String value) {
      r.setExtension(comment, value);
      expect(r.getExtension(comment), value);
      r.deliverChanges();
      checkLogOnce(log, [tag, '', value]);
    }

    void clear(String expected) {
      r.clear();
      r.deliverChanges();
      checkLogOnce(log, [tag, expected, '']);
    }

    setComment('hello');
    clear('hello');

    setComment('hello');
    r.setField(6, 'hi');
    r.deliverChanges();
    checkLogOnce(log, [tag, 'hello', 'hi']);
    clear('hi');

    setComment('hello');
    r.clearExtension(comment);
    r.deliverChanges();
    checkLogOnce(log, [tag, 'hello', '']);

    setComment('hello');
    r.clearField(comment.tagNumber);
    r.deliverChanges();
    checkLogOnce(log, [tag, 'hello', '']);

    final registry = ExtensionRegistry()..add(comment);
    r.mergeFromJson('{"$tag": "hello"}', registry);
    expect(r.getExtension(comment), 'hello');
    r.deliverChanges();
    checkLogOnce(log, [tag, '', 'hello']);
    clear('hello');

    final src = Rec()..setExtension(comment, 'hello');
    r.mergeFromMessage(src);
    expect(r.getExtension(comment), 'hello');
    r.deliverChanges();
    checkLogOnce(log, [tag, '', 'hello']);
    clear('hello');

    final bytes = src.writeToBuffer();
    r.mergeFromBuffer(bytes, registry);
    expect(r.getExtension(comment), 'hello');
    r.deliverChanges();
    checkLogOnce(log, [tag, '', 'hello']);
    clear('hello');
  });
}

List<List<PbFieldChange>> makeLog() => <List<PbFieldChange>>[];

void checkLogOnce(List<List<PbFieldChange>> log, List expectedEntry) =>
    checkLog(log, [
      [expectedEntry]
    ]);

void checkLog(List<List<PbFieldChange>> log, List<List<List>> expected) {
  final actual = <List<List>>[];
  for (final list in log) {
    final tuples = <List>[];
    for (final item in list) {
      tuples.add(toTuple(item));
    }
    actual.add(tuples);
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
  dynamic fixValue(v) {
    if (v is GeneratedMessage) {
      return '<msg>';
    }
    return v;
  }

  return [fc.tag, fixValue(fc.oldValue), fixValue(fc.newValue)];
}
