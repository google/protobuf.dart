// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark;

import 'generated/benchmark.pb.dart' as pb;

typedef Benchmark CreateBenchmarkFunc(pb.Request request);

// Describes how to construct a benchmark.
class BenchmarkType {
  final pb.BenchmarkID id;
  final CreateBenchmarkFunc create;
  const BenchmarkType(this.id, this.create);
}

/// A benchmark that also reports the counts for various operations.
/// (A modification of BenchmarkBase from the benchmark_harness library.)
abstract class Benchmark {
  static const int _DEFAULT_REPS = 10;

  final pb.BenchmarkID id;
  Benchmark(this.id);

  String get summary => id.name;

  pb.Request makeRequest(
          [Duration duration = const Duration(seconds: 1), int samples = 3]) =>
      new pb.Request()
        ..id = id
        ..params = makeParams()
        ..duration = duration.inMilliseconds
        ..samples = samples;

  pb.Params makeParams();

  /// Runs a benchmark for the requested number of times.
  ///
  /// The length of each iterator is the number of samples
  /// requested. If you create more than one iterator, each
  /// iterator runs benchmarks independently and will return
  /// different samples.
  Iterable<pb.Sample> measure(pb.Request r) sync* {
    if (r.id != id) {
      throw new ArgumentError("invalid benchmark id: ${r.id}");
    }
    if (r.params != makeParams()) {
      throw new ArgumentError("parameters don't match: ${r.params}");
    }

    int sampleMillis = r.duration;
    int samples = r.samples;
    setup();

    for (int i = 0; i < samples; i++) {
      yield _measureOnce(sampleMillis);
    }
    teardown();
  }

  pb.Sample _measureOnce(int sampleMillis) {
    // Warmup for at least 100ms. Discard result.
    _measureFor(() {
      warmup();
      return 1;
    }, 100);

    var sample = _measureFor(exercise, sampleMillis);
    setCounts(sample);
    return sample;
  }

  // Lifecycle methods

  /// Called before the benchmark runs. (Not measured.)
  void setup() {}

  /// Runs a short version of the benchmark. By default invokes [run] once.
  /// (Not measured.)
  void warmup() {
    run();
  }

  /// Exercises the code and returns the number of repetitions.
  int exercise() {
    for (int i = 0; i < _DEFAULT_REPS; i++) {
      run();
    }
    return _DEFAULT_REPS;
  }

  /// The code being measured.
  void run();

  /// Sets any counters in the sample.
  /// (Clears them for the next run if necessary.)
  void setCounts(pb.Sample m) {}

  /// Called after the benchmark finishes.
  void teardown() {}

  @override
  toString() => summary;

  /// Measures the average time spent per repetition.
  ///
  /// Executes [runner] repeatedly until [minimumMillis] has been reached.
  /// [runner] should return the number of times it ran the benchmark.
  static pb.Sample _measureFor(Function runner, int minimumMillis) {
    int minimumMicros = minimumMillis * 1000;
    int reps = 0;
    int elapsed = 0;
    Stopwatch watch = new Stopwatch()..start();
    while (elapsed < minimumMicros) {
      reps += runner();
      elapsed = watch.elapsedMicroseconds;
    }
    return new pb.Sample()
      ..duration = elapsed
      ..loopCount = reps
      ..counts = new pb.Counts();
  }
}
