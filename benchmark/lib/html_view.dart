// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.html_view;

import 'dart:async' show Future;
import 'dart:html';

import 'generated/benchmark.pb.dart' as pb;
import 'report.dart' show encodeReport;
import 'suite.dart' show runSuite;

import '../data/index.dart' show allReportNames;


/// Runs a benchmark suite and displays progress and results as HTML.
/// Returns after rendering the final report.
Future runSuiteWithView(pb.Suite suite, Element container) async {
  await loadReports(); // TODO: comparison view
  var view = new ReportView();
  container.children.clear();
  container.append(view.elt);

  var env = loadBrowserEnv();

  await for (pb.Report report in runSuite(suite)) {
    report.env = env;
    view.render(report);

    // Wait for frame to render and start a new timer task for next benchmark.
    await window.animationFrame;
    await new Future(() => null);
  }
}

pb.Env loadBrowserEnv() {
  var platform = new pb.Platform()
    ..userAgent = window.navigator.userAgent;
  return new pb.Env()
    ..platform = platform;
}

/// Loads all the reports saved to benchmark/data.
Future<List<pb.Report>> loadReports() async {
  var out = <pb.Report>[];
  // TODO: maybe parallelize?
  for (var name in allReportNames) {
    var url = "/data/" + name;
    String json = await HttpRequest.getString(url);
    out.add(new pb.Report.fromJson(json));
  }
  print("loaded ${out.length} reports");
  return out;
}

class ReportView {
  final DivElement elt = new DivElement();
  final DivElement _statusElt = new DivElement();
  final TableElement _tableElt = new TableElement();
  final _jsonView = new _JsonView();

  String _renderedStatus;
  final rows = <_BenchmarkView>[];

  ReportView() {
    // Fill in "template" elements that never change.
    elt.children.addAll([
      _statusElt..style.height = "1em",
      _tableElt
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
    _renderTable(r);
    _jsonView.render(r);
  }

  void _renderStatus(pb.Report r) {
    var newStatus = r.message;
    if (r.status == pb.Status.DONE) newStatus = "";

    if (newStatus == _renderedStatus) return;
    _statusElt.text = newStatus;
    _renderedStatus = newStatus;
  }

  void _renderTable(pb.Report r) {
    var it = r.responses.iterator;

    // Update existing rows
    for (var row in rows) {
      var hasNext = it.moveNext();
      assert(hasNext); // assume that the table only grows
      row.render(it.current);
    }

    // Add any new rows
    while (it.moveNext()) {
      var row = new _BenchmarkView()..render(it.current);
      _tableElt.append(row.elt);
      rows.add(row);
    }
  }
}

class _BenchmarkView {
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
