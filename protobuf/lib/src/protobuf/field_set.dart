// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../protobuf.dart';

void _throwFrozenMessageModificationError(String messageName,
    [String? methodName]) {
  if (methodName != null) {
    throw UnsupportedError(
        'Attempted to call $methodName on a read-only message ($messageName)');
  }
  throw UnsupportedError(
      'Attempted to change a read-only message ($messageName)');
}

/// All the data in a [GeneratedMessage].
///
/// These fields and methods are in a separate class to avoid polymorphic
/// access due to inheritance. This turns out to be faster when compiled to
/// JavaScript.
class _FieldSet {
  final GeneratedMessage? _message;
  final EventPlugin? _eventPlugin;

  /// The value of each non-extension field in a fixed-length array.
  /// The index of a field can be found in [FieldInfo.index].
  /// A null entry indicates that the field has no value.
  final List _values;

  /// Contains all the extension fields, or null if there aren't any.
  _ExtensionFieldSet? _extensions;

  /// Contains all the unknown fields, or null if there aren't any.
  UnknownFieldSet? _unknownFields;

  /// Encodes whether `this` has been frozen, and if so, also memoizes the
  /// hash code.
  ///
  /// Will always be a `bool` or `int`.
  ///
  /// If the message is mutable: `false`
  /// If the message is frozen and no hash code has been computed: `true`
  /// If the message is frozen and a hash code has been computed: the hash
  /// code as an `int`.
  Object _frozenState = false;

  /// The [BuilderInfo] for the [GeneratedMessage] this [_FieldSet] belongs to.
  ///
  /// WARNING: Avoid calling this for any performance critical code, instead
  /// obtain the [BuilderInfo] on the call site.
  BuilderInfo get _meta => _message!.info_;

  /// Returns the value of [_frozenState] as if it were a boolean indicator
  /// for whether `this` is read-only (has been frozen).
  ///
  /// If the value is not a `bool`, then it must contain the memoized hash code
  /// value, in which case the proto must be read-only.
  bool get _isReadOnly => _frozenState is! bool || _frozenState as bool;

  /// Returns the value of [_frozenState] if it contains the pre-computed value
  /// of the hashCode for the frozen field sets.
  ///
  /// Computing the hashCode of a proto object can be very expensive for large
  /// protos. Frozen protos don't allow any mutations, which means the contents
  /// of the field set should be stable.
  ///
  /// If [_frozenState] contains a boolean, the hashCode hasn't been memoized,
  /// so it will return null.
  int? get _memoizedHashCode =>
      _frozenState is int ? _frozenState as int : null;

  /// Maps a `oneof` field index to the tag number which is currently set. If
  /// the index is not present, the oneof field is unset.
  final Map<int, int>? _oneofCases;

  _FieldSet(this._message, BuilderInfo meta, this._eventPlugin)
      : _values = _makeValueList(meta.byIndex.length),
        _oneofCases = meta.oneofs.isEmpty ? null : <int, int>{};

  static List _makeValueList(int length) {
    if (length == 0) return _zeroList;
    return List.filled(length, null, growable: false);
  }

  // Use `List.filled` and not a `[]` to ensure that `_values` always has the
  // same implementation type.
  static final List _zeroList = List.filled(0, null, growable: false);

  // Metadata about multiple fields

  String get _messageName => _meta.qualifiedMessageName;
  bool get _hasRequiredFields => _meta.hasRequiredFields;

  /// The FieldInfo for each non-extension field.
  Iterable<FieldInfo> get _infos => _meta.fieldInfo.values;

  /// The FieldInfo for each non-extension field in tag order.
  Iterable<FieldInfo> get _infosSortedByTag => _meta.sortedByTag;

  _ExtensionFieldSet _ensureExtensions() =>
      _extensions ??= _ExtensionFieldSet(this);

  UnknownFieldSet _ensureUnknownFields() {
    if (_unknownFields == null) {
      if (_isReadOnly) return UnknownFieldSet.emptyUnknownFieldSet;
      _unknownFields = UnknownFieldSet();
    }
    return _unknownFields!;
  }

  // Metadata about single fields

  /// Returns FieldInfo for a non-extension field, or null if not found.
  FieldInfo? _nonExtensionInfo(BuilderInfo meta, int? tagNumber) =>
      meta.fieldInfo[tagNumber];

