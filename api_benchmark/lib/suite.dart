// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf/protobuf.dart';

import 'benchmark.dart';
import 'benchmarks/index.dart' show createBenchmark;
import 'generated/benchmark.pb.dart' as pb;

/// Runs a benchmark suite, returning progress until done.
///
/// [samplesPerBatch] is the number of times a benchmark will be run
/// before going on to the next one. They will be executed round-robin
/// until they're all done.
/// [profiler] if supplied, each request will be profiled once.
Iterable<pb.Report> runSuite(List<pb.Request?> requests,
    {int samplesPerBatch = 1, Profiler? profiler}) sync* {
  // Create a blank report with one response per request.
  final report = pb.Report()..status = pb.Status.RUNNING;
  for (final request in requests) {
    final r = pb.Response()..request = request!;
    report.responses.add(r);
  }

  // Set up progress reports.
  var sampleCount = 0;
  var totalSamples = 0;
  for (final request in requests) {
    totalSamples += request!.samples;
  }
  pb.Report progress() {
    report.message = 'Running ($sampleCount/$totalSamples)';
    return report.deepCopy();
  }

  // Send first progress message before starting.
  yield progress();

  final benchmarks = <Benchmark>[];
  for (final r in report.responses) {
    benchmarks.add(createBenchmark(r.request));
  }

  // Collect the requested number of samples.
  while (sampleCount < totalSamples) {
    for (var i = 0; i < benchmarks.length; i++) {
      final b = benchmarks[i];
      final r = report.responses[i];
      var batchSize = r.request.samples - r.samples.length;
      if (batchSize == 0) continue;
      if (batchSize > samplesPerBatch) batchSize = samplesPerBatch;
      final p = r.samples.isEmpty ? profiler : null;
      for (final s in b.measure(r.request, batchSize, profiler: p)) {
        r.samples.add(s);
        sampleCount++;
        yield progress();
      }
    }
  }

  // Send final report.
  report.status = pb.Status.DONE;
  report.message = 'Done';
  yield report;
}
