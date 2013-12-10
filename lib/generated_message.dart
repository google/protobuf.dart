// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

typedef GeneratedMessage CreateBuilderFunc();
typedef Object MakeDefaultFunc();
typedef ProtobufEnum ValueOfFunc(int value);

_inRange(min, value, max) => (min <= value) && (value <= max);

_isSigned32(int value) => _inRange(-2147483648, value, 2147483647);
_isUnsigned32(int value) => _inRange(0, value, 4294967295);
_isSigned64(Int64 value) => _isUnsigned64(value);
_isUnsigned64(Int64 value) => value is Int64;
_isFloat32(double value) => value.isNaN || value.isInfinite ||
    _inRange(-3.4028234663852886E38, value, 3.4028234663852886E38);

abstract class GeneratedMessage {
  static const int _REQUIRED_BIT      = 0x1;
  static const int _REPEATED_BIT      = 0x2;
  static const int _PACKED_BIT        = 0x4;

  static const int _BOOL_BIT         = 0x10;
  static const int _BYTES_BIT        = 0x20;
  static const int _STRING_BIT       = 0x40;
  static const int _DOUBLE_BIT       = 0x80;
  static const int _FLOAT_BIT       = 0x100;
  static const int _ENUM_BIT        = 0x200;
  static const int _GROUP_BIT       = 0x400;
  static const int _INT32_BIT       = 0x800;
  static const int _INT64_BIT      = 0x1000;
  static const int _SINT32_BIT     = 0x2000;
  static const int _SINT64_BIT     = 0x4000;
  static const int _UINT32_BIT     = 0x8000;
  static const int _UINT64_BIT    = 0x10000;
  static const int _FIXED32_BIT   = 0x20000;
  static const int _FIXED64_BIT   = 0x40000;
  static const int _SFIXED32_BIT  = 0x80000;
  static const int _SFIXED64_BIT = 0x100000;
  static const int _MESSAGE_BIT  = 0x200000;

  static const int _OPTIONAL_BOOL = _BOOL_BIT;
  static const int _OPTIONAL_BYTES = _BYTES_BIT;
  static const int _OPTIONAL_STRING = _STRING_BIT;
  static const int _OPTIONAL_FLOAT = _FLOAT_BIT;
  static const int _OPTIONAL_DOUBLE = _DOUBLE_BIT;
  static const int _OPTIONAL_ENUM = _ENUM_BIT;
  static const int _OPTIONAL_GROUP = _GROUP_BIT;
  static const int _OPTIONAL_INT32 = _INT32_BIT;
  static const int _OPTIONAL_INT64 = _INT64_BIT;
  static const int _OPTIONAL_SINT32 = _SINT32_BIT;
  static const int _OPTIONAL_SINT64 = _SINT64_BIT;
  static const int _OPTIONAL_UINT32 = _UINT32_BIT;
  static const int _OPTIONAL_UINT64 = _UINT64_BIT;
  static const int _OPTIONAL_FIXED32 = _FIXED32_BIT;
  static const int _OPTIONAL_FIXED64 = _FIXED64_BIT;
  static const int _OPTIONAL_SFIXED32 = _SFIXED32_BIT;
  static const int _OPTIONAL_SFIXED64 = _SFIXED64_BIT;
  static const int _OPTIONAL_MESSAGE = _MESSAGE_BIT;

  static const int _REQUIRED_BOOL = _REQUIRED_BIT | _BOOL_BIT;
  static const int _REQUIRED_BYTES = _REQUIRED_BIT | _BYTES_BIT;
  static const int _REQUIRED_STRING = _REQUIRED_BIT | _STRING_BIT;
  static const int _REQUIRED_FLOAT = _REQUIRED_BIT | _FLOAT_BIT;
  static const int _REQUIRED_DOUBLE = _REQUIRED_BIT | _DOUBLE_BIT;
  static const int _REQUIRED_ENUM = _REQUIRED_BIT | _ENUM_BIT;
  static const int _REQUIRED_GROUP = _REQUIRED_BIT | _GROUP_BIT;
  static const int _REQUIRED_INT32 = _REQUIRED_BIT | _INT32_BIT;
  static const int _REQUIRED_INT64 = _REQUIRED_BIT | _INT64_BIT;
  static const int _REQUIRED_SINT32 = _REQUIRED_BIT | _SINT32_BIT;
  static const int _REQUIRED_SINT64 = _REQUIRED_BIT | _SINT64_BIT;
  static const int _REQUIRED_UINT32 = _REQUIRED_BIT | _UINT32_BIT;
  static const int _REQUIRED_UINT64 = _REQUIRED_BIT | _UINT64_BIT;
  static const int _REQUIRED_FIXED32 = _REQUIRED_BIT | _FIXED32_BIT;
  static const int _REQUIRED_FIXED64 = _REQUIRED_BIT | _FIXED64_BIT;
  static const int _REQUIRED_SFIXED32 = _REQUIRED_BIT | _SFIXED32_BIT;
  static const int _REQUIRED_SFIXED64 = _REQUIRED_BIT | _SFIXED64_BIT;
  static const int _REQUIRED_MESSAGE = _REQUIRED_BIT | _MESSAGE_BIT;

