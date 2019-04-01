// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.suite;

import 'package:api_benchmark/benchmark.dart';
import 'benchmarks/index.dart' show createBenchmark;
import 'generated/benchmark.pb.dart' as pb;

/// Runs a benchmark suite, returning progress until done.
///
/// [samplesPerBatch] is the number of times a benchmark will be run
/// before going on to the next one. They will be executed round-robin
/// until they're all done.
/// [profiler] if supplied, each request will be profiled once.
Iterable<pb.Report> runSuite(List<pb.Request> requests,
    {samplesPerBatch = 1, Profiler profiler}) sync* {
  // Create a blank report with one response per request.
  var report = pb.Report()..status = pb.Status.RUNNING;
  for (var request in requests) {
    var r = pb.Response()..request = request;
    report.responses.add(r);
  }

  // Set up progress reports.
  int sampleCount = 0;
  int totalSamples = 0;
  for (var request in requests) {
    totalSamples += request.samples;
  }
  pb.Report progress() {
    report.message = "Running ($sampleCount/$totalSamples)";
    return report.clone();
  }

  // Send first progress message before starting.
  yield progress();

  var benchmarks = <Benchmark>[];
  for (var r in report.responses) {
    benchmarks.add(createBenchmark(r.request));
  }

  // Collect the requested number of samples.
  while (sampleCount < totalSamples) {
    for (var i = 0; i < benchmarks.length; i++) {
      var b = benchmarks[i];
      var r = report.responses[i];
      int batchSize = r.request.samples - r.samples.length;
      if (batchSize == 0) continue;
      if (batchSize > samplesPerBatch) batchSize = samplesPerBatch;
      var p = r.samples.isEmpty ? profiler : null;
      for (pb.Sample s in b.measure(r.request, batchSize, profiler: p)) {
        r.samples.add(s);
        sampleCount++;
        yield progress();
      }
    }
  }

  // Send final report.
  report.status = pb.Status.DONE;
  report.message = "Done";
  yield report;
}
