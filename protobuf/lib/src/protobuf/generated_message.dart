// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names

part of 'internal.dart';

/// Type of an empty message builder.
typedef CreateBuilderFunc = GeneratedMessage Function();

/// Type of a function that creates the default value of a protobuf field.
typedef MakeDefaultFunc = Function();

/// Type of a function that makes an enum integer value to corresponding
/// [ProtobufEnum] value.
typedef ValueOfFunc = ProtobufEnum? Function(int value);

/// The base class for all protobuf message types.
///
/// The protoc plugin generates subclasses providing type-specific properties
/// and methods.
///
/// Public properties and methods added here should also be added to
/// `GeneratedMessage_reservedNames` and should be unlikely to be used in a
/// proto file.
abstract class GeneratedMessage {
  FieldSet? __fieldSet;

  @pragma('dart2js:tryInline')
  FieldSet get _fieldSet => __fieldSet!;

  GeneratedMessage() {
    __fieldSet = FieldSet(this, info_);

    // The following two returns confuse dart2js into avoiding inlining the
    // constructor *body*. A `@pragma('dart2js:never-inline')` annotation on
    // the constructor affects inlining of the generative constructor factory,
    // not the constructor body that is called from all the subclasses.
    //
    // TODO(http://dartbug.com/49475): Remove this when there is an annotation
    // that will give the desired result.
    return;
    return; // ignore: dead_code
  }

  // Overridden by subclasses.
  BuilderInfo get info_;

  /// Creates a deep copy of the fields in this message.
  /// (The generated code uses [mergeFromMessage].)
  @Deprecated(
    'Using this can add significant size overhead to your binary. '
    'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
    'Will be removed in next major version',
  )
  GeneratedMessage clone();

  /// Creates an empty instance of the same message type as this.
  ///
  /// This method is useful when you have a value of type [GeneratedMessage] or
  /// `T extends GeneratedMessage` and you want a new empty message with the
  /// same message type as the value. If you know the actual message type, it's
  /// more direct to use the constructor, and this method creates the same
  /// message as the message's constructor.
  GeneratedMessage createEmptyInstance();

  UnknownFieldSet get unknownFields => _fieldSet._ensureUnknownFields();

  /// Make this message read-only.
  ///
  /// Marks this message, and any sub-messages, as read-only.
  GeneratedMessage freeze() {
    _fieldSet._markReadOnly();
    return this;
  }

  /// Returns `true` if this message is marked read-only. Otherwise `false`.
  ///
  /// Even when `false`, some sub-message could be read-only.
  ///
  /// If `true` all sub-messages are frozen.
  bool get isFrozen => _fieldSet._isReadOnly;

  /// Creates a writable, shallow copy of this message.
  ///
  /// Sub messages will be shared with this message and will still be frozen if
  /// this message is frozen.
  ///
  /// The lists representing repeated fields are copied. But their elements will
  /// be shared with the corresponding list in `this`.
  ///
  /// Similarly for map fields, the maps will be copied, but share the elements.
  GeneratedMessage toBuilder() {
    final result = createEmptyInstance();
    result._fieldSet._shallowCopyValues(_fieldSet);
    return result;
  }

  /// Apply [updates] to a copy of this message.
  ///
  /// Makes a writable shallow copy of this message, applies the [updates] to
  /// it, and marks the copy read-only before returning it.
  @Deprecated(
    'Using this can add significant size overhead to your binary. '
    'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
    'Will be removed in next major version',
  )
  GeneratedMessage copyWith(void Function(GeneratedMessage) updates) {
    final builder = toBuilder();
    updates(builder);
    return builder.freeze();
  }

  /// Whether the message has required fields.
  ///
  /// Note that proto3 doesn't have required fields, only proto2 does.
  bool hasRequiredFields() => info_.hasRequiredFields;

  /// Whether all required fields in the message and embedded messages are set.
  bool isInitialized() => _fieldSet._hasRequiredValues();

  /// Clears all data that was set in this message.
  ///
  /// After calling [clear], [getField] will still return default values for
  /// unset fields.
  void clear() => _fieldSet._clear();

  int? getTagNumber(String fieldName) => info_.tagNumber(fieldName);

