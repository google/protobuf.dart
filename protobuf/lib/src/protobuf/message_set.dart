// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../protobuf.dart';

const _messageSetItemsTag = 1;
const _messageSetItemTypeIdTag = 2;
const _messageSetItemMessageTag = 3;

/// Overrides binary serialization and deserialization methods to implement the
/// message set binary format.
///
/// Message set format is very old and only used in Google. When a message has
/// this option:
///
/// ```
/// option message_set_wire_format = true;
/// ```
///
/// The plugin extends the generated message class with this class instead of
/// [GeneratedMessage].
///
/// @nodoc
abstract class $_MessageSet extends GeneratedMessage {
  @override
  void writeToCodedBufferWriter(CodedBufferWriter output) {
    final extensions = _fieldSet._ensureExtensions();

    for (final ext in extensions._values.entries) {
      final typeId = ext.key;
      final message = ext.value as GeneratedMessage;

      output._writeTag(_messageSetItemsTag, WIRETYPE_START_GROUP);
      output._writeTag(_messageSetItemTypeIdTag, WIRETYPE_VARINT);
      output._writeVarint32(typeId);
      output._writeTag(_messageSetItemMessageTag, WIRETYPE_LENGTH_DELIMITED);
      final mark = output._startLengthDelimited();
      message.writeToCodedBufferWriter(output);
      output._endLengthDelimited(mark);
      output._writeTag(_messageSetItemsTag, WIRETYPE_END_GROUP);
    }

    final unknownFields = _fieldSet._unknownFields;
    if (unknownFields != null) {
      unknownFields.writeToCodedBufferWriter(output);
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

      if (tagNumber != _messageSetItemsTag) {
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
          // Skip unknown tags.
          if (!input.skipField(tag)) {
            break outer; // End of group.
          }
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
    final ext =
        extensionRegistry.getExtension(info_.qualifiedMessageName, typeId);
    if (ext == null) {
      final messageItem = UnknownFieldSet();
      messageItem.addField(_messageSetItemTypeIdTag,
          UnknownFieldSetField()..varints.add(Int64(typeId)));
      messageItem.addField(_messageSetItemMessageTag,
          UnknownFieldSetField()..lengthDelimited.add(message));

      final itemListField =
          _fieldSet._ensureUnknownFields().getField(_messageSetItemsTag) ??
              UnknownFieldSetField();
      itemListField.addGroup(messageItem);

      _fieldSet
          ._ensureUnknownFields()
          .addField(_messageSetItemsTag, itemListField);
    } else {
      setExtension(ext, ext.subBuilder!()..mergeFromBuffer(message));
    }
  }
}