  /// Returns FieldInfo for a non-extension field.
  FieldInfo _nonExtensionInfoByIndex(int index) => _meta.byIndex[index];

  /// Returns the FieldInfo for a regular or extension field.
  /// throws ArgumentException if no info is found.
  FieldInfo _ensureInfo(int tagNumber) {
    final fi = _getFieldInfoOrNull(tagNumber);
    if (fi != null) return fi;
    throw ArgumentError('tag $tagNumber not defined in $_messageName');
  }

  /// Returns the FieldInfo for a regular or extension field.
  FieldInfo? _getFieldInfoOrNull(int tagNumber) {
    final fi = _nonExtensionInfo(_meta, tagNumber);
    if (fi != null) return fi;
    return _extensions?._getInfoOrNull(tagNumber);
  }

  void _markReadOnly() {
    if (_isReadOnly) return;
    _frozenState = true;
    for (final field in _meta.sortedByTag) {
      if (field.isRepeated) {
        final PbList? list = _values[field.index!];
        if (list == null) continue;
        list.freeze();
      } else if (field.isMapField) {
        final PbMap? map = _values[field.index!];
        if (map == null) continue;
        map.freeze();
      } else if (field.isGroupOrMessage) {
        final entry = _values[field.index!];
        if (entry != null) {
          final GeneratedMessage msg = entry;
          msg.freeze();
        }
      }
    }

    _extensions?._markReadOnly();
    _unknownFields?._markReadOnly();
  }

  void _ensureWritable() {
    if (_isReadOnly) {
      _throwFrozenMessageModificationError(_messageName);
    }
  }

  // Single-field operations

  /// Gets a field with full error-checking.
  ///
  /// Works for both extended and non-extended fields.
  /// Creates repeated fields (unless read-only).
  /// Suitable for public API.
  dynamic _getField(int tagNumber) {
    final fi = _nonExtensionInfo(_meta, tagNumber);
    if (fi != null) {
      final value = _values[fi.index!];
      if (value != null) return value;
      return _getDefault(fi);
    }
    final extensions = _extensions;
    if (extensions != null) {
      final fi = extensions._getInfoOrNull(tagNumber);
      if (fi != null) {
        return extensions._getFieldOrDefault(fi);
      }
    }
    throw ArgumentError('tag $tagNumber not defined in $_messageName');
  }

  dynamic _getDefault(FieldInfo fi) {
    if (!fi.isRepeated && !fi.isMapField) return fi.makeDefault!();
    if (_isReadOnly) return fi.readonlyDefault;

    final value = fi.makeDefault!();
    _setNonExtensionFieldUnchecked(_meta, fi, value);
    return value;
  }

  dynamic _getFieldOrNullByTag(int tagNumber) {
    final fi = _getFieldInfoOrNull(tagNumber);
    if (fi == null) return null;
    return _getFieldOrNull(fi);
  }

  /// Returns the field's value or null if not set.
  ///
  /// Works for both extended and non-extend fields.
  /// Works for both repeated and non-repeated fields.
  dynamic _getFieldOrNull(FieldInfo fi) {
    if (fi.index != null) return _values[fi.index!];
    return _extensions?._getFieldOrNull(fi as Extension<dynamic>);
  }

  bool _hasField(int tagNumber) {
    final fi = _nonExtensionInfo(_meta, tagNumber);
    if (fi != null) return _$has(fi.index!);
    return _extensions?._hasField(tagNumber) ?? false;
  }

  void _clearField(int tagNumber) {
    _ensureWritable();
    final meta = _meta;
    final fi = _nonExtensionInfo(meta, tagNumber);

    if (fi != null) {
      assert(tagNumber == fi.tagNumber);

      // Clear a non-extension field
      final eventPlugin = _eventPlugin;
      if (eventPlugin != null && eventPlugin.hasObservers) {
        eventPlugin.beforeClearField(fi);
      }
      _values[fi.index!] = null;

      final oneofIndex = meta.oneofs[tagNumber];
      if (oneofIndex != null) {
        _oneofCases![oneofIndex] = 0;
      }

      return;
    }

    final extensions = _extensions;
    if (extensions != null) {
      final fi = extensions._getInfoOrNull(tagNumber);
      if (fi != null) {
        extensions._clearField(fi);
        return;
      }
    }

    // neither a regular field nor an extension.
    // TODO(skybrian) throw?
  }

