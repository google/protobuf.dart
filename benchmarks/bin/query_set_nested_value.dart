// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf/protobuf.dart';
import 'package:protobuf_benchmarks/benchmark_base.dart';
import 'package:protobuf_benchmarks/generated/f0.pb.dart' as f0;
import 'package:protobuf_benchmarks/generated/f19.pb.dart' as f19;
import 'package:protobuf_benchmarks/generated/f2.pb.dart' as f2;
import 'package:protobuf_benchmarks/readfile.dart';

class Benchmark extends BenchmarkBase {
  final f0.A0 _input;

  Benchmark(super.name, List<int> input)
      : _input = f0.A0.fromBuffer(input)..freeze();

  @override
  void run() {
    // ignore: unused_result
    _input.rebuild((f0.A0 a0Builder) {
      a0Builder.a4.last = a0Builder.a4.last.rebuild((f2.A1 a1builder) {
        a1builder.a378 = a1builder.a378
            .rebuild((f19.A220 a220builder) => a220builder.a234 = 'new_value');
      });
    });
  }
}

void main() {
  final List<int> encoded = readfile('datasets/query_benchmark.pb');
  Benchmark('query_set_nested_value', encoded).report();
}
