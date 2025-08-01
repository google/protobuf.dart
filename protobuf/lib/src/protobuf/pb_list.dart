// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'internal.dart';

/// Type of a function that checks items added to a `PbList`.
///
/// Throws [ArgumentError] or [RangeError] when the item is not valid.
typedef CheckFunc<E> = void Function(E? x);

/// A [ListBase] implementation used for protobuf `repeated` fields.
class PbList<E> extends ListBase<E> {
  /// The actual list storing the elements.
  ///
  /// Note: We want only one [List] implementation class to be stored here to
  /// make sure the list operations are monomorphic and can be inlined. In
  /// constructors make sure initializers for this field all return the same
  /// implementation class. (e.g. `_GrowableList` on the VM)
  final List<E> _wrappedList;

  /// A growable list, to be used in `unmodifiable` constructor to avoid
  /// allocating a list every time.
  ///
  /// We can't use `const []` as it makes the `_wrappedList` field polymorphic.
  static final _emptyList = <Never>[];

  final CheckFunc<E> _check;

  bool _isReadOnly = false;

  bool get isFrozen => _isReadOnly;

  PbList({CheckFunc<E> check = _checkNotNull})
    : _wrappedList = <E>[],
      _check = check;

  PbList.unmodifiable()
    : _wrappedList = _emptyList,
      _check = _checkNotNull,
      _isReadOnly = true;

  PbList.from(List<E> from)
    : _wrappedList = List<E>.from(from),
      _check = _checkNotNull;

  @override
  @pragma('dart2js:never-inline')
  void add(E element) {
    _checkModifiable('add');
    _check(element);
    _wrappedList.add(element);
  }

  @pragma('dart2js:tryInline')
  @pragma('vm:prefer-inline')
  @pragma('wasm:prefer-inline')
  void _addUnchecked(E element) {
    _wrappedList.add(element);
  }

  @override
  @pragma('dart2js:never-inline')
  void addAll(Iterable<E> iterable) {
    _checkModifiable('addAll');
    iterable.forEach(_check);
    _wrappedList.addAll(iterable);
  }

  @override
  Iterable<E> get reversed => _wrappedList.reversed;

  @override
  void sort([int Function(E a, E b)? compare]) {
    _checkModifiable('sort');
    _wrappedList.sort(compare);
  }

  @override
  void shuffle([math.Random? random]) {
    _checkModifiable('shuffle');
    _wrappedList.shuffle(random);
  }

  @override
  @pragma('dart2js:never-inline')
  void clear() {
    _checkModifiable('clear');
    _wrappedList.clear();
  }

  @override
  void insert(int index, E element) {
    _checkModifiable('insert');
    _check(element);
    _wrappedList.insert(index, element);
  }

  @override
  void insertAll(int index, Iterable<E> iterable) {
    _checkModifiable('insertAll');
    iterable.forEach(_check);
    _wrappedList.insertAll(index, iterable);
  }

  @override
  void setAll(int index, Iterable<E> iterable) {
    _checkModifiable('setAll');
    iterable.forEach(_check);
    _wrappedList.setAll(index, iterable);
  }

  @override
  bool remove(Object? element) {
    _checkModifiable('remove');
    return _wrappedList.remove(element);
  }

  @override
  E removeAt(int index) {
    _checkModifiable('removeAt');
    return _wrappedList.removeAt(index);
  }

  @override
  E removeLast() {
    _checkModifiable('removeLast');
    return _wrappedList.removeLast();
  }

  @override
  void removeWhere(bool Function(E element) test) {
    _checkModifiable('removeWhere');
    return _wrappedList.removeWhere(test);
  }

  @override
  void retainWhere(bool Function(E element) test) {
    _checkModifiable('retainWhere');
    return _wrappedList.retainWhere(test);
  }

  @override
  void setRange(int start, int end, Iterable<E> iterable, [int skipCount = 0]) {
    _checkModifiable('setRange');
    // NOTE: In case `take()` returns less than `end - start` elements, the
    // _wrappedList will fail with a `StateError`.
    iterable.skip(skipCount).take(end - start).forEach(_check);
    _wrappedList.setRange(start, end, iterable, skipCount);
  }

  @override
  void removeRange(int start, int end) {
    _checkModifiable('removeRange');
    _wrappedList.removeRange(start, end);
  }

  @override
  void fillRange(int start, int end, [E? fill]) {
    _checkModifiable('fillRange');
    _check(fill);
    _wrappedList.fillRange(start, end, fill);
  }

  @override
  void replaceRange(int start, int end, Iterable<E> newContents) {
    _checkModifiable('replaceRange');
    final values = newContents.toList();
    newContents.forEach(_check);
    _wrappedList.replaceRange(start, end, values);
  }

  @override
  int get length => _wrappedList.length;

  @override
  bool get isEmpty => _wrappedList.isEmpty;

  @override
  bool get isNotEmpty => _wrappedList.isNotEmpty;

  @override
  @pragma('dart2js:never-inline')
  Iterator<E> get iterator => _wrappedList.iterator;

  @override
  set length(int newLength) {
    _checkModifiable('set length');
    if (newLength > length) {
      throw UnsupportedError('Extending protobuf lists is not supported');
    }
    _wrappedList.length = newLength;
  }

  @override
  E operator [](int index) => _wrappedList[index];

  @override
  void operator []=(int index, E value) {
    _checkModifiable('set element');
    _check(value);
    _wrappedList[index] = value;
  }

  @override
  bool operator ==(Object other) =>
      other is PbList && areListsEqual(other, this);

  @override
  int get hashCode => HashUtils.hashObjects(_wrappedList);

  void freeze() {
    if (_isReadOnly) {
      return;
    }

    _isReadOnly = true;

    // Per spec `repeated map<..>` and `repeated repeated ..` are not allowed
    // so we only check for messages
    if (_wrappedList.isNotEmpty && _wrappedList[0] is GeneratedMessage) {
      for (final elem in _wrappedList as Iterable<GeneratedMessage>) {
        elem.freeze();
      }
    }
  }

  void _checkModifiable(String methodName) {
    if (_isReadOnly) {
      _readOnlyError(methodName);
    }
  }

  static Never _readOnlyError(String methodName) {
    throw UnsupportedError("'$methodName' on a read-only list");
  }
}