  /// Sets a non-repeated field with error-checking.
  ///
  /// Works for both extended and non-extended fields.
  /// Suitable for public API.
  void _setField(int tagNumber, Object value) {
    ArgumentError.checkNotNull(value, 'value');

    final meta = _meta;
    final fi = _nonExtensionInfo(meta, tagNumber);
    if (fi == null) {
      final extensions = _extensions;
      if (extensions == null) {
        throw ArgumentError('tag $tagNumber not defined in $_messageName');
      }
      extensions._setField(tagNumber, value);
      return;
    }

    if (fi.isRepeated) {
      throw ArgumentError(_setFieldFailedMessage(
          fi, value, 'repeating field (use get + .add())'));
    }
    _validateField(fi, value);
    _setNonExtensionFieldUnchecked(meta, fi, value);
  }

  /// Sets a non-repeated field without validating it.
  ///
  /// Works for both extended and non-extended fields.
  /// Suitable for decoders that do their own validation.
  void _setFieldUnchecked(BuilderInfo meta, FieldInfo fi, value) {
    ArgumentError.checkNotNull(fi, 'fi');
    assert(!fi.isRepeated);
    if (fi.index == null) {
      _ensureExtensions()
        .._addInfoUnchecked(fi as Extension<dynamic>)
        .._setFieldUnchecked(fi, value);
    } else {
      _setNonExtensionFieldUnchecked(meta, fi, value);
    }
  }

  /// Returns the list to use for adding to a repeated field.
  ///
  /// Works for both extended and non-extended fields.
  /// Creates and stores the repeated field if it doesn't exist.
  /// If it's an extension and the list doesn't exist, validates and stores it.
  /// Suitable for decoders.
  List<T> _ensureRepeatedField<T>(BuilderInfo meta, FieldInfo<T> fi) {
    assert(!_isReadOnly);
    assert(fi.isRepeated);
    if (fi.index == null) {
      return _ensureExtensions()._ensureRepeatedField(fi as Extension<T>);
    }
    final value = _getFieldOrNull(fi);
    if (value != null) return value;

    final newValue = fi._createRepeatedField(_message!);
    _setNonExtensionFieldUnchecked(meta, fi, newValue);
    return newValue;
  }

  PbMap<K, V> _ensureMapField<K, V>(BuilderInfo meta, MapFieldInfo<K, V> fi) {
    assert(!_isReadOnly);
    assert(fi.isMapField);
    assert(fi.index != null); // Map fields are not allowed to be extensions.

    final value = _getFieldOrNull(fi);
    if (value != null) return value;

    final newValue = fi._createMapField(_message!);
    _setNonExtensionFieldUnchecked(meta, fi, newValue);
    return newValue as PbMap<K, V>;
  }

  /// Sets a non-extended field and fires events.
  void _setNonExtensionFieldUnchecked(BuilderInfo meta, FieldInfo fi, value) {
    final tag = fi.tagNumber;
    final oneofIndex = meta.oneofs[tag];
    if (oneofIndex != null) {
      final currentOneofTag = _oneofCases![oneofIndex];
      if (currentOneofTag != null) {
        _clearField(currentOneofTag);
      }
      _oneofCases![oneofIndex] = tag;
    }

    // It is important that the callback to the observers is not moved to the
    // beginning of this method but happens just before the value is set.
    // Otherwise the observers will be notified about 'clearField' and
    // 'setField' events in an incorrect order.
    final eventPlugin = _eventPlugin;
    if (eventPlugin != null && eventPlugin.hasObservers) {
      eventPlugin.beforeSetField(fi, value);
    }
    _values[fi.index!] = value;
  }

  // Generated method implementations

  /// The implementation of a generated getter.
  T _$get<T>(int index, T? defaultValue) {
    final value = _values[index];
    if (value != null) return value;
    if (defaultValue != null) return defaultValue;
    return _getDefault(_nonExtensionInfoByIndex(index)) as T;
  }

  /// The implementation of a generated getter for a default value determined by
  /// the field definition value. Common case for submessages. dynamic type
  /// pushes the type check to the caller.
  dynamic _$getND(int index) {
    final value = _values[index];
    if (value != null) return value;
    return _getDefault(_nonExtensionInfoByIndex(index));
  }

