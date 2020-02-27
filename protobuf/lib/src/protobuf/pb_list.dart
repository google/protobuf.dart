// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

typedef CheckFunc<E> = void Function(E x);

class FrozenPbList<E> extends PbListBase<E> {
  FrozenPbList._(List<E> wrappedList) : super._(wrappedList);

  factory FrozenPbList.from(PbList<E> other) =>
      FrozenPbList._(other._wrappedList);

  UnsupportedError _unsupported(String method) =>
      UnsupportedError('Cannot call $method on an unmodifiable list');

  @override
  void operator []=(int index, E value) => throw _unsupported('set');
  @override
  set length(int newLength) => throw _unsupported('set length');
  @override
  void setAll(int at, Iterable<E> iterable) => throw _unsupported('setAll');
  @override
  void add(E value) => throw _unsupported('add');
  @override
  void addAll(Iterable<E> iterable) => throw _unsupported('addAll');
  @override
  void insert(int index, E element) => throw _unsupported('insert');
  @override
  void insertAll(int at, Iterable<E> iterable) =>
      throw _unsupported('insertAll');
  @override
  bool remove(Object element) => throw _unsupported('remove');
  @override
  void removeWhere(bool Function(E element) test) =>
      throw _unsupported('removeWhere');
  @override
  void retainWhere(bool Function(E element) test) =>
      throw _unsupported('retainWhere');
  @override
  void sort([Comparator<E> compare]) => throw _unsupported('sort');
  @override
  void shuffle([math.Random random]) => throw _unsupported('shuffle');
  @override
  void clear() => throw _unsupported('clear');
  @override
  E removeAt(int index) => throw _unsupported('removeAt');
  @override
  E removeLast() => throw _unsupported('removeLast');
  @override
  void setRange(int start, int end, Iterable<E> iterable,
          [int skipCount = 0]) =>
      throw _unsupported('setRange');
  @override
  void removeRange(int start, int end) => throw _unsupported('removeRange');
  @override
  void replaceRange(int start, int end, Iterable<E> iterable) =>
      throw _unsupported('replaceRange');
  @override
  void fillRange(int start, int end, [E fillValue]) =>
      throw _unsupported('fillRange');
}

class PbList<E> extends PbListBase<E> {
  PbList({check = _checkNotNull}) : super._noList(check: check);

  PbList.from(List from) : super._from(from);

  @Deprecated('Instead use the default constructor with a check function.'
      'This constructor will be removed in the next major version.')
  PbList.forFieldType(int fieldType)
      : super._noList(check: getCheckFunction(fieldType));

  /// Freezes the list by converting to [FrozenPbList].
  FrozenPbList<E> toFrozenPbList() => FrozenPbList<E>.from(this);

  /// Adds [value] at the end of the list, extending the length by one.
  /// Throws an [UnsupportedError] if the list is not extendable.
  @override
  void add(E value) {
    check(value);
    _wrappedList.add(value);
  }

  /// Appends all elements of the [collection] to the end of list.
  /// Extends the length of the list by the length of [collection].
  /// Throws an [UnsupportedError] if the list is not extendable.
  @override
  void addAll(Iterable<E> collection) {
    collection.forEach(check);
    _wrappedList.addAll(collection);
  }

  /// Returns an [Iterable] of the objects in this list in reverse order.
  @override
  Iterable<E> get reversed => _wrappedList.reversed;

  /// Sorts this list according to the order specified by the [compare]
  /// function.
  @override
  void sort([int Function(E a, E b) compare]) => _wrappedList.sort(compare);

  /// Shuffles the elements of this list randomly.
  @override
  void shuffle([math.Random random]) => _wrappedList.shuffle(random);

  /// Removes all objects from this list; the length of the list becomes zero.
  @override
  void clear() => _wrappedList.clear();

  /// Inserts a new element in the list.
  /// The element must be valid (and not nullable) for the PbList type.
  @override
  void insert(int index, E element) {
    check(element);
    _wrappedList.insert(index, element);
  }

  /// Inserts all elements of [iterable] at position [index] in the list.
  ///
  /// Elements in [iterable] must be valid and not nullable for the PbList type.
  @override
  void insertAll(int index, Iterable<E> iterable) {
    iterable.forEach(check);
    _wrappedList.insertAll(index, iterable);
  }

  /// Overwrites elements of `this` with elements of [iterable] starting at
  /// position [index] in the list.
  ///
  /// Elements in [iterable] must be valid and not nullable for the PbList type.
  @override
  void setAll(int index, Iterable<E> iterable) {
    iterable.forEach(check);
    _wrappedList.setAll(index, iterable);
  }

