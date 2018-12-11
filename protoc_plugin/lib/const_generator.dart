// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.const_generator;

import "indenting_writer.dart";

/// Writes JSON data as a Dart constant expression.
/// Accepts null, bool, num, String, and maps and lists.
void writeJsonConst(IndentingWriter out, val) {
  if (val is Map) {
    if (val.values.any(_nonEmptyListOrMap)) {
      out.addBlock(
          "const {", "}", () => _writeMapItems(out, val, vertical: true),
          endWithNewline: false);
    } else {
      out.print("const {");
      _writeMapItems(out, val);
      out.print("}");
    }
  } else if (val is List) {
    if (val.any(_nonEmptyListOrMap)) {
      out.addBlock(
          "const [", "]", () => _writeListItems(out, val, vertical: true),
          endWithNewline: false);
    } else {
      out.print("const [");
      _writeListItems(out, val);
      out.print("]");
    }
  } else if (val is String) {
    _writeString(out, val);
  } else if (val is num || val is bool) {
    out.print(val.toString());
  } else if (val == null) {
    out.print("null");
  } else {
    throw "not JSON: $val";
  }
}

bool _nonEmptyListOrMap(x) {
  if (x is List && x.isNotEmpty) return true;
  if (x is Map && x.isNotEmpty) return true;
  return false;
}

void _writeString(IndentingWriter out, String val) {
  if (_maybeWriteSingleLineString(out, val)) return;
  // handle the general case
  var quote = "'''";
  out.addUnindentedBlock("r$quote", "$quote", () {
    out.print(val.replaceAll(quote, '$quote "$quote" r$quote'));
  }, endWithNewline: false);
}

bool _maybeWriteSingleLineString(IndentingWriter out, String val) {
  if (val.contains("\n")) return false;
  var prefix = '';
  if (val.contains(r'$') || val.contains(r'\')) {
    prefix = 'r';
  }
  if (!val.contains("'")) {
    out.print("$prefix'$val'");
    return true;
  } else if (!val.contains('"')) {
    out.print('$prefix"$val"');
    return true;
  } else if (!val.contains("'''")) {
    out.print("$prefix'''$val'''");
    return true;
  } else if (!val.contains('"""')) {
    out.print('$prefix"""$val"""');
    return true;
  } else {
    return false;
  }
}

void _writeListItems(IndentingWriter out, List val, {bool vertical = false}) {
  bool first = true;
  for (var item in val) {
    if (!first && !vertical) {
      out.print(", ");
    }
    writeJsonConst(out, item);
    if (vertical) {
      out.println(",");
    }
    first = false;
  }
}

void _writeMapItems(IndentingWriter out, Map<dynamic, dynamic> val,
    {bool vertical = false}) {
  bool first = true;
  for (var key in val.keys) {
    if (!first && !vertical) out.print(", ");
    _writeString(out, key);
    out.print(": ");
    writeJsonConst(out, val[key]);
    if (vertical) {
      out.println(",");
    }
    first = false;
  }
}
