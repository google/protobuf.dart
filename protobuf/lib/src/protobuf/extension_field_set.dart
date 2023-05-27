// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../../protobuf.dart';

class _ExtensionFieldSet {
  final _FieldSet _parent;
  final Map<int, Extension> _info = <int, Extension>{};
  final Map<int, dynamic> _values = <int, dynamic>{};
  bool _isReadOnly = false;

  _ExtensionFieldSet(this._parent);

  Extension? _getInfoOrNull(int tagNumber) => _info[tagNumber];

  dynamic _getFieldOrDefault(Extension fi) {
    if (fi.isRepeated) return _getList(fi);
    _validateInfo(fi);
    // TODO(skybrian) seems unnecessary to add info?
    // I think this was originally here for repeated extensions.
    _addInfoUnchecked(fi);
    final value = _getFieldOrNull(fi);
    if (value == null) {
      _checkNotInUnknown(fi);
      return fi.makeDefault!();
    }
    return value;
  }

  bool _hasField(int tagNumber) {
    final value = _values[tagNumber];
    if (value == null) return false;
    if (value is List) return value.isNotEmpty;
    return true;
  }

  /// Ensures that the list exists and an extension is present.
  ///
  /// If it doesn't exist, creates the list and saves the extension.
  /// Suitable for public API and decoders.
  List<T> _ensureRepeatedField<T>(Extension<T> fi) {
    assert(!_isReadOnly);
    assert(fi.isRepeated);
    assert(fi.extendee == '' || fi.extendee == _parent._messageName);

    final list = _values[fi.tagNumber];
    if (list != null) return list;

    return _addInfoAndCreateList(fi);
  }

  List<T> _getList<T>(Extension<T> fi) {
    final value = _values[fi.tagNumber];
    if (value != null) return value;
    _checkNotInUnknown(fi);
    if (_isReadOnly) return List<T>.unmodifiable(const []);
    return _addInfoAndCreateList<T>(fi);
  }

  List<T> _addInfoAndCreateList<T>(Extension<T> fi) {
    _validateInfo(fi);
    final newList = fi._createRepeatedField(_parent._message!);
    _addInfoUnchecked(fi);
    _setFieldUnchecked(fi, newList);
    return newList;
  }

  dynamic _getFieldOrNull(Extension extension) => _values[extension.tagNumber];

  void _clearFieldAndInfo(Extension fi) {
    _clearField(fi);
    _info.remove(fi.tagNumber);
  }

  void _clearField(Extension fi) {
    _ensureWritable();
    _validateInfo(fi);
    final eventPlugin = _parent._eventPlugin;
    if (eventPlugin != null && eventPlugin.hasObservers) {
      eventPlugin.beforeClearField(fi);
    }
    _values.remove(fi.tagNumber);
  }

  /// Sets a value for a non-repeated extension that has already been added.
  /// Does error-checking.
  void _setField(int tagNumber, value) {
    final fi = _getInfoOrNull(tagNumber);
    if (fi == null) {
      throw ArgumentError(
          'tag $tagNumber not defined in $_parent._messageName');
    }
    if (fi.isRepeated) {
      throw ArgumentError(_parent._setFieldFailedMessage(
          fi, value, 'repeating field (use get + .add())'));
    }
    _ensureWritable();
    _parent._validateField(fi, value);
    _setFieldUnchecked(fi, value);
  }

  /// Sets a non-repeated value and extension.
  /// Overwrites any existing extension.
  void _setFieldAndInfo(Extension fi, value) {
    _ensureWritable();
    if (fi.isRepeated) {
      throw ArgumentError(_parent._setFieldFailedMessage(
          fi, value, 'repeating field (use get + .add())'));
    }
    _ensureWritable();
    _validateInfo(fi);
    _parent._validateField(fi, value);
    _addInfoUnchecked(fi);
    _setFieldUnchecked(fi, value);
  }

  void _ensureWritable() {
    if (_isReadOnly) {
      _throwFrozenMessageModificationError(_parent._messageName);
    }
  }

  void _validateInfo(Extension fi) {
    if (fi.extendee != _parent._messageName) {
      throw ArgumentError(
          'Extension $fi not legal for message ${_parent._messageName}');
    }
  }

  void _addInfoUnchecked(Extension fi) {
    assert(fi.extendee == _parent._messageName);
    _info[fi.tagNumber] = fi;
  }

  void _setFieldUnchecked(Extension fi, value) {
    final eventPlugin = _parent._eventPlugin;
    if (eventPlugin != null && eventPlugin.hasObservers) {
      eventPlugin.beforeSetField(fi, value);
    }
    // If there was already an unknown field with the same tag number,
    // overwrite it.
    _parent._unknownFields?.clearField(fi.tagNumber);
    _values[fi.tagNumber] = value;
  }

  // Bulk operations

  Iterable<int> get _tagNumbers => _values.keys;
  Iterable<Extension> get _infos => _info.values;

  bool get _hasValues => _values.isNotEmpty;

  bool _equalValues(_ExtensionFieldSet? other) =>
      other != null && _areMapsEqual(_values, other._values);

  void _clearValues() => _values.clear();

  /// Makes a shallow copy of all values from [original] to this.
  ///
  /// Repeated fields are copied.
  /// Extensions cannot contain map fields.
  void _shallowCopyValues(_ExtensionFieldSet original) {
    for (final tagNumber in original._tagNumbers) {
      final extension = original._getInfoOrNull(tagNumber)!;
      _addInfoUnchecked(extension);

      final value = original._getFieldOrNull(extension);
      if (value == null) continue;
      if (extension.isRepeated) {
        assert(value is PbList);
        _ensureRepeatedField(extension).addAll(value);
      } else {
        _setFieldUnchecked(extension, value);
      }
    }
  }

  void _markReadOnly() {
    if (_isReadOnly) return;
    _isReadOnly = true;
    for (final field in _info.values) {
      if (field.isRepeated) {
        final entriesDynamic = _values[field.tagNumber];
        if (entriesDynamic == null) continue;
        final PbList entries = entriesDynamic;
        entries.freeze();
      } else if (field.isGroupOrMessage) {
        final entry = _values[field.tagNumber];
        if (entry != null) {
          final GeneratedMessage msg = entry;
          msg.freeze();
        }
      }
    }
  }

  void _checkNotInUnknown(Extension extension) {
    final unknownFields = _parent._unknownFields;
    if (unknownFields != null && unknownFields.hasField(extension.tagNumber)) {
      throw StateError(
          'Trying to get $extension that is present as an unknown field. '
          'Parse the message with this extension in the extension registry or '
          'use `ExtensionRegistry.reparseMessage`.');
    }
  }
}
