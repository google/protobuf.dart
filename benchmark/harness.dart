// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library harness;

/// A benchmark that reports its results in units/second.
/// (A modification of BenchmarkBase from the benchmark_harness library.)
abstract class ThroughputBenchmark {
  static const int _DEFAULT_REPS = 10;

  final String name;
  ThroughputBenchmark(this.name);

  /// The number of units read or written per run.
  double get unitsPerRun;

  /// The name of the units used.
  String get units;

  // Lifecycle methods

  /// Called before the benchmark runs. (Not measured.)
  void setup() {}

  /// Runs a short version of the benchmark. By default invokes [run] once. (Not measured.)
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

  /// Called after the benchmark runs. (Not measured.)
  void teardown() {}

  /// Measures the average time spent per repetition.
  ///
  /// Executes [runner] repeatedly until [minimumMillis] has been reached.
  /// [runner] should return the number of times it ran the benchmark.
  static Duration measureFor(Function runner, int minimumMillis) {
    int minimumMicros = minimumMillis * 1000;
    int reps = 0;
    Stopwatch watch = new Stopwatch();
    watch.start();
    int elapsed = 0;
    while (elapsed < minimumMicros) {
      reps += runner();
      elapsed = watch.elapsedMicroseconds;
    }
    return new Duration(microseconds: elapsed ~/ reps);
  }

  /// Runs the benchmark.
  ///
  /// Returns the average time spent per run() call.
  /// (Measured in wall-clock time.)
  Duration measure() {
    setup();

    // Warmup for at least 100ms. Discard result.
    measureFor(() {
      warmup();
      return 1;
    }, 100);

    // Run the benchmark for at least 2000ms.
    int runner() => exercise();
    Duration result = measureFor(runner, 2000);

    teardown();
    return result;
  }

  void report() {
    Duration timePerRun = measure();
    int unitsPerSecond = unitsPerRun * 1000000.0 ~/ timePerRun.inMicroseconds;
    print("$name time: ${timePerRun.inMicroseconds} us,"
        " throughput: $unitsPerSecond $units/sec");
  }
}
