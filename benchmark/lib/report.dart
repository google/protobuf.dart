// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.report;

import 'dart:convert' show jsonEncode;

import 'generated/benchmark.pb.dart' as pb;

pb.Response findUpdatedResponse(pb.Report beforeRep, pb.Report afterRep) {
  if (beforeRep == null) return afterRep.responses[0];
  assert(afterRep != null);
  assert(beforeRep.responses.length == afterRep.responses.length);
  for (var i = 0; i < afterRep.responses.length; i++) {
    var before = beforeRep.responses[i];
    var after = afterRep.responses[i];
    assert(before.request.id == after.request.id);
    assert(before.request.params == after.request.params);
    if (before.samples.length != after.samples.length) {
      return after;
    }
  }
  return null; // not found
}

/// Returns a partially filled in pb.Platform.
///
/// It only includes the values we can determine without dart:html or dart:io.
pb.Platform createPlatform() {
  return new pb.Platform()
    ..dartVM = _isDartVM
    ..checkedMode = _checkedMode;
}

get _isDartVM => !identical(1, 1.0);

final bool _checkedMode = () {
  var checked = false;
  assert(() {
    checked = true;
    return true;
  }());
  return checked;
}();

/// Given the contents of the pubspec.yaml and pubspec.lock files,
/// create a pb.Packages object.
pb.Packages createPackages(String pubspecYaml, String pubspecLock) {
  var out = new pb.Packages();

  for (var line in pubspecYaml.split("\n")) {
    line = line.trim();
    if (line.startsWith("version:")) {
      out.version = line.substring("version:".length).trim();
    }
  }

  out.packages.addAll(_parseLockFile(pubspecLock));

  return out;
}

/// Quick and dirty lock file parser.
/// - ignores indentation
/// - assumes one top-level key "packages:"
/// - assumes all other lines without a value except 'description'
///   start a new package
/// - only allows known keys within a package
List<pb.PackageVersion> _parseLockFile(String contents) {
  var out = <pb.PackageVersion>[];

  bool inPackages = false;
  bool inDescription = false;
  pb.PackageVersion pv = null;
  var lineNumber = 0;
  for (var line in contents.split("\n")) {
    lineNumber++;
    line = line.trim(); // ignore indentation
    if (line == "" || line.startsWith("#")) continue;

    // find key and value
    var colon = line.indexOf(":");
    if (colon == -1) {
      throw "can't parse pubspec.lock at line $lineNumber";
    }
    var key = line.substring(0, colon).trim();
    var value = line.substring(colon + 1).trim();
    if (value.length >= 2 && value.startsWith('"') && value.endsWith('"')) {
      value = value.substring(1, value.length - 1);
    }

    if (!inPackages) {
      if (key == "packages" && value == "") {
        inPackages = true;
        continue;
      }
      throw "can't parse pubspec.lock at line $lineNumber";
    }

    if (value == "") {
      if (key == "description") {
        inDescription = true;
        continue;
      }
      if (pv != null) out.add(pv);
      pv = new pb.PackageVersion()..name = key;
      continue;
    }

    if (pv == null) {
      throw "can't parse pubspec.lock at line $lineNumber - no value for $key";
    }

    if (inDescription && (key == "name" || key == "url")) continue;
    inDescription = false;

    switch (key) {
      case "description":
        break;
      case "source":
        pv.source = value;
        break;
      case "version":
        pv.version = value;
        break;
      case "path":
        pv.path = value;
        break;
      case "relative":
        break; // ignore
      case "sdk":
        break; // ignore
      default:
        throw "can't parse pubspec.lock at line $lineNumber - unknown key $key";
    }
  }
  return out;
}

/// Encodes a report as nicely-formatted JSON.
String encodeReport(pb.Report report) {
  var json = report.writeToJsonMap();
  var out = new StringBuffer();
  _stringifyMap(out, json, "");
  out.writeln();
  return out.toString();
}

String _stringifyMap(StringBuffer out, Map json, String indent) {
  var childIndent = indent + "  ";
  out.writeln("{");
  var first = true;
  for (var key in json.keys) {
    if (!first) out.writeln(",");
    first = false;

    var value = json[key];
    out.write(childIndent);
    out.write(jsonEncode(key));
    out.write(": ");

    if (value is List) {
      _stringifyList(out, value, childIndent);
    } else if (value is Map && indent.length < 4) {
      _stringifyMap(out, value, childIndent);
    } else {
      out.write(jsonEncode(value));
    }
  }
  out.write("\n$indent}");
  return out.toString();
}

void _stringifyList(StringBuffer out, List json, String indent) {
  var childIndent = indent + "  ";
  out.write("[\n");
  bool first = true;
  for (var item in json) {
    if (!first) out.write(",\n");
    first = false;
    out.write(childIndent);
    out.write(jsonEncode(item));
  }
  out.write("\n$indent]");
}
