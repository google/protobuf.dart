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
  final status = _CodedBufferMerger(
          input: input, extensionRegistry: registry, fieldSet: fieldSet)
      .mergeMore();
  assert(status == _CodedBufferMergingStatus.done);
}

enum _CodedBufferMergingStatus { done, notDone }

typedef _Finish = void Function();

class _StackItem {
  final _Finish finish;
  final _FieldSet fieldSet;
  _StackItem(this.fieldSet, {this.finish});
}

class _CodedBufferMerger {
  CodedBufferReader input;
  ExtensionRegistry extensionRegistry;

  final List<_StackItem> stack;
  final int recursionLimit;

  _StackItem get top => stack.last;
  _FieldSet get topFieldSet => top.fieldSet;

  _CodedBufferMerger(
      {this.input,
        this.extensionRegistry,
        _FieldSet fieldSet,
        this.recursionLimit = 64})
      : stack = <_StackItem>[_StackItem(fieldSet)],
        assert(extensionRegistry != null);

  void _readPackable<T>(_FieldSet fieldSet, CodedBufferReader input, int wireType,
      FieldInfo fi, T Function() readFunc) {
    void readToList(List list) => list.add(readFunc());
    _readPackableToList(fieldSet, input, wireType, fi, readToList);
  }

  void _readPackableToListEnum(_FieldSet fieldSet, CodedBufferReader input,
      int wireType, FieldInfo fieldInfo, int tagNumber, ExtensionRegistry registry) {
    void readToList(List list) {
      int rawValue = input.readEnum();
      var value = fieldSet._meta._decodeEnum(tagNumber, registry, rawValue);
      if (value == null) {
        var unknown = fieldSet._ensureUnknownFields();
        unknown.mergeVarintField(tagNumber, new Int64(rawValue));
      } else {
        list.add(value);
      }
    }
    _readPackableToList(fieldSet, input, wireType, fieldInfo, readToList);
  }

