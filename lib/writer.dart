// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

abstract class Writer {
  void print(String out);
  void println([String out]);
}

class MemoryWriter implements Writer {
  final StringBuffer _buffer = new StringBuffer();

  void print(String out) {
    _buffer.write(out);
  }

  void println([String out]) {
    _buffer.write(out);
    _buffer.write('\n');
  }

  String toString() => _buffer.toString();
}
