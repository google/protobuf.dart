// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.vm;

import 'dart:async' show Future;
import 'dart:io' show Platform;

import 'generated/benchmark.pb.dart' as pb;
import 'report.dart' show encodeReport;
import 'suite.dart' show runSuite;


/// Runs a benchmark suite and prints a report.
Future runSuiteInVM(pb.Suite suite) async {
  var env = _loadEnv();

  var last;
  await for (var report in runSuite(suite)) {
    last = report;
  }
  last.env = env;

  print("Report data as JSON:\n");
  print(encodeReport(last));
}

pb.Env _loadEnv() {
  var platform = new pb.Platform()
    ..hostname = _hostname
    ..osType = _osType
    ..dartVersion = Platform.version;

  return new pb.Env()
    ..script = _script
    ..platform = platform;
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