  /// Removes the first occurrence of [value] from this list.
  @override
  bool remove(Object value) => _wrappedList.remove(value);

  /// Removes the object at position [index] from this list.
  @override
  E removeAt(int index) => _wrappedList.removeAt(index);

  /// Pops and returns the last object in this list.
  @override
  E removeLast() => _wrappedList.removeLast();

  /// Removes all objects from this list that satisfy [test].
  @override
  void removeWhere(bool Function(E element) test) =>
      _wrappedList.removeWhere(test);

  /// Removes all objects from this list that fail to satisfy [test].
  @override
  void retainWhere(bool Function(E element) test) =>
      _wrappedList.retainWhere(test);

  /// Copies [:end - start:] elements of the [from] array, starting from
  /// [skipCount], into [:this:], starting at [start].
  /// Throws an [UnsupportedError] if the list is not extendable.
  @override
  void setRange(int start, int end, Iterable<E> from, [int skipCount = 0]) {
    // NOTE: In case `take()` returns less than `end - start` elements, the
    // _wrappedList will fail with a `StateError`.
    from.skip(skipCount).take(end - start).forEach(check);
    _wrappedList.setRange(start, end, from, skipCount);
  }

  /// Removes the objects in the range [start] inclusive to [end] exclusive.
  @override
  void removeRange(int start, int end) => _wrappedList.removeRange(start, end);

  /// Sets the objects in the range [start] inclusive to [end] exclusive to the
  /// given [fillValue].
  @override
  void fillRange(int start, int end, [E fillValue]) {
    check(fillValue);
    _wrappedList.fillRange(start, end, fillValue);
  }

  /// Removes the objects in the range [start] inclusive to [end] exclusive and
  /// inserts the contents of [replacement] in its place.
  @override
  void replaceRange(int start, int end, Iterable<E> replacement) {
    final values = replacement.toList();
    replacement.forEach(check);
    _wrappedList.replaceRange(start, end, values);
  }
}

abstract class PbListBase<E> extends ListBase<E> {
  final List<E> _wrappedList;
  final CheckFunc<E> check;

  PbListBase._(this._wrappedList, {this.check = _checkNotNull});

  PbListBase._noList({this.check = _checkNotNull}) : _wrappedList = <E>[] {
    assert(check != null);
  }

  PbListBase._from(List from)
      // TODO(sra): Should this be validated?
      : _wrappedList = List<E>.from(from),
        check = _checkNotNull;

  @override
  bool operator ==(other) =>
      (other is PbListBase) && _areListsEqual(other, this);

  @override
  int get hashCode => _HashUtils._hashObjects(_wrappedList);

  /// Returns an [Iterator] for the list.
  @override
  Iterator<E> get iterator => _wrappedList.iterator;

  /// Returns a new lazy [Iterable] with elements that are created by calling
  /// `f` on each element of this `PbListBase` in iteration order.
  @override
  Iterable<T> map<T>(T Function(E e) f) => _wrappedList.map<T>(f);

  /// Returns a new lazy [Iterable] with all elements that satisfy the predicate
  /// [test].
  @override
  Iterable<E> where(bool Function(E element) test) => _wrappedList.where(test);

  /// Expands each element of this [Iterable] into zero or more elements.
  @override
  Iterable<T> expand<T>(Iterable<T> Function(E element) f) =>
      _wrappedList.expand(f);

  /// Returns true if the collection contains an element equal to [element].
  @override
  bool contains(Object element) => _wrappedList.contains(element);

  /// Applies the function [f] to each element of this list in iteration order.
  @override
  void forEach(void Function(E element) f) {
    _wrappedList.forEach(f);
  }

  /// Reduces a collection to a single value by iteratively combining elements
  /// of the collection using the provided function.
  @override
  E reduce(E Function(E value, E element) combine) =>
      _wrappedList.reduce(combine);

  /// Reduces a collection to a single value by iteratively combining each
  /// element of the collection with an existing value.
  @override
  T fold<T>(T initialValue, T Function(T previousValue, E element) combine) =>
      _wrappedList.fold(initialValue, combine);

  /// Checks whether every element of this iterable satisfies [test].
  @override
  bool every(bool Function(E element) test) => _wrappedList.every(test);

  /// Converts each element to a [String] and concatenates the strings.
  @override
  String join([String separator = '']) => _wrappedList.join(separator);

