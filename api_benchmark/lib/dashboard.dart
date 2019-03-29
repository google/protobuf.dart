// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.html_runner;

import 'dart:async' show Future;
import 'dart:convert';
import 'dart:html';
import 'dart:js' show context, JsObject;

import 'generated/benchmark.pb.dart' as pb;

import 'package:api_benchmark/benchmark.dart' show Profiler;
import 'dashboard_model.dart' show DashboardModel, Table, SelectEvent;
import 'dashboard_view.dart' show DashboardView;
import 'package:api_benchmark/report.dart' show createPlatform, createPackages;
import 'package:api_benchmark/suite.dart' show runSuite;

import 'package:api_benchmark/data_index.dart' as data;

/// Displays a dashboard that can be used to run benchmarks.
Future showDashboard(pb.Suite suite, Element container) async {
  // set up model

  var env = await loadBrowserEnv();
  var reports = await loadReports(suite);

  var defaultReport = pb.Report()..env = env;
  var model = DashboardModel(reports, Table(suite), defaultReport);

  var baseline = chooseBaseline(env, reports);
  if (baseline != null) {
    model = model.withBaseline(baseline);
  }

  var view = DashboardView();

  Future render(pb.Report report) async {
    report.env = env;
    model = model.withReport(report);
    await window.animationFrame;
    view.render(model);
    await Future(() => null); // exit to regular timer task
  }

  // Set up the main loop that runs the suite.

  bool running = false;
  void runBenchmarks() {
    if (running) return;
    var profiler = JsProfiler();
    running = true;
    () async {
      var requests = model.table.selections.toList();
      for (pb.Report report in runSuite(requests, profiler: profiler)) {
        await render(report);
      }
    }()
        .whenComplete(() {
      running = false;
    });
  }

  // set up event handlers

  view.onRunButtonClick.listen((_) => runBenchmarks());
  view.onSelectAllClick.listen((_) {
    model = model.withTable(model.table.withAllSelected());
    view.render(model);
  });
  view.onSelectNoneClick.listen((_) {
    model = model.withTable(model.table.withNoneSelected());
    view.render(model);
  });

  view.onMenuChange.listen((String item) {
    model = model.withBaseline(item);
    view.render(model);
  });

  view.onSelectionChange.listen((SelectEvent e) {
    model = model.withTable(model.table.withSelection(e.item, e.selected));
    view.render(model);
  });

  // show the view

  view.render(model);
  container.children.clear();
  container.append(view.elt);
}

/// Starts and stops the DevTools profiler.
class JsProfiler implements Profiler {
  static JsObject console = context["console"];

  int count = 1;

  startProfile(pb.Request request) {
    var label = "$count-${request.id.name}";
    count++;
    console.callMethod("profile", [label]);
  }

  endProfile(pb.Sample s) {
    console.callMethod("profileEnd");
    print("profile: $s");
  }
}

Future<pb.Env> loadBrowserEnv() async {
  const advice = "Run a VM benchmark to create this file.";
  var pubspecYaml = await _loadDataFile(data.pubspecYamlName, advice: advice);
  var pubspecLock = await _loadDataFile(data.pubspecLockName, advice: advice);
  var hostname = await _loadDataFile(data.hostfileName, advice: advice);

  var platform = createPlatform()
    ..hostname = hostname
    ..userAgent = window.navigator.userAgent;

  return pb.Env()
    ..page = window.location.pathname
    ..platform = platform
    ..packages = createPackages(pubspecYaml, pubspecLock);
}

/// Loads all the reports saved to benchmark/data.
Future<Map<String, pb.Report>> loadReports(pb.Suite suite) async {
  var out = <String, pb.Report>{};

  var dataJsonContent = await _loadDataFile('data.json');
  var dataJson = jsonDecode(dataJsonContent) as Map<String, dynamic>;

  for (var entry in dataJson.entries) {
    var report = pb.Report.fromJson(entry.value);
    if (isCompatibleBaseline(suite, report)) {
      out[entry.key] = report;
    }
  }
  print("loaded ${out.length} reports");
  return out;
}

/// Choose the report to display on the left side for comparison.
/// Returns null if no comparable report is found.
String chooseBaseline(pb.Env env, Map<String, pb.Report> reports) {
  for (var name in reports.keys) {
    var candidate = reports[name];
    if (candidate.env.platform == env.platform) {
      return name;
    }
  }
  return null;
}

/// Returns true if the baseline report used the same benchmarks.
bool isCompatibleBaseline(pb.Suite suite, pb.Report report) {
  for (int i = 0; i < suite.requests.length; i++) {
    if (i >= report.responses.length) {
      return true; // additional benchmarks ok
    }
    var request = suite.requests[i];
    var response = report.responses[i];
    if (request != response.request) return false;
  }
  return true;
}

Future<String> _loadDataFile(String name,
    {bool optional = false, String advice}) async {
  try {
    return await HttpRequest.getString("/data/$name");
  } catch (e) {
    if (optional) return null;
    String error = "File is missing in benchmark/data: $name";
    if (advice != null) {
      error += ". $advice";
    }
    throw error;
  }
}
