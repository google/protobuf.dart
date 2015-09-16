// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

typedef GeneratedMessage CreateBuilderFunc();
typedef Object MakeDefaultFunc();
typedef ProtobufEnum ValueOfFunc(int value);

abstract class GeneratedMessage {

  // Short names for use in generated code.
  // TODO(skybrian) remove once we're sure that all generated code
  // uses PbFieldType instead of GeneratedMessage for these constants.

  // _O_ptional.
  static const int OB = PbFieldType._OPTIONAL_BOOL;
  static const int OY = PbFieldType._OPTIONAL_BYTES;
  static const int OS = PbFieldType._OPTIONAL_STRING;
  static const int OF = PbFieldType._OPTIONAL_FLOAT;
  static const int OD = PbFieldType._OPTIONAL_DOUBLE;
  static const int OE = PbFieldType._OPTIONAL_ENUM;
  static const int OG = PbFieldType._OPTIONAL_GROUP;
  static const int O3 = PbFieldType._OPTIONAL_INT32;
  static const int O6 = PbFieldType._OPTIONAL_INT64;
  static const int OS3 = PbFieldType._OPTIONAL_SINT32;
  static const int OS6 = PbFieldType._OPTIONAL_SINT64;
  static const int OU3 = PbFieldType._OPTIONAL_UINT32;
  static const int OU6 = PbFieldType._OPTIONAL_UINT64;
  static const int OF3 = PbFieldType._OPTIONAL_FIXED32;
  static const int OF6 = PbFieldType._OPTIONAL_FIXED64;
  static const int OSF3 = PbFieldType._OPTIONAL_SFIXED32;
  static const int OSF6 = PbFieldType._OPTIONAL_SFIXED64;
  static const int OM = PbFieldType._OPTIONAL_MESSAGE;

  // re_Q_uired.
  static const int QB = PbFieldType._REQUIRED_BOOL;
  static const int QY = PbFieldType._REQUIRED_BYTES;
  static const int QS = PbFieldType._REQUIRED_STRING;
  static const int QF = PbFieldType._REQUIRED_FLOAT;
  static const int QD = PbFieldType._REQUIRED_DOUBLE;
  static const int QE = PbFieldType._REQUIRED_ENUM;
  static const int QG = PbFieldType._REQUIRED_GROUP;
  static const int Q3 = PbFieldType._REQUIRED_INT32;
  static const int Q6 = PbFieldType._REQUIRED_INT64;
  static const int QS3 = PbFieldType._REQUIRED_SINT32;
  static const int QS6 = PbFieldType._REQUIRED_SINT64;
  static const int QU3 = PbFieldType._REQUIRED_UINT32;
  static const int QU6 = PbFieldType._REQUIRED_UINT64;
  static const int QF3 = PbFieldType._REQUIRED_FIXED32;
  static const int QF6 = PbFieldType._REQUIRED_FIXED64;
  static const int QSF3 = PbFieldType._REQUIRED_SFIXED32;
  static const int QSF6 = PbFieldType._REQUIRED_SFIXED64;
  static const int QM = PbFieldType._REQUIRED_MESSAGE;

  // re_P_eated.
  static const int PB = PbFieldType._REPEATED_BOOL;
  static const int PY = PbFieldType._REPEATED_BYTES;
  static const int PS = PbFieldType._REPEATED_STRING;
  static const int PF = PbFieldType._REPEATED_FLOAT;
  static const int PD = PbFieldType._REPEATED_DOUBLE;
  static const int PE = PbFieldType._REPEATED_ENUM;
  static const int PG = PbFieldType._REPEATED_GROUP;
  static const int P3 = PbFieldType._REPEATED_INT32;
  static const int P6 = PbFieldType._REPEATED_INT64;
  static const int PS3 = PbFieldType._REPEATED_SINT32;
  static const int PS6 = PbFieldType._REPEATED_SINT64;
  static const int PU3 = PbFieldType._REPEATED_UINT32;
  static const int PU6 = PbFieldType._REPEATED_UINT64;
  static const int PF3 = PbFieldType._REPEATED_FIXED32;
  static const int PF6 = PbFieldType._REPEATED_FIXED64;
  static const int PSF3 = PbFieldType._REPEATED_SFIXED32;
  static const int PSF6 = PbFieldType._REPEATED_SFIXED64;
  static const int PM = PbFieldType._REPEATED_MESSAGE;

