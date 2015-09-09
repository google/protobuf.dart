// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.report;

import 'dart:convert' show JSON;

import 'generated/benchmark.pb.dart' as pb;

/// Returns the sample with the median ints reads per second.
pb.Sample medianSample(pb.Response response) {
  if (response.samples.isEmpty) return null;
  var samples = []..addAll(response.samples);
  samples.sort((a, b) {
    return intReadsPerSecond(a).compareTo(intReadsPerSecond(b));
  });
  int index = samples.length ~/ 2;
  return samples[index];
}

/// Returns the sample with the best int reads per second.
pb.Sample maxSample(pb.Response response) {
  pb.Sample best;
  for (var s in response.samples) {
    if (best == null) best = s;
    if (intReadsPerSecond(best) < intReadsPerSecond(s)) {
      best = s;
    }
  }
  return best;
}

double intReadsPerSecond(pb.Sample s) =>
  s.counts.int32Reads * 1000000 / s.duration;

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

String summarizeResponse(pb.Response r) {
  assert(r != null);

  var name = r.request.id.name.padRight(25);
  var median = _kIntReadsPerSecond(medianSample(r)).toString().padLeft(4);
  var max = _kIntReadsPerSecond(maxSample(r)).toString().padLeft(4);
  var sampleCount = r.samples.length.toString().padLeft(2);

  return "$name samples: $sampleCount"
      " median: ${median}k max: ${max}k int32 reads/sec";
}

int _kIntReadsPerSecond(pb.Sample s) {
  if (s == null) return 0;
  return s.counts.int32Reads * 1000 ~/ s.duration;
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
  bool x = true;
  try {
    // Trigger an exception if we're in checked mode.
    x = "" as dynamic;
    return x != ""; // return false; suppress unused variable warning
  } catch (e) {
    return true;
  }
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
/// - assumes all other lines without a value start a new package
/// - only allows three known keys within a package
List<pb.PackageVersion> _parseLockFile(String contents) {
  var out = <pb.PackageVersion>[];

  bool inPackages = false;
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
      if (pv != null) out.add(pv);
      pv = new pb.PackageVersion()..name = key;
      continue;
    }

    if (pv == null) {
      throw "can't parse pubspec.lock at line $lineNumber";
    }

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
      default:
        throw "can't parse pubspec.lock at line $lineNumber";
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
    out.write(JSON.encode(key));
    out.write(": ");

    if (value is List) {
      _stringifyList(out, value, childIndent);
    } else if (value is Map && indent.length < 4) {
      _stringifyMap(out, value, childIndent);
    } else {
      out.write(JSON.encode(value));
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
    out.write(JSON.encode(item));
  }
  out.write("\n$indent]");
}
