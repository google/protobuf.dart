// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

class UnknownFieldSet {
  static final UnknownFieldSet emptyUnknownFieldSet = UnknownFieldSet()
    .._markReadOnly();
  final Map<int, UnknownFieldSetField> fields = <int, UnknownFieldSetField>{};

  UnknownFieldSet();

  UnknownFieldSet._clone(UnknownFieldSet unknownFieldSet) {
    mergeFromUnknownFieldSet(unknownFieldSet);
  }

  UnknownFieldSet clone() => UnknownFieldSet._clone(this);

  bool get isEmpty => fields.isEmpty;
  bool get isNotEmpty => fields.isNotEmpty;
  bool _isReadOnly = false;

  Map<int, UnknownFieldSetField> asMap() => Map.from(fields);

  void clear() {
    ensureWritable('clear');
    fields.clear();
  }

  UnknownFieldSetField? getField(int tagNumber) => fields[tagNumber];

  bool hasField(int tagNumber) => fields.containsKey(tagNumber);

  void addField(int number, UnknownFieldSetField field) {
    ensureWritable('addField');
    _checkFieldNumber(number);
    fields[number] = field;
  }

  void mergeField(int number, UnknownFieldSetField field) {
    ensureWritable('mergeField');
    getFieldOrDefault(number)
      ..varints.addAll(field.varints)
      ..fixed32s.addAll(field.fixed32s)
      ..fixed64s.addAll(field.fixed64s)
      ..lengthDelimited.addAll(field.lengthDelimited)
      ..groups.addAll(field.groups);
  }

/*
  bool mergeFieldFromBuffer(int tag, CodedBufferReader input) {
    ensureWritable('mergeFieldFromBuffer');
    var number = getTagFieldNumber(tag);
    switch (getTagWireType(tag)) {
      case WIRETYPE_VARINT:
        mergeVarintField(number, input.readInt64());
        return true;
      case WIRETYPE_FIXED64:
        mergeFixed64Field(number, input.readFixed64());
        return true;
      case WIRETYPE_LENGTH_DELIMITED:
        mergeLengthDelimitedField(number, input.readBytes());
        return true;
      case WIRETYPE_START_GROUP:
        var subGroup = input.readUnknownFieldSetGroup(number);
        mergeGroupField(number, subGroup);
        return true;
      case WIRETYPE_END_GROUP:
        return false;
      case WIRETYPE_FIXED32:
        mergeFixed32Field(number, input.readFixed32());
        return true;
      default:
        throw InvalidProtocolBufferException.invalidWireType();
    }
  }

  void mergeFromCodedBufferReader(CodedBufferReader input) {
    ensureWritable('mergeFromCodedBufferReader');
    while (true) {
      var tag = input.readTag();
      if (tag == 0 || !mergeFieldFromBuffer(tag, input)) {
        break;
      }
    }
  }
*/

  void mergeFromUnknownFieldSet(UnknownFieldSet other) {
    ensureWritable('mergeFromUnknownFieldSet');
    for (var key in other.fields.keys) {
      mergeField(key, other.fields[key]!);
    }
  }

  void _checkFieldNumber(int number) {
    if (number == 0) {
      throw ArgumentError('Zero is not a valid field number.');
    }
  }

  void mergeFixed32Field(int number, int value) {
    ensureWritable('mergeFixed32Field');
    getFieldOrDefault(number).addFixed32(value);
  }

  void mergeFixed64Field(int number, Int64 value) {
    ensureWritable('mergeFixed64Field');
    getFieldOrDefault(number).addFixed64(value);
  }

  void mergeGroupField(int number, UnknownFieldSet value) {
    ensureWritable('mergeGroupField');
    getFieldOrDefault(number).addGroup(value);
  }

  void mergeLengthDelimitedField(int number, List<int> value) {
    ensureWritable('mergeLengthDelimitedField');
    getFieldOrDefault(number).addLengthDelimited(value);
  }

  void mergeVarintField(int number, Int64 value) {
    ensureWritable('mergeVarintField');
    getFieldOrDefault(number).addVarint(value);
  }

  UnknownFieldSetField getFieldOrDefault(int number) {
    _checkFieldNumber(number);
    if (_isReadOnly) assert(fields.containsKey(number));
    return fields.putIfAbsent(number, () => UnknownFieldSetField());
  }

  @override
  bool operator ==(other) {
    if (other is! UnknownFieldSet) return false;

    var o = other;
    return _areMapsEqual(o.fields, fields);
  }