  // pac_K_ed.
  static const int KB = PbFieldType._PACKED_BOOL;
  static const int KE = PbFieldType._PACKED_ENUM;
  static const int KF = PbFieldType._PACKED_FLOAT;
  static const int KD = PbFieldType._PACKED_DOUBLE;
  static const int K3 = PbFieldType._PACKED_INT32;
  static const int K6 = PbFieldType._PACKED_INT64;
  static const int KS3 = PbFieldType._PACKED_SINT32;
  static const int KS6 = PbFieldType._PACKED_SINT64;
  static const int KU3 = PbFieldType._PACKED_UINT32;
  static const int KU6 = PbFieldType._PACKED_UINT64;
  static const int KF3 = PbFieldType._PACKED_FIXED32;
  static const int KF6 = PbFieldType._PACKED_FIXED64;
  static const int KSF3 = PbFieldType._PACKED_SFIXED32;
  static const int KSF6 = PbFieldType._PACKED_SFIXED64;

  // Range of integers in JSON (53-bit integers).
  static Int64 MAX_JSON_INT = new Int64.fromInts(0x200000, 0);
  static Int64 MIN_JSON_INT = -MAX_JSON_INT;

  final Map<int, dynamic> _fieldValues = new HashMap<int, dynamic>();

  Map<int, Extension> __extensions;
  Map<int, Extension> get _extensions {
    if (__extensions == null) __extensions = new HashMap<int, Extension>();
    return __extensions;
  }