  T _$ensure<T>(int index) {
    if (!_$has(index)) {
      final dynamic value = _nonExtensionInfoByIndex(index).subBuilder!();
      _$set(index, value);
      return value;
    }
    // The implicit downcast at the return is always correct by construction
    // from the protoc generator. See `GeneratedMessage.$_getN` for details.
    return _$getND(index);
  }

  /// The implementation of a generated getter for repeated fields.
  List<T> _$getList<T>(int index) {
    final value = _values[index];
    if (value != null) return value;

    final fi = _nonExtensionInfoByIndex(index) as FieldInfo<T>;
    assert(fi.isRepeated);

    if (_isReadOnly) {
      return fi.readonlyDefault;
    }

    final list = fi._createRepeatedFieldWithType<T>(_message!);
    _setNonExtensionFieldUnchecked(_meta, fi, list);
    return list;
  }

  /// The implementation of a generated getter for map fields.
  Map<K, V> _$getMap<K, V>(GeneratedMessage parentMessage, int index) {
    final value = _values[index];
    if (value != null) return value as Map<K, V>;

    final fi = _nonExtensionInfoByIndex(index) as MapFieldInfo<K, V>;
    assert(fi.isMapField);

    if (_isReadOnly) {
      return PbMap<K, V>.unmodifiable(
          PbMap<K, V>(fi.keyFieldType, fi.valueFieldType));
    }

    final map = fi._createMapField(_message!);
    _setNonExtensionFieldUnchecked(_meta, fi, map);
    return map;
  }

  /// The implementation of a generated getter for `bool` fields.
  bool _$getB(int index, bool? defaultValue) {
    var value = _values[index];
    if (value == null) {
      if (defaultValue != null) return defaultValue;
      value = _getDefault(_nonExtensionInfoByIndex(index));
    }
    return value;
  }

  /// The implementation of a generated getter for `bool` fields that default to
  /// `false`.
  bool _$getBF(int index) => _values[index] ?? false;

  /// The implementation of a generated getter for int fields.
  int _$getI(int index, int? defaultValue) {
    var value = _values[index];
    if (value == null) {
      if (defaultValue != null) return defaultValue;
      value = _getDefault(_nonExtensionInfoByIndex(index));
    }
    return value;
  }

  /// The implementation of a generated getter for `int` fields (int32, uint32,
  /// fixed32, sfixed32) that default to `0`.
  int _$getIZ(int index) => _values[index] ?? 0;

  /// The implementation of a generated getter for String fields.
  String _$getS(int index, String? defaultValue) {
    var value = _values[index];
    if (value == null) {
      if (defaultValue != null) return defaultValue;
      value = _getDefault(_nonExtensionInfoByIndex(index));
    }
    return value;
  }

  /// The implementation of a generated getter for String fields that default to
  /// the empty string.
  String _$getSZ(int index) => _values[index] ?? '';

  /// The implementation of a generated getter for Int64 fields.
  Int64 _$getI64(int index) {
    var value = _values[index];
    value ??= _getDefault(_nonExtensionInfoByIndex(index));
    return value;
  }

  /// The implementation of a generated 'has' method.
  bool _$has(int index) {
    final value = _values[index];
    if (value == null) return false;
    if (value is List) return value.isNotEmpty;
    return true;
  }

  /// The implementation of a generated setter.
  ///
  /// In production, does no validation other than a null check.
  /// Only handles non-repeated, non-extension fields.
  /// Also, doesn't handle enums or messages which need per-type validation.
  void _$set(int index, Object? value) {
    assert(!_nonExtensionInfoByIndex(index).isRepeated);
    assert(_$check(index, value));
    _ensureWritable();
    if (value == null) {
      _$check(index, value); // throw exception for null value
    }
    final eventPlugin = _eventPlugin;
    if (eventPlugin != null && eventPlugin.hasObservers) {
      eventPlugin.beforeSetField(_nonExtensionInfoByIndex(index), value);
    }
    final meta = _meta;
    final tag = meta.byIndex[index].tagNumber;
    final oneofIndex = meta.oneofs[tag];

    if (oneofIndex != null) {
      final currentOneofTag = _oneofCases![oneofIndex];
      if (currentOneofTag != null) {
        _clearField(currentOneofTag);
      }
      _oneofCases![oneofIndex] = tag;
    }
    _values[index] = value;
  }

  bool _$check(int index, var newValue) {
    _validateField(_nonExtensionInfoByIndex(index), newValue);
    return true; // Allows use in an assertion.
  }

