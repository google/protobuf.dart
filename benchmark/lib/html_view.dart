// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.html_view;

import 'dart:async' show Future;
import 'dart:html';

import 'generated/benchmark.pb.dart' as pb;
import 'report.dart' show createPlatform, createPackages, encodeReport;
import 'suite.dart' show runSuite;

import '../data/index.dart' as data;

/// Runs a benchmark suite and displays progress and results as HTML.
/// Returns after rendering the final report.
Future runSuiteWithView(pb.Suite suite, Element container) async {
  await loadReports(); // TODO: comparison view

  var env = await loadBrowserEnv();

  var view = new ReportView();
  container.children.clear();
  container.append(view.elt);

  for (pb.Report report in runSuite(suite)) {
    report.env = env;
    view.render(report);

    // Wait for frame to render and start a new timer task for next benchmark.
    await window.animationFrame;
    await new Future(() => null);
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

  return new pb.Env()
    ..page = window.location.pathname
    ..platform = platform
    ..packages = createPackages(pubspecYaml, pubspecLock);
}

/// Loads all the reports saved to benchmark/data.
Future<List<pb.Report>> loadReports() async {
  var out = <pb.Report>[];
  // TODO: maybe parallelize?
  for (var name in data.allReportNames) {
    String json =
        await _loadDataFile(name, optional: (name == data.latestVMReportName));
    if (json != null) {
      out.add(new pb.Report.fromJson(json));
    }
  }
  print("loaded ${out.length} reports");
  return out;
}

Future<String> _loadDataFile(String name,
    {bool optional: false, String advice}) async {
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

class ReportView {
  final DivElement elt = new DivElement();
  final DivElement _statusElt = new DivElement();
  final PreElement _envElt = new PreElement();
  final TableElement _responseTable = new TableElement();
  final _jsonView = new _JsonView();

  String _renderedStatus;
  String _renderedPlatform;
  final rows = <_ResponseView>[];

  ReportView() {
    // Fill in "template" elements that never change.
    elt.children.addAll([
      _statusElt..style.height = "1em",
      _envElt,
      _responseTable
        ..children.addAll([
          _headerCell("Benchmark"),
          _headerCell("Params"),
          _headerCell("1000 * int32 reads / second")..colSpan = 3
        ]),
      _jsonView.elt
    ]);
  }

  void render(pb.Report r) {
    _renderStatus(r);
    _renderEnv(r);
    _renderResponses(r);
    _jsonView.render(r);
  }

  void _renderStatus(pb.Report r) {
    var newStatus = r.message;
    if (r.status == pb.Status.DONE) newStatus = "";

    if (newStatus == _renderedStatus) return;
    _statusElt.text = newStatus;
    _renderedStatus = newStatus;
  }

  void _renderEnv(pb.Report r) {
    String newPlatform = r.env.platform.toString();
    if (newPlatform == _renderedPlatform) return;
    _envElt.text = newPlatform;
    _renderedPlatform = newPlatform;
  }

  void _renderResponses(pb.Report r) {
    var it = r.responses.iterator;

    // Update existing rows
    for (var row in rows) {
      var hasNext = it.moveNext();
      assert(hasNext); // assume that the table only grows
      row.render(it.current);
    }

    // Add any new rows
    while (it.moveNext()) {
      var row = new _ResponseView()..render(it.current);
      _responseTable.append(row.elt);
      rows.add(row);
    }
  }
}

class _ResponseView {
  final TableRowElement elt = new TableRowElement();
  pb.Response _rendered;

  void render(pb.Response response) {
    if (_rendered == response) return;

    elt.children.clear();
    elt.append(_textCell(response.request.id.name));
    elt.append(_textCell(response.request.params.toString()));

    for (var s in response.samples) {
      double kIntsPerSecond = s.counts.int32Reads * 1000 / s.duration;
      var cell = _textCell(kIntsPerSecond.toStringAsFixed(1))
        ..style.textAlign = "right";
      elt.append(cell);
    }
  }
}

class _JsonView {
  final DivElement elt = new DivElement();
  String _rendered;

  void render(pb.Report r) {
    // Don't show JSON while benchmarks are in progress.
    String json = "";
    if (r.status == pb.Status.DONE) {
      json = encodeReport(r);
    }

    if (json == _rendered) return;

    elt.children.clear();
    if (json == "") return;
    elt.children.addAll([
      new HeadingElement.h2()..text = "Report data as JSON:",
      new PreElement()..text = json
    ]);
    _rendered = json;
  }
}

_headerCell(String columnName) => new Element.th()
  ..style.textAlign = "left"
  ..text = columnName;

_textCell(String value) => new TableCellElement()..text = value.toString();
