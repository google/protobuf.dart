// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.vm;

import 'dart:async' show Future;
import 'dart:io' show File, Directory, Link, Platform, stdout;

import 'data_index.dart'
    show latestVMReportName, pubspecYamlName, pubspecLockName, hostfileName;
import 'benchmarks/index.dart' show createBenchmark;
import 'generated/benchmark.pb.dart' as pb;
import 'report.dart'
    show createPlatform, createPackages, encodeReport, findUpdatedResponse;
import 'suite.dart' show runSuite;

/// Runs a benchmark suite.
/// Writes a report to latest_vm.pb.json after every change,
/// to make progress available to the browser.
runSuiteInVM(pb.Suite suite) async {
  var env = await _loadEnv();

  pb.Report lastReport;
  pb.Response lastUpdate;
  for (var report in runSuite(suite.requests, samplesPerBatch: 10)) {
    report.env = env;

    // show progress
    var update = findUpdatedResponse(lastReport, report);
    if (update != null) {
      var summary = _summarize(update);
      if (lastUpdate == null || update.request != lastUpdate.request) {
        stdout.write("\n$summary");
      } else {
        _overwrite(summary);
      }
    }

    lastReport = report;
    lastUpdate = update;
  }

  // save the report to a file
  var outFile = "${dataDir.path}/$latestVMReportName";
  var tmpFile = File("$outFile.tmp");
  await tmpFile.writeAsString(encodeReport(lastReport));
  await tmpFile.rename(outFile);
  print("\nWrote result to ${outFile}");
}

String _summarize(pb.Response r) {
  assert(r != null);
  var b = createBenchmark(r.request);
  return b.summarizeResponse(r);
}

final _escapeChar = String.fromCharCode(27);
final _clearLine = "\r$_escapeChar[2K";

/// Overwrite the last line printed to the terminal.
void _overwrite(String line) {
  stdout.write("$_clearLine$line");
}

Future<pb.Env> _loadEnv() async {
  await _ensureDataDir();

  var platform = createPlatform()
    ..hostname = _hostname
    ..osType = _osType
    ..dartVersion = Platform.version;

  var pubspec = await (File(pubspecYaml.path).readAsString());
  var lock = await (File(pubspecLock.path).readAsString());

  return pb.Env()
    ..script = _script
    ..platform = platform
    ..packages = createPackages(pubspec, lock);
}

/// Create files and symlinks in the data directory.
///
/// This is so they can be accessed in browser benchmarks.
_ensureDataDir() async {
  await hostnameFile.writeAsString(_hostname);

  if (!await pubspecYaml.exists()) {
    await pubspecYaml.create("${pubspecDir.path}/pubspec.yaml");
  }

  if (!await pubspecLock.exists()) {
    await pubspecLock.create("${pubspecDir.path}/pubspec.lock");
  }
}

String get _script {
  // Only including the last part of the script name.
  return Platform.script.pathSegments.last;
}

String get _hostname {
  // Only including the first part of the hostname.
  var h = Platform.localHostname;
  int firstDot = h.indexOf(".");
  if (firstDot == -1) return h;
  return h.substring(0, firstDot);
}

pb.OSType get _osType {
  if (Platform.isLinux) return pb.OSType.LINUX;
  if (Platform.isMacOS) return pb.OSType.MAC;
  if (Platform.isWindows) return pb.OSType.WINDOWS;
  if (Platform.isAndroid) return pb.OSType.ANDROID;

  // What is this?
  throw "unknown OS type";
}

final File hostnameFile = File("${dataDir.path}/$hostfileName");
final Link pubspecYaml = Link("${dataDir.path}/$pubspecYamlName");
final Link pubspecLock = Link("${dataDir.path}/$pubspecLockName");

final Directory dataDir = () {
  var d = Directory("${pubspecDir.path}/web/data");
  if (!d.existsSync()) {
    throw "data dir doesn't exist at ${d.path}";
  }
  return d;
}();

/// Returns the drectory containing the pubspec.yaml file.
final Directory pubspecDir = () {
  for (var d = Directory.current; d.parent != d; d = d.parent) {
    if (File("${d.path}/pubspec.yaml").existsSync()) {
      return d;
    }
  }
  throw "can't find pubspec.yaml above ${Directory.current}";
}();
