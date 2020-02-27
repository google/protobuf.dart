// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

class PbMap<K, V> extends MapBase<K, V> {
  final int keyFieldType;
  final int valueFieldType;

  static const int _keyFieldNumber = 1;
  static const int _valueFieldNumber = 2;

  final Map<K, V> _wrappedMap;
  final BuilderInfo _entryBuilderInfo;

  bool _isReadonly = false;
  _FieldSet _entryFieldSet() => _FieldSet(null, _entryBuilderInfo, null);

  PbMap(this.keyFieldType, this.valueFieldType, this._entryBuilderInfo)
      : _wrappedMap = <K, V>{};

  PbMap.unmodifiable(PbMap other)
      : keyFieldType = other.keyFieldType,
        valueFieldType = other.valueFieldType,
        _wrappedMap = Map.unmodifiable(other._wrappedMap),
        _entryBuilderInfo = other._entryBuilderInfo,
        _isReadonly = other._isReadonly;

  @override
  V operator [](Object key) => _wrappedMap[key];

  @override
  void operator []=(K key, V value) {
    if (_isReadonly) {
      throw UnsupportedError('Attempted to change a read-only map field');
    }
    _checkNotNull(key);
    _checkNotNull(value);
    _wrappedMap[key] = value;
  }

  /// A [PbMap] is equal to another [PbMap] with equal key/value
  /// pairs in any order.
  @override
  bool operator ==(other) {
    if (identical(other, this)) {
      return true;
    }
    if (other is! PbMap) {
      return false;
    }
    if (other.length != length) {
      return false;
    }
    for (final key in keys) {
      if (!other.containsKey(key)) {
        return false;
      }
    }
    for (final key in keys) {
      if (other[key] != this[key]) {
        return false;
      }
    }
    return true;
  }

  /// A [PbMap] is equal to another [PbMap] with equal key/value
  /// pairs in any order. Then, the `hashCode` is guaranteed to be the same.
  @override
  int get hashCode {
    return _wrappedMap.entries
        .fold(0, (h, entry) => h ^ _HashUtils._hash2(entry.key, entry.value));
  }

  @override
  void clear() {
    if (_isReadonly) {
      throw UnsupportedError('Attempted to change a read-only map field');
    }
    _wrappedMap.clear();
  }

  @override
  Iterable<K> get keys => _wrappedMap.keys;

  @override
  V remove(Object key) {
    if (_isReadonly) {
      throw UnsupportedError('Attempted to change a read-only map field');
    }
    return _wrappedMap.remove(key);
  }

  @Deprecated('This function was not intended to be public. '
      'It will be removed from the public api in next major version. ')
  void add(CodedBufferReader input, [ExtensionRegistry registry]) {
    _mergeEntry(input, registry);
  }

  void _mergeEntry(CodedBufferReader input, [ExtensionRegistry registry]) {
    var length = input.readInt32();
    var oldLimit = input._currentLimit;
    input._currentLimit = input._bufferPos + length;
    var entryFieldSet = _entryFieldSet();
    _mergeFromCodedBufferReader(entryFieldSet, input, registry);
    input.checkLastTagWas(0);
    input._currentLimit = oldLimit;
    var key = entryFieldSet._$get<K>(0, null);
    var value = entryFieldSet._$get<V>(1, null);
    _wrappedMap[key] = value;
  }

  void _checkNotNull(Object val) {
    if (val == null) {
      throw ArgumentError("Can't add a null to a map field");
    }
  }

  PbMap freeze() {
    _isReadonly = true;
    if (_isGroupOrMessage(valueFieldType)) {
      for (var subMessage in values as Iterable<GeneratedMessage>) {
        subMessage.freeze();
      }
    }
    return this;
  }
}
