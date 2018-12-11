// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.indenting_writer;

/// A buffer for writing indented source code.
class IndentingWriter {
  final StringBuffer _buffer = new StringBuffer();
  String _indent = "";
  bool _needIndent = true;

  /// Appends a string indented to the current level.
  /// (Indentation will be added after newline characters where needed.)
  void print(String text) {
    var lastNewline = text.lastIndexOf('\n');
    if (lastNewline == -1) {
      _writeChunk(text);
      return;
    }

    for (String line in text.substring(0, lastNewline).split('\n')) {
      _writeChunk(line);
      _newline();
    }
    _writeChunk(text.substring(lastNewline + 1));
  }

  /// Same as print, but with a newline at the end.
  void println([String text = '']) {
    print(text);
    _newline();
  }

  /// Prints a block of text with the body indented one more level.
  void addBlock(String start, String end, void body(),
      {endWithNewline = true}) {
    _addBlock(start, end, body, endWithNewline, _indent + '  ');
  }

  /// Prints a block of text with an unindented body.
  /// (For example, for triple quotes.)
  void addUnindentedBlock(String start, String end, void body(),
      {endWithNewline = true}) {
    _addBlock(start, end, body, endWithNewline, '');
  }

  void _addBlock(
      String start, String end, void body(), endWithNewline, newIndent) {
    println(start);
    var oldIndent = _indent;
    _indent = newIndent;
    body();
    _indent = oldIndent;
    if (endWithNewline) {
      println(end);
    } else {
      print(end);
    }
  }

  String toString() => _buffer.toString();

  /// Writes part of a line of text.
  /// Adds indentation if we're at the start of a line.
  void _writeChunk(String chunk) {
    assert(!chunk.contains('\n'));

    if (chunk.isEmpty) return;
    if (_needIndent) {
      _buffer.write(_indent);
      _needIndent = false;
    }
    _buffer.write(chunk);
  }

  void _newline() {
    _buffer.writeln();
    _needIndent = true;
  }
}
