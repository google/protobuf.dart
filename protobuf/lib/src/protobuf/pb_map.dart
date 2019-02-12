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
  _FieldSet _entryFieldSet() => new _FieldSet(null, _entryBuilderInfo, null);

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
    if (_isReadonly)
      throw new UnsupportedError('Attempted to change a read-only map field');
    _checkNotNull(key);
    _checkNotNull(value);
    _wrappedMap[key] = value;
  }

  @override
  void clear() {
    if (_isReadonly)
      throw new UnsupportedError('Attempted to change a read-only map field');
    _wrappedMap.clear();
  }

  @override
  Iterable<K> get keys => _wrappedMap.keys;

  @override
  V remove(Object key) {
    if (_isReadonly)
      throw new UnsupportedError('Attempted to change a read-only map field');
    return _wrappedMap.remove(key);
  }

  @Deprecated("This function was not intended to be public. "
      "It will be removed from the public api in next major version. ")
  void add(CodedBufferReader input, [ExtensionRegistry registry]) {
    _mergeEntry(input, registry);
  }

  void _mergeEntry(CodedBufferReader input, [ExtensionRegistry registry]) {
    int length = input.readInt32();
    int oldLimit = input._currentLimit;
    input._currentLimit = input._bufferPos + length;
    _FieldSet entryFieldSet = _entryFieldSet();
    _mergeFromCodedBufferReader(entryFieldSet, input, registry);
    input.checkLastTagWas(0);
    input._currentLimit = oldLimit;
    K key = entryFieldSet._$get(0, null);
    V value = entryFieldSet._$get(1, null);
    _wrappedMap[key] = value;
  }

  void _checkNotNull(Object val) {
    if (val == null) {
      throw new ArgumentError("Can't add a null to a map field");
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
