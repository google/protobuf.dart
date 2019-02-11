// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

void _writeToCodedBufferWriter(_FieldSet fs, CodedBufferWriter out) {
  // Sorting by tag number isn't required, but it sometimes enables
  // performance optimizations for the receiver. See:
  // https://developers.google.com/protocol-buffers/docs/encoding?hl=en#order

  for (var fi in fs._infosSortedByTag) {
    var value = fs._values[fi.index];
    if (value == null) continue;
    out.writeField(fi.tagNumber, fi.type, value);
  }

  if (fs._hasExtensions) {
    for (var tagNumber in sorted(fs._extensions._tagNumbers)) {
      var fi = fs._extensions._getInfoOrNull(tagNumber);
      out.writeField(tagNumber, fi.type, fs._extensions._getFieldOrNull(fi));
    }
  }
  if (fs._hasUnknownFields) {
    fs._unknownFields.writeToCodedBufferWriter(out);
  }
}

void _mergeFromCodedBufferReader(
    _FieldSet fieldSet, CodedBufferReader input, ExtensionRegistry registry,
    {int recursionLimit = 64}) {
  final status = _CodedBufferMerger(input: input, extensionRegistry: registry, fieldSet: fieldSet).mergeMore();
  assert(status == _CodedBufferMergingStatus.done);
}

enum _CodedBufferMergingStatus {
  done, notDone
}

typedef Insert = void Function(dynamic value);

class _CodedBufferMerger {
  CodedBufferReader input;
  ExtensionRegistry extensionRegistry;

  final List<_FieldSet> stack;
//  final List<FieldInfo> fieldInfoStack = <FieldInfo>[];
  final int recursionLimit;

  _CodedBufferMerger(
      {this.input, this.extensionRegistry, _FieldSet fieldSet, this.recursionLimit = 64})
      : stack = <_FieldSet>[fieldSet],
        assert(extensionRegistry != null);

  void _readPackableToList(int wireType, FieldInfo fi, Function readToList) {
    List list = stack.last._ensureRepeatedField(fi);

    if (wireType == WIRETYPE_LENGTH_DELIMITED) {
      // Packed.
      input._withLimit(input.readInt32(), () {
        while (!input.isAtEnd()) {
          readToList(list);
        }
      });
    } else {
      // Not packed.
      readToList(list);
    }
  }

  void _readPackable(int wireType, FieldInfo fi, Function readFunc) {
    void readToList(List list) => list.add(readFunc());
    _readPackableToList(wireType, fi, readToList);
  }

