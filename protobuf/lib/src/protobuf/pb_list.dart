// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

typedef CheckFunc<E> = void Function(E? x);

class PbList<E> extends ListBase<E> {
  final List<E> _wrappedList;
  final CheckFunc<E> _check;

  bool _isReadOnly = false;

  bool get isFrozen => _isReadOnly;

  PbList({check = _checkNotNull})
      : _wrappedList = <E>[],
        _check = check;

  PbList.unmodifiable()
      : _wrappedList = const [],
        _check = _checkNotNull,
        _isReadOnly = true;

  PbList.from(List from)
      : _wrappedList = List<E>.from(from),
        _check = _checkNotNull;

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
      throw UnsupportedError('`removeRange` on a read-only list');
    }
    _wrappedList.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E? fill]) {
    if (_isReadOnly) {
      throw UnsupportedError('`fillRange` on a read-only list');
    }
    _check(fill);
    _wrappedList.fillRange(start, end, fill);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> newContents) {
    if (_isReadOnly) {
      throw UnsupportedError('`replaceRange` on a read-only list');
    }
    final values = newContents.toList();
    newContents.forEach(_check);
    _wrappedList.replaceRange(start, end, values);
  }

  @override
  int get length => _wrappedList.length;

  @override
  set length(int newLength) {
    if (_isReadOnly) {
      throw UnsupportedError('Setting length of a read-only list');
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
  bool operator ==(other) => other is PbList && _areListsEqual(other, this);

  @override
  int get hashCode => _HashUtils._hashObjects(_wrappedList);

  void freeze() {
    if (_isReadOnly) {
      return;
    }

    _isReadOnly = true;

    // Per spec `repeated map<..>` and `repeated repeated ..` are not allowed
    // so we only check for messages
    if (_wrappedList.isNotEmpty && _wrappedList[0] is GeneratedMessage) {
      for (var elem in _wrappedList as Iterable<GeneratedMessage>) {
        elem.freeze();
      }
    }
  }
}