  /// Checks whether any element of this iterable satisfies [test].
  @override
  bool any(bool Function(E element) test) => _wrappedList.any(test);

  /// Creates a [List] containing the elements of this [Iterable].
  @override
  List<E> toList({bool growable = true}) =>
      _wrappedList.toList(growable: growable);

  /// Creates a [Set] containing the same elements as this iterable.
  @override
  Set<E> toSet() => _wrappedList.toSet();

  /// Returns `true` if there are no elements in this collection.
  @override
  bool get isEmpty => _wrappedList.isEmpty;

  /// Returns `true` if there is at least one element in this collection.
  @override
  bool get isNotEmpty => _wrappedList.isNotEmpty;

  /// Returns a lazy iterable of the [count] first elements of this iterable.
  @override
  Iterable<E> take(int count) => _wrappedList.take(count);

  /// Returns a lazy iterable of the leading elements satisfying [test].
  @override
  Iterable<E> takeWhile(bool Function(E value) test) =>
      _wrappedList.takeWhile(test);

  /// Returns an [Iterable] that provides all but the first [count] elements.
  @override
  Iterable<E> skip(int count) => _wrappedList.skip(count);

  /// Returns an `Iterable` that skips leading elements while [test] is
  /// satisfied.
  @override
  Iterable<E> skipWhile(bool Function(E value) test) =>
      _wrappedList.skipWhile(test);

  /// Returns the first element.
  @override
  E get first => _wrappedList.first;

  /// Returns the last element.
  @override
  E get last => _wrappedList.last;

  /// Checks that this iterable has only one element, and returns that element.
  @override
  E get single => _wrappedList.single;

  /// Returns the first element that satisfies the given predicate [test].
  @override
  E firstWhere(bool Function(E element) test, {E Function() orElse}) =>
      _wrappedList.firstWhere(test, orElse: orElse);

  /// Returns the last element that satisfies the given predicate [test].
  @override
  E lastWhere(bool Function(E element) test, {E Function() orElse}) =>
      _wrappedList.lastWhere(test, orElse: orElse);

  /// Returns the single element that satisfies [test].
  // TODO(jakobr): Implement once Dart 2 corelib changes have landed.
  //E singleWhere(bool test(E element), {E orElse()}) =>
  //    _wrappedList.singleWhere(test, orElse: orElse);

  /// Returns the [index]th element.
  @override
  E elementAt(int index) => _wrappedList.elementAt(index);

  /// Returns a string representation of (some of) the elements of `this`.
  @override
  String toString() => _wrappedList.toString();

  /// Returns the element at the given [index] in the list or throws an
  /// [IndexOutOfRangeException] if [index] is out of bounds.
  @override
  E operator [](int index) => _wrappedList[index];

  /// Returns the number of elements in this collection.
  @override
  int get length => _wrappedList.length;

  // TODO(jakobr): E instead of Object once dart-lang/sdk#31311 is fixed.
  /// Returns the first index of [element] in this list.
  @override
  int indexOf(Object element, [int start = 0]) =>
      _wrappedList.indexOf(element, start);

  // TODO(jakobr): E instead of Object once dart-lang/sdk#31311 is fixed.
  /// Returns the last index of [element] in this list.
  @override
  int lastIndexOf(Object element, [int start]) =>
      _wrappedList.lastIndexOf(element, start);

  /// Returns a new list containing the objects from [start] inclusive to [end]
  /// exclusive.
  @override
  List<E> sublist(int start, [int end]) => _wrappedList.sublist(start, end);

  /// Returns an [Iterable] that iterates over the objects in the range [start]
  /// inclusive to [end] exclusive.
  @override
  Iterable<E> getRange(int start, int end) => _wrappedList.getRange(start, end);

  /// Returns an unmodifiable [Map] view of `this`.
  @override
  Map<int, E> asMap() => _wrappedList.asMap();

  /// Sets the entry at the given [index] in the list to [value].
  /// Throws an [IndexOutOfRangeException] if [index] is out of bounds.
  @override
  void operator []=(int index, E value) {
    check(value);
    _wrappedList[index] = value;
  }

  /// Unsupported -- violated non-null constraint imposed by protobufs.
  ///
  /// Changes the length of the list. If [newLength] is greater than the current
  /// [length], entries are initialized to [:null:]. Throws an
  /// [UnsupportedError] if the list is not extendable.
  @override
  set length(int newLength) {
    if (newLength > length) {
      throw UnsupportedError('Extending protobuf lists is not supported');
    }
    _wrappedList.length = newLength;
  }
}
