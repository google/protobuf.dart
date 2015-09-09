// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.dashboard_model;

import 'generated/benchmark.pb.dart' as pb;

import 'report.dart' show medianSample;

/// Contains the viewable state of the dashboard. (Immutable.)
class DashboardModel {
  final Map<String, pb.Report> savedReports;
  // The name of the saved report to display.
  final String baselineName;

  final pb.Report latest;

  DashboardModel(this.savedReports, this.baselineName, this.latest);

  DashboardModel withBaseline(String name) =>
      new DashboardModel(savedReports, name, latest);

  DashboardModel withReport(pb.Report right) =>
      new DashboardModel(savedReports, baselineName, right);

  /// Returns true if the Run button should be enabled.
  bool get canRun => !latest.hasStatus() || latest.status != pb.Status.RUNNING;

  /// Returns the samples to use for comparison.
  BaselineSamples getBaselineSamples() {
    var r = savedReports[baselineName];
    if (r == null) return new BaselineSamples([]);
    return new BaselineSamples(r.responses);
  }
}

class BaselineSamples {
  final samples = <String, pb.Sample>{};
  BaselineSamples(List<pb.Response> responses) {
    for (var response in responses) {
      samples[_key(response.request)] = medianSample(response);
    }
  }

  pb.Sample getSample(pb.Request request) => samples[_key(request)];

  String _key(pb.Request request) =>
    request.id.name + "-" + request.params.toString();
}
