// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/empty.pb.dart';
import '../out/protos/message_set.pb.dart';

void main() {
  final encoded = [
    0xda, 0x07, 0x0e, 0x0b, 0x10, 0xc8, 0xa6, 0x6b, 0x1a, //
    0x06, 0x08, 0x7b, 0x12, 0x02, 0x68, 0x69, 0x0c
  ];

  test('Simple message set field', () {
    final registry = ExtensionRegistry()..add(TestMessage.messageSetExtension);
    final msg = TestMessage.fromBuffer(encoded, registry);
    final extensionValue = msg.info
        .getExtension(TestMessage.messageSetExtension) as ExtensionMessage;
    expect(extensionValue.a, 123);
    expect(extensionValue.b, 'hi');
    expect(msg.writeToBuffer(), encoded);
  });

  test('Parse as unknown fields and serialize', () {
    final msg = TestMessage.fromBuffer(encoded);
    expect(msg.writeToBuffer(), encoded);
  });

  test('Reparse with extensions (nested message)', () {
    final msg = TestMessage.fromBuffer(encoded);
    final registry = ExtensionRegistry()..add(TestMessage.messageSetExtension);
    final reparsedInfo = registry.reparseMessage(msg.info);
    final extensionValue = reparsedInfo
        .getExtension(TestMessage.messageSetExtension) as ExtensionMessage;
    expect(extensionValue.a, 123);
    expect(extensionValue.b, 'hi');
    expect(reparsedInfo.unknownFields.isEmpty, true);
  });

  test('Reparse with extensions (top-level message)', () {
    final msg = TestMessage.fromBuffer(encoded);
    final registry = ExtensionRegistry()..add(TestMessage.messageSetExtension);
    final reparsedMsg = registry.reparseMessage(msg);
    final extensionValue = reparsedMsg.info
        .getExtension(TestMessage.messageSetExtension) as ExtensionMessage;
    expect(extensionValue.a, 123);
    expect(extensionValue.b, 'hi');
    expect(msg.unknownFields.isEmpty, true);
  });

  test('Ignore extra tags in items', () {
    // Generate a message set encoding using unknown fields. Message set item
    // will have extra tags.

    final itemFieldGroup = UnknownFieldSet();

    // Invalid field with tag 1.
    itemFieldGroup.addField(
        1, UnknownFieldSetField()..addLengthDelimited([1, 2, 3]));

    // Extension field.
    itemFieldGroup.addField(
        3,
        UnknownFieldSetField()
          ..addLengthDelimited((ExtensionMessage()
                ..a = 123456
                ..b = 'test')
              .writeToBuffer()));

    // Invalid field with tag 3.
    itemFieldGroup.addField(
        4, UnknownFieldSetField()..addVarint(Int64(123456)));

    // Type id field.
    itemFieldGroup.addField(
        2, UnknownFieldSetField()..addVarint(Int64(1758024)));

    final messageSetUnknownFields = UnknownFieldSet();
    messageSetUnknownFields.addField(
        1, UnknownFieldSetField()..addGroup(itemFieldGroup));

    final messageSetEncoded = CodedBufferWriter();
    messageSetUnknownFields.writeToCodedBufferWriter(messageSetEncoded);

    final encoded = (Empty()
          ..unknownFields.addField(
              123,
              UnknownFieldSetField()
                ..lengthDelimited.add(messageSetEncoded.toBuffer())))
        .writeToBuffer();

    final registry = ExtensionRegistry()..add(TestMessage.messageSetExtension);
    final msg = TestMessage.fromBuffer(encoded, registry);
    final extensionValue = msg.info
        .getExtension(TestMessage.messageSetExtension) as ExtensionMessage;
    expect(extensionValue.a, 123456);
    expect(extensionValue.b, 'test');
    expect(msg.unknownFields.isEmpty, true);
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

    final registry = ExtensionRegistry()..add(TestMessage.messageSetExtension);
    final msg = TestMessage.fromBuffer(encoded, registry);
    expect(msg.info.hasExtension(TestMessage.messageSetExtension), false);
  });
}
