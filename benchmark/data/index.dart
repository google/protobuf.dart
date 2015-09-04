// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.data;

const String latestVMReportName = "latest_vm.pb.json";

// Symbolic links to make these files available in a browser.
const String pubspecYamlName = "pubspec.link.yaml";
const String pubspecLockName = "pubspec.link.lock";

const String hostfileName = "hostname.txt";

List<String> allReportNames = const [
  latestVMReportName,
  "skybrian5/0.4.2/json_chrome.pb.json",
  "skybrian5/0.4.2/json_vm.pb.json"
];
