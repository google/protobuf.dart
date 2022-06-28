// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:benchmark_harness/benchmark_harness.dart';

/// `benchmark_harness-2` reports 10x the time the benchmarked code takes. This
/// overrides the `measure` method to divide the result by 10.
abstract class QueryBenchmark extends BenchmarkBase {
  QueryBenchmark(String name) : super(name);

  @override
  double measure() {
    var result = super.measure();
    return result / 10;
  }
}
