// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show jsonEncode;

import 'package:yaml/yaml.dart';

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
  return pb.Platform()
    ..dartVM = _isDartVM
    ..checkedMode = _implicitChecksEnabled;
}

get _isDartVM => !identical(1, 1.0);

/// Returns `false` if running via dart2js and `--omit-implicit-checks` is set
final bool _implicitChecksEnabled = () {
  // ignore: unused_local_variable
  bool x = true;
  try {
    // Trigger an exception if we're in checked mode.
    x = "" as dynamic;
    return false;
  } catch (e) {
    return true;
  }
}();

/// Given the contents of the pubspec.yaml and pubspec.lock files,
/// create a pb.Packages object.
pb.Packages createPackages(String pubspecYaml, String pubspecLock) {
  var out = pb.Packages();

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
Iterable<pb.PackageVersion> _parseLockFile(String contents) sync* {
  var yaml = loadYaml(contents) as YamlMap;
  var packages = yaml['packages'] as YamlMap;

  for (var entry in packages.entries) {
    var map = entry.value as YamlMap;
    var pkgVersion = pb.PackageVersion()
      ..name = entry.key as String
      ..source = map['source']
      ..version = map['version'];

    var path = (map['description'] as YamlMap)['path'];
    if (path != null) {
      pkgVersion.path = path;
    }
    yield pkgVersion;
  }
}

/// Encodes a report as nicely-formatted JSON.
String encodeReport(pb.Report report) {
  var json = report.writeToJsonMap();
  var out = StringBuffer();
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