  static const int _REPEATED_BOOL = _REPEATED_BIT | _BOOL_BIT;
  static const int _REPEATED_BYTES = _REPEATED_BIT | _BYTES_BIT;
  static const int _REPEATED_STRING = _REPEATED_BIT | _STRING_BIT;
  static const int _REPEATED_FLOAT = _REPEATED_BIT | _FLOAT_BIT;
  static const int _REPEATED_DOUBLE = _REPEATED_BIT | _DOUBLE_BIT;
  static const int _REPEATED_ENUM = _REPEATED_BIT | _ENUM_BIT;
  static const int _REPEATED_GROUP = _REPEATED_BIT | _GROUP_BIT;
  static const int _REPEATED_INT32 = _REPEATED_BIT | _INT32_BIT;
  static const int _REPEATED_INT64 = _REPEATED_BIT | _INT64_BIT;
  static const int _REPEATED_SINT32 = _REPEATED_BIT | _SINT32_BIT;
  static const int _REPEATED_SINT64 = _REPEATED_BIT | _SINT64_BIT;
  static const int _REPEATED_UINT32 = _REPEATED_BIT | _UINT32_BIT;
  static const int _REPEATED_UINT64 = _REPEATED_BIT | _UINT64_BIT;
  static const int _REPEATED_FIXED32 = _REPEATED_BIT | _FIXED32_BIT;
  static const int _REPEATED_FIXED64 = _REPEATED_BIT | _FIXED64_BIT;
  static const int _REPEATED_SFIXED32 = _REPEATED_BIT | _SFIXED32_BIT;
  static const int _REPEATED_SFIXED64 = _REPEATED_BIT | _SFIXED64_BIT;
  static const int _REPEATED_MESSAGE = _REPEATED_BIT | _MESSAGE_BIT;

  static const int _PACKED_BOOL = _REPEATED_BIT | _PACKED_BIT | _BOOL_BIT;
  static const int _PACKED_FLOAT = _REPEATED_BIT | _PACKED_BIT | _FLOAT_BIT;
  static const int _PACKED_DOUBLE = _REPEATED_BIT | _PACKED_BIT | _DOUBLE_BIT;
  static const int _PACKED_ENUM = _REPEATED_BIT | _PACKED_BIT | _ENUM_BIT;
  static const int _PACKED_INT32 = _REPEATED_BIT | _PACKED_BIT | _INT32_BIT;
  static const int _PACKED_INT64 = _REPEATED_BIT | _PACKED_BIT | _INT64_BIT;
  static const int _PACKED_SINT32 = _REPEATED_BIT | _PACKED_BIT | _SINT32_BIT;
  static const int _PACKED_SINT64 = _REPEATED_BIT | _PACKED_BIT | _SINT64_BIT;
  static const int _PACKED_UINT32 = _REPEATED_BIT | _PACKED_BIT | _UINT32_BIT;
  static const int _PACKED_UINT64 = _REPEATED_BIT | _PACKED_BIT | _UINT64_BIT;
  static const int _PACKED_FIXED32 = _REPEATED_BIT | _PACKED_BIT | _FIXED32_BIT;
  static const int _PACKED_FIXED64 = _REPEATED_BIT | _PACKED_BIT | _FIXED64_BIT;
  static const int _PACKED_SFIXED32 = _REPEATED_BIT | _PACKED_BIT |
      _SFIXED32_BIT;
  static const int _PACKED_SFIXED64 = _REPEATED_BIT | _PACKED_BIT |
      _SFIXED64_BIT;

  // Short names for use in generated code.

  // _O_ptional.
  static const int OB = _OPTIONAL_BOOL;
  static const int OY = _OPTIONAL_BYTES;
  static const int OS = _OPTIONAL_STRING;
  static const int OF = _OPTIONAL_FLOAT;
  static const int OD = _OPTIONAL_DOUBLE;
  static const int OE = _OPTIONAL_ENUM;
  static const int OG = _OPTIONAL_GROUP;
  static const int O3 = _OPTIONAL_INT32;
  static const int O6 = _OPTIONAL_INT64;
  static const int OS3 = _OPTIONAL_SINT32;
  static const int OS6 = _OPTIONAL_SINT64;
  static const int OU3 = _OPTIONAL_UINT32;
  static const int OU6 = _OPTIONAL_UINT64;
  static const int OF3 = _OPTIONAL_FIXED32;
  static const int OF6 = _OPTIONAL_FIXED64;
  static const int OSF3 = _OPTIONAL_SFIXED32;
  static const int OSF6 = _OPTIONAL_SFIXED64;
  static const int OM = _OPTIONAL_MESSAGE;

  // re_Q_uired.
  static const int QB = _REQUIRED_BOOL;
  static const int QY = _REQUIRED_BYTES;
  static const int QS = _REQUIRED_STRING;
  static const int QF = _REQUIRED_FLOAT;
  static const int QD = _REQUIRED_DOUBLE;
  static const int QE = _REQUIRED_ENUM;
  static const int QG = _REQUIRED_GROUP;
  static const int Q3 = _REQUIRED_INT32;
  static const int Q6 = _REQUIRED_INT64;
  static const int QS3 = _REQUIRED_SINT32;
  static const int QS6 = _REQUIRED_SINT64;
  static const int QU3 = _REQUIRED_UINT32;
  static const int QU6 = _REQUIRED_UINT64;
  static const int QF3 = _REQUIRED_FIXED32;
  static const int QF6 = _REQUIRED_FIXED64;
  static const int QSF3 = _REQUIRED_SFIXED32;
  static const int QSF6 = _REQUIRED_SFIXED64;
  static const int QM = _REQUIRED_MESSAGE;

