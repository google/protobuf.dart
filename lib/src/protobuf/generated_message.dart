// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

typedef GeneratedMessage CreateBuilderFunc();
typedef Object MakeDefaultFunc();
typedef ProtobufEnum ValueOfFunc(int value);

bool _inRange(min, value, max) => (min <= value) && (value <= max);

bool _isSigned32(int value) => _inRange(-2147483648, value, 2147483647);
bool _isUnsigned32(int value) => _inRange(0, value, 4294967295);
bool _isSigned64(Int64 value) => _isUnsigned64(value);
bool _isUnsigned64(Int64 value) => value is Int64;
bool _isFloat32(double value) => value.isNaN || value.isInfinite ||
    _inRange(-3.4028234663852886E38, value, 3.4028234663852886E38);

abstract class GeneratedMessage {

  // Short names for use in generated code.
  // TODO(skybrian) change generated code to use FieldType instead.

  // _O_ptional.
  static const int OB = FieldType._OPTIONAL_BOOL;
  static const int OY = FieldType._OPTIONAL_BYTES;
  static const int OS = FieldType._OPTIONAL_STRING;
  static const int OF = FieldType._OPTIONAL_FLOAT;
  static const int OD = FieldType._OPTIONAL_DOUBLE;
  static const int OE = FieldType._OPTIONAL_ENUM;
  static const int OG = FieldType._OPTIONAL_GROUP;
  static const int O3 = FieldType._OPTIONAL_INT32;
  static const int O6 = FieldType._OPTIONAL_INT64;
  static const int OS3 = FieldType._OPTIONAL_SINT32;
  static const int OS6 = FieldType._OPTIONAL_SINT64;
  static const int OU3 = FieldType._OPTIONAL_UINT32;
  static const int OU6 = FieldType._OPTIONAL_UINT64;
  static const int OF3 = FieldType._OPTIONAL_FIXED32;
  static const int OF6 = FieldType._OPTIONAL_FIXED64;
  static const int OSF3 = FieldType._OPTIONAL_SFIXED32;
  static const int OSF6 = FieldType._OPTIONAL_SFIXED64;
  static const int OM = FieldType._OPTIONAL_MESSAGE;

  // re_Q_uired.
  static const int QB = FieldType._REQUIRED_BOOL;
  static const int QY = FieldType._REQUIRED_BYTES;
  static const int QS = FieldType._REQUIRED_STRING;
  static const int QF = FieldType._REQUIRED_FLOAT;
  static const int QD = FieldType._REQUIRED_DOUBLE;
  static const int QE = FieldType._REQUIRED_ENUM;
  static const int QG = FieldType._REQUIRED_GROUP;
  static const int Q3 = FieldType._REQUIRED_INT32;
  static const int Q6 = FieldType._REQUIRED_INT64;
  static const int QS3 = FieldType._REQUIRED_SINT32;
  static const int QS6 = FieldType._REQUIRED_SINT64;
  static const int QU3 = FieldType._REQUIRED_UINT32;
  static const int QU6 = FieldType._REQUIRED_UINT64;
  static const int QF3 = FieldType._REQUIRED_FIXED32;
  static const int QF6 = FieldType._REQUIRED_FIXED64;
  static const int QSF3 = FieldType._REQUIRED_SFIXED32;
  static const int QSF6 = FieldType._REQUIRED_SFIXED64;
  static const int QM = FieldType._REQUIRED_MESSAGE;

  // re_P_eated.
  static const int PB = FieldType._REPEATED_BOOL;
  static const int PY = FieldType._REPEATED_BYTES;
  static const int PS = FieldType._REPEATED_STRING;
  static const int PF = FieldType._REPEATED_FLOAT;
  static const int PD = FieldType._REPEATED_DOUBLE;
  static const int PE = FieldType._REPEATED_ENUM;
  static const int PG = FieldType._REPEATED_GROUP;
  static const int P3 = FieldType._REPEATED_INT32;
  static const int P6 = FieldType._REPEATED_INT64;
  static const int PS3 = FieldType._REPEATED_SINT32;
  static const int PS6 = FieldType._REPEATED_SINT64;
  static const int PU3 = FieldType._REPEATED_UINT32;
  static const int PU6 = FieldType._REPEATED_UINT64;
  static const int PF3 = FieldType._REPEATED_FIXED32;
  static const int PF6 = FieldType._REPEATED_FIXED64;
  static const int PSF3 = FieldType._REPEATED_SFIXED32;
  static const int PSF6 = FieldType._REPEATED_SFIXED64;
  static const int PM = FieldType._REPEATED_MESSAGE;

