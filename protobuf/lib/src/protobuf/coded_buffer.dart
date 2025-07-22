// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'internal.dart';

void _writeToCodedBufferWriter(FieldSet fs, CodedBufferWriter out) {
  // Sorting by tag number isn't required, but it sometimes enables
  // performance optimizations for the receiver. See:
  // https://developers.google.com/protocol-buffers/docs/encoding?hl=en#order

  for (final fi in fs._infosSortedByTag) {
    final value = fs._values[fi.index!];
    if (value == null) continue;
    out.writeField(fi.tagNumber, fi.type, value);
  }

  final extensions = fs._extensions;
  if (extensions != null) {
    for (final tagNumber in sorted(extensions._tagNumbers)) {
      final fi = extensions._getInfoOrNull(tagNumber)!;
      out.writeField(tagNumber, fi.type, extensions._getFieldOrNull(fi));
    }
  }

  final unknownFields = fs._unknownFields;
  if (unknownFields != null) {
    unknownFields.writeToCodedBufferWriter(out);
  }
}

void _mergeFromCodedBufferReader(
  BuilderInfo meta,
  FieldSet fs,
  CodedBufferReader input,
  ExtensionRegistry registry,
) {
  fs._ensureWritable();
  while (true) {
    final tag = input.readTag();
    if (tag == 0) return;
    final wireType = tag & 0x7;
    final tagNumber = tag >> 3;

    var fi = fs._nonExtensionInfo(meta, tagNumber);
    fi ??= registry.getExtension(meta.qualifiedMessageName, tagNumber);

    if (fi == null || !_wireTypeMatches(fi.type, wireType)) {
      if (!fs._ensureUnknownFields().mergeFieldFromBuffer(tag, input)) {
        return;
      }
      continue;
    }

    // Ignore required/optional packed/unpacked.
    var fieldType = fi.type;
    fieldType &= ~(PbFieldType._PACKED_BIT | PbFieldType._REQUIRED_BIT);
    switch (fieldType) {
      case PbFieldType._OPTIONAL_BOOL:
        fs._setFieldUnchecked(meta, fi, input.readBool());
        break;
      case PbFieldType._OPTIONAL_BYTES:
        fs._setFieldUnchecked(meta, fi, input.readBytes());
        break;
      case PbFieldType._OPTIONAL_STRING:
        fs._setFieldUnchecked(meta, fi, input.readString());
        break;
      case PbFieldType._OPTIONAL_FLOAT:
        fs._setFieldUnchecked(meta, fi, input.readFloat());
        break;
      case PbFieldType._OPTIONAL_DOUBLE:
        fs._setFieldUnchecked(meta, fi, input.readDouble());
        break;
      case PbFieldType._OPTIONAL_ENUM:
        final rawValue = input.readEnum();
        final value = meta._decodeEnum(tagNumber, registry, rawValue);
        if (value == null) {
          final unknown = fs._ensureUnknownFields();
          unknown.mergeVarintField(tagNumber, Int64(rawValue));
        } else {
          fs._setFieldUnchecked(meta, fi, value);
        }
        break;
      case PbFieldType._OPTIONAL_GROUP:
        final subMessage = meta._makeEmptyMessage(tagNumber, registry);
        final oldValue = fs._getFieldOrNull(fi);
        if (oldValue != null) {
          subMessage.mergeFromMessage(oldValue);
        }
        input.readGroup(tagNumber, subMessage, registry);
        fs._setFieldUnchecked(meta, fi, subMessage);
        break;
      case PbFieldType._OPTIONAL_INT32:
        fs._setFieldUnchecked(meta, fi, input.readInt32());
        break;
      case PbFieldType._OPTIONAL_INT64:
        fs._setFieldUnchecked(meta, fi, input.readInt64());
        break;
      case PbFieldType._OPTIONAL_SINT32:
        fs._setFieldUnchecked(meta, fi, input.readSint32());
        break;
      case PbFieldType._OPTIONAL_SINT64:
        fs._setFieldUnchecked(meta, fi, input.readSint64());
        break;
      case PbFieldType._OPTIONAL_UINT32:
        fs._setFieldUnchecked(meta, fi, input.readUint32());
        break;
      case PbFieldType._OPTIONAL_UINT64:
        fs._setFieldUnchecked(meta, fi, input.readUint64());
        break;
      case PbFieldType._OPTIONAL_FIXED32:
        fs._setFieldUnchecked(meta, fi, input.readFixed32());
        break;
      case PbFieldType._OPTIONAL_FIXED64:
        fs._setFieldUnchecked(meta, fi, input.readFixed64());
        break;
      case PbFieldType._OPTIONAL_SFIXED32:
        fs._setFieldUnchecked(meta, fi, input.readSfixed32());
        break;
      case PbFieldType._OPTIONAL_SFIXED64:
        fs._setFieldUnchecked(meta, fi, input.readSfixed64());
        break;
      case PbFieldType._OPTIONAL_MESSAGE:
        final GeneratedMessage? oldValue = fs._getFieldOrNull(fi);
        if (oldValue != null) {
          input.readMessage(oldValue, registry);
        } else {
          final subMessage = meta._makeEmptyMessage(tagNumber, registry);
          input.readMessage(subMessage, registry);
          fs._setFieldUnchecked(meta, fi, subMessage);
        }
        break;
      case PbFieldType._REPEATED_BOOL:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            // No need to check the element as for `bool` fields we only need to
            // check that the value is not null, and we know in `add` below that
            // the value isn't null (`readBool` doesn't return `null`).
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readBool());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readBool());
        }
        break;
      case PbFieldType._REPEATED_BYTES:
        final list = fs._ensureRepeatedField(meta, fi);
        list._checkModifiable('add');
        list._addUnchecked(input.readBytes());
        break;
      case PbFieldType._REPEATED_STRING:
        final list = fs._ensureRepeatedField(meta, fi);
        list._checkModifiable('add');
        list._addUnchecked(input.readString());
        break;
      case PbFieldType._REPEATED_FLOAT:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readFloat());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readFloat());
        }
        break;
      case PbFieldType._REPEATED_DOUBLE:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readDouble());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readDouble());
        }
        break;
      case PbFieldType._REPEATED_ENUM:
        final list = fs._ensureRepeatedField(meta, fi);
        _readPackableToListEnum(
          list,
          meta,
          fs,
          input,
          wireType,
          tagNumber,
          registry,
        );
        break;
      case PbFieldType._REPEATED_GROUP:
        final subMessage = meta._makeEmptyMessage(tagNumber, registry);
        input.readGroup(tagNumber, subMessage, registry);
        final list = fs._ensureRepeatedField(meta, fi);
        list.add(subMessage);
        break;
      case PbFieldType._REPEATED_INT32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readInt32());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readInt32());
        }
        break;
      case PbFieldType._REPEATED_INT64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readInt64());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readInt64());
        }
        break;
      case PbFieldType._REPEATED_SINT32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readSint32());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readSint32());
        }
        break;
      case PbFieldType._REPEATED_SINT64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readSint64());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readSint64());
        }
        break;
      case PbFieldType._REPEATED_UINT32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readUint32());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readUint32());
        }
        break;
      case PbFieldType._REPEATED_UINT64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readUint64());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readUint64());
        }
        break;
      case PbFieldType._REPEATED_FIXED32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readFixed32());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readFixed32());
        }
        break;
      case PbFieldType._REPEATED_FIXED64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readFixed64());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readFixed64());
        }
        break;
      case PbFieldType._REPEATED_SFIXED32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readSfixed32());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readSfixed32());
        }
        break;
      case PbFieldType._REPEATED_SFIXED64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list._checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list._addUnchecked(input.readSfixed64());
              }
            });
          }
        } else {
          list._checkModifiable('add');
          list._addUnchecked(input.readSfixed64());
        }
        break;
      case PbFieldType._REPEATED_MESSAGE:
        final subMessage = meta._makeEmptyMessage(tagNumber, registry);
        input.readMessage(subMessage, registry);
        final list = fs._ensureRepeatedField(meta, fi);
        list.add(subMessage);
        break;
      case PbFieldType._MAP:
        final mapFieldInfo = fi as MapFieldInfo;
        final mapEntryMeta = mapFieldInfo.mapEntryBuilderInfo;
        fs
            ._ensureMapField(meta, mapFieldInfo)
            ._mergeEntry(mapEntryMeta, input, registry);
        break;
      default:
        throw UnsupportedError('Unknown field type $fieldType');
    }
  }
}

void _readPackableToListEnum(
  List list,
  BuilderInfo meta,
  FieldSet fs,
  CodedBufferReader input,
  int wireType,
  int tagNumber,
  ExtensionRegistry registry,
) {
  if (wireType == WIRETYPE_LENGTH_DELIMITED) {
    // Packed.
    input._withLimit(input.readInt32(), () {
      while (!input.isAtEnd()) {
        _readRepeatedEnum(list, meta, fs, input, tagNumber, registry);
      }
    });
  } else {
    // Not packed.
    _readRepeatedEnum(list, meta, fs, input, tagNumber, registry);
  }
}

void _readRepeatedEnum(
  List list,
  BuilderInfo meta,
  FieldSet fs,
  CodedBufferReader input,
  int tagNumber,
  ExtensionRegistry registry,
) {
  final rawValue = input.readEnum();
  final value = meta._decodeEnum(tagNumber, registry, rawValue);
  if (value == null) {
    final unknown = fs._ensureUnknownFields();
    unknown.mergeVarintField(tagNumber, Int64(rawValue));
  } else {
    list.add(value);
  }
}
