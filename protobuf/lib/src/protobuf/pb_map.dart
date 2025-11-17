// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=3.7

import 'dart:collection' show MapBase;

import 'internal.dart';
import 'utils.dart';

const mapKeyFieldNumber = 1;
const mapValueFieldNumber = 2;

/// A [MapBase] implementation used for protobuf `map` fields.
class PbMap<K, V> extends MapBase<K, V> {
  /// Key type of the map. Per proto2 and proto3 specs, this needs to be an
  /// integer type or `string`, and the type cannot be `repeated`.
  ///
  /// The `int` value is interpreted the same way as [FieldInfo.type].
  final int keyFieldType;

  /// Value type of the map. Per proto2 and proto3 specs, this can be any type
  /// other than `map`, and the type cannot be `repeated`.
  ///
  /// The `int` value is interpreted the same way as [FieldInfo.type].
  final int valueFieldType;

  /// The actual list storing the elements.
  ///
  /// Note: We want only one [Map] implementation class to be stored here to
  /// make sure the map operations are monomorphic and can be inlined. In
  /// constructors make sure initializers for this field all return the same
  /// implementation class.
  final Map<K, V> _wrappedMap;

  bool _isReadOnly = false;

  PbMap(this.keyFieldType, this.valueFieldType) : _wrappedMap = <K, V>{};

  PbMap.unmodifiable(this.keyFieldType, this.valueFieldType)
    : _wrappedMap = <K, V>{},
      _isReadOnly = true;

  @override
  V? operator [](Object? key) => _wrappedMap[key];

  @override
  void operator []=(K key, V value) {
    if (_isReadOnly) {
      throw UnsupportedError('Attempted to change a read-only map field');
    }
    ArgumentError.checkNotNull(key, 'key');
    ArgumentError.checkNotNull(value, 'value');
    _wrappedMap[key] = value;
  }

  /// A [PbMap] is equal to another [PbMap] with equal key/value
  /// pairs in any order.
  @override
  bool operator ==(Object other) {
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
    return _wrappedMap.entries.fold(
      0,
      (h, entry) => h ^ HashUtils.hash2(entry.key, entry.value),
    );
  }

  @override
  void clear() {
    if (_isReadOnly) {
      throw UnsupportedError('Attempted to change a read-only map field');
    }
    _wrappedMap.clear();
  }

  @override
  Iterable<K> get keys => _wrappedMap.keys;

  @override
  V? remove(Object? key) {
    if (_isReadOnly) {
      throw UnsupportedError('Attempted to change a read-only map field');
    }
    return _wrappedMap.remove(key);
  }

  PbMap freeze() {
    _isReadOnly = true;
    if (PbFieldType.isGroupOrMessage(valueFieldType)) {
      for (final subMessage in values as Iterable<GeneratedMessage>) {
        subMessage.freeze();
      }
    }
    return this;
  }

  PbMap<K, V> _deepCopy() {
    final newMap = PbMap<K, V>(keyFieldType, valueFieldType);
    final wrappedMap = _wrappedMap;
    final newWrappedMap = newMap._wrappedMap;
    if (PbFieldType.isGroupOrMessage(valueFieldType)) {
      for (final entry in wrappedMap.entries) {
        newWrappedMap[entry.key] =
            (entry.value as GeneratedMessage).deepCopy() as V;
      }
    } else {
      newWrappedMap.addAll(wrappedMap);
    }
    return newMap;
  }
}

extension PbMapInternalExtension<K, V> on PbMap<K, V> {
  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  PbMap<K, V> deepCopy() => _deepCopy();
}
