// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../protobuf.dart';

const _messageSetItemTypeIdTag = 2;
const _messageSetItemMessageTag = 3;

abstract class MessageSet extends GeneratedMessage {
  @override
  void writeToCodedBufferWriter(CodedBufferWriter output) {
    final extensions = _fieldSet._ensureExtensions();

    for (final ext in extensions._values.entries) {
      final typeId = ext.key;
      final message = ext.value as GeneratedMessage;

      output._writeTag(1, WIRETYPE_START_GROUP);
      output._writeTag(2, WIRETYPE_VARINT);
      output._writeVarint32(typeId);
      output._writeTag(3, WIRETYPE_LENGTH_DELIMITED);
      final mark = output._startLengthDelimited();
      message.writeToCodedBufferWriter(output);
      output._endLengthDelimited(mark);
      output._writeTag(1, WIRETYPE_END_GROUP);
    }
  }

  @override
  void mergeFromCodedBufferReader(CodedBufferReader input,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    // Parse items. The field for the items looks like:
    //
    //   repeated Item items = 1;
    //
    // Since message sets are compatible with proto1 items can't be packed.
    outer:
    while (true) {
      final tag = input.readTag();
      final wireType = getTagWireType(tag);
      final tagNumber = getTagFieldNumber(tag);

      if (tag == 0) {
        break;
      }

      if (tagNumber != 1) {
        throw UnsupportedError(
            'Invalid message set (type = $wireType, tag = $tagNumber)');
      }

      // Parse an item. An item is a message with two fields:
      //
      //   message Item {
      //     int32 type_id = 2;
      //     Message message = 3;
      //   }
      //
      // We can see the fields in any order, so loop until parsing both fields.
      int? typeId;
      List<int>? message;
      while (true) {
        final tag = input.readTag();
        final tagNumber = getTagFieldNumber(tag);

        if (tag == 0) {
          break;
        }

        if (tagNumber == _messageSetItemTypeIdTag) {
          typeId = input.readInt32();
          if (message != null) {
            _parseExtension(typeId, message, extensionRegistry);
            typeId = null;
            message = null;
            continue outer;
          }
        } else if (tagNumber == _messageSetItemMessageTag) {
          message = input.readBytes();
          if (typeId != null) {
            _parseExtension(typeId, message, extensionRegistry);
            typeId = null;
            message = null;
            continue outer;
          }
        } else {
          throw UnsupportedError('Invalid message set item (tag = $tagNumber)');
        }
      }
    }
  }

  @override
  void mergeFromBuffer(List<int> input,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    mergeFromCodedBufferReader(CodedBufferReader(input), extensionRegistry);
  }

  void _parseExtension(
      int typeId, List<int> message, ExtensionRegistry extensionRegistry) {
    final ext = extensionRegistry.getExtension('MessageSet', typeId);
    if (ext == null) {
      final itemMessage = UnknownFieldSet();
      itemMessage.addField(
          2, UnknownFieldSetField()..varints.add(Int64(typeId)));
      itemMessage.addField(
          3, UnknownFieldSetField()..lengthDelimited.add(message));
      final itemMessageBuffer = CodedBufferWriter();
      itemMessage.writeToCodedBufferWriter(itemMessageBuffer);

      _fieldSet._ensureUnknownFields().addField(
          1,
          UnknownFieldSetField()
            ..lengthDelimited.add(itemMessageBuffer.toBuffer()));
    } else {
      setExtension(ext, ext.subBuilder!()..mergeFromBuffer(message));
    }
  }
}
