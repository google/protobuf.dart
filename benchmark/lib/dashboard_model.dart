// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.dashboard_model;

import 'generated/benchmark.pb.dart' as pb;

import 'benchmark.dart' show Benchmark;
import 'suite.dart' show createBenchmark;

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

  /// Returns true if the Run button should be enabled.
  bool get canRun => !latest.hasStatus() || latest.status != pb.Status.RUNNING;
}

/// The parts of the benchmark results table that don't change often.
class Table {
  final pb.Suite suite;
  final String baseline;
  final rows = <Row>[];

  Table(this.suite, [this.baseline, List<pb.Response> responses = const []]) {
    var it = responses.iterator;
    for (var r in suite.requests) {
      var b = createBenchmark(r);
      pb.Sample baseline;
      if (it.moveNext()) {
        b.checkRequest(it.current.request);
        baseline = b.medianSample(it.current);
      }
      rows.add(new Row(r, b, baseline));
    }
  }

  Table withBaseline(String baseline, pb.Report baselineReport) =>
      new Table(suite, baseline, baselineReport.responses);
}

/// The parts of a row in the benchmark results table that don't change often.
class Row {
  final pb.Request request;
  final Benchmark benchmark;
  final pb.Sample baseline;
  Row(this.request, this.benchmark, this.baseline);
}
