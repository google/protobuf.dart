// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:collection';

import 'src/generated/descriptor.pb.dart';

/// Specifies code locations where metadata annotations should be attached and
/// where they should point to in the original proto.
class NamedLocation {
  final String name;
  final List<int> fieldPathSegment;
  final int start;

  NamedLocation(
      {required this.name,
      required this.fieldPathSegment,
      required this.start});
}

/// A buffer for writing indented source code.
class IndentingWriter {
  final StringBuffer _buffer = StringBuffer();
  final GeneratedCodeInfo sourceLocationInfo = GeneratedCodeInfo();
  String _indent = '';
  bool _needIndent = true;
  // After writing any chunk, _previousOffset is the size of everything that was
  // written to the buffer before the latest call to print or addBlock.
  int _previousOffset = 0;
  final String? _sourceFile;

  // Named text sections to write at the end of the file.
  final Map<String, String> _suffixes = SplayTreeMap();

  IndentingWriter({String? filename}) : _sourceFile = filename;

  /// Appends a string indented to the current level.
  /// (Indentation will be added after newline characters where needed.)
  void print(String text) {
    _previousOffset = _buffer.length;
    final lastNewline = text.lastIndexOf('\n');
    if (lastNewline == -1) {
      _writeChunk(text);
      return;
    }

    for (final line in text.substring(0, lastNewline).split('\n')) {
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

  void printAnnotated(String text, List<NamedLocation> namedLocations) {
    final indentOffset = _needIndent ? _indent.length : 0;
    print(text);
    for (final location in namedLocations) {
      _addAnnotation(location.fieldPathSegment, location.name,
          location.start + indentOffset);
    }
  }

  void printlnAnnotated(String text, List<NamedLocation> namedLocations) {
    printAnnotated(text, namedLocations);
    _newline();
  }

  /// Prints a block of text with the body indented one more level.
  void addBlock(String start, String end, void Function() body,
      {bool endWithNewline = true}) {
    println(start);
    _addBlockBodyAndEnd(end, body, endWithNewline, '$_indent  ');
  }

  /// Prints a block of text with an unindented body.
  /// (For example, for triple quotes.)
  void addUnindentedBlock(String start, String end, void Function() body,
      {bool endWithNewline = true}) {
    println(start);
    _addBlockBodyAndEnd(end, body, endWithNewline, '');
  }

  void addAnnotatedBlock(String start, String end,
      List<NamedLocation> namedLocations, void Function() body,
      {bool endWithNewline = true}) {
    printlnAnnotated(start, namedLocations);
    _addBlockBodyAndEnd(end, body, endWithNewline, '$_indent  ');
  }

  void _addBlockBodyAndEnd(
      String end, void Function() body, bool endWithNewline, String newIndent) {
    final oldIndent = _indent;
    _indent = newIndent;
    body();
    _indent = oldIndent;
    if (endWithNewline) {
      println(end);
    } else {
      print(end);
    }
  }

  /// Add a named piece of text that will be emitted at the end of the file
  /// after the main contents are generated.
  ///
  /// The [suffixKey] is not emitted - it's just used as a key for uniqueness,
  /// so that `addSuffix` could be called more than once with the same suffix
  /// content, but only emit that particular suffix text once.
  void addSuffix(String suffixKey, String text) {
    _suffixes[suffixKey] = text;
  }

  @override
  String toString() {
    if (_suffixes.isNotEmpty) {
      // TODO: We may want to introduce the notion of closing the writer.
      println('');
      for (final key in _suffixes.keys) {
        println(_suffixes[key]!);
      }
      _suffixes.clear();
    }

    return _buffer.toString();
  }

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

  /// Creates an annotation, given the starting offset and ending offset.
  /// [start] should be the location of the identifier as it appears in the
  /// string that was passed to the previous [print]. Name should be the string
  /// that was written to file.
  void _addAnnotation(List<int> fieldPath, String name, int start) {
    if (_sourceFile == null) {
      return;
    }
    final annotation = GeneratedCodeInfo_Annotation()
      ..path.addAll(fieldPath)
      ..sourceFile = _sourceFile!
      ..begin = _previousOffset + start
      ..end = _previousOffset + start + name.length;
    sourceLocationInfo.annotation.add(annotation);
  }
}

/// A utility class to generate a set of imports. The imports will be grouped
/// by kind (`dart:` imports, `package:` imports, ...) and sorted lexically
/// within the groups.
class ImportWriter {
  final Set<String> _dartImports = SplayTreeSet<String>();
  final Set<String> _packageImports = SplayTreeSet<String>();
  final Set<String> _fileImports = SplayTreeSet<String>();
  final Set<String> _exports = SplayTreeSet<String>();

  /// Whether any imports were written.
  bool get hasImports =>
      _dartImports.isNotEmpty ||
      _packageImports.isNotEmpty ||
      _fileImports.isNotEmpty ||
      _exports.isNotEmpty;

  /// Add an import with an optional import prefix.
  void addImport(String url, {String? prefix}) {
    final directive =
        prefix == null ? "import '$url';" : "import '$url' as $prefix;";
    if (url.startsWith('dart:')) {
      _dartImports.add(directive);
    } else if (url.startsWith('package:')) {
      _packageImports.add(directive);
    } else {
      _fileImports.add(directive);
    }
  }

  /// And an export.
  void addExport(String url) {
    _exports.add("export '$url';");
  }

  /// Return the generated text for the set of imports.
  String emit() {
    final buf = StringBuffer();

    if (_dartImports.isNotEmpty) {
      _dartImports.forEach(buf.writeln);
    }
    if (_packageImports.isNotEmpty) {
      if (buf.isNotEmpty) buf.writeln();
      _packageImports.forEach(buf.writeln);
    }
    if (_fileImports.isNotEmpty) {
      if (buf.isNotEmpty) buf.writeln();
      _fileImports.forEach(buf.writeln);
    }
    if (_exports.isNotEmpty) {
      if (buf.isNotEmpty) buf.writeln();
      _exports.forEach(buf.writeln);
    }

    return buf.toString();
  }
}