  @override
  bool operator ==(Object other) {
    if (identical(this, other)) return true;
    return other is GeneratedMessage && _fieldSet._equals(other._fieldSet);
  }

  /// Calculates a hash code based on the contents of the protobuf.
  ///
  /// The hash may change when any field changes (recursively).
  /// Therefore, protobufs used as map keys shouldn't be changed.
  @override
  int get hashCode => _fieldSet._hashCode;

  /// Returns a [String] representation of this message.
  ///
  /// This representation is similar to, but not quite, the Protocol Buffer
  /// TextFormat. Each field is printed on its own line. Sub-messages are
  /// indented two spaces farther than their parent messages.
  ///
  /// Note that this format is absolutely subject to change, and should only
  /// ever be used for debugging.
  @override
  String toString() => toDebugString();

  /// Returns a [String] representation of this message.
  ///
  /// This generates the same output as [toString], but can be used by mixins
  /// to compose debug strings with additional information.
  String toDebugString() {
    final out = StringBuffer();
    _fieldSet.writeString(out, '');
    return out.toString();
  }

  /// Throws a [StateError] if the message has required fields without a value.
  ///
  /// This library does not check in any of the methods that required fields in
  /// have values. Use this method if you need to check that required fields
  /// have values.
  void check() {
    if (!isInitialized()) {
      final invalidFields = <String>[];
      _fieldSet._appendInvalidFields(invalidFields, '');
      final missingFields = (invalidFields..sort()).join(', ');
      throw StateError('Message missing required fields: $missingFields');
    }
  }

  /// Serialize the message as the protobuf binary format.
  ///
  /// Unknown field data, data for which there is no metadata for the associated
  /// field, will only be included if this message was deserialized from the
  /// same wire format.
  Uint8List writeToBuffer() {
    final out = CodedBufferWriter();
    writeToCodedBufferWriter(out);
    return out.toBuffer();
  }

  /// Same as [writeToBuffer], but serializes to the given [CodedBufferWriter].
  void writeToCodedBufferWriter(CodedBufferWriter output) =>
      _writeToCodedBufferWriter(_fieldSet, output);

  /// Same as [mergeFromBuffer], but takes a [CodedBufferReader] input.
  void mergeFromCodedBufferReader(
    CodedBufferReader input, [
    ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY,
  ]) {
    final meta = _fieldSet._meta;
    _mergeFromCodedBufferReader(meta, _fieldSet, input, extensionRegistry);
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
    List<int> input, [
    ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY,
  ]) {
    final codedInput = CodedBufferReader(input);
    final meta = _fieldSet._meta;
    _mergeFromCodedBufferReader(meta, _fieldSet, codedInput, extensionRegistry);
    codedInput.checkLastTagWas(0);
  }

  // JSON support.

  /// Returns the JSON encoding of this message as a Dart [Map].
  ///
  /// The encoding is described in [GeneratedMessage.writeToJson].
  ///
  /// Unknown field data, data for which there is no metadata for the associated
  /// field, will only be included if this message was deserialized from the
  /// same wire format.
  Map<String, dynamic> writeToJsonMap() => json_lib.writeToJsonMap(_fieldSet);

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
  ///
  /// For the proto3 JSON format use: [toProto3Json].
  ///
  /// Unknown field data, data for which there is no metadata for the associated
  /// field, will only be included if this message was deserialized from the
  /// same wire format.
  String writeToJson() => json_lib.writeToJsonString(_fieldSet);

  /// Returns an Object representing Proto3 JSON serialization of `this`.
  ///
  /// The key for each field is be the camel-cased name of the field.
  ///
  /// Well-known types and their special JSON encoding are supported.
  /// If a well-known type cannot be encoded (eg. a `google.protobuf.Timestamp`
  /// with negative `nanoseconds`) an error is thrown.
  ///
  /// Extensions and unknown fields are not encoded.
  ///
  /// The [typeRegistry] is be used for encoding `Any` messages. If an `Any`
  /// message encoding a type not in [typeRegistry] is encountered, an
  /// error is thrown.
  ///
  /// Unknown field data, data for which there is no metadata for the associated
  /// field, will not be included.
  Object? toProto3Json({
    TypeRegistry typeRegistry = const TypeRegistry.empty(),
  }) => _writeToProto3Json(_fieldSet, typeRegistry);

