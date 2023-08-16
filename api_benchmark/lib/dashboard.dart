// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async' show Future;
import 'dart:convert';
import 'dart:html';
import 'dart:js' show JsObject, context;

import 'benchmark.dart' show Profiler;
import 'dashboard_model.dart' show DashboardModel, SelectEvent, Table;
import 'dashboard_view.dart' show DashboardView;
import 'data_index.dart' as data;
import 'generated/benchmark.pb.dart' as pb;
import 'report.dart' show createPackages, createPlatform;
import 'suite.dart' show runSuite;

/// Displays a dashboard that can be used to run benchmarks.
Future showDashboard(pb.Suite suite, Element container) async {
  // set up model

  final env = await loadBrowserEnv();
  final reports = await loadReports(suite);

  final defaultReport = pb.Report()..env = env;
  var model = DashboardModel(reports, Table(suite), defaultReport);

  final baseline = chooseBaseline(env, reports);
  if (baseline != null) {
    model = model.withBaseline(baseline);
  }

  final view = DashboardView();

  Future render(pb.Report report) async {
    report.env = env;
    model = model.withReport(report);
    await window.animationFrame;
    view.render(model);
    await Future(() => null); // exit to regular timer task
  }

  // Set up the main loop that runs the suite.

  var running = false;
  void runBenchmarks() {
    if (running) return;
    final profiler = JsProfiler();
    running = true;
    () async {
      final requests = model.table.selections.toList();
      for (final report in runSuite(requests, profiler: profiler)) {
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

  view.onMenuChange.listen((String? item) {
    model = model.withBaseline(item);
    view.render(model);
  });

  view.onSelectionChange.listen((SelectEvent e) {
    model = model.withTable(model.table.withSelection(e.item, e.selected!));
    view.render(model);
  });

  // show the view

  view.render(model);
  container.children.clear();
  container.append(view.elt);
}

/// Starts and stops the DevTools profiler.
class JsProfiler implements Profiler {
  static JsObject? console = context['console'];

  int count = 1;

  @override
  void startProfile(pb.Request request) {
    final label = '$count-${request.id.name}';
    count++;
    console!.callMethod('profile', [label]);
  }

  @override
  void endProfile(pb.Sample s) {
    console!.callMethod('profileEnd');
    print('profile: $s');
  }
}

Future<pb.Env> loadBrowserEnv() async {
  const advice = 'Run a VM benchmark to create this file.';
  final pubspecYaml =
      (await _loadDataFile(data.pubspecYamlName, advice: advice))!;
  final pubspecLock =
      (await _loadDataFile(data.pubspecLockName, advice: advice))!;
  final hostname = (await _loadDataFile(data.hostfileName, advice: advice))!;

  final platform = createPlatform()
    ..hostname = hostname
    ..userAgent = window.navigator.userAgent;

  return pb.Env()
    ..page = window.location.pathname!
    ..platform = platform
    ..packages = createPackages(pubspecYaml, pubspecLock);
}

/// Loads all the reports saved to benchmark/data.
Future<Map<String, pb.Report>> loadReports(pb.Suite suite) async {
  final out = <String, pb.Report>{};

  final dataJsonContent = (await _loadDataFile('data.json'))!;
  final dataJson = jsonDecode(dataJsonContent) as Map<String, dynamic>;

  for (final entry in dataJson.entries) {
    final report = pb.Report.fromJson(entry.value);
    if (isCompatibleBaseline(suite, report)) {
      out[entry.key] = report;
    }
  }
  print('loaded ${out.length} reports');
  return out;
}

/// Choose the report to display on the left side for comparison.
/// Returns null if no comparable report is found.
String? chooseBaseline(pb.Env env, Map<String, pb.Report> reports) {
  for (final name in reports.keys) {
    final candidate = reports[name]!;
    if (candidate.env.platform == env.platform) {
      return name;
    }
  }
  return null;
}

/// Returns true if the baseline report used the same benchmarks.
bool isCompatibleBaseline(pb.Suite suite, pb.Report report) {
  for (var i = 0; i < suite.requests.length; i++) {
    if (i >= report.responses.length) {
      return true; // additional benchmarks ok
    }
    final request = suite.requests[i];
    final response = report.responses[i];
    if (request != response.request) return false;
  }
  return true;
}

Future<String?> _loadDataFile(String name,
    {bool optional = false, String? advice}) async {
  try {
    return await HttpRequest.getString('/data/$name');
  } catch (e) {
    if (optional) return null;
    var error = 'File is missing in benchmark/data: $name';
    if (advice != null) {
      error += '. $advice';
    }
    throw error;
  }
}