  // pac_K_ed.
  static const int KB = FieldType._PACKED_BOOL;
  static const int KE = FieldType._PACKED_ENUM;
  static const int KF = FieldType._PACKED_FLOAT;
  static const int KD = FieldType._PACKED_DOUBLE;
  static const int K3 = FieldType._PACKED_INT32;
  static const int K6 = FieldType._PACKED_INT64;
  static const int KS3 = FieldType._PACKED_SINT32;
  static const int KS6 = FieldType._PACKED_SINT64;
  static const int KU3 = FieldType._PACKED_UINT32;
  static const int KU6 = FieldType._PACKED_UINT64;
  static const int KF3 = FieldType._PACKED_FIXED32;
  static const int KF6 = FieldType._PACKED_FIXED64;
  static const int KSF3 = FieldType._PACKED_SFIXED32;
  static const int KSF6 = FieldType._PACKED_SFIXED64;

  // Range of integers in JSON (53-bit integers).
  static Int64 MAX_JSON_INT = new Int64.fromInts(0x200000, 0);
  static Int64 MIN_JSON_INT = -MAX_JSON_INT;

  final Map<int, dynamic> _fieldValues = new Map<int, dynamic>();
  final Map<int, Extension> _extensions = new Map<int, Extension>();
  final UnknownFieldSet unknownFields = new UnknownFieldSet();

  GeneratedMessage() {
    if (eventPlugin != null) eventPlugin.attach(this);
  }

  GeneratedMessage.fromBuffer(List<int> input,
                              ExtensionRegistry extensionRegistry) {
    if (eventPlugin != null) eventPlugin.attach(this);
    mergeFromBuffer(input, extensionRegistry);
  }

  GeneratedMessage.fromJson(String input,
                            ExtensionRegistry extensionRegistry) {
    if (eventPlugin != null) eventPlugin.attach(this);
    mergeFromJson(input, extensionRegistry);
  }

  /// Subclasses can override this getter to be notified of changes
  /// to protobuf fields.
  EventPlugin get eventPlugin => null;

  /// Returns true if we should send events to the plugin.
  bool get _hasObservers => eventPlugin != null && eventPlugin.hasObservers;

  bool hasRequiredFields() => info_.hasRequiredFields;

  /// Returns [:true:] if all required fields in the message and all embedded
  /// messages are set, false otherwise.
  bool isInitialized() {
    if (!info_.hasRequiredFields) {
      return true;
    }
    return info_.isInitialized(_fieldValues) && extensionsAreInitialized();
  }

  void _findInvalidFields(List<String> invalidFields, String prefix) {
    info_._findInvalidFields(_fieldValues, invalidFields, prefix);
  }

