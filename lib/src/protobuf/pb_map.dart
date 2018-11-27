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

  _FieldSet _entryFieldSet;

  PbMap(this.keyFieldType, this.valueFieldType,
      [CreateBuilderFunc valueCreator,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues])
      : _wrappedMap = <K, V>{} {
    BuilderInfo entryInfo = new BuilderInfo("entry")
      ..add(_keyFieldNumber, "key", keyFieldType, null, null, null, null)
      ..add(_valueFieldNumber, "value", valueFieldType, null, valueCreator,
          valueOf, enumValues);
    _entryFieldSet = new _FieldSet(null, entryInfo, null);
  }

  PbMap.unmodifiable(PbMap other)
      : keyFieldType = other.keyFieldType,
        valueFieldType = other.valueFieldType,
        _wrappedMap = Map.unmodifiable(other._wrappedMap),
        _entryFieldSet = other._entryFieldSet;

  @override
  V operator [](Object key) => _wrappedMap[key];

  @override
  void operator []=(K key, V value) {
    _checkNotNull(key);
    _checkNotNull(value);
    _wrappedMap[key] = value;
  }

  @override
  void clear() => _wrappedMap.clear();

  @override
  Iterable<K> get keys => _wrappedMap.keys;

  @override
  V remove(Object key) => _wrappedMap.remove(key);

  void add(CodedBufferReader input, [ExtensionRegistry registry]) {
    int length = input.readInt32();
    int oldLimit = input._currentLimit;
    input._currentLimit = input._bufferPos + length;
    _mergeFromCodedBufferReader(_entryFieldSet, input, registry);
    input.checkLastTagWas(0);
    input._currentLimit = oldLimit;
    K key = _entryFieldSet._$get(0, null);
    V value = _entryFieldSet._$get(1, null);
    _wrappedMap[key] = value;
  }

  void _checkNotNull(Object val) {
    if (val == null) {
      throw new ArgumentError("Can't add a null to a map field");
    }
  }
}
