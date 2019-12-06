// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Returns true if [a] and [b] are the same ignoring case and all instances of
///  `-` and `_`.
///
/// This is specialized code for comparing enum names.
/// Works only for ascii strings containing letters and `_` and `-`.
bool permissiveCompare(String a, String b) {
  const dash = 45;
  const underscore = 95;

  int i = 0;
  int j = 0;
  bool iReachedEnd = false;
  bool jReachedEnd = false;
  int ca;
  int cb;

  while (true) {
    // Fetch next letter (not dash and not underscore) from a.
    while (true) {
      if (i >= a.length) {
        iReachedEnd = true;
        break;
      }
      ca = a.codeUnitAt(i);
      i++;
      if (ca != dash && ca != underscore) {
        break;
      }
    }
    // Fetch next letter (not dash and not underscore) from b.
    while (true) {
      if (j >= b.length) {
        jReachedEnd = true;
        break;
      }
      cb = b.codeUnitAt(j);
      j++;
      if (cb != dash && cb != underscore) {
        break;
      }
    }
    if (iReachedEnd != jReachedEnd) {
      // We reached the end of one of the strings but not the other.
      return false;
    }
    if (iReachedEnd) {
      assert(jReachedEnd);
      return true;
    }
    assert(!iReachedEnd && !jReachedEnd);
    if (ca != cb && (ca ^ cb != 0x20 || !_isAsciiLetter(ca))) {
      // Different characters.
      return false;
    }
  }
}

bool _isAsciiLetter(int char) {
  const lowerA = 97;
  const lowerZ = 122;
  const capitalA = 65;
  char |= lowerA ^ capitalA;
  return lowerA <= char && char <= lowerZ;
}
