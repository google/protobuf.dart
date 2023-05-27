// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf_benchmarks/benchmark_base.dart';
import 'package:protobuf_benchmarks/generated/f0.pb.dart' as f0;
import 'package:protobuf_benchmarks/readfile.dart';

class Benchmark extends BenchmarkBase {
  final String _input;

  Benchmark(super.name, List<int> input)
      : _input = f0.A0.fromBuffer(input).writeToJson();

  @override
  void run() {
    f0.A0.fromJson(_input);
  }
}

void main() {
  final List<int> encoded = readfile('datasets/query_benchmark.pb');
  Benchmark('query_decode_json', encoded).report();
}