  /// Merges field values from [json], a JSON object using proto3 encoding.
  ///
  /// Well-known types and their special JSON encodings are supported.
  ///
  /// Throws [FormatException] if [ignoreUnknownFields] is `false` (the
  /// default) and an unknown field or enum name is encountered. Otherwise the
  /// unknown field or enum is ignored.
  ///
  /// If [supportNamesWithUnderscores] is `true` (the default) field names in
  /// the JSON can be represented as either camel-case JSON-names or names with
  /// underscores. Otherwise only the JSON names are supported.
  ///
  /// If [permissiveEnums] is `true` (default `false`) enum values in the JSON
  /// will be matched without case insensitivity and ignoring `-`s and `_`s.
  /// This allows JSON values like `camelCase` and `kebab-case` to match the
  /// enum values `CAMEL_CASE` and `KEBAB_CASE`.
  ///
  /// In case of ambiguities between the enum values, the first matching value
  /// will be used.
  ///
  /// The [typeRegistry] is used for decoding `Any` messages.
  ///
  /// Throws [FormatException] if an `Any` message type is not in
  /// [typeRegistry].
  ///
  /// Throws [FormatException] if the JSON not formatted correctly (a String
  /// where a number was expected etc.).
  void mergeFromProto3Json(
    Object? json, {
    TypeRegistry typeRegistry = const TypeRegistry.empty(),
    bool ignoreUnknownFields = false,
    bool supportNamesWithUnderscores = true,
    bool permissiveEnums = false,
  }) => _mergeFromProto3Json(
    json,
    _fieldSet,
    typeRegistry,
    ignoreUnknownFields,
    supportNamesWithUnderscores,
    permissiveEnums,
  );

  /// Merges field values from [data], a JSON object, encoded as described by
  /// [GeneratedMessage.writeToJson].
  ///
  /// For the proto3 JSON format use: [mergeFromProto3Json].
  void mergeFromJson(
    String data, [
    ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY,
  ]) {
    json_lib.mergeFromJsonString(_fieldSet, data, extensionRegistry);
  }

  /// Merges field values from a JSON object represented as a Dart map.
  ///
  /// The encoding is described in [GeneratedMessage.writeToJson].
  void mergeFromJsonMap(
    Map<String, dynamic> json, [
    ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY,
  ]) {
    json_lib.mergeFromJsonMap(_fieldSet, json, extensionRegistry);
  }

  /// Adds an extension field value to a repeated field.
  ///
  /// The backing [List] will be created if necessary.
  /// If the list already exists, the old extension won't be overwritten.
  void addExtension(Extension extension, Object? value) {
    if (!extension.isRepeated) {
      throw ArgumentError(
        'Cannot add to a non-repeated field (use setExtension())',
      );
    }
    _fieldSet._ensureExtensions()._ensureRepeatedField(extension).add(value);
  }

  /// Clears an extension field and also removes the extension.
  void clearExtension(Extension extension) {
    _fieldSet._extensions?._clearFieldAndInfo(extension);
  }

  /// Clears the contents of a given field.
  ///
  /// If it's an extension field, the Extension will be kept.
  /// The tagNumber should be a valid tag or extension.
  void clearField(int tagNumber) => _fieldSet._clearField(tagNumber);

  /// For generated code only.
  /// @nodoc
  int $_whichOneof(int oneofIndex) => _fieldSet._oneofCases![oneofIndex] ?? 0;

  bool extensionsAreInitialized() => _fieldSet._hasRequiredExtensionValues();

  /// Returns the value of [extension].
  ///
  /// If not set, returns the extension's default value.
  dynamic getExtension(Extension extension) =>
      _fieldSet._ensureExtensions()._getFieldOrDefault(extension);

  /// Returns the value of the field associated with [tagNumber], or the
  /// default value if it is not set.
  dynamic getField(int tagNumber) => _fieldSet._getField(tagNumber);

  /// Returns the value of a field, ignoring any defaults.
  ///
  /// For unset or cleared fields, returns null.
  /// Also returns null for unknown tag numbers.
  dynamic getFieldOrNull(int tagNumber) =>
      _fieldSet._getFieldOrNullByTag(tagNumber);

