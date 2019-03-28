// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.dashboard_model;

import 'generated/benchmark.pb.dart' as pb;

import 'package:api_benchmark/benchmark.dart' show Benchmark;
import 'benchmarks/index.dart' show createBenchmark;

/// Contains the viewable state of the dashboard. (Immutable.)
class DashboardModel {
  final Map<String, pb.Report> savedReports;
  final Table table;
  final pb.Report latest;

  DashboardModel(this.savedReports, this.table, this.latest);

  DashboardModel withBaseline(String name) {
    var nextTable = table.withBaseline(name, savedReports[name]);
    return DashboardModel(savedReports, nextTable, latest);
  }

  DashboardModel withReport(pb.Report right) =>
      DashboardModel(savedReports, table, right);

  DashboardModel withTable(Table table) =>
      DashboardModel(savedReports, table, latest);

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
      Table._raw(suite, null, null, Set<pb.Request>.from(suite.requests));

  Table._raw(this.suite, this.baseline, this.report, this.selections) {
    Iterator it = report == null ? [].iterator : report.responses.iterator;
    for (var r in suite.requests) {
      var b = createBenchmark(r);
      pb.Sample baseline;
      if (it.moveNext()) {
        b.checkRequest(it.current.request);
        baseline = b.medianSample(it.current);
      }
      rows.add(Row(r, b, baseline, selected: this.selections.contains(r)));
    }
  }

  Table withBaseline(String baseline, pb.Report report) =>
      Table._raw(suite, baseline, report, selections);

  Table withAllSelected() {
    return Table._raw(
        suite, baseline, report, Set<pb.Request>.from(suite.requests));
  }

  Table withNoneSelected() {
    return Table._raw(suite, baseline, report, Set<pb.Request>());
  }

  Table withSelection(pb.Request request, bool selected) {
    var s = Set<pb.Request>.from(selections);
    if (selected) {
      s.add(request);
    } else {
      s.remove(request);
    }
    return Table._raw(suite, baseline, report, s);
  }
}

/// The parts of a row in the benchmark results table that don't change often.
class Row {
  final pb.Request request;
  final Benchmark benchmark;
  final pb.Sample baseline;
  final bool selected;
  Row(this.request, this.benchmark, this.baseline, {this.selected = true});

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
