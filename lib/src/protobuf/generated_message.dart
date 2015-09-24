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

  _FieldSet _fieldSet;

  UnknownFieldSet get unknownFields => _fieldSet._ensureUnknownFields();

  GeneratedMessage() {
    _fieldSet = new _FieldSet(this, info_, eventPlugin);
    if (eventPlugin != null) eventPlugin.attach(this);
  }

  GeneratedMessage.fromBuffer(
      List<int> input, ExtensionRegistry extensionRegistry) {
    _fieldSet = new _FieldSet(this, info_, eventPlugin);
    if (eventPlugin != null) eventPlugin.attach(this);
    mergeFromBuffer(input, extensionRegistry);
  }

  GeneratedMessage.fromJson(String input, ExtensionRegistry extensionRegistry) {
    _fieldSet = new _FieldSet(this, info_, eventPlugin);
    if (eventPlugin != null) eventPlugin.attach(this);
    mergeFromJson(input, extensionRegistry);
  }

  /// Subclasses can override this getter to be notified of changes
  /// to protobuf fields.
  EventPlugin get eventPlugin => null;

  bool get _isReadOnly => false;

  bool hasRequiredFields() => info_.hasRequiredFields;

  /// Returns [:true:] if all required fields in the message and all embedded
  /// messages are set, false otherwise.
  bool isInitialized() => _fieldSet._hasRequiredValues();

  /// Clears all data that was set in this message.
  ///
  /// After calling [clear], [getField] will still return default values for
  /// unset fields.
  void clear() => _fieldSet._clear();

  // TODO(antonm): move to getters.
  int getTagNumber(String fieldName) => info_.tagNumber(fieldName);

  bool operator ==(other) {
    if (other is! GeneratedMessage) return false;
    return _fieldSet._equals(other._fieldSet);
  }

  /// Calculates a hash code based on the contents of the protobuf.
  ///
  /// The hash may change when any field changes (recursively).
  /// Therefore, protobufs used as map keys shouldn't be changed.
  int get hashCode => _fieldSet._hashCode;

  /// Returns a String representation of this message.
  ///
  /// This representation is similar to, but not quite, the Protocol Buffer
  /// TextFormat. Each field is printed on its own line. Sub-messages are
  /// indented two spaces farther than their parent messages.
  ///
  /// Note that this format is absolutely subject to change, and should only
  /// ever be used for debugging.
  String toString() {
    var out = new StringBuffer();
    _fieldSet.writeString(out, '');
    return out.toString();
  }

  void check() {
    if (!isInitialized()) {
      List<String> invalidFields = <String>[];
      _fieldSet._appendInvalidFields(invalidFields, "");
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

  void writeToCodedBufferWriter(CodedBufferWriter output) =>
      _writeToCodedBufferWriter(_fieldSet, output);

  void mergeFromCodedBufferReader(CodedBufferReader input,
          [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) =>
      _mergeFromCodedBufferReader(_fieldSet, input, extensionRegistry);

  /// Merges serialized protocol buffer data into this message.
  ///
  /// For each field in [input] that is already present in this message:
  ///
  /// * If it's a repeated field, this appends to the end of our list.
  /// * Else, if it's a scalar, this overwrites our field.
  /// * Else, (it's a non-repeated sub-message), this recursively merges into
  ///   the existing sub-message.
  void mergeFromBuffer(List<int> input,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    CodedBufferReader codedInput = new CodedBufferReader(input);
    _mergeFromCodedBufferReader(_fieldSet, codedInput, extensionRegistry);
    codedInput.checkLastTagWas(0);
  }

  // JSON support.

  /// Returns the JSON encoding of this message as a Dart [Map].
  ///
  /// The encoding is described in [GeneratedMessage.writeToJson].
  Map<String, dynamic> writeToJsonMap() => _writeToJsonMap(_fieldSet);

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

  /// Merges field values from [data], a JSON object, encoded as described by
  /// [GeneratedMessage.writeToJson].
  void mergeFromJson(String data,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    /// Disable lazy creation of Dart objects for a dart2js speedup.
    /// This is a slight regression on the Dart VM.
    /// TODO(skybrian) we could skip the reviver if we're running
    /// on the Dart VM for a slight speedup.
    var jsonMap = JSON.decode(data, reviver: _emptyReviver);
    _mergeFromJsonMap(_fieldSet, jsonMap, extensionRegistry);
  }

  static _emptyReviver(k, v) => v;

  /// Merges field values from a JSON object represented as a Dart map.
  ///
  /// The encoding is described in [GeneratedMessage.writeToJson].
  void mergeFromJsonMap(Map<String, dynamic> json,
      [ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY]) {
    _mergeFromJsonMap(_fieldSet, json, extensionRegistry);
  }

  /// Adds an extension field value to a repeated field.
  ///
  /// The backing [List] will be created if necessary.
  /// If the list already exists, the old extension won't be overwritten.
  void addExtension(Extension extension, var value) {
    if (!extension.isRepeated) {
      throw new ArgumentError(
          'Cannot add to a non-repeated field (use setExtension())');
    }
    _fieldSet._ensureExtensions().._ensureRepeatedField(extension).add(value);
  }

  /// Clears an extension field and also removes the extension.
  void clearExtension(Extension extension) {
    if (_fieldSet._hasExtensions) {
      _fieldSet._extensions._clearFieldAndInfo(extension);
    }
  }

  /// Clears the contents of a given field.
  ///
  /// If it's an extension field, the Extension will be kept.
  /// The tagNumber should be a valid tag or extension.
  void clearField(int tagNumber) => _fieldSet._clearField(tagNumber);

  bool extensionsAreInitialized() => _fieldSet._hasRequiredExtensionValues();

  /// Returns the value of [extension].
  ///
  /// If not set, returns the extension's default value.
  getExtension(Extension extension) {
    if (_isReadOnly) return extension.readonlyDefault;
    return _fieldSet._ensureExtensions()._getFieldOrDefault(extension);
  }

  /// Returns the value of the field associated with [tagNumber], or the
  /// default value if it is not set.
  getField(int tagNumber) => _fieldSet._getField(tagNumber);

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
  getFieldOrNull(int tagNumber) => _fieldSet._getFieldOrNullByTag(tagNumber);

  /// Returns the default value for the given field.
  ///
  /// For repeated fields, returns an immutable empty list
  /// (unlike [getField]). For all other fields, returns
  /// the same thing that getField() would for a cleared field.
  getDefaultForField(int tagNumber) =>
      _fieldSet._ensureInfo(tagNumber).readonlyDefault;

  /// Returns [:true:] if a value of [extension] is present.
  bool hasExtension(Extension extension) => _fieldSet._hasExtensions &&
      _fieldSet._extensions._getFieldOrNull(extension) != null;

  /// Returns [:true:] if this message has a field associated with [tagNumber].
  bool hasField(int tagNumber) => _fieldSet._hasField(tagNumber);

  /// Merges the contents of the [other] into this message.
  ///
  /// Singular fields that are set in [other] overwrite the corresponding fields
  /// in this message. Repeated fields are appended. Singular sub-messages are
  /// recursively merged.
  void mergeFromMessage(GeneratedMessage other) =>
      _fieldSet._mergeFromMessage(other._fieldSet);

  void mergeUnknownFields(UnknownFieldSet unknownFieldSet) => _fieldSet
      ._ensureUnknownFields()
      .mergeFromUnknownFieldSet(unknownFieldSet);

  /// Sets the value of a non-repeated extension field to [value].
  void setExtension(Extension extension, value) {
    if (value == null) throw new ArgumentError('value is null');
    if (_isRepeated(extension.type)) {
      throw new ArgumentError(_fieldSet._setFieldFailedMessage(
          extension, value, 'repeating field (use get + .add())'));
    }
    _fieldSet._ensureExtensions()._setFieldAndInfo(extension, value);
  }

  /// Sets the value of a field by its [tagNumber].
  ///
  /// Throws an [:ArgumentError:] if [value] does not match the type
  /// associated with [tagNumber].
  ///
  /// Throws an [:ArgumentError:] if [value] is [:null:]. To clear a field of
  /// it's current value, use [clearField] instead.
  void setField(int tagNumber, value) => _fieldSet._setField(tagNumber, value);
}