  /// Returns the default value for the given field.
  ///
  /// For repeated fields, returns an immutable empty list
  /// (unlike [getField]). For all other fields, returns
  /// the same thing that getField() would for a cleared field.
  dynamic getDefaultForField(int tagNumber) =>
      _fieldSet._ensureInfo(tagNumber).readonlyDefault;

  /// Returns `true` if a value of [extension] is present.
  bool hasExtension(Extension extension) =>
      _fieldSet._extensions?._getFieldOrNull(extension) != null;

  /// Whether this message has a field associated with [tagNumber].
  bool hasField(int tagNumber) => _fieldSet._hasField(tagNumber);

  /// Merges the contents of the [other] into this message.
  ///
  /// Singular fields that are set in [other] overwrite the corresponding fields
  /// in this message. Repeated fields are appended. Singular sub-messages are
  /// recursively merged.
  @pragma('dart2js:noInline')
  void mergeFromMessage(GeneratedMessage other) =>
      _fieldSet._mergeFromMessage(other._fieldSet);

  void mergeUnknownFields(UnknownFieldSet unknownFieldSet) => _fieldSet
      ._ensureUnknownFields()
      .mergeFromUnknownFieldSet(unknownFieldSet);

  /// Sets the value of a non-repeated extension field to [value].
  void setExtension(Extension extension, Object value) {
    if (PbFieldType.isRepeated(extension.type)) {
      throw ArgumentError(
        _fieldSet._setFieldFailedMessage(
          extension,
          value,
          'repeating field (use get + .add())',
        ),
      );
    }
    _fieldSet._ensureExtensions()._setFieldAndInfo(extension, value);
  }

  /// Sets the value of a field by its [tagNumber].
  ///
  /// Throws an [ArgumentError] if [value] does not match the type associated
  /// with [tagNumber].
  ///
  /// Throws an [ArgumentError] if [value] is `null`.
  ///
  /// To clear a field of it's current value, use [clearField] instead.
  @pragma('dart2js:noInline')
  void setField(int tagNumber, Object value) {
    _fieldSet._setField(tagNumber, value);
  }

  /// For generated code only.
  /// @nodoc
  T $_get<T>(int index, T defaultValue) =>
      _fieldSet._$get<T>(index, defaultValue);

  /// For generated code only.
  /// @nodoc
  T $_getN<T>(int index) => _fieldSet._$getND(index);

  /// For generated code only.
  /// @nodoc
  T $_ensure<T>(int index) => _fieldSet._$ensure<T>(index);

  /// For generated code only.
  /// @nodoc
  PbList<T> $_getList<T>(int index) => _fieldSet._$getList<T>(index);

  /// For generated code only.
  /// @nodoc
  PbMap<K, V> $_getMap<K, V>(int index) =>
      _fieldSet._$getMap<K, V>(this, index);

  /// For generated code only.
  /// @nodoc
  bool $_getB(int index, bool defaultValue) =>
      _fieldSet._$getB(index, defaultValue);

  /// For generated code only.
  /// @nodoc
  bool $_getBF(int index) => _fieldSet._$getBF(index);

  /// For generated code only.
  /// @nodoc
  int $_getI(int index, int defaultValue) =>
      _fieldSet._$getI(index, defaultValue);

  /// For generated code only.
  /// @nodoc
  int $_getIZ(int index) => _fieldSet._$getIZ(index);

  /// For generated code only.
  /// @nodoc
  String $_getS(int index, String defaultValue) =>
      _fieldSet._$getS(index, defaultValue);

  /// For generated code only.
  /// @nodoc
  String $_getSZ(int index) => _fieldSet._$getSZ(index);

  /// For generated code only.
  /// @nodoc
  Int64 $_getI64(int index) => _fieldSet._$getI64(index);

  /// For generated code only.
  /// @nodoc
  bool $_has(int index) => _fieldSet._$has(index);

  /// For generated code only.
  /// @nodoc
  void $_setBool(int index, bool value) => _fieldSet._$set(index, value);

  /// For generated code only.
  /// @nodoc
  void $_setBytes(int index, List<int> value) => _fieldSet._$set(index, value);

  /// For generated code only.
  /// @nodoc
  void $_setString(int index, String value) => _fieldSet._$set(index, value);