  // re_P_eated.
  static const int PB = _REPEATED_BOOL;
  static const int PY = _REPEATED_BYTES;
  static const int PS = _REPEATED_STRING;
  static const int PF = _REPEATED_FLOAT;
  static const int PD = _REPEATED_DOUBLE;
  static const int PE = _REPEATED_ENUM;
  static const int PG = _REPEATED_GROUP;
  static const int P3 = _REPEATED_INT32;
  static const int P6 = _REPEATED_INT64;
  static const int PS3 = _REPEATED_SINT32;
  static const int PS6 = _REPEATED_SINT64;
  static const int PU3 = _REPEATED_UINT32;
  static const int PU6 = _REPEATED_UINT64;
  static const int PF3 = _REPEATED_FIXED32;
  static const int PF6 = _REPEATED_FIXED64;
  static const int PSF3 = _REPEATED_SFIXED32;
  static const int PSF6 = _REPEATED_SFIXED64;
  static const int PM = _REPEATED_MESSAGE;

  // pac_K_ed.
  static const int KB = _PACKED_BOOL;
  static const int KE = _PACKED_ENUM;
  static const int KF = _PACKED_FLOAT;
  static const int KD = _PACKED_DOUBLE;
  static const int K3 = _PACKED_INT32;
  static const int K6 = _PACKED_INT64;
  static const int KS3 = _PACKED_SINT32;
  static const int KS6 = _PACKED_SINT64;
  static const int KU3 = _PACKED_UINT32;
  static const int KU6 = _PACKED_UINT64;
  static const int KF3 = _PACKED_FIXED32;
  static const int KF6 = _PACKED_FIXED64;
  static const int KSF3 = _PACKED_SFIXED32;
  static const int KSF6 = _PACKED_SFIXED64;

  // Range of integers in JSON (53-bit integers).
  static Int64 MAX_JSON_INT = new Int64.fromInts(0x200000, 0);
  static Int64 MIN_JSON_INT = -MAX_JSON_INT;

  // Closures commonly used by initializers.
  static String _STRING_EMPTY() => '';
  static List<int> _BYTES_EMPTY() => new PbList<int>();
  static bool _BOOL_FALSE() => false;
  static int _INT_ZERO() => 0;
  static double _DOUBLE_ZERO() => 0.0;

  static MakeDefaultFunc _defaultForType(int type) {
    switch (type) {
    case _OPTIONAL_BOOL: case _REQUIRED_BOOL:
      return _BOOL_FALSE;
    case _OPTIONAL_BYTES: case _REQUIRED_BYTES:
      return _BYTES_EMPTY;
    case _OPTIONAL_STRING: case _REQUIRED_STRING:
      return _STRING_EMPTY;
    case _OPTIONAL_FLOAT: case _REQUIRED_FLOAT:
    case _OPTIONAL_DOUBLE: case _REQUIRED_DOUBLE:
      return _DOUBLE_ZERO;
    case _OPTIONAL_INT32: case _REQUIRED_INT32:
    case _OPTIONAL_INT64: case _REQUIRED_INT64:
    case _OPTIONAL_SINT32: case _REQUIRED_SINT32:
    case _OPTIONAL_SINT64: case _REQUIRED_SINT64:
    case _OPTIONAL_UINT32: case _REQUIRED_UINT32:
    case _OPTIONAL_UINT64: case _REQUIRED_UINT64:
    case _OPTIONAL_FIXED32: case _REQUIRED_FIXED32:
    case _OPTIONAL_FIXED64: case _REQUIRED_FIXED64:
    case _OPTIONAL_SFIXED32: case _REQUIRED_SFIXED32:
    case _OPTIONAL_SFIXED64: case _REQUIRED_SFIXED64:
      return _INT_ZERO;
    default:
      return null;
    }
  }

  final Map<int, dynamic> _fieldValues = new Map<int, dynamic>();
  final Map<int, Extension> _extensions = new Map<int, Extension>();
  final UnknownFieldSet unknownFields = new UnknownFieldSet();

  GeneratedMessage();

  GeneratedMessage.fromBuffer(List<int> input,
                              ExtensionRegistry extensionRegistry) {
    mergeFromBuffer(input, extensionRegistry);
  }

  GeneratedMessage.fromJson(String input,
                            ExtensionRegistry extensionRegistry) {
    mergeFromJson(input, extensionRegistry);
  }

  bool hasRequiredFields() => info_.hasRequiredFields;

  bool isInitialized() {
    if (!info_.hasRequiredFields) {
      return true;
    }
    return info_.isInitialized(_fieldValues) && extensionsAreInitialized();
  }

  void _findInvalidFields(List<String> invalidFields, String prefix) {
    info_._findInvalidFields(_fieldValues, invalidFields, prefix);
  }

  void clear() {
    unknownFields.clear();
    _fieldValues.clear();
  }

  // TODO(antonm): move to getters.
  int getTagNumber(String fieldName) => info_.tagNumber(fieldName);

  bool operator ==(other) {
    if (other is! GeneratedMessage) return false;

    GeneratedMessage o = other;
    if (o.info_ != info_) return false;
    if (!_areMapsEqual(o._fieldValues, _fieldValues)) return false;
    if (o.unknownFields != unknownFields) return false;

    return true;
  }

