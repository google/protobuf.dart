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
  "skybrian5/0.4.2/json_vm.pb.json",
  "skybrian5/0.4.2/props_chrome.pb.json",
  "skybrian5/0.4.2/props_vm.pb.json",
  "skybrian5/head/json_chrome.pb.json",
  "skybrian5/head/json_vm.pb.json",
  "skybrian5/head/props_chrome.pb.json",
  "skybrian5/head/props_vm.pb.json",
  "skybrian-macbookpro/0.4.2/json_chrome.pb.json",
  "skybrian-macbookpro/0.4.2/json_vm.pb.json",
  "skybrian-macbookpro/0.4.2/props_chrome.pb.json",
  "skybrian-macbookpro/0.4.2/props_vm.pb.json",
  "skybrian-macbookpro/0.5.0/json_chrome.pb.json",
  "skybrian-macbookpro/0.5.0/json_vm.pb.json",
  "skybrian-macbookpro/0.5.0/props_chrome.pb.json",
  "skybrian-macbookpro/0.5.0/props_vm.pb.json",
  "skybrian-macbookpro/head/json_chrome.pb.json",
  "skybrian-macbookpro/head/json_vm.pb.json",
  "skybrian-macbookpro/head/props_chrome.pb.json",
  "skybrian-macbookpro/head/props_vm.pb.json",
];