  /// For generated code only.
  /// @nodoc
  void $_setFloat(int index, double value) {
    if (!_isFloat32(value)) {
      _fieldSet._$check(index, value);
    }
    _fieldSet._$set(index, value);
  }

  /// For generated code only.
  /// @nodoc
  void $_setDouble(int index, double value) => _fieldSet._$set(index, value);

  /// For generated code only.
  /// @nodoc
  void $_setSignedInt32(int index, int value) {
    if (!_isSigned32(value)) {
      _fieldSet._$check(index, value);
    }
    _fieldSet._$set(index, value);
  }

  /// For generated code only.
  /// @nodoc
  void $_setUnsignedInt32(int index, int value) {
    if (!_isUnsigned32(value)) {
      _fieldSet._$check(index, value);
    }
    _fieldSet._$set(index, value);
  }

  /// For generated code only.
  /// @nodoc
  void $_setInt64(int index, Int64 value) => _fieldSet._$set(index, value);

  /// For generated code only. Separate from [setField] to distinguish
  /// reflective accesses.
  /// @nodoc
  void $_setField(int tagNumber, Object value) =>
      _fieldSet._setField(tagNumber, value);

  /// For generated code only. Separate from [clearField] to distinguish
  /// reflective accesses.
  /// @nodoc
  void $_clearField(int tagNumber) => _fieldSet._clearField(tagNumber);

  // Support for generating a read-only default singleton instance.

  static final Map<Function?, _SingletonMaker<GeneratedMessage>>
  _defaultMakers = {};

  static T Function() _defaultMakerFor<T extends GeneratedMessage>(
    T Function()? createFn,
  ) => _getSingletonMaker(createFn!)._frozenSingletonCreator;

  /// For generated code only.
  /// @nodoc
  static T $_defaultFor<T extends GeneratedMessage>(T Function() createFn) =>
      _getSingletonMaker(createFn)._frozenSingleton;

  static _SingletonMaker<T> _getSingletonMaker<T extends GeneratedMessage>(
    T Function() fun,
  ) {
    final oldMaker = _defaultMakers[fun];
    if (oldMaker != null) {
      // The CFE will insert an implicit downcast to `_SingletonMaker<T>`. We
      // avoid making that explicit because implicit downcasts are avoided by
      // dart2js in production code.
      return oldMaker as dynamic;
    }
    return _defaultMakers[fun] = _SingletonMaker<T>(fun);
  }
}

// We use a class that creates singletones instead of a closure function. We do
// so because the result of the lookup in [_defaultMakers] has to be downcasted.
// A downcast to a generic interface type is much easier to perform at runtime
// than a downcast to a generic function type.
class _SingletonMaker<T extends GeneratedMessage> {
  final T Function() _creator;

  _SingletonMaker(this._creator);

  late final T _frozenSingleton = _creator()..freeze();
  // ignore: prefer_function_declarations_over_variables
  late final T Function() _frozenSingletonCreator = () => _frozenSingleton;
}

/// The package name of a protobuf message.
class PackageName {
  final String name;

  const PackageName(this.name);

  String get prefix => name == '' ? '' : '$name.';
}

/// Extensions on [GeneratedMessage]s.
extension GeneratedMessageGenericExtensions<T extends GeneratedMessage> on T {
  /// Apply [updates] to a copy of this message.
  ///
  /// Throws an [ArgumentError] if `this` is not already frozen.
  ///
  /// Makes a writable shallow copy of this message, applies the [updates] to
  /// it, and marks the copy read-only before returning it.
  @UseResult(
    '[GeneratedMessageGenericExtensions.rebuild] '
    'does not update the message, returns a new message',
  )
  T rebuild(void Function(T) updates) {
    if (!isFrozen) {
      throw ArgumentError('Rebuilding only works on frozen messages.');
    }
    final t = toBuilder();
    updates(t as T);
    return t..freeze();
  }

  /// Returns a writable deep copy of this message.
  @UseResult(
    '[GeneratedMessageGenericExtensions.deepCopy] '
    'does not update the message, returns a new message',
  )
  T deepCopy() => info_.createEmptyInstance!() as T..mergeFromMessage(this);
}

extension GeneratedMessageInternalExtension on GeneratedMessage {
  FieldSet get fieldSet => _fieldSet;
}