  UnknownFieldSet _unknownFields;
  UnknownFieldSet get unknownFields {
    if (_unknownFields == null) _unknownFields = new UnknownFieldSet();
    return _unknownFields;
  }

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
    for (var fi in info_.fieldInfo.values) {
      var value = _fieldValues[fi.tagNumber];
      if (!fi._isInitialized(value)) return false;
    }
    return extensionsAreInitialized();
  }

  /// Adds the path to each uninitialized field to the list.
  void _appendInvalidFields(List<String> problems, String prefix) {
    for (var fi in info_.fieldInfo.values) {
      var value = _fieldValues[fi.tagNumber];
      fi._appendInvalidFields(problems, value, prefix);
    }
    // TODO(skybrian): search extensions as well
    // https://github.com/dart-lang/dart-protobuf/issues/46
  }

  /// Clears all data that was set in this message.
  ///
  /// After calling [clear], [getField] will still return default values for
  /// unset fields.
  void clear() {
    if (_unknownFields != null) {
      _unknownFields.clear();
    }

    if (_hasObservers) {
      for (int key in _fieldValues.keys) {
        var fi = _ensureFieldInfo(key);
        eventPlugin.beforeClearField(fi);
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
    if (_unknownFields == null || _unknownFields.isEmpty) {
      // Check if other unknown fields is logically empty.
      // (Don't create it unnecessarily.)
      if (o._unknownFields != null && o._unknownFields.isNotEmpty) return false;
    } else {
      // Check if the other unknown fields has the same fields.
      if (_unknownFields != o._unknownFields) return false;
    }

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
        var value = _fieldValues[tagNumber];
        if (value is List && value.isEmpty) {
          continue;  // It's either repeated or an empty byte array.
        }
        hash = ((37 * hash) + tagNumber) & 0x3fffffff;
        var fi = _ensureFieldInfo(tagNumber);
        if (!_isEnum(fi.type)) {
          // TODO(sgjesse): Remove 'as Object' here when issue 14951 is fixed.
          hash = ((53 * hash) + (value as Object).hashCode) & 0x3fffffff;
        } else if (fi.isRepeated) {
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
      _appendInvalidFields(invalidFields, "");
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
      var value = _fieldValues[tagNumber];
      var fi = _ensureFieldInfo(tagNumber);
      output.writeField(tagNumber, fi.type, value);
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

      FieldInfo fi = info_.fieldInfo[tagNumber];
      if (fi == null) {
        fi = extensionRegistry.getExtension(info_.messageName, tagNumber);
        if (fi != null) {
          _addExtensionToMap(fi);
        }
      }

      if (fi == null || !_wireTypeMatches(fi.type, wireType)) {
        if (!unknownFields.mergeFieldFromBuffer(tag, input)) {
          return;
        }
        continue;
      }

      // Ignore required/optional packed/unpacked.
      int fieldType = fi.type;
      fieldType &= ~(PbFieldType._PACKED_BIT | PbFieldType._REQUIRED_BIT);
      switch (fieldType) {
        case PbFieldType._OPTIONAL_BOOL:
          _setField(fi, input.readBool());
          break;
        case PbFieldType._OPTIONAL_BYTES:
          _setField(fi, input.readBytes());
          break;
        case PbFieldType._OPTIONAL_STRING:
          _setField(fi, input.readString());
          break;
        case PbFieldType._OPTIONAL_FLOAT:
          _setField(fi, input.readFloat());
          break;
        case PbFieldType._OPTIONAL_DOUBLE:
          _setField(fi, input.readDouble());
          break;
        case PbFieldType._OPTIONAL_ENUM:
          int rawValue = input.readEnum();
          var value = _getValueOfFunc(tagNumber, extensionRegistry)(rawValue);
          if (value == null) {
            unknownFields.mergeVarintField(tagNumber, new Int64(rawValue));
          } else {
            _setField(fi, value);
          }
          break;
        case PbFieldType._OPTIONAL_GROUP:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          if (_fieldValues.containsKey(tagNumber)) {
            subMessage.mergeFromMessage(getField(tagNumber));
          }
          input.readGroup(tagNumber, subMessage, extensionRegistry);
          _setField(fi, subMessage);
          break;
        case PbFieldType._OPTIONAL_INT32:
          _setField(fi, input.readInt32());
          break;
        case PbFieldType._OPTIONAL_INT64:
          _setField(fi, input.readInt64());
          break;
        case PbFieldType._OPTIONAL_SINT32:
          _setField(fi, input.readSint32());
          break;
        case PbFieldType._OPTIONAL_SINT64:
          _setField(fi, input.readSint64());
          break;
        case PbFieldType._OPTIONAL_UINT32:
          _setField(fi, input.readUint32());
          break;
        case PbFieldType._OPTIONAL_UINT64:
          _setField(fi, input.readUint64());
          break;
        case PbFieldType._OPTIONAL_FIXED32:
          _setField(fi, input.readFixed32());
          break;
        case PbFieldType._OPTIONAL_FIXED64:
          _setField(fi, input.readFixed64());
          break;
        case PbFieldType._OPTIONAL_SFIXED32:
          _setField(fi, input.readSfixed32());
          break;
        case PbFieldType._OPTIONAL_SFIXED64:
          _setField(fi, input.readSfixed64());
          break;
        case PbFieldType._OPTIONAL_MESSAGE:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          if (_fieldValues.containsKey(tagNumber)) {
            subMessage.mergeFromMessage(getField(tagNumber));
          }
          input.readMessage(subMessage, extensionRegistry);
          _setField(fi, subMessage);
          break;
        case PbFieldType._REPEATED_BOOL:
          readPackable(wireType, tagNumber, input.readBool);
          break;
        case PbFieldType._REPEATED_BYTES:
          appendToRepeated(tagNumber, input.readBytes());
          break;
        case PbFieldType._REPEATED_STRING:
          appendToRepeated(tagNumber, input.readString());
          break;
        case PbFieldType._REPEATED_FLOAT:
          readPackable(wireType, tagNumber, input.readFloat);
          break;
        case PbFieldType._REPEATED_DOUBLE:
          readPackable(wireType, tagNumber, input.readDouble);
          break;
        case PbFieldType._REPEATED_ENUM:
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
        case PbFieldType._REPEATED_GROUP:
          GeneratedMessage subMessage =
              _getEmptyMessage(tagNumber, extensionRegistry);
          input.readGroup(tagNumber, subMessage, extensionRegistry);
          appendToRepeated(tagNumber, subMessage);
          break;
        case PbFieldType._REPEATED_INT32:
          readPackable(wireType, tagNumber, input.readInt32);
          break;
        case PbFieldType._REPEATED_INT64:
          readPackable(wireType, tagNumber, input.readInt64);
          break;
        case PbFieldType._REPEATED_SINT32:
          readPackable(wireType, tagNumber, input.readSint32);
          break;
        case PbFieldType._REPEATED_SINT64:
          readPackable(wireType, tagNumber, input.readSint64);
          break;
        case PbFieldType._REPEATED_UINT32:
          readPackable(wireType, tagNumber, input.readUint32);
          break;
        case PbFieldType._REPEATED_UINT64:
          readPackable(wireType, tagNumber, input.readUint64);
          break;
        case PbFieldType._REPEATED_FIXED32:
          readPackable(wireType, tagNumber, input.readFixed32);
          break;
        case PbFieldType._REPEATED_FIXED64:
          readPackable(wireType, tagNumber, input.readFixed64);
          break;
        case PbFieldType._REPEATED_SFIXED32:
          readPackable(wireType, tagNumber, input.readSfixed32);
          break;
        case PbFieldType._REPEATED_SFIXED64:
          readPackable(wireType, tagNumber, input.readSfixed64);
          break;
        case PbFieldType._REPEATED_MESSAGE:
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
      int baseType = PbFieldType._baseType(fieldType);

      if (_isRepeated(fieldType)) {
        return new List.from(fieldValue.map((e) => convertToMap(e, baseType)));
      }

      switch (baseType) {
      case PbFieldType._BOOL_BIT:
      case PbFieldType._STRING_BIT:
      case PbFieldType._FLOAT_BIT:
      case PbFieldType._DOUBLE_BIT:
      case PbFieldType._INT32_BIT:
      case PbFieldType._SINT32_BIT:
      case PbFieldType._UINT32_BIT:
      case PbFieldType._FIXED32_BIT:
      case PbFieldType._SFIXED32_BIT:
        return fieldValue;
      case PbFieldType._BYTES_BIT:
        // Encode 'bytes' as a base64-encoded string.
        return CryptoUtils.bytesToBase64(fieldValue);
      case PbFieldType._ENUM_BIT:
        return fieldValue.value; // assume |value| < 2^52
      case PbFieldType._INT64_BIT:
      case PbFieldType._SINT64_BIT:
      case PbFieldType._UINT64_BIT:
      case PbFieldType._FIXED64_BIT:
      case PbFieldType._SFIXED64_BIT:
        // Use strings for 64-bit integers which cannot fit in doubles.
        if (MIN_JSON_INT <= fieldValue && fieldValue <= MAX_JSON_INT) {
          return fieldValue.toInt();
        }
        return fieldValue.toString();
      case PbFieldType._GROUP_BIT:
      case PbFieldType._MESSAGE_BIT:
        return fieldValue.writeToJsonMap();
      default:
        throw 'Unknown type $fieldType';
      }
    }

    var result = <String, dynamic>{};
    for (int tagNumber in sorted(_fieldValues.keys)) {
      var value = _fieldValues[tagNumber];
      if (value is List && value.isEmpty) {
        continue;  // It's either repeated or an empty byte array.
      }
      var fi = _ensureFieldInfo(tagNumber);
      result['$tagNumber'] = convertToMap(value, fi.type);
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
  void _mergeFromJsonMap(
      Map<String, dynamic> json, ExtensionRegistry registry) {
    for (String key in json.keys) {
      var fi = info_.byTagAsString[key];
      if (fi == null) {
        int tagNumber = int.parse(key);
        if (registry != null) {
          fi = registry.getExtension(info_.messageName, tagNumber);
        }
        if (fi == null) {
          // Unknown extensions can be skipped.
          continue;
        }
        _addExtensionToMap(fi);
      }
      if (fi.isRepeated) {
        _appendJsonList(json[key], fi, registry);
      } else {
        _setJsonField(json[key], fi, registry);
      }
    }
  }

  void _appendJsonList(List json, FieldInfo fi, ExtensionRegistry registry) {
    int tagNumber = fi.tagNumber;
    int type = fi.type;
    List repeated = getField(tagNumber);
    for (var value in json) {
      repeated.add(_convertJsonValue(value, tagNumber, type, registry));
    }
  }

  void _setJsonField(json, FieldInfo fi, ExtensionRegistry registry) {
    int tagNumber = fi.tagNumber;
    int type = fi.type;
    var value = _convertJsonValue(json, tagNumber, type, registry);
    _validate(tagNumber, type, value);
    _setField(fi, value);
  }

  _convertJsonValue(value, int tagNumber, int fieldType,
      ExtensionRegistry registry) {
    String expectedType; // for exception message
    switch (PbFieldType._baseType(fieldType)) {
      case PbFieldType._BOOL_BIT:
        if (value is bool) {
          return value;
        } else if (value is String) {
          if (value == 'true') {
            return true;
          } else if (value == 'false') {
            return false;
          }
        } else if (value is num) {
          if (value == 1) {
            return true;
          } else if (value == 0) {
            return false;
          }
        }
        expectedType = 'bool (true, false, "true", "false", 1, 0)';
        break;
      case PbFieldType._BYTES_BIT:
        if (value is String) {
          return CryptoUtils.base64StringToBytes(value);
        }
        expectedType = 'Base64 String';
        break;
      case PbFieldType._STRING_BIT:
        if (value is String) {
          return value;
        }
        expectedType = 'String';
        break;
      case PbFieldType._FLOAT_BIT:
      case PbFieldType._DOUBLE_BIT:
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
      case PbFieldType._ENUM_BIT:
        // Allow quoted values, although we don't emit them.
        if (value is String) {
          value = int.parse(value);
        }
        if (value is int) {
          return _getValueOfFunc(tagNumber, registry)(value);
        }
        expectedType = 'int or stringified int';
        break;
      case PbFieldType._INT32_BIT:
      case PbFieldType._SINT32_BIT:
      case PbFieldType._UINT32_BIT:
      case PbFieldType._FIXED32_BIT:
      case PbFieldType._SFIXED32_BIT:
        if (value is int) return value;
        if (value is String) return int.parse(value);
        expectedType = 'int or stringified int';
        break;
      case PbFieldType._INT64_BIT:
      case PbFieldType._SINT64_BIT:
      case PbFieldType._UINT64_BIT:
      case PbFieldType._FIXED64_BIT:
      case PbFieldType._SFIXED64_BIT:
        if (value is int) return new Int64(value);
        if (value is String) return Int64.parseRadix(value, 10);
        expectedType = 'int or stringified int';
        break;
      case PbFieldType._GROUP_BIT:
      case PbFieldType._MESSAGE_BIT:
        if (value is Map) {
          GeneratedMessage subMessage = _getEmptyMessage(tagNumber, registry);
          subMessage._mergeFromJsonMap(value, registry);
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
    _mergeFromJsonMap(JSON.decode(data), extensionRegistry);
  }

  /// Merges field values from a JSON object represented as a Dart map.
  ///
  /// The encoding is described in [GeneratedMessage.writeToJson].
  void mergeFromJsonMap(
      Map<String, dynamic> json,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    _mergeFromJsonMap(json, extensionRegistry);
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
      list = createRepeatedField(extension.tagNumber, extension);
      _addExtensionToMap(extension);
      _setField(extension, list);
    }

    list.add(value);
  }

  /// Clears an extension field and also removes the extension.
  void clearExtension(Extension extension) {
    _checkExtension(extension);
    if (_hasObservers) {
      eventPlugin.beforeClearField(extension);
    }
    _fieldValues.remove(extension.tagNumber);
    _extensions.remove(extension.tagNumber);
  }

  /// Clears the contents of a given field.
  ///
  /// If it's an extension field, the Extension will be kept.
  /// The tagNumber should be a valid tag or extension.
  void clearField(int tagNumber) {
    if (_hasObservers) {
      var fi = _ensureFieldInfo(tagNumber);
      eventPlugin.beforeClearField(fi);
    }
    // TODO(skybrian) enforce that FieldInfo exists when there are no observers?
    // For now this has no effect.
    _fieldValues.remove(tagNumber);
  }

  bool extensionsAreInitialized() {
    for (var extension in _extensions.values) {
      var value = _fieldValues[extension.tagNumber];
      if (!extension._isInitialized(value)) return false;
    }
    return true; // no problems found
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

    var fi = _ensureFieldInfo(tagNumber);
    if (fi.isRepeated) {
      return _getDefaultRepeatedField(tagNumber, fi);
    } else {
      return fi.makeDefault();
    }
  }

  /// Returns the FieldInfo for a tag (which may be an Extension).
  /// throws ArgumentException if there is no regular field or extension.
  FieldInfo _ensureFieldInfo(int tagNumber) {
    var fi = info_.fieldInfo[tagNumber];
    if (fi != null) return fi;
    fi = _extensions[tagNumber];
    if (fi != null) return fi;
    throw new ArgumentError(
        "tag $tagNumber not defined in ${info_.messageName}");
  }

  List _getDefaultRepeatedField(int tagNumber, FieldInfo fi) {
    // Automatically save the repeated field so that changes won't be lost.
    //
    // TODO(skybrian) we could avoid this by generating another
    // method for repeated fields:
    //
    //   msg.mutableFoo().add(123);
    //
    // Then msg.foo could return an immutable empty list by default.
    // But it doesn't seem urgent or worth the migration.
    var value = createRepeatedField(tagNumber, fi);
    _setField(fi, value);
    return value;
  }

  /// Creates List implementing a mutable repeated field.
  ///
  /// Mixins may override this method to change the List type. To ensure
  /// that the protobuf can be encoded correctly, the returned List must
  /// validate all items added to it. This can most easily be done
  /// using the FieldInfo.check function.
  List createRepeatedField(int tagNumber, FieldInfo fi) {
    if (fi.check != null) {
      // new way
      return new PbList(check: fi.check);
    } else {
      // old way; remove after all generated code is upgraded.
      return fi.makeDefault();
    }
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
  getDefaultForField(int tagNumber) =>
      _ensureFieldInfo(tagNumber).readonlyDefault;

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
      return false;  // It's either repeated or an empty byte array.
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

      // Don't allow regular fields to be overwritten by extensions.
      var fi = info_.fieldInfo[tagNumber];
      if (fi == null) {
        // This overrides any existing extension - is this okay?
        fi = other._extensions[tagNumber];
        if (fi != null) {
          _checkExtension(fi);
          _addExtensionToMap(fi);
        }
      }
      var otherType = other._ensureFieldInfo(tagNumber).type;
      var cloner = (x) => x;
      if (_isGroupOrMessage(otherType)) {
        cloner = (message) => message.clone();
      }
      if (fi.isRepeated) {
        getField(tagNumber).addAll(new List.from(fieldValue).map(cloner));
      } else {
        fieldValue = cloner(fieldValue);
        _validate(tagNumber, fi.type, fieldValue);
        _setField(fi, fieldValue);
      }
    }

    mergeUnknownFields(other.unknownFields);
  }

  void mergeUnknownFields(UnknownFieldSet unknownFieldSet) {
    unknownFields.mergeFromUnknownFieldSet(unknownFieldSet);
  }

  /// Sets the value of a non-repeated extension field to [value].
  void setExtension(Extension extension, value) {
    if (value == null) {
      throw new ArgumentError('value is null');
    } else if (_isRepeated(extension.type)) {
      throw new ArgumentError(_generateMessage(extension.tagNumber, value,
          'repeating field (use get + .add())'));
    }
    _checkExtension(extension);
    _addExtensionToMap(extension);
    _validate(extension.tagNumber, extension.type, value);
    _setField(extension, value);
  }

  /// Sets the value of a field by its [tagNumber].
  ///
  /// Throws an [:ArgumentError:] if [value] does not match the type
  /// associated with [tagNumber].
  ///
  /// Throws an [:ArgumentError:] if [value] is [:null:]. To clear a field of
  /// it's current value, use [clearField] instead.
  void setField(int tagNumber, value) {
    if (value == null) throw new ArgumentError('value is null');

    var fi = _ensureFieldInfo(tagNumber);
    if (fi.isRepeated) {
      throw new ArgumentError(_generateMessage(tagNumber, value,
          'repeating field (use get + .add())'));
    }

    // Validate type and range.
    _validate(tagNumber, fi.type, value);
    _setField(fi, value);
  }

  void _setField(FieldInfo fi, value) {
    assert(fi != null);
    if (_hasObservers) {
      eventPlugin.beforeSetField(fi, value);
    }
    _fieldValues[fi.tagNumber] = value;
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
    var message = _getFieldError(fieldType, value);
    if (message != null) {
      throw new ArgumentError(_generateMessage(tagNumber, value, message));
    }
  }
}