  // Bulk operations reading or writing multiple fields

  void _clear() {
    _ensureWritable();
    if (_unknownFields != null) {
      _unknownFields!.clear();
    }

    final extensions = _extensions;

    final eventPlugin = _eventPlugin;
    if (eventPlugin != null && eventPlugin.hasObservers) {
      for (final fi in _infos) {
        if (_values[fi.index!] != null) {
          eventPlugin.beforeClearField(fi);
        }
      }
      if (extensions != null) {
        for (final key in extensions._tagNumbers) {
          final fi = extensions._getInfoOrNull(key)!;
          eventPlugin.beforeClearField(fi);
        }
      }
    }
    if (_values.isNotEmpty) _values.fillRange(0, _values.length, null);
    extensions?._clearValues();
  }

  bool _equals(_FieldSet o) {
    if (_meta != o._meta) return false;
    for (var i = 0; i < _values.length; i++) {
      if (!_equalFieldValues(_values[i], o._values[i])) return false;
    }

    final extensions = _extensions;
    if (extensions == null || !extensions._hasValues) {
      // Check if other extensions are logically empty.
      // (Don't create them unnecessarily.)
      final oExtensions = o._extensions;
      if (oExtensions != null && oExtensions._hasValues) {
        return false;
      }
    } else {
      if (!extensions._equalValues(o._extensions)) return false;
    }

    if (_unknownFields == null || _unknownFields!.isEmpty) {
      // Check if other unknown fields is logically empty.
      // (Don't create them unnecessarily.)
      if (o._unknownFields != null && o._unknownFields!.isNotEmpty) {
        return false;
      }
    } else {
      // Check if the other unknown fields has the same fields.
      if (_unknownFields != o._unknownFields) return false;
    }

    return true;
  }

  bool _equalFieldValues(left, right) {
    if (left != null && right != null) return _deepEquals(left, right);

    final val = left ?? right;

    // Two uninitialized fields are equal.
    if (val == null) return true;

    // One field is null. We are comparing an initialized field
    // with its default value.

    // An empty repeated field is the same as uninitialized.
    // This is because accessing a repeated field automatically creates it.
    // We don't want reading a field to change equality comparisons.
    if (val is List && val.isEmpty) return true;

    // An empty map field is the same as uninitialized.
    // This is because accessing a map field automatically creates it.
    // We don't want reading a field to change equality comparisons.
    if (val is PbMap && val.isEmpty) return true;

    // For now, initialized and uninitialized fields are different.
    // TODO(skybrian) consider other cases; should we compare with the
    // default value or not?
    return false;
  }

  /// Calculates a hash code based on the contents of the protobuf.
  ///
  /// The hash may change when any field changes (recursively).
  /// Therefore, protobufs used as map keys shouldn't be changed.
  ///
  /// If the protobuf contents have been frozen the hashCode is memoized to
  /// speed up performance.
  int get _hashCode {
    if (_memoizedHashCode != null) {
      return _memoizedHashCode!;
    }

    // Hash with descriptor.
    var hash = _HashUtils._combine(0, _meta.hashCode);

    // Hash with non-extension fields.
    final values = _values;
    for (final fi in _infosSortedByTag) {
      final value = values[fi.index!];
      if (value == null) continue;
      hash = _hashField(hash, fi, value);
    }

    // Hash with extension fields.
    final extensions = _extensions;
    if (extensions != null) {
      final sortedByTagNumbers = _sorted(extensions._tagNumbers);
      for (final tagNumber in sortedByTagNumbers) {
        final fi = extensions._getInfoOrNull(tagNumber)!;
        hash = _hashField(hash, fi, extensions._getFieldOrNull(fi));
      }
    }

    // Hash with unknown fields.
    hash = _HashUtils._combine(hash, _unknownFields?.hashCode ?? 0);

    if (_isReadOnly) {
      _frozenState = hash;
    }
    return hash;
  }

