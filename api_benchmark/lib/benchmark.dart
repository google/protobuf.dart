// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'generated/benchmark.pb.dart' as pb;

typedef CreateBenchmarkFunc = Benchmark Function(pb.Request request);

// Describes how to construct a benchmark.
class BenchmarkType {
  final pb.BenchmarkID id;
  final CreateBenchmarkFunc create;
  const BenchmarkType(this.id, this.create);
}

abstract class Profiler {
  void startProfile(pb.Request request);
  void endProfile(pb.Sample s);
}

/// A benchmark that also reports the counts for various operations.
/// (A modification of BenchmarkBase from the benchmark_harness library.)
abstract class Benchmark {
  static const int _defaultReps = 10;

  final pb.BenchmarkID id;
  Benchmark(this.id);

  String get summary => id.name;

  pb.Request makeRequest(
          [Duration duration = const Duration(milliseconds: 50),
          int samples = 20]) =>
      pb.Request()
        ..id = id
        ..params = makeParams()
        ..duration = duration.inMilliseconds
        ..samples = samples;

  pb.Params makeParams();

  /// Runs a benchmark for the requested number of times.
  ///
  /// The length of each iterator is the number of [samples]
  /// requested. If you create more than one iterator, each
  /// iterator runs benchmarks independently and will return
  /// different samples.
  ///
  /// If a [profiler] is provided, it will be used for one extra sample.
  /// (Not included in results.)
  Iterable<pb.Sample> measure(pb.Request r, int samples,
      {Profiler? profiler}) sync* {
    checkRequest(r);

    final sampleMillis = r.duration;
    setup();

    for (var i = 0; i < samples; i++) {
      yield _measureOnce(sampleMillis);
    }

    if (profiler != null) {
      profiler.startProfile(r);
      final s = _measureOnce(sampleMillis);
      profiler.endProfile(s);
    }

    teardown();
  }

  void checkRequest(pb.Request r) {
    if (r.id != id) {
      throw ArgumentError('invalid benchmark id: ${r.id}');
    }
    if (r.params != makeParams()) {
      throw ArgumentError("parameters don't match: ${r.params}");
    }
  }

  pb.Sample _measureOnce(int sampleMillis) {
    // Warmup for at least 100ms. Discard result.
    _measureFor(() {
      warmup();
      return 1;
    }, 100);

    final sample = _measureFor(exercise, sampleMillis);
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
    for (var i = 0; i < _defaultReps; i++) {
      run();
    }
    return _defaultReps;
  }

  /// The code being measured.
  void run();

  /// Sets any counters in the sample.
  /// (Clears them for the next run if necessary.)
  void setCounts(pb.Sample m) {}

  /// Called after the benchmark finishes.
  void teardown() {}

  String summarizeResponse(pb.Response r) {
    checkRequest(r.request);

    final prefix = summary.padRight(39);
    final sampleCount = r.samples.length.toStringAsFixed(0).padLeft(2);
    final median = measureSample(medianSample(r)).toStringAsFixed(0).padLeft(4);
    final max = measureSample(maxSample(r)).toStringAsFixed(0).padLeft(4);

    return '$prefix samples: $sampleCount'
        ' median: $median max: $max $measureSampleUnits';
  }

  /// Returns the sample with the median measurement.
  pb.Sample? medianSample(pb.Response? response) {
    if (response == null || response.samples.isEmpty) return null;
    final samples = [...response.samples];
    samples.sort((a, b) {
      return measureSample(a).compareTo(measureSample(b));
    });
    final index = samples.length ~/ 2;
    return samples[index];
  }

  /// Returns the sample with the highest measurement.
  pb.Sample? maxSample(pb.Response? response) {
    if (response == null) return null;
    pb.Sample? best;
    for (final s in response.samples) {
      best ??= s;
      if (measureSample(best) < measureSample(s)) {
        best = s;
      }
    }
    return best;
  }

  double measureSample(pb.Sample? s);

  String get measureSampleUnits;

  @override
  String toString() => summary;

  /// Measures the average time spent per repetition.
  ///
  /// Executes [runner] repeatedly until [minimumMillis] has been reached.
  /// [runner] should return the number of times it ran the benchmark.
  static pb.Sample _measureFor(int Function() runner, int minimumMillis) {
    final minimumMicros = minimumMillis * 1000;
    var reps = 0;
    var elapsed = 0;
    final watch = Stopwatch()..start();
    while (elapsed < minimumMicros) {
      reps += runner();
      elapsed = watch.elapsedMicroseconds;
    }
    return pb.Sample()
      ..duration = elapsed
      ..loopCount = reps
      ..counts = pb.Counts();
  }
}

double int32ReadsPerMillisecond(pb.Sample? s) {
  if (s == null || !s.counts.hasInt32Reads() || !s.hasDuration()) return 0.0;
  return s.counts.int32Reads * 1000 / s.duration;
}

double int64ReadsPerMillisecond(pb.Sample? s) {
  if (s == null || !s.counts.hasInt64Reads() || !s.hasDuration()) return 0.0;
  return s.counts.int64Reads * 1000 / s.duration;
}

double stringReadsPerMillisecond(pb.Sample? s) {
  if (s == null || !s.counts.hasStringReads() || !s.hasDuration()) return 0.0;
  return s.counts.stringReads * 1000 / s.duration;
}

double stringWritesPerMillisecond(pb.Sample? s) {
  if (s == null || !s.counts.hasStringWrites() || !s.hasDuration()) return 0.0;
  return s.counts.stringWrites * 1000 / s.duration;
}