  int get hashCode {
    int hash;

    void hashEnumList(PbList enums) {
      enums.forEach((ProtobufEnum enm) {
        hash = (31 * hash + enm.value) & 0x3fffffff;
      });
    }

    void hashFields() {
      for (int tagNumber in sorted(_fieldValues.keys)) {
        if (!hasField(tagNumber)) continue;
        var value = _fieldValues[tagNumber];
        hash = ((37 * hash) + tagNumber) & 0x3fffffff;
        int fieldType = _getFieldType(tagNumber);
        if (_toBaseFieldType(fieldType) != _ENUM_BIT) {
          // TODO(sgjesse): Remove 'as Object' here when issue 14951 is fixed.
          hash = ((53 * hash) + (value as Object).hashCode) & 0x3fffffff;
        } else if ((fieldType & _REPEATED_BIT) != 0) {
          hashEnumList(value);
        } else {
          ProtobufEnum enm = value;
          hash = ((53 * hash) + enm.value) & 0x3fffffff;
        }
      }
    }

    // Generate hash.
    hash = 41;
    // Hash with descriptor.
    hash = ((19 * hash) + info_.hashCode) & 0x3fffffff;
    // Hash with fields.
    hashFields();
    // Hash with unknown fields.
    hash = ((29 * hash) + unknownFields.hashCode) & 0x3fffffff;
    return hash;
  }

  String toString() => _toString('');

  String _toString(String indent) {
    StringBuffer s = new StringBuffer();
    void renderValue(key, value) {
      if (value is GeneratedMessage) {
        s.write('${indent}${key}: {\n');
        s.write(value._toString('$indent  '));
        s.write('${indent}}\n');
      } else {
        s.write('${indent}${key}: ${value}\n');
      }
    }

    // Sort output by tag number.
    List<FieldInfo> fields =
        new List<FieldInfo>.from(info_.fieldInfo.values)
            ..sort((a, b) => a.tagNumber.compareTo(b.tagNumber));

    for (FieldInfo field in fields) {
      if (hasField(field.tagNumber)) {
        var fieldValue = _fieldValues[field.tagNumber];
        if (fieldValue is ByteData) {
          // TODO(antonm): fix for longs.
          final value = fieldValue.getUint64(0, Endianness.LITTLE_ENDIAN);
          renderValue(field.name, value);
        } else if (fieldValue is List) {
          for (var value in fieldValue) {
            renderValue(field.name, value);
          }
        } else {
          renderValue(field.name, fieldValue);
        }
      }
    }
    s.write(unknownFields.toString());
    return s.toString();
  }

  void check() {
    if (!isInitialized()) {
      List<String> invalidFields = <String>[];
      info_._findInvalidFields(_fieldValues, invalidFields);
      String missingFields = (invalidFields..sort()).join(', ');
      throw new StateError('Message missing required fields: $missingFields');
    }
  }

  // Overriden by subclasses.
  BuilderInfo get info_;

  Uint8List writeToBuffer() {
    CodedBufferWriter out = new CodedBufferWriter();
    writeToCodedBufferWriter(out);
    return out.toBuffer();
  }

  void writeToCodedBufferWriter(CodedBufferWriter output) {
    for (int tagNumber in sorted(_fieldValues.keys)) {
      var fieldValue = _fieldValues[tagNumber];
      int fieldType = _getFieldType(tagNumber);
      output.writeField(tagNumber, fieldType, fieldValue);
    }
    unknownFields.writeToCodedBufferWriter(output);
  }

