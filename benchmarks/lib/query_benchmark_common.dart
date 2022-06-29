// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:benchmark_harness/benchmark_harness.dart';

/// Use this class in the old "query_benchmark" benchmarks.
///
/// `benchmark_harness-2` reports 10x the time the benchmarked code takes
/// (https://github.com/dart-lang/benchmark_harness/issues/30). Because
/// query_benchmark previously did not use `benchmark_harness`, when we start
/// using `benchmark_harness` we get 10x larger benchmark results. To avoid
/// this, this class overrides the relevant [BenchmarkBase] method(s) and
/// divides the result by 10 before reporting, making query_benchmark numbers
/// same as before.
abstract class QueryBenchmark extends BenchmarkBase {
  QueryBenchmark(String name) : super(name);

  @override
  double measure() {
    var result = super.measure();
    return result / 10;
  }
}
