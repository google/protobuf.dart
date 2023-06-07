// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../protobuf.dart';

const typeIdTag = 2;
const messageTag = 3;

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

      int? typeId;
      List<int>? message;

      // Parse items
      while (true) {
        final tag = input.readTag();
        final tagNumber = getTagFieldNumber(tag);

        if (tag == 0) {
          break;
        }

        if (tagNumber == typeIdTag) {
          typeId = input.readInt32();
          if (message != null) {
            _parseExtension(typeId, message, extensionRegistry);
            typeId = null;
            message = null;
            continue outer;
          }
        } else if (tagNumber == messageTag) {
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
      _fieldSet._ensureUnknownFields().addField(
          typeId, UnknownFieldSetField()..addLengthDelimited(message));
    } else {
      setExtension(ext, ext.subBuilder!()..mergeFromBuffer(message));
    }
  }
}
