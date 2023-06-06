// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../protobuf.dart';

const typeIdTag = 2;
const messageTag = 3;

abstract class MessageSet extends GeneratedMessage {
  @override
  void writeToCodedBufferWriter(CodedBufferWriter output) {
    throw 'TODO';
  }

  @override
  void mergeFromCodedBufferReader(CodedBufferReader input,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    outer:
    while (true) {
      final tag = input.readTag();
      final wireType = tag & 0x7;
      final tagNumber = tag >> 3;

      if (tag == 0) {
        break;
      }

      if (tagNumber != 1) {
        throw 'Strange message set tag: $tag (type = $wireType, tag number = $tagNumber)';
      }

      int? typeId;
      List<int>? message;

      // Parse items
      while (true) {
        final tag = input.readTag();
        final wireType = tag & 0x7;
        final tagNumber = tag >> 3;

        if (tag == 0) {
          break;
        }

        if (tagNumber == typeIdTag) {
          assert(wireType == WIRETYPE_VARINT);
          typeId = input.readInt32();
          if (message != null) {
            _parseExtension(typeId, message, extensionRegistry);
            typeId = null;
            message = null;
            continue outer;
          }
        } else if (tagNumber == messageTag) {
          assert(wireType == WIRETYPE_LENGTH_DELIMITED);
          message = input.readBytes();
          if (typeId != null) {
            _parseExtension(typeId, message, extensionRegistry);
            typeId = null;
            message = null;
            continue outer;
          }
        } else {
          throw 'Invalid message set (tag = $tagNumber)';
        }
      }
    }
  }

  @override
  void mergeFromBuffer(List<int> input,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    mergeFromCodedBufferReader(CodedBufferReader(input), extensionRegistry);
  }

  void _parseExtension(int typeId, List<int> message, ExtensionRegistry extensionRegistry) {
    final ext = extensionRegistry.getExtension('MessageSet', typeId);
    if (ext == null) {
      _fieldSet._ensureUnknownFields().addField(typeId, UnknownFieldSetField()..addLengthDelimited(message));
    } else {
      setExtension(ext, (ext.makeDefault!() as GeneratedMessage).deepCopy()..mergeFromBuffer(message));
    }
  }
}
