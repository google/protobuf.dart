// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf_benchmarks/generated/f0.pb.dart' as f0;
import 'package:protobuf_benchmarks/readfile.dart';

import 'package:benchmark_harness/benchmark_harness.dart';

class Benchmark extends BenchmarkBase {
  late final f0.A0 _input;

  Benchmark(String name, List<int> input) : super(name) {
    _input = f0.A0.fromBuffer(input);
  }

  @override
  void run() {
    _input.writeToBuffer();
  }
}

void main() {
  List<int> encoded = readfile('datasets/query_benchmark.pb');
  Benchmark('protobuf_encode', encoded).report();
}