  void mergeFromCodedBufferReader(
      CodedBufferReader input,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {

    void readPackableIoc(int wireType, int tagNumber, var iocReadFunc) {
      List list = getField(tagNumber);
      if (wireType == WIRETYPE_LENGTH_DELIMITED) {
        // Packed.
        input._withLimit(input.readInt32(), () {
            while (!input.isAtEnd()) {
              iocReadFunc(list.add);
            }
        });
      } else {
        // Not-packed.
        iocReadFunc(list.add);
      }
    }

    void readPackable(int wireType, int tagNumber, var readFunc) {
      readPackableIoc(wireType, tagNumber,
          (var assigner) => assigner(readFunc()));
    }

    bool wireTypeMatch(int tagNumber, int fieldType, int wireType) {
      switch (_toBaseFieldType(fieldType)) {
        case _BOOL_BIT:
        case _ENUM_BIT:
        case _INT32_BIT:
        case _INT64_BIT:
        case _SINT32_BIT:
        case _SINT64_BIT:
        case _UINT32_BIT:
        case _UINT64_BIT:
          return wireType == WIRETYPE_VARINT ||
              wireType == WIRETYPE_LENGTH_DELIMITED;
        case _FLOAT_BIT:
        case _FIXED32_BIT:
        case _SFIXED32_BIT:
          return wireType == WIRETYPE_FIXED32 ||
              wireType == WIRETYPE_LENGTH_DELIMITED;
        case _DOUBLE_BIT:
        case _FIXED64_BIT:
        case _SFIXED64_BIT:
          return wireType == WIRETYPE_FIXED64 ||
              wireType == WIRETYPE_LENGTH_DELIMITED;
        case _BYTES_BIT:
        case _STRING_BIT:
        case _MESSAGE_BIT:
          return wireType == WIRETYPE_LENGTH_DELIMITED;
        case _GROUP_BIT:
          return wireType == WIRETYPE_START_GROUP;
        default:
          return false;
      }
    }

    while (true) {
      int tag = input.readTag();
      if (tag == 0) {
        return;
      }
      int wireType = tag & 0x7;
      int tagNumber = tag >> 3;
      int fieldType = -1;

      if (info_.containsTagNumber(tagNumber)) {
        fieldType = info_.fieldType(tagNumber);
      } else {
        Extension extension = extensionRegistry
            .getExtension(info_.messageName, tagNumber);
        if (extension != null) {
          _addExtensionToMap(extension);
          fieldType = extension.type;
        }
      }
      if (fieldType == -1 || !wireTypeMatch(tagNumber, fieldType, wireType)) {
        if (!unknownFields.mergeFieldFromBuffer(tag, input)) {
          return;
        } else {
          continue;
        }
      }

      // Ignore required/optional packed/unpacked.
      fieldType &= ~(_PACKED_BIT | _REQUIRED_BIT);
      switch (fieldType) {
        case _OPTIONAL_BOOL:
          _fieldValues[tagNumber] = input.readBool();
          break;
        case _OPTIONAL_BYTES:
          _fieldValues[tagNumber] = input.readBytes();
          break;
        case _OPTIONAL_STRING:
          _fieldValues[tagNumber] = input.readString();
          break;
        case _OPTIONAL_FLOAT:
          _fieldValues[tagNumber] = input.readFloat();
          break;
        case _OPTIONAL_DOUBLE:
          _fieldValues[tagNumber] = input.readDouble();
          break;
        case _OPTIONAL_ENUM:
          int rawValue = input.readEnum();
          var value = _getValueOfFunc(tagNumber, extensionRegistry)(rawValue);
          if (value == null) {
            unknownFields.mergeVarintField(tagNumber, makeLongInt(rawValue));
          } else {
            _fieldValues[tagNumber] = value;
          }
          break;
        case _OPTIONAL_GROUP:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          if (_fieldValues.containsKey(tagNumber)) {
            subMessage.mergeFromMessage(getField(tagNumber));
          }
          input.readGroup(tagNumber, subMessage, extensionRegistry);
          _fieldValues[tagNumber] = subMessage;
          break;
        case _OPTIONAL_INT32:
          _fieldValues[tagNumber] = input.readInt32();
          break;
        case _OPTIONAL_INT64:
          _fieldValues[tagNumber] = input.readInt64();
          break;
        case _OPTIONAL_SINT32:
          _fieldValues[tagNumber] = input.readSint32();
          break;
        case _OPTIONAL_SINT64:
          _fieldValues[tagNumber] = input.readSint64();
          break;
        case _OPTIONAL_UINT32:
          _fieldValues[tagNumber] = input.readUint32();
          break;
        case _OPTIONAL_UINT64:
          _fieldValues[tagNumber] = input.readUint64();
          break;
        case _OPTIONAL_FIXED32:
          _fieldValues[tagNumber] = input.readFixed32();
          break;
        case _OPTIONAL_FIXED64:
          _fieldValues[tagNumber] = input.readFixed64();
          break;
        case _OPTIONAL_SFIXED32:
          _fieldValues[tagNumber] = input.readSfixed32();
          break;
        case _OPTIONAL_SFIXED64:
          _fieldValues[tagNumber] = input.readSfixed64();
          break;
        case _OPTIONAL_MESSAGE:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          if (_fieldValues.containsKey(tagNumber)) {
            subMessage.mergeFromMessage(getField(tagNumber));
          }
          input.readMessage(subMessage, extensionRegistry);
          _fieldValues[tagNumber] = subMessage;
          break;
        case _REPEATED_BOOL:
          readPackable(wireType, tagNumber, input.readBool);
          break;
        case _REPEATED_BYTES:
          List list = getField(tagNumber);
          list.add(input.readBytes());
          break;
        case _REPEATED_STRING:
          List list = getField(tagNumber);
          list.add(input.readString());
          break;
        case _REPEATED_FLOAT:
          readPackable(wireType, tagNumber, input.readFloat);
          break;
        case _REPEATED_DOUBLE:
          readPackable(wireType, tagNumber, input.readDouble);
          break;
        case _REPEATED_ENUM:
          readPackableIoc(wireType, tagNumber, (var assigner){
            int rawValue = input.readEnum();
            var value = _getValueOfFunc(tagNumber, extensionRegistry)(rawValue);
            if (value == null) {
              unknownFields.mergeVarintField(tagNumber, makeLongInt(rawValue));
            } else {
              assigner(value);
            }
          });
          break;
        case _REPEATED_GROUP:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          input.readGroup(tagNumber, subMessage, extensionRegistry);
          List list = getField(tagNumber);
          list.add(subMessage);
          break;
        case _REPEATED_INT32:
          readPackable(wireType, tagNumber, input.readInt32);
          break;
        case _REPEATED_INT64:
          readPackable(wireType, tagNumber, input.readInt64);
          break;
        case _REPEATED_SINT32:
          readPackable(wireType, tagNumber, input.readSint32);
          break;
        case _REPEATED_SINT64:
          readPackable(wireType, tagNumber, input.readSint64);
          break;
        case _REPEATED_UINT32:
          readPackable(wireType, tagNumber, input.readUint32);
          break;
        case _REPEATED_UINT64:
          readPackable(wireType, tagNumber, input.readUint64);
          break;
        case _REPEATED_FIXED32:
          readPackable(wireType, tagNumber, input.readFixed32);
          break;
        case _REPEATED_FIXED64:
          readPackable(wireType, tagNumber, input.readFixed64);
          break;
        case _REPEATED_SFIXED32:
          readPackable(wireType, tagNumber, input.readSfixed32);
          break;
        case _REPEATED_SFIXED64:
          readPackable(wireType, tagNumber, input.readSfixed64);
          break;
        case _REPEATED_MESSAGE:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          input.readMessage(subMessage, extensionRegistry);
          List list = getField(tagNumber);
          list.add(subMessage);
          break;
        default:
          throw 'Unknown field type $fieldType';
      }
    }
  }

  void mergeFromBuffer(
      List<int> input,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    CodedBufferReader codedInput = new CodedBufferReader(input);
    mergeFromCodedBufferReader(codedInput, extensionRegistry);
    codedInput.checkLastTagWas(0);
  }

  // JSON support.

  Map<String, dynamic> _toMap() {
    convertToMap(fieldValue, fieldType) {
      int scalarType = fieldType & ~(_REPEATED_BIT | _PACKED_BIT);

      if ((fieldType & _REPEATED_BIT) != 0) {
        return new List.from(fieldValue.map((e) => convertToMap(e, scalarType)));
      }

      switch (scalarType) {
      case _BOOL_BIT:
      case _STRING_BIT:
      case _FLOAT_BIT:
      case _DOUBLE_BIT:
      case _INT32_BIT:
      case _SINT32_BIT:
      case _UINT32_BIT:
      case _FIXED32_BIT:
      case _SFIXED32_BIT:
        return fieldValue;
      case _BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        return CryptoUtils.bytesToBase64(fieldValue);
      case _ENUM_BIT:
        return fieldValue.value; // assume |value| < 2^52
      case _INT64_BIT:
      case _SINT64_BIT:
      case _UINT64_BIT:
      case _FIXED64_BIT:
      case _SFIXED64_BIT:
        // Use strings for 64-bit integers which cannot fit in doubles.
        if (MIN_JSON_INT <= fieldValue && fieldValue <= MAX_JSON_INT) {
          return fieldValue.toInt();
        } else {
          return fieldValue.toString();
        }
        break;
      case _GROUP_BIT:
      case _MESSAGE_BIT:
        return fieldValue._toMap();
      default:
        throw 'Unknown type $fieldType';
      }
    }

    var result = <String, dynamic>{};
    for (int tagNumber in sorted(_fieldValues.keys)) {
      if (!hasField(tagNumber)) continue;
      String key = '$tagNumber';
      var fieldValue = _fieldValues[tagNumber];
      int fieldType = _getFieldType(tagNumber) & ~_REQUIRED_BIT;
      result[key] = convertToMap(fieldValue, fieldType);
    }
    return result;
  }

  /**
   * Return a JSON string that encodes this message.  Each message (top level
   * or nested) is represented as an object delimited by curly braces.  Within
   * a message, elements are indexed by tag number (surrounded by quotes).
   * Repeated elements are represented as arrays.
   *
   * Boolean values, strings, and floating-point values are represented as
   * literals.  Values with a 32-bit integer datatype are represented as integer
   * literals; values with a 64-bit integer datatype (regardless of their
   * actual runtime value) are represented as strings.  Enumerated values are
   * represented as their integer value.
   */
  String writeToJson() => JSON.encode(_toMap());

  // Merge fields from a previously decoded JSON object.
  GeneratedMessage _mergeFromJson(
      Map<String, dynamic> json,
      ExtensionRegistry extensionRegistry) {
    // Extract a value from its JSON representation.
    convertJsonValue(var value, int tagNumber, int fieldType) {
      String expectedType; // for exception message
      switch (_toBaseFieldType(fieldType)) {
      case _BOOL_BIT:
        if (value is bool) {
          return value;
        } else if (value is String) {
          if (value == 'true') {
            return true;
          } else if (value == 'false') {
            return false;
          }
        }
        expectedType = 'bool, "true", or "false"';
        break;
      case _BYTES_BIT:
        if (value is String) {
          return CryptoUtils.base64StringToBytes(value);
        }
        expectedType = 'Base64 String';
        break;
      case _STRING_BIT:
        if (value is String) {
          return value;
        }
        expectedType = 'String';
        break;
      case _FLOAT_BIT:
      case _DOUBLE_BIT:
        // Allow quoted values, although we don't emit them.
        if (value is double) {
          return value;
        } else if (value is num) {
          return value.toDouble();
        } else if (value is String) {
          return double.parse(value);
        }
        expectedType = 'num or stringified num';
        break;
      case _ENUM_BIT:
        // Allow quoted values, although we don't emit them.
        if (value is String) {
          value = int.parse(value);
        }
        if (value is int) {
          return _getValueOfFunc(tagNumber, extensionRegistry)(value);
        }
        expectedType = 'int or stringified int';
        break;
      case _INT32_BIT:
      case _SINT32_BIT:
      case _UINT32_BIT:
      case _FIXED32_BIT:
      case _SFIXED32_BIT:
        if (value is String) {
          value = int.parse(value);
        }
        // Allow unquoted values, although we don't emit them.
        if (value is int) {
          return value;
        }
        expectedType = 'int or stringified int';
        break;
      case _INT64_BIT:
      case _SINT64_BIT:
      case _UINT64_BIT:
      case _FIXED64_BIT:
      case _SFIXED64_BIT:
        // Allow quoted values, although we don't emit them.
        if (value is String) {
          return Int64.parseRadix(value, 10);
        }
        if (value is int) {
          return new Int64(value);
        }
        expectedType = 'int or stringified int';
        break;
      case _GROUP_BIT:
      case _MESSAGE_BIT:
        if (value is Map<String, Object>) {
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          subMessage._mergeFromJson(value, extensionRegistry);
          return subMessage;
        }
        expectedType = 'nested message or group';
        break;
      default:
        throw new ArgumentError('Unknown type $fieldType');
      }
      throw new ArgumentError('Expected type $expectedType, got $value');
    }

    for (int tagNumber in sorted(json.keys.map(int.parse))) {
      var fieldValue = json[tagNumber.toString()];
      int fieldType = -1;

      Extension extension = null;
      if (info_.containsTagNumber(tagNumber)) {
        fieldType = info_.fieldType(tagNumber);
      } else if (extensionRegistry != null) {
        extension = extensionRegistry.getExtension(info_.messageName,
            tagNumber);
        if (extension == null) {
          // Unknown extensions can be skipped.
          continue;
        }
        _addExtensionToMap(extension);
        fieldType = extension.type;
      }
      if (fieldType == -1) {
        throw new StateError('Unknown field type for tag number $tagNumber');
      }
      if ((fieldType & _REPEATED_BIT) != 0) {
        List thisList = getField(tagNumber);
        for (var value in fieldValue) {
          thisList.add(convertJsonValue(value, tagNumber, fieldType));
        }
      } else {
        var value = convertJsonValue(fieldValue, tagNumber, fieldType);
        setField(tagNumber, value, fieldType);
      }
    }
  }

  /**
   * Merge field values from a JSON object, encoded as described by
   * [GeneratedMessage.writeToJson].
   */
  void mergeFromJson(
      String data,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    _mergeFromJson(JSON.decode(data), extensionRegistry);
  }

  /**
   * Add an extension field value to a repeated field.  The backing
   * [List] will be created if necessary.
   */
  void addExtension(Extension extension, var value) {
    _checkExtension(extension);
    if ((extension.type & _REPEATED_BIT) == 0) {
      throw new ArgumentError(
          'Cannot add to a non-repeated field (use setExtension())');
    }
    // Validate type and range.
    _validate(extension.tagNumber, extension.type & ~0x7, value);

    var list = _fieldValues[extension.tagNumber];
    if (list == null) {
      list = extension.makeDefault();
      _setExtension(extension, list);
    }

    list.add(value);
  }

  void clearExtension(Extension extension) {
    _checkExtension(extension);
    _fieldValues.remove(extension.tagNumber);
    var value = extension.makeDefault();
    if (value is List) {
      _setExtension(extension, value);
    } else {
      _extensions.remove(extension.tagNumber);
    }
  }

  void clearField(int tagNumber) {
    _fieldValues.remove(tagNumber);
  }

  bool extensionsAreInitialized() {
    return _extensions.keys.every((int tagNumber) {
      return info_._isFieldInitialized(_fieldValues, tagNumber,
          _extensions[tagNumber].type);
    });
  }

  /**
   * Returns the value of the given extension.  For repeated fields that have
   * not been set previously, [:null:] is returned.
   */
  getExtension(Extension extension) {
    _checkExtension(extension);
    _addExtensionToMap(extension);
    return getField(extension.tagNumber);
  }

  getField(int tagNumber) {
    var value = _fieldValues[tagNumber];
    // Initialize the field.
    if (value == null) {
      MakeDefaultFunc makeDefaultFunc = info_.makeDefault(tagNumber);
      if (makeDefaultFunc == null) {
        makeDefaultFunc = _extensions[tagNumber].makeDefault;
      }
      value = makeDefaultFunc();
      // TODO(antonm): ugly trick which should go away imho:
      // right now getField for repeated fields returns a list
      // which is implicitly added to the message.
      // Should return immutable empty list instead, imho.
      if (value is List) {
        _fieldValues[tagNumber] = value;
      }
    }
    return value;
  }

  /**
   * Return [:true:] if a value of the given extension is present.
   */
  bool hasExtension(Extension extension) {
    _checkExtension(extension);
    return hasField(extension.tagNumber);
  }

  bool hasField(int tagNumber) {
    if (!_fieldValues.containsKey(tagNumber)) {
      return false;
    }
    var value = _fieldValues[tagNumber];
    if (value is List && value.isEmpty) {
      return false;
    }
    return true;
  }

  void mergeFromMessage(GeneratedMessage other) {
    for (int tagNumber in other._fieldValues.keys) {
      var fieldValue = other._fieldValues[tagNumber];

      if (other._extensions.containsKey(tagNumber)) {
        _addExtensionToMap(other._extensions[tagNumber]);
      }
      int fieldType = other._getFieldType(tagNumber);
      var cloner = (x) => x;
      if ((fieldType & (_GROUP_BIT | _MESSAGE_BIT)) != 0) {
        cloner = (message) => message.clone();
      }
      if ((fieldType & _REPEATED_BIT) != 0) {
        getField(tagNumber).addAll(new List.from(fieldValue).map(cloner));
      } else {
        setField(tagNumber, cloner(fieldValue), fieldType);
      }
    }

    mergeUnknownFields(other.unknownFields);
  }

  void mergeUnknownFields(UnknownFieldSet unknownFieldSet) {
    unknownFields.mergeFromUnknownFieldSet(unknownFieldSet);
  }

  /**
   * Set the value of a non-repeated extension field.
   */
  void setExtension(Extension extension, var value) {
    _checkExtension(extension);
    _addExtensionToMap(extension);
    setField(extension.tagNumber, value, extension.type);
  }

  /**
   * Sets the value of a given field by its [tagNumber]. Can throw an
   * [:ArgumentError:] if the value does not match the type
   * associated with [tagNumber].
   */
  void setField(int tagNumber, var value, [int fieldType = null]) {
    if (value == null) {
      throw new ArgumentError('value is null');
    }
    if (fieldType == null) {
      if (!info_.containsTagNumber(tagNumber)) {
        throw new ArgumentError('Unknown tag: $tagNumber');
      }
      fieldType = info_.fieldType(tagNumber);
    }
    if ((fieldType & _REPEATED_BIT) != 0) {
      throw new ArgumentError(_generateMessage(tagNumber, value,
          'repeating field (use get + .add())'));
    }

    // Validate type and range.
    _validate(tagNumber, fieldType & ~0x7, value);
    _fieldValues[tagNumber] = value;
  }

  void _addExtensionToMap(Extension extension) {
    _extensions[extension.tagNumber] = extension;
  }

  void _checkExtension(Extension extension) {
    if (extension.extendee != info_.messageName) {
      throw new ArgumentError(
          'Extension $extension not legal for message ${info_.messageName}');
    }
  }

  /**
   * Returns the type associated with a given tag number, either from the
   * [BuilderInfo] associated with this [GeneratedMessage],
   * or from a known extension.  If the type is unknown, [null] is returned.
   */
  int _getFieldType(int tagNumber) {
    int type = info_.fieldType(tagNumber);
    if (type == null && _extensions.containsKey(tagNumber)) {
      type = _extensions[tagNumber].type;
    }
    return type;
  }

  /**
   * Returns the type associated with a given tag number, either from the
   * [BuilderInfo] associated with this [GeneratedMessage],
   * or from a known extension.  If the type is unknown, [null] is returned.
   */
  int _getBaseFieldType(int tagNumber) {
    int type = info_.fieldType(tagNumber);
    if (type == null && _extensions.containsKey(tagNumber)) {
      type = _extensions[tagNumber].type;
    }
    return type;
  }

  /*
   * Returns the base field type without any of the required, repeated
   * and packed bits.
   */
  int _toBaseFieldType(int fieldType) {
    return fieldType & ~(_REQUIRED_BIT | _REPEATED_BIT | _PACKED_BIT);
  }

  GeneratedMessage _getEmptyMessage(
      int tagNumber, ExtensionRegistry extensionRegistry) {
    CreateBuilderFunc subBuilderFunc = info_.subBuilder(tagNumber);
    if (subBuilderFunc == null && extensionRegistry != null) {
      subBuilderFunc = extensionRegistry.getExtension(info_.messageName,
          tagNumber).subBuilder;
    }
    return subBuilderFunc();
  }

  ValueOfFunc _getValueOfFunc(int tagNumber,
      ExtensionRegistry extensionRegistry) {
    ValueOfFunc valueOfFunc = info_.valueOfFunc(tagNumber);
    if (valueOfFunc == null && extensionRegistry != null) {
      valueOfFunc = extensionRegistry.getExtension(info_.messageName,
        tagNumber).valueOf;
    }
    return valueOfFunc;
  }

  // Does not perform validation.
  void _setExtension(Extension extension, var value) {
    _addExtensionToMap(extension);
    _fieldValues[extension.tagNumber] = value;
  }

  String _generateMessage(int tagNumber, var value, String detail) {
    String fieldName;
    if (_extensions[tagNumber] != null) {
      fieldName = _extensions[tagNumber].name;
    } else {
      fieldName = info_.fieldName(tagNumber);
    }
    String messageType = info_.messageName;
    return 'Illegal to set field $fieldName ($tagNumber) of $messageType'
        ' to value ($value): $detail';
  }

  void _validate(int tagNumber, int fieldType, var value) {
    switch (fieldType) {
      case _BOOL_BIT:
        if (value is !bool) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type bool'));
        }
        break;
      case _BYTES_BIT:
        if (value is !List<int>) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not List<int>'));
        }
        break;
      case _STRING_BIT:
        if (value is !String) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type String'));
        }
        break;
      case _FLOAT_BIT:
        if (value is !double) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type double'));
        }
        if (!_isFloat32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for float'));
        }
        break;
      case _DOUBLE_BIT:
        if (value is !double) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type double'));
        }
        break;
      case _ENUM_BIT:
        if (value is !ProtobufEnum) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type ProtobufEnum'));
        }
        break;
      case _INT32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isSigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for int32'));
        }
        break;
      case _INT64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isSigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for int64'));
        }
        break;
      case _SINT32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isSigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for sint32'));
        }
        break;
      case _SINT64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isSigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for sint64'));
        }
        break;
      case _UINT32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isUnsigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for uint32'));
        }
        break;
      case _UINT64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isUnsigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for uint64'));
        }
        break;
      case _FIXED32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isUnsigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for fixed32'));
        }
        break;
      case _FIXED64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isUnsigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for fixed64'));
        }
        break;
      case _SFIXED32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isSigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for sfixed32'));
        }
        break;
      case _SFIXED64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isSigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for sfixed64'));
        }
        break;
      case _GROUP_BIT:
      case _MESSAGE_BIT:
        if (value is !GeneratedMessage) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not a GeneratedMessage'));
        }
        break;
      default:
        throw new ArgumentError(
            _generateMessage(tagNumber, value, 'field has unknown type '
            '$fieldType'));
    }
  }
}