  /// Clears all data that was set in this message.
  ///
  /// After calling [clear], [getField] will still return default values for
  /// unset fields.
  void clear() {
    unknownFields.clear();

    if (_hasObservers) {
      for (int key in _fieldValues.keys) {
        eventPlugin.beforeClearField(key);
      }
    }
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
        if (!_isEnum(fieldType)) {
          // TODO(sgjesse): Remove 'as Object' here when issue 14951 is fixed.
          hash = ((53 * hash) + (value as Object).hashCode) & 0x3fffffff;
        } else if (_isRepeated(fieldType)) {
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

  /// Returns a String representation of this message.
  ///
  /// This representation is similar to, but not quite, the Protocol Buffer
  /// TextFormat. Each field is printed on its own line. Sub-messages are
  /// indented two spaces farther than their parent messages.
  ///
  /// Note that this format is absolutely subject to change, and should only
  /// ever be used for debugging.
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

  // Overridden by subclasses.
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

    void appendToRepeated(tagNumber, value) {
      List list = getField(tagNumber);
      list.add(value);
    }

    void readPackableToList(int wireType, int tagNumber, Function readToList) {
      List list = getField(tagNumber);

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

    void readPackable(int wireType, int tagNumber, Function readFunc) {
      void readToList(List list) => list.add(readFunc());
      readPackableToList(wireType, tagNumber, readToList);
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
      if (fieldType == -1 || !_wireTypeMatches(fieldType, wireType)) {
        if (!unknownFields.mergeFieldFromBuffer(tag, input)) {
          return;
        } else {
          continue;
        }
      }

      // Ignore required/optional packed/unpacked.
      fieldType &= ~(FieldType._PACKED_BIT | FieldType._REQUIRED_BIT);
      switch (fieldType) {
        case FieldType._OPTIONAL_BOOL:
          _setField(tagNumber, input.readBool());
          break;
        case FieldType._OPTIONAL_BYTES:
          _setField(tagNumber, input.readBytes());
          break;
        case FieldType._OPTIONAL_STRING:
          _setField(tagNumber, input.readString());
          break;
        case FieldType._OPTIONAL_FLOAT:
          _setField(tagNumber, input.readFloat());
          break;
        case FieldType._OPTIONAL_DOUBLE:
          _setField(tagNumber, input.readDouble());
          break;
        case FieldType._OPTIONAL_ENUM:
          int rawValue = input.readEnum();
          var value = _getValueOfFunc(tagNumber, extensionRegistry)(rawValue);
          if (value == null) {
            unknownFields.mergeVarintField(tagNumber, new Int64(rawValue));
          } else {
            _setField(tagNumber, value);
          }
          break;
        case FieldType._OPTIONAL_GROUP:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          if (_fieldValues.containsKey(tagNumber)) {
            subMessage.mergeFromMessage(getField(tagNumber));
          }
          input.readGroup(tagNumber, subMessage, extensionRegistry);
          _setField(tagNumber, subMessage);
          break;
        case FieldType._OPTIONAL_INT32:
          _setField(tagNumber, input.readInt32());
          break;
        case FieldType._OPTIONAL_INT64:
          _setField(tagNumber, input.readInt64());
          break;
        case FieldType._OPTIONAL_SINT32:
          _setField(tagNumber, input.readSint32());
          break;
        case FieldType._OPTIONAL_SINT64:
          _setField(tagNumber, input.readSint64());
          break;
        case FieldType._OPTIONAL_UINT32:
          _setField(tagNumber, input.readUint32());
          break;
        case FieldType._OPTIONAL_UINT64:
          _setField(tagNumber, input.readUint64());
          break;
        case FieldType._OPTIONAL_FIXED32:
          _setField(tagNumber, input.readFixed32());
          break;
        case FieldType._OPTIONAL_FIXED64:
          _setField(tagNumber, input.readFixed64());
          break;
        case FieldType._OPTIONAL_SFIXED32:
          _setField(tagNumber, input.readSfixed32());
          break;
        case FieldType._OPTIONAL_SFIXED64:
          _setField(tagNumber, input.readSfixed64());
          break;
        case FieldType._OPTIONAL_MESSAGE:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          if (_fieldValues.containsKey(tagNumber)) {
            subMessage.mergeFromMessage(getField(tagNumber));
          }
          input.readMessage(subMessage, extensionRegistry);
          _setField(tagNumber, subMessage);
          break;
        case FieldType._REPEATED_BOOL:
          readPackable(wireType, tagNumber, input.readBool);
          break;
        case FieldType._REPEATED_BYTES:
          appendToRepeated(tagNumber, input.readBytes());
          break;
        case FieldType._REPEATED_STRING:
          appendToRepeated(tagNumber, input.readString());
          break;
        case FieldType._REPEATED_FLOAT:
          readPackable(wireType, tagNumber, input.readFloat);
          break;
        case FieldType._REPEATED_DOUBLE:
          readPackable(wireType, tagNumber, input.readDouble);
          break;
        case FieldType._REPEATED_ENUM:
          readPackableToList(wireType, tagNumber, (List list) {
            int rawValue = input.readEnum();
            var value = _getValueOfFunc(tagNumber, extensionRegistry)(rawValue);
            if (value == null) {
              unknownFields.mergeVarintField(tagNumber, new Int64(rawValue));
            } else {
              list.add(value);
            }
          });
          break;
        case FieldType._REPEATED_GROUP:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          input.readGroup(tagNumber, subMessage, extensionRegistry);
          appendToRepeated(tagNumber, subMessage);
          break;
        case FieldType._REPEATED_INT32:
          readPackable(wireType, tagNumber, input.readInt32);
          break;
        case FieldType._REPEATED_INT64:
          readPackable(wireType, tagNumber, input.readInt64);
          break;
        case FieldType._REPEATED_SINT32:
          readPackable(wireType, tagNumber, input.readSint32);
          break;
        case FieldType._REPEATED_SINT64:
          readPackable(wireType, tagNumber, input.readSint64);
          break;
        case FieldType._REPEATED_UINT32:
          readPackable(wireType, tagNumber, input.readUint32);
          break;
        case FieldType._REPEATED_UINT64:
          readPackable(wireType, tagNumber, input.readUint64);
          break;
        case FieldType._REPEATED_FIXED32:
          readPackable(wireType, tagNumber, input.readFixed32);
          break;
        case FieldType._REPEATED_FIXED64:
          readPackable(wireType, tagNumber, input.readFixed64);
          break;
        case FieldType._REPEATED_SFIXED32:
          readPackable(wireType, tagNumber, input.readSfixed32);
          break;
        case FieldType._REPEATED_SFIXED64:
          readPackable(wireType, tagNumber, input.readSfixed64);
          break;
        case FieldType._REPEATED_MESSAGE:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          input.readMessage(subMessage, extensionRegistry);
          appendToRepeated(tagNumber, subMessage);
          break;
        default:
          throw 'Unknown field type $fieldType';
      }
    }
  }

  /// Merges serialized protocol buffer data into this message.
  ///
  /// For each field in [input] that is already present in this message:
  ///
  /// * If it's a repeated field, this appends to the end of our list.
  /// * Else, if it's a scalar, this overwrites our field.
  /// * Else, (it's a non-repeated sub-message), this recursively merges into
  ///   the existing sub-message.
  void mergeFromBuffer(
      List<int> input,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    CodedBufferReader codedInput = new CodedBufferReader(input);
    mergeFromCodedBufferReader(codedInput, extensionRegistry);
    codedInput.checkLastTagWas(0);
  }

  // JSON support.

  /// Returns the JSON encoding of this message as a Dart [Map].
  ///
  /// The encoding is described in [GeneratedMessage.writeToJson].
  Map<String, dynamic> writeToJsonMap() {
    convertToMap(fieldValue, fieldType) {
      int baseType = FieldType._baseType(fieldType);

      if (_isRepeated(fieldType)) {
        return new List.from(fieldValue.map((e) => convertToMap(e, baseType)));
      }

      switch (baseType) {
      case FieldType._BOOL_BIT:
      case FieldType._STRING_BIT:
      case FieldType._FLOAT_BIT:
      case FieldType._DOUBLE_BIT:
      case FieldType._INT32_BIT:
      case FieldType._SINT32_BIT:
      case FieldType._UINT32_BIT:
      case FieldType._FIXED32_BIT:
      case FieldType._SFIXED32_BIT:
        return fieldValue;
      case FieldType._BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        return CryptoUtils.bytesToBase64(fieldValue);
      case FieldType._ENUM_BIT:
        return fieldValue.value; // assume |value| < 2^52
      case FieldType._INT64_BIT:
      case FieldType._SINT64_BIT:
      case FieldType._UINT64_BIT:
      case FieldType._FIXED64_BIT:
      case FieldType._SFIXED64_BIT:
        // Use strings for 64-bit integers which cannot fit in doubles.
        if (MIN_JSON_INT <= fieldValue && fieldValue <= MAX_JSON_INT) {
          return fieldValue.toInt();
        }
        return fieldValue.toString();
      case FieldType._GROUP_BIT:
      case FieldType._MESSAGE_BIT:
        return fieldValue.writeToJsonMap();
      default:
        throw 'Unknown type $fieldType';
      }
    }

    var result = <String, dynamic>{};
    for (int tagNumber in sorted(_fieldValues.keys)) {
      if (!hasField(tagNumber)) continue;
      String key = '$tagNumber';
      var fieldValue = _fieldValues[tagNumber];
      int fieldType = _getFieldType(tagNumber);
      result[key] = convertToMap(fieldValue, fieldType);
    }
    return result;
  }

  /// Returns a JSON string that encodes this message.
  ///
  /// Each message (top level or nested) is represented as an object delimited
  /// by curly braces. Within a message, elements are indexed by tag number
  /// (surrounded by quotes). Repeated elements are represented as arrays.
  ///
  /// Boolean values, strings, and floating-point values are represented as
  /// literals. Values with a 32-bit integer datatype are represented as integer
  /// literals; values with a 64-bit integer datatype (regardless of their
  /// actual runtime value) are represented as strings. Enumerated values are
  /// represented as their integer value.
  String writeToJson() => JSON.encode(writeToJsonMap());

  // Merge fields from a previously decoded JSON object.
  // (Called recursively on nested messages.)
  void _mergeFromJson(
      Map<String, dynamic> json,
      ExtensionRegistry extensionRegistry) {

    // Extract a value from its JSON representation.

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
      if (_isRepeated(fieldType)) {
        List thisList = getField(tagNumber);
        for (var value in fieldValue) {
          thisList.add(_convertJsonValue(value, tagNumber, fieldType,
                                         extensionRegistry));
        }
      } else {
        var value = _convertJsonValue(fieldValue, tagNumber, fieldType,
            extensionRegistry);
        setField(tagNumber, value, fieldType);
      }
    }
  }

  _convertJsonValue(value, int tagNumber, int fieldType,
                   ExtensionRegistry extensionRegistry) {
    String expectedType; // for exception message
    switch (FieldType._baseType(fieldType)) {
    case FieldType._BOOL_BIT:
      if (value is bool) {
        return value;
      } else if (value is String) {
        if (value == 'true') {
          return true;
        } else if (value == 'false') {
          return false;
        }
        expectedType = 'bool, "true", or "false"';
      } else if (value is num) {
        if (value == 1) {
          return true;
        } else if (value == 0) {
          return false;
        }
        expectedType = 'bool, 0, or 1';
      }
      break;
    case FieldType._BYTES_BIT:
      if (value is String) {
        return CryptoUtils.base64StringToBytes(value);
      }
      expectedType = 'Base64 String';
      break;
    case FieldType._STRING_BIT:
      if (value is String) {
        return value;
      }
      expectedType = 'String';
      break;
    case FieldType._FLOAT_BIT:
    case FieldType._DOUBLE_BIT:
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
    case FieldType._ENUM_BIT:
      // Allow quoted values, although we don't emit them.
      if (value is String) {
        value = int.parse(value);
      }
      if (value is int) {
        return _getValueOfFunc(tagNumber, extensionRegistry)(value);
      }
      expectedType = 'int or stringified int';
      break;
    case FieldType._INT32_BIT:
    case FieldType._SINT32_BIT:
    case FieldType._UINT32_BIT:
    case FieldType._FIXED32_BIT:
    case FieldType._SFIXED32_BIT:
      if (value is String) {
        value = int.parse(value);
      }
      // Allow unquoted values, although we don't emit them.
      if (value is int) {
        return value;
      }
      expectedType = 'int or stringified int';
      break;
    case FieldType._INT64_BIT:
    case FieldType._SINT64_BIT:
    case FieldType._UINT64_BIT:
    case FieldType._FIXED64_BIT:
    case FieldType._SFIXED64_BIT:
      // Allow quoted values, although we don't emit them.
      if (value is String) {
        return Int64.parseRadix(value, 10);
      }
      if (value is int) {
        return new Int64(value);
      }
      expectedType = 'int or stringified int';
      break;
    case FieldType._GROUP_BIT:
    case FieldType._MESSAGE_BIT:
      if (value is Map) {
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

  /// Merges field values from [data], a JSON object, encoded as described by
  /// [GeneratedMessage.writeToJson].
  void mergeFromJson(
      String data,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    _mergeFromJson(JSON.decode(data), extensionRegistry);
  }

  /// Merges field values from a JSON object represented as a Dart map.
  ///
  /// The encoding is described in [GeneratedMessage.writeToJson].
  void mergeFromJsonMap(
      Map<String, dynamic> json,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    _mergeFromJson(json, extensionRegistry);
  }

  /// Adds an extension field value to a repeated field.
  ///
  /// The backing [List] will be created if necessary.
  void addExtension(Extension extension, var value) {
    _checkExtension(extension);
    if (!_isRepeated(extension.type)) {
      throw new ArgumentError(
          'Cannot add to a non-repeated field (use setExtension())');
    }
    // Validate type and range.
    _validate(extension.tagNumber, extension.type, value);

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

  /// Clears the contents of a given field.
  void clearField(int tagNumber) {
    if (_hasObservers) {
      eventPlugin.beforeClearField(tagNumber);
    }
    _fieldValues.remove(tagNumber);
  }

  bool extensionsAreInitialized() {
    return _extensions.keys.every((int tagNumber) {
      return info_._isFieldInitialized(_fieldValues, tagNumber,
          _extensions[tagNumber].type);
    });
  }

  /// Returns the value of [extension].
  ///
  /// For repeated fields that have not been set previously, [:null:] is
  /// returned.
  getExtension(Extension extension) {
    _checkExtension(extension);
    _addExtensionToMap(extension);
    return getField(extension.tagNumber);
  }

  /// Returns the value of the field associated with [tagNumber], or the
  /// default value if it is not set.
  getField(int tagNumber) {
    var value = _fieldValues[tagNumber];
    if (value != null) return value;

    // Initialize the field.
    value = _callDefaultFunction(tagNumber);
    if (value is List) {
      return _getDefaultRepeatedField(tagNumber, value);
    }
    return value;
  }

  List _getDefaultRepeatedField(int tagNumber, List value) {
    // Automatically save the repeated field so that changes won't be lost.
    //
    // TODO(skybrian) we could avoid this by generating another
    // method for repeated fields:
    //
    //   msg.mutableFoo().add(123);
    //
    // Then msg.foo could return an immutable empty list by default.
    // But it doesn't seem urgent or worth the migration.
    _setField(tagNumber, value);
    return value;
  }

  /// Returns the value of a field, ignoring any defaults.
  ///
  /// For unset or cleared fields, returns null.
  /// Also returns null for unknown tag numbers.
  getFieldOrNull(int tagNumber) => _fieldValues[tagNumber];

  /// Returns the default value for the given field.
  ///
  /// For repeated fields, returns an immutable empty list
  /// (unlike [getField]). For all other fields, returns
  /// the same thing that getField() would for a cleared field.
  getDefaultForField(int tagNumber) {
    var value =  _callDefaultFunction(tagNumber);
    if (value is List) return _emptyList;
    return value;
  }

  _callDefaultFunction(int tagNumber) {
    MakeDefaultFunc f = info_.makeDefault(tagNumber);
    if (f != null) return f();

    var extension = _extensions[tagNumber];
    if (extension != null) return extension.makeDefault();

    throw new ArgumentError(
        "tag $tagNumber not defined in ${info_.messageName}");
  }

  /// Returns [:true:] if a value of [extension] is present.
  bool hasExtension(Extension extension) {
    _checkExtension(extension);
    return hasField(extension.tagNumber);
  }

  /// Returns [:true:] if this message has a field associated with [tagNumber].
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

  /// Merges the contents of the [other] into this message.
  ///
  /// Singular fields that are set in [other] overwrite the corresponding fields
  /// in this message. Repeated fields are appended. Singular sub-messages are
  /// recursively merged.
  void mergeFromMessage(GeneratedMessage other) {
    for (int tagNumber in other._fieldValues.keys) {
      var fieldValue = other._fieldValues[tagNumber];

      if (other._extensions.containsKey(tagNumber)) {
        _addExtensionToMap(other._extensions[tagNumber]);
      }
      int fieldType = other._getFieldType(tagNumber);
      var cloner = (x) => x;
      if ((fieldType & (FieldType._GROUP_BIT | FieldType._MESSAGE_BIT)) != 0) {
        cloner = (message) => message.clone();
      }
      if (_isRepeated(fieldType)) {
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

  /// Sets the value of a non-repeated extension field to [value].
  void setExtension(Extension extension, value) {
    _checkExtension(extension);
    _addExtensionToMap(extension);
    setField(extension.tagNumber, value, extension.type);
  }

  /// Sets the value of a given field by its [tagNumber].
  ///
  /// Throws an [:ArgumentError:] if [value] does not match the type
  /// associated with [tagNumber].
  ///
  /// Throws an [:ArgumentError:] if [value] is [:null:]. To clear a field of
  /// it's current value, use [clearField] instead.
  void setField(int tagNumber, value, [int fieldType = null]) {
    if (value == null) {
      throw new ArgumentError('value is null');
    }
    if (fieldType == null) {
      if (!info_.containsTagNumber(tagNumber)) {
        throw new ArgumentError('Unknown tag: $tagNumber');
      }
      fieldType = info_.fieldType(tagNumber);
    }
    if (_isRepeated(fieldType)) {
      throw new ArgumentError(_generateMessage(tagNumber, value,
          'repeating field (use get + .add())'));
    }

    // Validate type and range.
    _validate(tagNumber, fieldType, value);

    _setField(tagNumber, value);
  }

  void _setField(int tagNumber, value) {
    if (_hasObservers) {
      eventPlugin.beforeSetField(tagNumber, value);
    }
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

  /// Returns the type associated with [tagNumber].
  ///
  /// The type is discovered either from the [BuilderInfo] associated with this
  /// [GeneratedMessage], or from a known extension. If the type is unknown,
  /// [null] is returned.
  int _getFieldType(int tagNumber) {
    int type = info_.fieldType(tagNumber);
    if (type == null && _extensions.containsKey(tagNumber)) {
      type = _extensions[tagNumber].type;
    }
    return type;
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
    switch (FieldType._baseType(fieldType)) {
      case FieldType._BOOL_BIT:
        if (value is !bool) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type bool'));
        }
        break;
      case FieldType._BYTES_BIT:
        if (value is !List) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not List'));
        }
        break;
      case FieldType._STRING_BIT:
        if (value is !String) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type String'));
        }
        break;
      case FieldType._FLOAT_BIT:
        if (value is !double) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type double'));
        }
        if (!_isFloat32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for float'));
        }
        break;
      case FieldType._DOUBLE_BIT:
        if (value is !double) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type double'));
        }
        break;
      case FieldType._ENUM_BIT:
        if (value is !ProtobufEnum) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type ProtobufEnum'));
        }
        break;
      case FieldType._INT32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isSigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for int32'));
        }
        break;
      case FieldType._INT64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isSigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for int64'));
        }
        break;
      case FieldType._SINT32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isSigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for sint32'));
        }
        break;
      case FieldType._SINT64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isSigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for sint64'));
        }
        break;
      case FieldType._UINT32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isUnsigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for uint32'));
        }
        break;
      case FieldType._UINT64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isUnsigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for uint64'));
        }
        break;
      case FieldType._FIXED32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isUnsigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for fixed32'));
        }
        break;
      case FieldType._FIXED64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isUnsigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for fixed64'));
        }
        break;
      case FieldType._SFIXED32_BIT:
        if (value is !int) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not type int'));
        }
        if (!_isSigned32(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for sfixed32'));
        }
        break;
      case FieldType._SFIXED64_BIT:
        if (value is !Int64) {
          throw new ArgumentError(
              _generateMessage(tagNumber, value, 'not Int64'));
        }
        if (!_isSigned64(value)) {
          throw new ArgumentError(_generateMessage(tagNumber, value,
              'out of range for sfixed64'));
        }
        break;
      case FieldType._GROUP_BIT:
      case FieldType._MESSAGE_BIT:
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