  _CodedBufferMergingStatus mergeMore({int byteLimit = -1}) {
    int start = input._bufferPos;
    while (byteLimit == -1 || input._bufferPos - start < byteLimit) {
      _FieldSet currentFieldSet = stack.last;
      int tag = input.readTag();
      if (tag == 0) {
        input.stopReadingMessage();
        stack.removeLast();
        if (stack.isEmpty) {
          return _CodedBufferMergingStatus.done;
        }
        continue;
      }
      int wireType = tag & 0x7;
      int tagNumber = tag >> 3;

      FieldInfo fi = currentFieldSet._nonExtensionInfo(tagNumber);
      if (fi == null) {
        fi = extensionRegistry.getExtension(
            currentFieldSet._messageName, tagNumber);
      }

      stderr.writeln("fi: $fi $tagNumber ${fi?.name}");

      if (fi == null || !_wireTypeMatches(fi.type, wireType)) {
        !currentFieldSet._ensureUnknownFields().mergeFieldFromBuffer(tag, input);
      }

      // Ignore required/optional packed/unpacked.
      int fieldType = fi.type;
      fieldType &= ~(PbFieldType._PACKED_BIT | PbFieldType._REQUIRED_BIT);
      switch (fieldType) {
        case PbFieldType._OPTIONAL_BOOL:
          currentFieldSet._setFieldUnchecked(fi, input.readBool());
          break;
        case PbFieldType._OPTIONAL_BYTES:
          currentFieldSet._setFieldUnchecked(fi, input.readBytes());
          break;
        case PbFieldType._OPTIONAL_STRING:
          final s = input.readString();
          stderr.writeln(s);
          currentFieldSet._setFieldUnchecked(fi, s);
          break;
        case PbFieldType._OPTIONAL_FLOAT:
          currentFieldSet._setFieldUnchecked(fi, input.readFloat());
          break;
        case PbFieldType._OPTIONAL_DOUBLE:
          currentFieldSet._setFieldUnchecked(fi, input.readDouble());
          break;
        case PbFieldType._OPTIONAL_ENUM:
          int rawValue = input.readEnum();
          var value = currentFieldSet._meta._decodeEnum(
              tagNumber, extensionRegistry, rawValue);
          if (value == null) {
            var unknown = currentFieldSet._ensureUnknownFields();
            unknown.mergeVarintField(tagNumber, new Int64(rawValue));
          } else {
            currentFieldSet._setFieldUnchecked(fi, value);
          }
          break;
        case PbFieldType._OPTIONAL_GROUP:
          GeneratedMessage subMessage =
          currentFieldSet._meta._makeEmptyMessage(tagNumber, extensionRegistry);
          var oldValue = currentFieldSet._getFieldOrNull(fi);
          if (oldValue != null) {
            subMessage.mergeFromMessage(oldValue);
          }
          input.startReadingMessage();
          stack.add(subMessage._fieldSet);
          currentFieldSet._setFieldUnchecked(fi, subMessage);
          break;
        case PbFieldType._OPTIONAL_INT32:
          currentFieldSet._setFieldUnchecked(fi, input.readInt32());
          break;
        case PbFieldType._OPTIONAL_INT64:
          currentFieldSet._setFieldUnchecked(fi, input.readInt64());
          break;
        case PbFieldType._OPTIONAL_SINT32:
          currentFieldSet._setFieldUnchecked(fi, input.readSint32());
          break;
        case PbFieldType._OPTIONAL_SINT64:
          currentFieldSet._setFieldUnchecked(fi, input.readSint64());
          break;
        case PbFieldType._OPTIONAL_UINT32:
          currentFieldSet._setFieldUnchecked(fi, input.readUint32());
          break;
        case PbFieldType._OPTIONAL_UINT64:
          currentFieldSet._setFieldUnchecked(fi, input.readUint64());
          break;
        case PbFieldType._OPTIONAL_FIXED32:
          currentFieldSet._setFieldUnchecked(fi, input.readFixed32());
          break;
        case PbFieldType._OPTIONAL_FIXED64:
          currentFieldSet._setFieldUnchecked(fi, input.readFixed64());
          break;
        case PbFieldType._OPTIONAL_SFIXED32:
          currentFieldSet._setFieldUnchecked(fi, input.readSfixed32());
          break;
        case PbFieldType._OPTIONAL_SFIXED64:
          currentFieldSet._setFieldUnchecked(fi, input.readSfixed64());
          break;
        case PbFieldType._OPTIONAL_MESSAGE:
          GeneratedMessage subMessage =
          currentFieldSet._meta._makeEmptyMessage(tagNumber, extensionRegistry);
          var oldValue = currentFieldSet._getFieldOrNull(fi);
          if (oldValue != null) {
            // TODO(sigurdm): Consider using clone().
            subMessage.mergeFromMessage(oldValue);
          }
          stack.add(subMessage._fieldSet);
          input.startReadingMessage();
          currentFieldSet._setFieldUnchecked(fi, subMessage);
          break;
        case PbFieldType._REPEATED_BOOL:
          _readPackable(wireType, fi, input.readBool);
          break;
        case PbFieldType._REPEATED_BYTES:
          currentFieldSet._ensureRepeatedField(fi).add(input.readBytes());
          break;
        case PbFieldType._REPEATED_STRING:
          currentFieldSet._ensureRepeatedField(fi).add(input.readString());
          break;
        case PbFieldType._REPEATED_FLOAT:
          _readPackable(wireType, fi, input.readFloat);
          break;
        case PbFieldType._REPEATED_DOUBLE:
          _readPackable(wireType, fi, input.readDouble);
          break;
        case PbFieldType._REPEATED_ENUM:
          _readPackableToList(wireType, fi, (List list) {
            int rawValue = input.readEnum();
            var value = currentFieldSet._meta._decodeEnum(
                tagNumber, extensionRegistry, rawValue);
            if (value == null) {
              var unknown = currentFieldSet._ensureUnknownFields();
              unknown.mergeVarintField(tagNumber, new Int64(rawValue));
            } else {
              list.add(value);
            }
          });
          break;
        case PbFieldType._REPEATED_GROUP:
          GeneratedMessage subMessage =
          currentFieldSet._meta._makeEmptyMessage(tagNumber, extensionRegistry);
          input.startReadingMessage();
          stack.add(subMessage._fieldSet);
          currentFieldSet._ensureRepeatedField(fi).add(subMessage);
          break;
        case PbFieldType._REPEATED_INT32:
          _readPackable(wireType, fi, input.readInt32);
          break;
        case PbFieldType._REPEATED_INT64:
          _readPackable(wireType, fi, input.readInt64);
          break;
        case PbFieldType._REPEATED_SINT32:
          _readPackable(wireType, fi, input.readSint32);
          break;
        case PbFieldType._REPEATED_SINT64:
          _readPackable(wireType, fi, input.readSint64);
          break;
        case PbFieldType._REPEATED_UINT32:
          _readPackable(wireType, fi, input.readUint32);
          break;
        case PbFieldType._REPEATED_UINT64:
          _readPackable(wireType, fi, input.readUint64);
          break;
        case PbFieldType._REPEATED_FIXED32:
          _readPackable(wireType, fi, input.readFixed32);
          break;
        case PbFieldType._REPEATED_FIXED64:
          _readPackable(wireType, fi, input.readFixed64);
          break;
        case PbFieldType._REPEATED_SFIXED32:
          _readPackable(wireType, fi, input.readSfixed32);
          break;
        case PbFieldType._REPEATED_SFIXED64:
          _readPackable(wireType, fi, input.readSfixed64);
          break;
        case PbFieldType._REPEATED_MESSAGE:
          GeneratedMessage subMessage =
          currentFieldSet._meta._makeEmptyMessage(tagNumber, extensionRegistry);
          input.startReadingMessage();
          stack.add(subMessage._fieldSet);
          currentFieldSet._ensureRepeatedField(fi).add(subMessage);
          break;
        case PbFieldType._MAP:

          input.startReadingMessage();
          PbMap map = currentFieldSet._ensureMapField(fi);
          _FieldSet entryFieldSet = map._entryFieldSet();
          stack.add(entryFieldSet);

          K key = _entryFieldSet._$get(0, null);
          V value = _entryFieldSet._$get(1, null);
          _wrappedMap[key] = value;

          .add(input, extensionRegistry);
          break;
        default:
          throw 'Unknown field type $fieldType';
      }
    }
    return _CodedBufferMergingStatus.notDone;
  }
}
