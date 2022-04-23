// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

typedef CheckFunc<E> = void Function(E? x);

class PbList<E> extends ListBase<E> {
  final List<E> _wrappedList;
  final CheckFunc<E> _check;

  // TODO: Just store if the element type is a group or message?
  final int _elementType;

  bool _isReadOnly = false;

  PbList(this._elementType, {check = _checkNotNull})
      : _wrappedList = <E>[],
        _check = check;

  PbList.unmodifiable(this._elementType)
      : _wrappedList = const [],
        _check = _checkNotNull,
        _isReadOnly = true;

  @override
  void add(E element) {
    if (_isReadOnly) {
      throw UnsupportedError('`add` on a read-only list');
    }
    _check(element);
    _wrappedList.add(element);
  }

  @override
  void addAll(Iterable<E> iterable) {
    if (_isReadOnly) {
      throw UnsupportedError('`addAll` on a read-only list');
    }
    iterable.forEach(_check);
    _wrappedList.addAll(iterable);
  }

  @override
  Iterable<E> get reversed => _wrappedList.reversed;

  @override
  void sort([int Function(E a, E b)? compare]) {
    if (_isReadOnly) {
      throw UnsupportedError('`sort` on a read-only list');
    }
    _wrappedList.sort(compare);
  }

  @override
  void shuffle([math.Random? random]) {
    if (_isReadOnly) {
      throw UnsupportedError('`shuffle` on a read-only list');
    }
    _wrappedList.shuffle(random);
  }

  @override
  void clear() {
    if (_isReadOnly) {
      throw UnsupportedError('`clear` on a read-only list');
    }
    _wrappedList.clear();
  }

  @override
  void insert(int index, E element) {
    if (_isReadOnly) {
      throw UnsupportedError('`insert` on a read-only list');
    }
    _check(element);
    _wrappedList.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    if (_isReadOnly) {
      throw UnsupportedError('`insertAll` on a read-only list');
    }
    iterable.forEach(_check);
    _wrappedList.insertAll(index, iterable);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    if (_isReadOnly) {
      throw UnsupportedError('`setAll` on a read-only list');
    }
    iterable.forEach(_check);
    _wrappedList.setAll(index, iterable);
  }

  @override
  bool remove(Object? element) {
    if (_isReadOnly) {
      throw UnsupportedError('`remove` on a read-only list');
    }
    return _wrappedList.remove(element);
  }

  @override
  E removeAt(int index) {
    if (_isReadOnly) {
      throw UnsupportedError('`removeAt` on a read-only list');
    }
    return _wrappedList.removeAt(index);
  }

  @override
  E removeLast() {
    if (_isReadOnly) {
      throw UnsupportedError('`removeLast` on a read-only list');
    }
    return _wrappedList.removeLast();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    if (_isReadOnly) {
      throw UnsupportedError('`removeWhere` on a read-only list');
    }
    return _wrappedList.removeWhere(test);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    if (_isReadOnly) {
      throw UnsupportedError('`retainWhere` on a read-only list');
    }
    return _wrappedList.retainWhere(test);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    if (_isReadOnly) {
      // TODO: Do we want to avoid this when range is empty?
      throw UnsupportedError('`setRange` on a read-only list');
    }
    // NOTE: In case `take()` returns less than `end - start` elements, the
    // _wrappedList will fail with a `StateError`.
    iterable.skip(skipCount).take(end - start).forEach(_check);
    _wrappedList.setRange(start, end, iterable, skipCount);
  }

  @override
  void removeRange(int start, int end) {
    if (_isReadOnly) {
      // TODO: Do we want to avoid this when range is empty?
      throw UnsupportedError('`removeRange` on a read-only list');
    }
    _wrappedList.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E? fill]) {
    if (_isReadOnly) {
      // TODO: Do we want to avoid this when range is empty?
      throw UnsupportedError('`fillRange` on a read-only list');
    }
    _check(fill);
    _wrappedList.fillRange(start, end, fill);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> newContents) {
    if (_isReadOnly) {
      // TODO: Do we want to avoid this when range is empty?
      throw UnsupportedError('`replaceRange` on a read-only list');
    }
    final values = newContents.toList();
    newContents.forEach(_check);
    _wrappedList.replaceRange(start, end, values);
  }

  @override
  int get length => _wrappedList.length;

  /// Unsupported -- violated non-null constraint imposed by protobufs.
  ///
  /// Changes the length of the list. If [newLength] is greater than the current
  /// [length], entries are initialized to [:null:]. Throws an
  /// [UnsupportedError] if the list is not extendable.
  @override
  set length(int newLength) {
    if (_isReadOnly) {
      throw UnsupportedError('Setting length on a read-only list');
    }
    if (newLength > length) {
      throw UnsupportedError('Extending protobuf lists is not supported');
    }
    _wrappedList.length = newLength;
  }

  @override
  E operator [](int index) => _wrappedList[index];

  @override
  void operator []=(int index, E value) {
    if (_isReadOnly) {
      throw UnsupportedError('Setting field of a read-only list');
    }
    _check(value);
    _wrappedList[index] = value;
  }

  @override
  bool operator ==(other) => (other is PbList) && _areListsEqual(other, this);

  @override
  int get hashCode => _HashUtils._hashObjects(_wrappedList);

  void freeze() {
    _isReadOnly = true;
    if (_isGroupOrMessage(_elementType)) {
      for (var elem in _wrappedList) {
        (elem as GeneratedMessage).freeze();
      }
    }
  }
}