  // Hashes the value of one field (recursively).
  static int _hashField(int hash, FieldInfo fi, value) {
    if (value is List && value.isEmpty) {
      return hash; // It's either repeated or an empty byte array.
    }

    if (value is PbMap && value.isEmpty) {
      return hash;
    }

    hash = _HashUtils._combine(hash, fi.tagNumber);
    if (_isBytes(fi.type)) {
      // Bytes are represented as a List<int> (Usually with byte-data).
      // We special case that to match our equality semantics.
      hash = _HashUtils._combine(hash, _HashUtils._hashObjects(value));
    } else if (!_isEnum(fi.type)) {
      hash = _HashUtils._combine(hash, value.hashCode);
    } else if (fi.isRepeated) {
      final PbList list = value;
      hash = _HashUtils._combine(hash, _HashUtils._hashObjects(list.map((enm) {
        final ProtobufEnum enm_ = enm;
        return enm_.value;
      })));
    } else {
      final ProtobufEnum enm = value;
      hash = _HashUtils._combine(hash, enm.value);
    }

    return hash;
  }

  void writeString(StringBuffer out, String indent) {
    void renderValue(key, value) {
      if (value is GeneratedMessage) {
        out.write('$indent$key: {\n');
        value._fieldSet.writeString(out, '$indent  ');
        out.write('$indent}\n');
      } else if (value is MapEntry) {
        out.write('$indent$key: {${value.key} : ${value.value}} \n');
      } else {
        out.write('$indent$key: $value\n');
      }
    }

    void writeFieldValue(fieldValue, String name) {
      if (fieldValue == null) return;
      if (fieldValue is PbList) {
        for (final value in fieldValue) {
          renderValue(name, value);
        }
      } else if (fieldValue is PbMap) {
        for (final entry in fieldValue.entries) {
          renderValue(name, entry);
        }
      } else {
        renderValue(name, fieldValue);
      }
    }

    for (final fi in _infosSortedByTag) {
      writeFieldValue(_values[fi.index!],
          fi.name == '' ? fi.tagNumber.toString() : fi.name);
    }

    final extensions = _extensions;
    if (extensions != null) {
      extensions._info.keys.toList()
        ..sort()
        ..forEach((int tagNumber) => writeFieldValue(
            _extensions!._values[tagNumber],
            '[${_extensions!._info[tagNumber]!.name}]'));
    }

    final unknownFields = _unknownFields;
    if (unknownFields != null) {
      out.write(unknownFields.toString());
    } else {
      out.write(UnknownFieldSet().toString());
    }
  }

  /// Merges the contents of the [other] into this message.
  ///
  /// Singular fields that are set in [other] overwrite the corresponding fields
  /// in this message. Repeated fields are appended. Singular sub-messages are
  /// recursively merged.
  void _mergeFromMessage(_FieldSet other) {
    // TODO(https://github.com/google/protobuf.dart/issues/60): Recognize
    // when `this` and [other] are the same protobuf (e.g. from cloning). In
    // this case, we can merge the non-extension fields without field lookups or
    // validation checks.
    _ensureWritable();
    for (final fi in other._infosSortedByTag) {
      final value = other._values[fi.index!];
      if (value != null) _mergeField(fi, value, isExtension: false);
    }

    final otherExtensions = other._extensions;
    if (otherExtensions != null) {
      for (final tagNumber in otherExtensions._tagNumbers) {
        final extension = otherExtensions._getInfoOrNull(tagNumber)!;
        final value = otherExtensions._getFieldOrNull(extension);
        _mergeField(extension, value, isExtension: true);
      }
    }

    final otherUnknownFields = other._unknownFields;
    if (otherUnknownFields != null) {
      _ensureUnknownFields().mergeFromUnknownFieldSet(otherUnknownFields);
    }
  }

