// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.dashboard_model;

import 'generated/benchmark.pb.dart' as pb;

import 'benchmark.dart' show Benchmark;
import 'benchmarks/index.dart' show createBenchmark;

/// Contains the viewable state of the dashboard. (Immutable.)
class DashboardModel {
  final Map<String, pb.Report> savedReports;
  final Table table;
  final pb.Report latest;

  DashboardModel(this.savedReports, this.table, this.latest);

  DashboardModel withBaseline(String name) {
    var nextTable = table.withBaseline(name, savedReports[name]);
    return new DashboardModel(savedReports, nextTable, latest);
  }

  DashboardModel withReport(pb.Report right) =>
      new DashboardModel(savedReports, table, right);

  DashboardModel withTable(Table table) =>
      new DashboardModel(savedReports, table, latest);

  /// Returns true if the Run button should be enabled.
  bool get canRun => !latest.hasStatus() || latest.status != pb.Status.RUNNING;
}

/// The parts of the benchmark results table that don't change often.
class Table {
  final pb.Suite suite;
  final String baseline;
  final pb.Report report;
  final Set<pb.Request> selections;
  final rows = <Row>[];

  factory Table(pb.Suite suite) =>
    new Table._raw(suite, null, null, new Set<pb.Request>.from(suite.requests));

  Table._raw(this.suite, this.baseline, this.report, this.selections) {
    var it = report == null ? [].iterator : report.responses.iterator;
    for (var r in suite.requests) {
      var b = createBenchmark(r);
      pb.Sample baseline;
      if (it.moveNext()) {
        b.checkRequest(it.current.request);
        baseline = b.medianSample(it.current);
      }
      rows.add(new Row(r, b, baseline, selected: this.selections.contains(r)));
    }
  }

  Table withBaseline(String baseline, pb.Report report) =>
      new Table._raw(suite, baseline, report, selections);

  Table withAllSelected() {
    return new Table._raw(suite, baseline, report,
      new Set<pb.Request>.from(suite.requests));
  }

  Table withNoneSelected() {
    return new Table._raw(suite, baseline, report, new Set<pb.Request>());
  }

  Table withSelection(pb.Request request, bool selected) {
    var s = new Set<pb.Request>.from(selections);
    if (selected) {
      s.add(request);
    } else {
      s.remove(request);
    }
    return new Table._raw(suite, baseline, report, s);
  }
}

/// The parts of a row in the benchmark results table that don't change often.
class Row {
  final pb.Request request;
  final Benchmark benchmark;
  final pb.Sample baseline;
  final bool selected;
  Row(this.request, this.benchmark, this.baseline, {this.selected: true});

  /// Returns the response that should be displayed in this row.
  pb.Response findResponse(pb.Report r) {
    for (var candidate in r.responses) {
      if (candidate.request == request) return candidate;
    }
    return null;
  }
}

// Indicates that the given item was added or removed from a selection.
class SelectEvent<T> {
  final bool selected;
  final T item;
  SelectEvent(this.selected, [this.item]);
  toString() => "SelectEvent($selected, $item)";
}
