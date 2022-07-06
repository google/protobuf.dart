// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:benchmark_harness/benchmark_harness.dart' as bh;

/// A subclass of [bh.BenchmarkBase] with two changes:
///
/// 1. Work around https://github.com/dart-lang/benchmark_harness/issues/30 by
///    dividing the result by 10.
///
/// 2. Report the results as "RunTimeRaw" instead of "RunTime". What
///    benchmark_harness calls "RunTime" is called "RunTimeRaw" in Golem.
///
abstract class BenchmarkBase extends bh.BenchmarkBase {
  BenchmarkBase(String name) : super(name, emitter: const _ResultPrinter());

  @override
  double measure() {
    return super.measure() / 10;
  }
}

class _ResultPrinter implements bh.ScoreEmitter {
  const _ResultPrinter() : super();

  @override
  void emit(String testName, double value) {
    // Same as the default, but prints "RunTimeRaw" instead of "RunTime"
    print('$testName(RunTimeRaw): $value us.');
  }
}
