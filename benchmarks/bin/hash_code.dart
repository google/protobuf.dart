// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf_benchmarks/benchmark_base.dart';
import 'package:protobuf_benchmarks/generated/google_message1_proto2.pb.dart'
    as p2;
import 'package:protobuf_benchmarks/generated/google_message1_proto3.pb.dart'
    as p3;
import 'package:protobuf_benchmarks/generated/google_message2.pb.dart';
import 'package:protobuf_benchmarks/readfile.dart';

class Benchmark extends BenchmarkBase {
  final p2.GoogleMessage1 _message1Proto2;
  final p3.GoogleMessage1 _message1Proto3;
  final GoogleMessage2 _message2;

  Benchmark(super.name, List<int> message1Proto2Input,
      List<int> message1Proto3Input, List<int> message2Input)
      : _message1Proto2 = p2.GoogleMessage1.fromBuffer(message1Proto2Input),
        _message1Proto3 = p3.GoogleMessage1.fromBuffer(message1Proto3Input),
        _message2 = GoogleMessage2.fromBuffer(message2Input);

  @override
  void run() {
    _message1Proto2.hashCode;
    _message1Proto3.hashCode;
    _message2.hashCode;
  }
}

void main() {
  final List<int> message1Proto2Input =
      readfile('datasets/google_message1_proto2.pb');
  final List<int> message1Proto3Input =
      readfile('datasets/google_message1_proto3.pb');
  final List<int> message2Input = readfile('datasets/google_message2.pb');
  Benchmark(
          'hash_code', message1Proto2Input, message1Proto3Input, message2Input)
      .report();
}
