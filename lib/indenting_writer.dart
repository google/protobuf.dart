// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class IndentingWriter implements Writer {
  final String _indentSequence;
  final Writer _writer;
  final StringBuffer _currentText = new StringBuffer();
  String _currentIndent = '';

  IndentingWriter(this._indentSequence, this._writer);

  void addBlock(String start, String end, void body(), {endWithNewline: true}) {
    println(start);
    var oldIndent = _currentIndent;
    _currentIndent = '$_currentIndent$_indentSequence';
    body();
    _currentIndent = oldIndent;
    if (endWithNewline) {
      println(end);
    } else {
      print(end);
    }
  }

  void print(String stringToPrint) {
    _currentText.write(stringToPrint);
  }

  /*
   * Add the specified line to the output buffer with the current
   * level of indent.
   */
  void println([String out = '']) {
    // TODO - not clear how this plays cross-platform.
    // more sophisticated patterns don't seem to match.
    print(out);
    for (String line in _currentText.toString().split('\n')) {
      if (!line.isEmpty) _writer.print(_currentIndent);
      _writer.println(line);
    }
    _currentText.clear();
  }
}
