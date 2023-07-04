// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/empty.pb.dart';
import '../out/protos/message_set.pb.dart';

void main() {
  // Example message with a nested message set, encoded with the C++ library.
  // `protoc --decode_raw` output:
  //
  // 1 {
  //   1 {
  //     2: 1758024
  //     3 {
  //       1: 123
  //       2: "testing"
  //       3 {
  //         5: 0
  //         5: 1
  //         5: 2
  //       }
  //     }
  //   }
  //   1 {
  //     2: 1832098
  //     3 {
  //       5: 987
  //       5: 654
  //       5: 321
  //     }
  //   }
  // }
  final encodedNested = [
    10, 44, 11, 16, 200, 166, 107, 26, 19, 8, 123, 18, 7, 116, 101, 115, //
    116, 105, 110, 103, 26, 6, 40, 0, 40, 1, 40, 2, 12, 11, 16, 162, 233, //
    111, 26, 9, 40, 219, 7, 40, 142, 5, 40, 193, 2, 12
  ];

  // Example message with a top-level message set, encoded with the C++
  // library. `protoc --decode_raw` output:
  //
  // 1 {
  //   2: 1758024
  //   3 {
  //     1: 123
  //   }
  // }
  // 1 {
  //   2: 1832098
  //   3 {
  //     5: 987
  //   }
  // }
  final encodedTopLevel = [
    11, 16, 200, 166, 107, 26, 2, 8, 123, 12, 11, 16, 162, 233, 111, 26, 3, //
    40, 219, 7, 12
  ];

  test('Parse message set extensions (nested)', () {
    final registry = ExtensionRegistry()
      ..add(TestMessage.ext1)
      ..add(TestMessage.ext2);
    final msg = TestMessage.fromBuffer(encodedNested, registry);

    final ext1Value =
        msg.info.getExtension(TestMessage.ext1) as ExtensionMessage1;
    expect(ext1Value.a, 123);
    expect(ext1Value.b, 'testing');
    expect(ext1Value.c.ints, [0, 1, 2]);

    final ext2Value =
        msg.info.getExtension(TestMessage.ext2) as ExtensionMessage2;
    expect(ext2Value.ints, [987, 654, 321]);

    expect(msg.writeToBuffer(), encodedNested);
  });

  test('Parse message set (top-level)', () {
    final registry = ExtensionRegistry()
      ..add(TestMessage.ext1)
      ..add(TestMessage.ext2);
    final msg = MessageSet.fromBuffer(encodedTopLevel, registry);

    final ext1Value = msg.getExtension(TestMessage.ext1) as ExtensionMessage1;
    expect(ext1Value.a, 123);
    expect(ext1Value.b, ''); // not set
    expect(ext1Value.c.ints, []); // not set

    final ext2Value = msg.getExtension(TestMessage.ext2) as ExtensionMessage2;
    expect(ext2Value.ints, [987]);

    expect(msg.writeToBuffer(), encodedTopLevel);
  });

  test('Parse as unknown fields and serialize', () {
    final msg = TestMessage.fromBuffer(encodedNested);
    expect(msg.writeToBuffer(), encodedNested);
  });

  test('Reparse with extensions (nested message)', () {
    final msg = TestMessage.fromBuffer(encodedNested);
    final registry = ExtensionRegistry()
      ..add(TestMessage.ext1)
      ..add(TestMessage.ext2);
    final reparsedInfo = registry.reparseMessage(msg.info);

    final ext1Value =
        reparsedInfo.getExtension(TestMessage.ext1) as ExtensionMessage1;
    expect(ext1Value.a, 123);
    expect(ext1Value.b, 'testing');

    final ext2Value =
        reparsedInfo.getExtension(TestMessage.ext2) as ExtensionMessage2;
    expect(ext2Value.ints, [987, 654, 321]);

    expect(reparsedInfo.unknownFields.isEmpty, true);
  });

  test('Reparse with extensions (top-level message)', () {
    final msg = TestMessage.fromBuffer(encodedNested);
    final registry = ExtensionRegistry()
      ..add(TestMessage.ext1)
      ..add(TestMessage.ext2);
    final reparsedMsg = registry.reparseMessage(msg);

    final ext1Value =
        reparsedMsg.info.getExtension(TestMessage.ext1) as ExtensionMessage1;
    expect(ext1Value.a, 123);
    expect(ext1Value.b, 'testing');

    final ext2Value =
        reparsedMsg.info.getExtension(TestMessage.ext2) as ExtensionMessage2;
    expect(ext2Value.ints, [987, 654, 321]);

    expect(msg.unknownFields.isEmpty, true);
  });

  test('Ignore extra tags in items', () {
    // Generate a message set encoding using unknown fields. Message set item
    // will have extra tags.

    final encoded = encodeMessageSetWithExtraItemTags(Encoding.group);

    final registry = ExtensionRegistry()..add(TestMessage.ext1);
    final decodedMsg = MessageSet.fromBuffer(encoded, registry);
    final extensionValue =
        decodedMsg.getExtension(TestMessage.ext1) as ExtensionMessage1;

    expect(extensionValue.a, 123456);
    expect(extensionValue.b, 'test');
    expect(decodedMsg.unknownFields.isEmpty, true);
  });

  test('Ignore extra tags in items (length delimited encoding)', () {
    // Same as above, but tests length delimited encoding.

    final encoded = encodeMessageSetWithExtraItemTags(Encoding.lengthDelimited);

    final registry = ExtensionRegistry()..add(TestMessage.ext1);
    final decodedMsg = MessageSet.fromBuffer(encoded, registry);
    final extensionValue =
        decodedMsg.getExtension(TestMessage.ext1) as ExtensionMessage1;

    expect(extensionValue.a, 123456);
    expect(extensionValue.b, 'test');
    expect(decodedMsg.unknownFields.isEmpty, true);
  });

  test('Ignore invalid tags in repeated items', () {
    // Extra fields other than `repeated Item items = 1` in the outer message.

    final messageSetUnknownFields = UnknownFieldSet();
    messageSetUnknownFields.addField(
        2, UnknownFieldSetField()..addVarint(Int64(987)));

    final messageSetEncoded = CodedBufferWriter();
    messageSetUnknownFields.writeToCodedBufferWriter(messageSetEncoded);

    final encoded = (Empty()
          ..unknownFields.addField(
              123,
              UnknownFieldSetField()
                ..lengthDelimited.add(messageSetEncoded.toBuffer())))
        .writeToBuffer();

    final registry = ExtensionRegistry()..add(TestMessage.ext1);
    final msg = TestMessage.fromBuffer(encoded, registry);
    expect(msg.info.hasExtension(TestMessage.ext1), false);
  });

  test('Encode message set as length prefixed', () {
    // Message sets are generally encoded as groups, but we support length
    // delimited as well.

    final messageSetUnknownFields = UnknownFieldSet();
    messageSetUnknownFields.addField(
        2, UnknownFieldSetField()..addVarint(Int64(987)));

    final messageSetEncoded = CodedBufferWriter();
    messageSetUnknownFields.writeToCodedBufferWriter(messageSetEncoded);

    final encoded = (Empty()
          ..unknownFields.addField(
              123,
              UnknownFieldSetField()
                ..lengthDelimited.add(messageSetEncoded.toBuffer())))
        .writeToBuffer();

    final registry = ExtensionRegistry()..add(TestMessage.ext1);
    final msg = TestMessage.fromBuffer(encoded, registry);
    expect(msg.info.hasExtension(TestMessage.ext1), false);
  });
}

