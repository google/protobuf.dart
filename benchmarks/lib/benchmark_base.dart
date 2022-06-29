// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:benchmark_harness/benchmark_harness.dart' as bh;

/// A subclass of [bh.BenchmarkBase] to work around
/// https://github.com/dart-lang/benchmark_harness/issues/30.
///
/// Overrides the relevant [bh.BenchmarkBase] method(s) to report accurate
/// results, rather than 10x the actual results.
abstract class BenchmarkBase extends bh.BenchmarkBase {
  BenchmarkBase(String name) : super(name);

  @override
  double measure() {
    return super.measure() / 10;
  }
}
