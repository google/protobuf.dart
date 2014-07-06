// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

class PbList<E> extends Object with ListMixin<E> implements List<E> {

  PbList() : _wrappedList = <E>[];

  PbList.from(List from) : _wrappedList = new List<E>.from(from);

  bool operator ==(other) =>
      (other is PbList) && _areListsEqual(other, this);

  int get hashCode {
    int hash = 0;
    _wrappedList.forEach((E value) {
      hash = (hash + value.hashCode) & 0x3fffffff;
      hash = (hash + hash << 10) & 0x3fffffff;
      hash = (hash ^ hash >> 6) & 0x3fffffff;
    });
    hash = (hash + hash << 3) & 0x3fffffff;
    hash = (hash ^ hash >> 11) & 0x3fffffff;
    hash = (hash + hash << 15) & 0x3fffffff;
    return hash;
  }

  /**
   * Returns an [Iterator] for the list.
   */
  Iterator<E> get iterator => _wrappedList.iterator;

  /**
   * Returns the element at the given [index] in the list or throws
   * an [IndexOutOfRangeException] if [index] is out of bounds.
   */
  E operator [](int index) => _wrappedList[index];

  /**
   * Sets the entry at the given [index] in the list to [value].
   * Throws an [IndexOutOfRangeException] if [index] is out of bounds.
   */
  void operator []=(int index, E value) {
    _validate(value);
    _wrappedList[index] = value;
  }

  /**
   * Unsupported -- violated non-null constraint imposed by protobufs.
   *
   * Changes the length of the list. If [newLength] is greater than
   * the current [length], entries are initialized to [:null:]. Throws
   * an [UnsupportedError] if the list is not extendable.
   */
  void set length(int newLength) {
    if (newLength > length) {
      throw new ArgumentError('Extending protobuf lists is not supported');
    }
    _wrappedList.length = newLength;
  }

  /**
   * Adds [value] at the end of the list, extending the length by
   * one. Throws an [UnsupportedError] if the list is not
   * extendable.
   */
  void add(E value) {
    _validate(value);
    _wrappedList.add(value);
  }

  /**
   * Appends all elements of the [collection] to the end of list.
   * Extends the length of the list by the length of [collection].
   * Throws an [UnsupportedError] if the list is not
   * extendable.
   */
  void addAll(Iterable<E> collection) {
    collection.forEach(_validate);
    _wrappedList.addAll(collection);
  }

  /**
   * Copies [:end - start:] elements of the [from] array, starting
   * from [skipCount], into [:this:], starting at [start].
   * Throws an [UnsupportedError] if the list is
   * not extendable.
   */
  void setRange(int start, int end, List<E> from, [int skipCount = 0]) {
    from.sublist(skipCount, skipCount + end - start).forEach(_validate);
    _wrappedList.setRange(start, end, from, skipCount);
  }

  /**
   * Inserts a new element in the list.
   * The element must be valid (and not nullable) for the PbList type.
   */
  void insert(int index, E element) {
    _validate(element);
    _wrappedList.insert(index, element);
  }

  /**
   * Inserts all elements of [iterable] at position [index] in the list.
   *
   * Elements in [iterable] must be valid and not nullable for the PbList type.
   */
  void insertAll(int index, Iterable<E> iterable) {
    iterable.forEach(_validate);
    _wrappedList.insertAll(index, iterable);
  }

  /**
   * Overrites elements of `this` with elements of [iterable] starting at
   * position [index] in the list.
   *
   * Elements in [iterable] must be valid and not nullable for the PbList type.
   */
  void setAll(int index, Iterable<E> iterable) {
    iterable.forEach(_validate);
    _wrappedList.setAll(index, iterable);
  }

  /**
   * Returns the number of elements in this collection.
   */
  int get length => _wrappedList.length;

  void _validate(E val) {
    if (val == null) {
      throw new ArgumentError('Value is null');
    }
    if (val is! E) {
      throw new ArgumentError(
          'Value ($val) is not of the correct type');
    }
    _validateElement(val);
  }

  void _validateElement(E val) {}

  final List<E> _wrappedList;
}

/**
 * A [PbList] that requires its elements to be [int]s in the range
 * [:-2^31, 2^31 - 1:].
 */
class PbSint32List extends PbList<int> {
  void _validateElement(int val) {
    if (!_isSigned32(val)) {
      throw new ArgumentError('Illegal to add value (${val}): out '
          'of range for int32');
    }
  }
}

/**
 * A [PbList] that requires its elements to be [int]s in the range
 * [:0, 2^32 - 1:].
 */
class PbUint32List extends PbList<int> {
  void _validateElement(int val) {
    if (!_isUnsigned32(val)) {
      throw new ArgumentError('Illegal to add value (${val}):'
          ' out of range for uint32');
    }
  }
}

/**
 * A [PbList] that requires its elements to be [int]s in the range
 * [:2^-63, 2^63 - 1:].
 */
class PbSint64List extends PbList<Int64> {
  void _validateElement(Int64 val) {
    if (!_isSigned64(val)) {
      throw new ArgumentError('Illegal to add value (${val}):'
          ' out of range for sint64');
    }
  }
}

/**
 * A [PbList] that requires its elements to be [int]s in the range
 * [:0, 2^64 - 1:].
 */
class PbUint64List extends PbList<Int64> {
  void _validateElement(Int64 val) {
    if (!_isUnsigned64(val)) {
      throw new ArgumentError('Illegal to add value (${val}):'
          ' out of range for uint64');
    }
  }
}

/**
 * A [PbList] that requires its elements to be [double]s in the range
 * [:-3.4E38, 3.4E38:], i.e., with the IEEE single-precision range.
 */
class PbFloatList extends PbList<double> {
  void _validateElement(double val) {
    if (!_isFloat32(val)) {
      throw new ArgumentError('Illegal to add value (${val}):'
          ' out of range for float');
    }
  }
}