enum Encoding {
  lengthDelimited,
  group,
}

/// Generate a message set encoding with one extension. Extension will have
/// extra tags.
Uint8List encodeMessageSetWithExtraItemTags(Encoding encoding) {
  final itemFieldGroup = UnknownFieldSet();

  // Invalid field with tag 1.
  itemFieldGroup.addField(
      1, UnknownFieldSetField()..addLengthDelimited([1, 2, 3]));

  // Extension field.
  itemFieldGroup.addField(
      3,
      UnknownFieldSetField()
        ..addLengthDelimited((ExtensionMessage1()
              ..a = 123456
              ..b = 'test')
            .writeToBuffer()));

  // Invalid field with tag 3.
  itemFieldGroup.addField(4, UnknownFieldSetField()..addVarint(Int64(123456)));

  // Type id field.
  itemFieldGroup.addField(2, UnknownFieldSetField()..addVarint(Int64(1758024)));

  final messageSet = Empty();
  final messageSetUnknownFields = messageSet.unknownFields;

  switch (encoding) {
    case Encoding.lengthDelimited:
      final writer = CodedBufferWriter();
      itemFieldGroup.writeToCodedBufferWriter(writer);
      messageSetUnknownFields.addField(
          1, UnknownFieldSetField()..addLengthDelimited(writer.toBuffer()));
      break;
    case Encoding.group:
      messageSetUnknownFields.addField(
          1, UnknownFieldSetField()..addGroup(itemFieldGroup));
      break;
  }

  messageSetUnknownFields.addField(
      1, UnknownFieldSetField()..addGroup(itemFieldGroup));

  final messageSetEncoded = CodedBufferWriter();
  messageSetUnknownFields.writeToCodedBufferWriter(messageSetEncoded);

  return messageSet.writeToBuffer();
}
