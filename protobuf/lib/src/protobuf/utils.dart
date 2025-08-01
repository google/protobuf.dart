// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'internal.dart';

// TODO(antonm): reconsider later if PbList should take care of equality.
bool deepEquals(Object lhs, Object rhs) {
  // Some GeneratedMessages implement Map, so test this first.
  if (lhs is GeneratedMessage) return lhs == rhs;
  if (rhs is GeneratedMessage) return false;
  if ((lhs is List) && (rhs is List)) return areListsEqual(lhs, rhs);
  if ((lhs is Map) && (rhs is Map)) return areMapsEqual(lhs, rhs);
  return lhs == rhs;
}

bool areListsEqual(List lhs, List rhs) {
  if (lhs.length != rhs.length) return false;
  for (var i = 0; i < lhs.length; i++) {
    if (!deepEquals(lhs[i], rhs[i])) return false;
  }
  return true;
}

bool areMapsEqual(Map lhs, Map rhs) {
  if (lhs.length != rhs.length) return false;
  return lhs.keys.every((key) => deepEquals(lhs[key], rhs[key]));
}

List<T> sorted<T>(Iterable<T> list) => List.from(list)..sort();

class HashUtils {
  // Jenkins hash functions copied from
  // https://github.com/google/quiver-dart/blob/master/lib/src/core/hash.dart.

  static int combine(int hash, int value) {
    hash = 0x1fffffff & (hash + value);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int _finish(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  /// Generates a hash code for multiple [objects].
  static int hashObjects(Iterable objects) =>
      _finish(objects.fold(0, (h, i) => combine(h, i.hashCode)));

  /// Generates a hash code for two objects.
  static int hash2(dynamic a, dynamic b) =>
      _finish(combine(combine(0, a.hashCode), b.hashCode));
}