  void _readPackableToList<T>(_FieldSet fs, CodedBufferReader input, int wireType,
      FieldInfo fieldInfo, void Function(List<T> l) readToList) {
    List<T> list = topFieldSet._ensureRepeatedField(fieldInfo);
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

  /// Reads at least [byteLimit] bytes from [input].
  ///
  /// Returns [_CodedBufferMergingStatus.done] if the message is read to end,
  /// and [_CodedBufferMergingStatus.notDone] otherwise.
  ///
  /// The fieldSet is not in a complete state until
  /// [_CodedBufferMergingStatus.done] has been returned.
  _CodedBufferMergingStatus mergeMore({int byteLimit = -1}) {
    int start = input._bufferPos;
    while (byteLimit == -1 || input._bufferPos - start < byteLimit) {
      int tag = input.readTag();
      if (tag == 0 || getTagWireType(tag) == WIRETYPE_END_GROUP) {
        input._stopReadingMessageOrGroup();
        _StackItem stackItem = stack.removeLast();

        if (stackItem.finish != null) {
          stackItem.finish();
        }

        if (stack.isEmpty) {
          return _CodedBufferMergingStatus.done;
        }
        continue;
      }
      int wireType = tag & 0x7;
      int tagNumber = tag >> 3;
      _FieldSet currentFieldSet = topFieldSet;
      FieldInfo fi = currentFieldSet._nonExtensionInfo(tagNumber);
      if (fi == null) {
        fi = extensionRegistry.getExtension(
            currentFieldSet._messageName, tagNumber);
      }

      if (fi == null || !_wireTypeMatches(fi.type, wireType)) {
        currentFieldSet
            ._ensureUnknownFields()
            .mergeFieldFromBuffer(tag, input);
        continue;
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
          var value = currentFieldSet._meta
              ._decodeEnum(tagNumber, extensionRegistry, rawValue);
          if (value == null) {
            var unknown = currentFieldSet._ensureUnknownFields();
            unknown.mergeVarintField(tagNumber, new Int64(rawValue));
          } else {
            currentFieldSet._setFieldUnchecked(fi, value);
          }
          break;
        case PbFieldType._OPTIONAL_GROUP:
          GeneratedMessage subMessage = currentFieldSet._meta
              ._makeEmptyMessage(tagNumber, extensionRegistry);
          var oldValue = currentFieldSet._getFieldOrNull(fi);
          if (oldValue != null) {
            subMessage.mergeFromMessage(oldValue);
          }
          input._startReadingGroup();
          stack.add(_StackItem(subMessage._fieldSet, finish: () {
            input.checkLastTagWas(makeTag(tagNumber, WIRETYPE_END_GROUP));
          }));
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
          GeneratedMessage subMessage = currentFieldSet._meta
              ._makeEmptyMessage(tagNumber, extensionRegistry);
          var oldValue = currentFieldSet._getFieldOrNull(fi);
          if (oldValue != null) {
            subMessage.mergeFromMessage(oldValue);
          }
          stack.add(_StackItem(subMessage._fieldSet));
          input._startReadingMessage();
          currentFieldSet._setFieldUnchecked(fi, subMessage);
          break;
        case PbFieldType._REPEATED_BOOL:
          _readPackable(currentFieldSet, input, wireType, fi, input.readBool);
          break;
        case PbFieldType._REPEATED_BYTES:
          currentFieldSet._ensureRepeatedField(fi).add(input.readBytes());
          break;
        case PbFieldType._REPEATED_STRING:
          currentFieldSet._ensureRepeatedField(fi).add(input.readString());
          break;
        case PbFieldType._REPEATED_FLOAT:
          _readPackable(currentFieldSet, input, wireType, fi, input.readFloat);
          break;
        case PbFieldType._REPEATED_DOUBLE:
          _readPackable(currentFieldSet, input, wireType, fi, input.readDouble);
          break;
        case PbFieldType._REPEATED_ENUM:
          _readPackableToListEnum(
              currentFieldSet, input, wireType, fi, tagNumber,
              extensionRegistry);
          break;
        case PbFieldType._REPEATED_GROUP:
          GeneratedMessage subMessage = currentFieldSet._meta
              ._makeEmptyMessage(tagNumber, extensionRegistry);
          input._startReadingGroup();
          stack.add(_StackItem(subMessage._fieldSet));
          currentFieldSet._ensureRepeatedField(fi).add(subMessage);
          break;
        case PbFieldType._REPEATED_INT32:
          _readPackable(currentFieldSet, input, wireType, fi, input.readInt32);
          break;
        case PbFieldType._REPEATED_INT64:
          _readPackable(currentFieldSet, input, wireType, fi, input.readInt64);
          break;
        case PbFieldType._REPEATED_SINT32:
          _readPackable(currentFieldSet, input, wireType, fi, input.readSint32);
          break;
        case PbFieldType._REPEATED_SINT64:
          _readPackable(currentFieldSet, input, wireType, fi, input.readSint64);
          break;
        case PbFieldType._REPEATED_UINT32:
          _readPackable(currentFieldSet, input, wireType, fi, input.readUint32);
          break;
        case PbFieldType._REPEATED_UINT64:
          _readPackable(currentFieldSet, input, wireType, fi, input.readUint64);
          break;
        case PbFieldType._REPEATED_FIXED32:
          _readPackable(
              currentFieldSet, input, wireType, fi, input.readFixed32);
          break;
        case PbFieldType._REPEATED_FIXED64:
          _readPackable(
              currentFieldSet, input, wireType, fi, input.readFixed64);
          break;
        case PbFieldType._REPEATED_SFIXED32:
          _readPackable(
              currentFieldSet, input, wireType, fi, input.readSfixed32);
          break;
        case PbFieldType._REPEATED_SFIXED64:
          _readPackable(
              currentFieldSet, input, wireType, fi, input.readSfixed64);
          break;
        case PbFieldType._REPEATED_MESSAGE:
          GeneratedMessage subMessage = currentFieldSet._meta
              ._makeEmptyMessage(tagNumber, extensionRegistry);
          input._startReadingMessage();
          stack.add(_StackItem(subMessage._fieldSet));
          currentFieldSet._ensureRepeatedField(fi).add(subMessage);
          break;
        case PbFieldType._MAP:
          PbMap map = currentFieldSet._ensureMapField(fi);
          _FieldSet entryFieldSet = map._entryFieldSet();
          input._startReadingMessage();
          stack.add(_StackItem(entryFieldSet, finish: () {
            map._addEntry(entryFieldSet);
          }));
          break;
        default:
          throw 'Unknown field type $fieldType';
      }
    }
    return _CodedBufferMergingStatus.notDone;
  }
}
