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
    //   repeated group Item items = 1;
    //
    // Since message sets are compatible with proto1 items can't be packed.
    while (true) {
      final tag = input.readTag();
      final tagNumber = getTagFieldNumber(tag);

      if (tag == 0) {
        break; // End of input.
      }

      if (tagNumber != _messageSetItemsTag) {
        if (!input.skipField(tag)) {
          break; // End of group.
        } else {
          continue;
        }
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
      Uint8List? message;
      while (true) {
        final tag = input.readTag();
        final tagNumber = getTagFieldNumber(tag);

        if (tag == 0) {
          break; // End of input.
        }

        if (tagNumber == _messageSetItemTypeIdTag) {
          typeId = input.readInt32();
          if (message != null) {
            _parseExtension(typeId, message, extensionRegistry);
            typeId = null;
            message = null;
          }
        } else if (tagNumber == _messageSetItemMessageTag) {
          message = input.readBytesAsView();
          if (typeId != null) {
            _parseExtension(typeId, message, extensionRegistry);
            typeId = null;
            message = null;
          }
        } else {
          // Skip unknown tags. If we're at the end of the group consume the
          // EGROUP tag.
          if (!input.skipField(tag)) {
            break; // End of group.
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
      int typeId, Uint8List message, ExtensionRegistry extensionRegistry) {
    final ext =
        extensionRegistry.getExtension(info_.qualifiedMessageName, typeId);
    if (ext == null) {
      final messageItem = UnknownFieldSet();
      messageItem.addField(_messageSetItemTypeIdTag,
          UnknownFieldSetField()..varints.add(Int64(typeId)));
      messageItem.addField(
          _messageSetItemMessageTag,
          UnknownFieldSetField()
            ..lengthDelimited.add(Uint8List.fromList(message)));

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
