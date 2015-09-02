// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.report;

import 'dart:convert' show JSON;

import 'generated/benchmark.pb.dart' as pb;

/// Encodes a report as nicely-formatted JSON.
String encodeReport(pb.Report report) {
  var json = report.writeToJsonMap();
  var out = new StringBuffer();
  _stringifyMap(out, json, "");
  return out.toString();
}

String _stringifyMap(StringBuffer out, Map json, String indent) {
  out.writeln("{");
  var first = true;
  for (var key in json.keys) {
    if (!first) out.writeln(",");
    first = false;

    var value = json[key];
    out.write(indent);
    out.write(JSON.encode(key));
    out.write(": ");

    if (value is List) {
      _stringifyList(out, value, "  ");
    } else if (value is Map && indent.length < 4) {
      _stringifyMap(out, value, indent + "  ");
    } else {
      out.write(JSON.encode(value));
    }
  }
  out.write("\n}");
  return out.toString();
}

void _stringifyList(StringBuffer out, List json, String indent) {
  out.write("[\n");
  bool first = true;
  for (var item in json) {
    if (!first) out.write(",\n");
    first = false;
    out.write(indent);
    out.write(JSON.encode(item));
  }
  out.write("\n]");
}
