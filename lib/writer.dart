// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class Writer {
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

class OutputStreamWriter implements Writer {
  static final List<int> NEWLINE_CHARS = NEWLINE.codeUnits;

  final IOSink _outStream;

  OutputStreamWriter(this._outStream);

  void print(String str) {
    _outStream.writeBytes(str.codeUnits);
  }

  void println([String out]) {
    if (null != out) print(out);
    _outStream.writeBytes(NEWLINE_CHARS);
  }
}
