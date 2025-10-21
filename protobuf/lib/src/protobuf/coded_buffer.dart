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
    fieldType &= ~(PbFieldType.PACKED_BIT | PbFieldType.REQUIRED_BIT);
    switch (fieldType) {
      case PbFieldType.OPTIONAL_BOOL:
        fs._setFieldUnchecked(meta, fi, input.readBool());
      case PbFieldType.OPTIONAL_BYTES:
        fs._setFieldUnchecked(meta, fi, input.readBytes());
      case PbFieldType.OPTIONAL_STRING:
        fs._setFieldUnchecked(meta, fi, input.readString());
      case PbFieldType.OPTIONAL_FLOAT:
        fs._setFieldUnchecked(meta, fi, input.readFloat());
      case PbFieldType.OPTIONAL_DOUBLE:
        fs._setFieldUnchecked(meta, fi, input.readDouble());
      case PbFieldType.OPTIONAL_ENUM:
        final rawValue = input.readEnum();
        final value = meta._decodeEnum(tagNumber, registry, rawValue);
        if (value == null) {
          final unknown = fs._ensureUnknownFields();
          unknown.mergeVarintField(tagNumber, Int64(rawValue));
        } else {
          fs._setFieldUnchecked(meta, fi, value);
        }
      case PbFieldType.OPTIONAL_GROUP:
        final subMessage = meta._makeEmptyMessage(tagNumber, registry);
        final oldValue = fs._getFieldOrNull(fi);
        if (oldValue != null) {
          subMessage.mergeFromMessage(oldValue);
        }
        input.readGroup(tagNumber, subMessage, registry);
        fs._setFieldUnchecked(meta, fi, subMessage);
      case PbFieldType.OPTIONAL_INT32:
        fs._setFieldUnchecked(meta, fi, input.readInt32());
      case PbFieldType.OPTIONAL_INT64:
        fs._setFieldUnchecked(meta, fi, input.readInt64());
      case PbFieldType.OPTIONAL_SINT32:
        fs._setFieldUnchecked(meta, fi, input.readSint32());
      case PbFieldType.OPTIONAL_SINT64:
        fs._setFieldUnchecked(meta, fi, input.readSint64());
      case PbFieldType.OPTIONAL_UINT32:
        fs._setFieldUnchecked(meta, fi, input.readUint32());
      case PbFieldType.OPTIONAL_UINT64:
        fs._setFieldUnchecked(meta, fi, input.readUint64());
      case PbFieldType.OPTIONAL_FIXED32:
        fs._setFieldUnchecked(meta, fi, input.readFixed32());
      case PbFieldType.OPTIONAL_FIXED64:
        fs._setFieldUnchecked(meta, fi, input.readFixed64());
      case PbFieldType.OPTIONAL_SFIXED32:
        fs._setFieldUnchecked(meta, fi, input.readSfixed32());
      case PbFieldType.OPTIONAL_SFIXED64:
        fs._setFieldUnchecked(meta, fi, input.readSfixed64());
      case PbFieldType.OPTIONAL_MESSAGE:
        final GeneratedMessage? oldValue = fs._getFieldOrNull(fi);
        if (oldValue != null) {
          input.readMessage(oldValue, registry);
        } else {
          final subMessage = meta._makeEmptyMessage(tagNumber, registry);
          input.readMessage(subMessage, registry);
          fs._setFieldUnchecked(meta, fi, subMessage);
        }
      case PbFieldType.REPEATED_BOOL:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            // No need to check the element as for `bool` fields we only need to
            // check that the value is not null, and we know in `add` below that
            // the value isn't null (`readBool` doesn't return `null`).
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readBool());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readBool());
        }
      case PbFieldType.REPEATED_BYTES:
        final list = fs._ensureRepeatedField(meta, fi);
        list.checkModifiable('add');
        list.addUnchecked(input.readBytes());
      case PbFieldType.REPEATED_STRING:
        final list = fs._ensureRepeatedField(meta, fi);
        list.checkModifiable('add');
        list.addUnchecked(input.readString());
      case PbFieldType.REPEATED_FLOAT:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readFloat());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readFloat());
        }
      case PbFieldType.REPEATED_DOUBLE:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readDouble());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readDouble());
        }
      case PbFieldType.REPEATED_ENUM:
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
      case PbFieldType.REPEATED_GROUP:
        final subMessage = meta._makeEmptyMessage(tagNumber, registry);
        input.readGroup(tagNumber, subMessage, registry);
        final list = fs._ensureRepeatedField(meta, fi);
        list.add(subMessage);
      case PbFieldType.REPEATED_INT32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readInt32());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readInt32());
        }
      case PbFieldType.REPEATED_INT64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readInt64());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readInt64());
        }
      case PbFieldType.REPEATED_SINT32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readSint32());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readSint32());
        }
      case PbFieldType.REPEATED_SINT64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readSint64());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readSint64());
        }
      case PbFieldType.REPEATED_UINT32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readUint32());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readUint32());
        }
      case PbFieldType.REPEATED_UINT64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readUint64());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readUint64());
        }
      case PbFieldType.REPEATED_FIXED32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readFixed32());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readFixed32());
        }
      case PbFieldType.REPEATED_FIXED64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readFixed64());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readFixed64());
        }
      case PbFieldType.REPEATED_SFIXED32:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readSfixed32());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readSfixed32());
        }
      case PbFieldType.REPEATED_SFIXED64:
        final list = fs._ensureRepeatedField(meta, fi);
        if (wireType == WIRETYPE_LENGTH_DELIMITED) {
          final limit = input.readInt32();
          if (limit != 0) {
            list.checkModifiable('add');
            input._withLimit(limit, () {
              while (!input.isAtEnd()) {
                list.addUnchecked(input.readSfixed64());
              }
            });
          }
        } else {
          list.checkModifiable('add');
          list.addUnchecked(input.readSfixed64());
        }
      case PbFieldType.REPEATED_MESSAGE:
        final subMessage = meta._makeEmptyMessage(tagNumber, registry);
        input.readMessage(subMessage, registry);
        final list = fs._ensureRepeatedField(meta, fi);
        list.add(subMessage);
      case PbFieldType.MAP:
        final mapFieldInfo = fi as MapFieldInfo;
        final mapEntryMeta = mapFieldInfo.mapEntryBuilderInfo;
        final map = fs._ensureMapField(meta, mapFieldInfo);
        _readMapEntry(map, mapEntryMeta, input, registry);
      default:
        throw UnsupportedError('Unknown field type $fieldType');
    }
  }
}

void _readMapEntry(
  PbMap map,
  BuilderInfo meta,
  CodedBufferReader input,
  ExtensionRegistry registry,
) {
  final length = input.readInt32();
  final oldLimit = input._currentLimit;
  input._currentLimit = input._bufferPos + length;
  final entryFieldSet = FieldSet(null, meta);
  _mergeFromCodedBufferReader(meta, entryFieldSet, input, registry);
  input.checkLastTagWas(0);
  input._currentLimit = oldLimit;
  final key = entryFieldSet._values[0] ?? meta.byIndex[0].makeDefault!();
  final value = entryFieldSet._values[1] ?? meta.byIndex[1].makeDefault!();
  map[key] = value;
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
