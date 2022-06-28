// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf_benchmarks/generated/f0.pb.dart' as f0;
import 'package:protobuf_benchmarks/query_benchmark_common.dart';
import 'package:protobuf_benchmarks/readfile.dart';

class Benchmark extends QueryBenchmark {
  final f0.A0 _input;

  Benchmark(String name, List<int> input)
      : _input = f0.A0.fromBuffer(input),
        super(name);

  @override
  void run() {
    _input.writeToJson();
  }
}

void main() {
  List<int> encoded = readfile('datasets/query_benchmark.pb');
  Benchmark('protobuf_encode_json', encoded).report();
}