  void _mergeField(FieldInfo otherFi, fieldValue, {required bool isExtension}) {
    final tagNumber = otherFi.tagNumber;

    // Determine the FieldInfo to use.
    // Don't allow regular fields to be overwritten by extensions.
    final meta = _meta;
    var fi = _nonExtensionInfo(meta, tagNumber);
    if (fi == null && isExtension) {
      // This will overwrite any existing extension field info.
      fi = otherFi;
    }

    if (fi!.isMapField) {
      if (fieldValue == null) {
        return;
      }
      final MapFieldInfo<dynamic, dynamic> f = fi as dynamic;
      final PbMap<dynamic, dynamic> map =
          f._ensureMapField(meta, this) as dynamic;
      if (_isGroupOrMessage(f.valueFieldType)) {
        final PbMap<dynamic, GeneratedMessage> fieldValueMap = fieldValue;
        for (final entry in fieldValueMap.entries) {
          map[entry.key] = entry.value.deepCopy();
        }
      } else {
        map.addAll(fieldValue);
      }
      return;
    }

    if (fi.isRepeated) {
      if (_isGroupOrMessage(otherFi.type)) {
        // fieldValue must be a PbList of GeneratedMessage.
        final PbList<GeneratedMessage> pbList = fieldValue;
        final repeatedFields = fi._ensureRepeatedField(meta, this);
        for (var i = 0; i < pbList.length; ++i) {
          repeatedFields.add(pbList[i].deepCopy());
        }
      } else {
        // fieldValue must be at least a PbList.
        final PbList pbList = fieldValue;
        fi._ensureRepeatedField(meta, this).addAll(pbList);
      }
      return;
    }

    if (otherFi.isGroupOrMessage) {
      final currentFi = isExtension
          ? _ensureExtensions()._getFieldOrNull(fi as Extension<dynamic>)
          : _values[fi.index!];

      final GeneratedMessage msg = fieldValue;
      if (currentFi == null) {
        fieldValue = msg.deepCopy();
      } else {
        final GeneratedMessage currentMsg = currentFi;
        fieldValue = currentMsg..mergeFromMessage(msg);
      }
    }

    if (isExtension) {
      _ensureExtensions()
          ._setFieldAndInfo(fi as Extension<dynamic>, fieldValue);
    } else {
      _validateField(fi, fieldValue);
      _setNonExtensionFieldUnchecked(meta, fi, fieldValue);
    }
  }

  // Error-checking

  /// Checks that the message is mutable (not frozen) and the value for the
  /// field is valid for the field type.
  ///
  /// Throws [UnsupportedError] if the message if immutable (frozen).
  ///
  /// Throws [ArgumentError] if the field value is not valid for the field
  /// type. For example, when setting a proto `string` field a Dart `int`.
  void _validateField(FieldInfo fi, var newValue) {
    _ensureWritable();
    final message = _getFieldError(fi.type, newValue);
    if (message != null) {
      throw ArgumentError(_setFieldFailedMessage(fi, newValue, message));
    }
  }

  String _setFieldFailedMessage(FieldInfo fi, var value, String detail) {
    return 'Illegal to set field ${fi.name} (${fi.tagNumber}) of $_messageName'
        ' to value ($value): $detail';
  }

  bool _hasRequiredValues() {
    if (!_hasRequiredFields) return true;
    for (final fi in _infos) {
      final value = _values[fi.index!];
      if (!fi._hasRequiredValues(value)) return false;
    }
    return _hasRequiredExtensionValues();
  }

  bool _hasRequiredExtensionValues() {
    final extensions = _extensions;
    if (extensions == null) return true;
    for (final fi in extensions._infos) {
      final value = extensions._getFieldOrNull(fi);
      if (!fi._hasRequiredValues(value)) return false;
    }
    return true; // No problems found.
  }

  /// Adds the path to each uninitialized field to the list.
  void _appendInvalidFields(List<String> problems, String prefix) {
    if (!_hasRequiredFields) return;
    for (final fi in _infos) {
      final value = _values[fi.index!];
      fi._appendInvalidFields(problems, value, prefix);
    }
    // TODO(skybrian): search extensions as well
    // https://github.com/google/protobuf.dart/issues/46
  }

  /// Makes a shallow copy of all values from [original] to this.
  ///
  /// Map fields and repeated fields are copied.
  void _shallowCopyValues(_FieldSet original) {
    _values.setRange(0, original._values.length, original._values);
    final info = _meta;
    for (var index = 0; index < info.byIndex.length; index++) {
      final fieldInfo = info.byIndex[index];
      if (fieldInfo.isMapField) {
        final PbMap? map = _values[index];
        if (map != null) {
          _values[index] = (fieldInfo as MapFieldInfo)
              ._createMapField(_message!)
            ..addAll(map);
        }
      } else if (fieldInfo.isRepeated) {
        final PbList? list = _values[index];
        if (list != null) {
          _values[index] = fieldInfo._createRepeatedField(_message!)
            ..addAll(list);
        }
      }
    }

    final originalExtensions = original._extensions;
    if (originalExtensions != null) {
      _ensureExtensions()._shallowCopyValues(originalExtensions);
    }

    final originalUnknownFields = original._unknownFields;
    if (originalUnknownFields != null) {
      _ensureUnknownFields()._fields.addAll(originalUnknownFields._fields);
    }

    _oneofCases?.addAll(original._oneofCases!);
  }
}