  @override
  int get hashCode {
    var hash = 0;
    fields.forEach((int number, Object value) {
      hash = 0x1fffffff & ((37 * hash) + number);
      hash = 0x1fffffff & ((53 * hash) + value.hashCode);
    });
    return hash;
  }

  @override
  String toString() => _toString('');

  String _toString(String indent) {
    var stringBuffer = StringBuffer();

    for (var tag in _sorted(fields.keys)) {
      var field = fields[tag]!;
      for (var value in field.values) {
        if (value is UnknownFieldSet) {
          stringBuffer
            ..write('$indent$tag: {\n')
            ..write(value._toString('$indent  '))
            ..write('$indent}\n');
        } else {
          if (value is ByteData) {
            // TODO(antonm): fix for longs.
            value = value.getUint64(0, Endian.little);
          }
          stringBuffer.write('$indent$tag: $value\n');
        }
      }
    }

    return stringBuffer.toString();
  }

/*
  void writeToCodedBufferWriter(CodedBufferWriter output) {
    for (var key in fields.keys) {
      fields[key]!.writeTo(key, output);
    }
  }
*/

  void _markReadOnly() {
    if (_isReadOnly) return;
    for (var f in fields.values) {
      f._markReadOnly();
    }
    _isReadOnly = true;
  }

  void ensureWritable(String methodName) {
    if (_isReadOnly) {
      frozenMessageModificationHandler('UnknownFieldSet', methodName);
    }
  }
}

class UnknownFieldSetField {
  List<List<int>> _lengthDelimited = <List<int>>[];
  List<Int64> _varints = <Int64>[];
  List<int> _fixed32s = <int>[];
  List<Int64> _fixed64s = <Int64>[];
  List<UnknownFieldSet> _groups = <UnknownFieldSet>[];

  List<List<int>> get lengthDelimited => _lengthDelimited;
  List<Int64> get varints => _varints;
  List<int> get fixed32s => _fixed32s;
  List<Int64> get fixed64s => _fixed64s;
  List<UnknownFieldSet> get groups => _groups;

  bool _isReadOnly = false;

  void _markReadOnly() {
    if (_isReadOnly) return;
    _isReadOnly = true;
    _lengthDelimited = List.unmodifiable(_lengthDelimited);
    _varints = List.unmodifiable(_varints);
    _fixed32s = List.unmodifiable(_fixed32s);
    _fixed64s = List.unmodifiable(_fixed64s);
    _groups = List.unmodifiable(_groups);
  }

  @override
  bool operator ==(other) {
    if (other is! UnknownFieldSetField) return false;

    var o = other;
    if (lengthDelimited.length != o.lengthDelimited.length) return false;
    for (var i = 0; i < lengthDelimited.length; i++) {
      if (!_areListsEqual(o.lengthDelimited[i], lengthDelimited[i])) {
        return false;
      }
    }
    if (!_areListsEqual(o.varints, varints)) return false;
    if (!_areListsEqual(o.fixed32s, fixed32s)) return false;
    if (!_areListsEqual(o.fixed64s, fixed64s)) return false;
    if (!_areListsEqual(o.groups, groups)) return false;

    return true;
  }

  @override
  int get hashCode {
    var hash = 0;
    for (final value in lengthDelimited) {
      for (var i = 0; i < value.length; i++) {
        hash = 0x1fffffff & (hash + value[i]);
        hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
        hash = hash ^ (hash >> 6);
      }
      hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
      hash = hash ^ (hash >> 11);
      hash = 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
    }
    for (final value in varints) {
      hash = 0x1fffffff & (hash + (7 * value.hashCode));
    }
    for (final value in fixed32s) {
      hash = 0x1fffffff & (hash + (37 * value.hashCode));
    }
    for (final value in fixed64s) {
      hash = 0x1fffffff & (hash + (53 * value.hashCode));
    }
    for (final value in groups) {
      hash = 0x1fffffff & (hash + value.hashCode);
    }
    return hash;
  }

  List get values => [
        ...lengthDelimited,
        ...varints,
        ...fixed32s,
        ...fixed64s,
        ...groups,
      ];

  void addGroup(UnknownFieldSet value) {
    groups.add(value);
  }

  void addLengthDelimited(List<int> value) {
    lengthDelimited.add(value);
  }

  void addFixed32(int value) {
    fixed32s.add(value);
  }

  void addFixed64(Int64 value) {
    fixed64s.add(value);
  }

  void addVarint(Int64 value) {
    varints.add(value);
  }

  bool hasRequiredFields() => false;

  bool isInitialized() => true;

  int get length => values.length;
}
