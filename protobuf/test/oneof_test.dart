// Copyright (c) 2026, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

/// A message whose [BuilderInfo] is supplied by the test, so the test can
/// declare `oneof`s and fields in any order.
class OneofMessage extends GeneratedMessage {
  @override
  final BuilderInfo info_;

  OneofMessage(this.info_);

  @override
  OneofMessage createEmptyInstance() => OneofMessage(info_);

  @override
  OneofMessage clone() => deepCopy();

  int whichOneof(int oneofIndex) => $_whichOneof(oneofIndex);
}

/// Declares `oneof`s before fields, the way generated code does:
///
/// - oneof 0: `a` (1), `c` (3), `child` (6)
/// - oneof 1: `b` (2), `d` (4)
/// - `plain` (5) is not in a `oneof`.
BuilderInfo twoOneofsInfo() {
  late final BuilderInfo info;
  info =
      BuilderInfo('TwoOneofs', createEmptyInstance: () => OneofMessage(info))
        ..oo(0, [1, 3, 6])
        ..oo(1, [2, 4])
        ..aOS(1, 'a')
        ..aOS(2, 'b')
        ..a<int>(3, 'c', PbFieldType.O3)
        ..aOS(4, 'd')
        ..aOS(5, 'plain')
        ..aOM<OneofMessage>(6, 'child', subBuilder: () => OneofMessage(info));
  return info;
}

void main() {
  test('no oneof is set on a fresh message', () {
    final message = OneofMessage(twoOneofsInfo());
    expect(message.whichOneof(0), 0);
    expect(message.whichOneof(1), 0);
  });

  test('oneofs declared before their fields are tracked', () {
    final message = OneofMessage(twoOneofsInfo())..setField(3, 7);
    expect(message.whichOneof(0), 3);
    expect(message.whichOneof(1), 0);

    message.setField(1, 'a');
    expect(message.whichOneof(0), 1);
    expect(message.hasField(3), isFalse);

    message.setField(4, 'd');
    expect(message.whichOneof(0), 1);
    expect(message.whichOneof(1), 4);

    message.setField(5, 'plain');
    expect(message.whichOneof(0), 1);
    expect(message.whichOneof(1), 4);

    message.clearField(1);
    expect(message.whichOneof(0), 0);
    expect(message.whichOneof(1), 4);
  });

  test('the slot of the replaced member is cleared', () {
    final info = twoOneofsInfo();
    final message =
        OneofMessage(info)
          ..setField(6, OneofMessage(info)..setField(5, 'x'))
          ..setField(3, 7);
    expect(message.whichOneof(0), 3);
    expect(message.getFieldOrNull(6), isNull);
    expect(message.getFieldOrNull(1), isNull);
  });

  test('the oneof member index is rebuilt when fields are added later', () {
    late final BuilderInfo info;
    info =
        BuilderInfo('Growing', createEmptyInstance: () => OneofMessage(info))
          ..oo(0, [1, 2])
          ..aOS(1, 'a')
          ..aOS(2, 'b');

    // Compute the oneof member indices.
    expect((OneofMessage(info)..setField(2, 'b')).whichOneof(0), 2);

    info
      ..oo(1, [3, 4])
      ..aOS(3, 'c')
      ..aOS(4, 'd');

    final message =
        OneofMessage(info)
          ..setField(3, 'c')
          ..setField(1, 'a');
    expect(message.whichOneof(0), 1);
    expect(message.whichOneof(1), 3);

    message.setField(4, 'd');
    expect(message.whichOneof(1), 4);
    expect(message.hasField(3), isFalse);
  });

  test('a oneof tag without a field is never the active member', () {
    late final BuilderInfo info;
    info =
        BuilderInfo(
            'MissingField',
            createEmptyInstance: () => OneofMessage(info),
          )
          ..oo(0, [1, 99])
          ..aOS(1, 'a');

    final message = OneofMessage(info);
    expect(message.whichOneof(0), 0);
    message.setField(1, 'a');
    expect(message.whichOneof(0), 1);
  });

  test('oneof state survives binary and JSON round trips', () {
    final info = twoOneofsInfo();
    final message =
        OneofMessage(info)
          ..setField(1, 'a')
          ..setField(3, 0)
          ..setField(2, '');

    final fromBuffer = OneofMessage(info)
      ..mergeFromBuffer(message.writeToBuffer());
    expect(fromBuffer.whichOneof(0), 3);
    expect(fromBuffer.whichOneof(1), 2);
    expect(fromBuffer, message);

    final fromJson = OneofMessage(info)..mergeFromJson(message.writeToJson());
    expect(fromJson.whichOneof(0), 3);
    expect(fromJson.whichOneof(1), 2);
  });

  test('copies keep the oneof state', () {
    final info = twoOneofsInfo();
    final message =
        OneofMessage(info)
          ..setField(6, OneofMessage(info))
          ..setField(4, 'd');

    final deepCopy = message.deepCopy();
    expect(deepCopy.whichOneof(0), 6);
    expect(deepCopy.whichOneof(1), 4);

    message.freeze();
    final rebuilt = message.rebuild((m) => m.setField(1, 'a'));
    expect(rebuilt.whichOneof(0), 1);
    expect(rebuilt.whichOneof(1), 4);
    expect(message.whichOneof(0), 6);

    final merged =
        OneofMessage(info)
          ..setField(3, 1)
          ..mergeFromMessage(message);
    expect(merged.whichOneof(0), 6);
    expect(merged.hasField(3), isFalse);
  });
}
