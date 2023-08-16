// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:protobuf_benchmarks/benchmark_base.dart';
import 'package:protobuf_benchmarks/generated/google_message1_proto2.pb.dart'
    as p2;
import 'package:protobuf_benchmarks/generated/google_message1_proto3.pb.dart'
    as p3;
import 'package:protobuf_benchmarks/generated/google_message2.pb.dart';
import 'package:protobuf_benchmarks/readfile.dart';

class Benchmark extends BenchmarkBase {
  final Uint8List _message1Proto2Input;
  final Uint8List _message1Proto3Input;
  final Uint8List _message2Input;

  Benchmark(super.name, List<int> message1Proto2Input,
      List<int> message1Proto3Input, List<int> message2Input)
      : _message1Proto2Input = Uint8List.fromList(message1Proto2Input),
        _message1Proto3Input = Uint8List.fromList(message1Proto3Input),
        _message2Input = Uint8List.fromList(message2Input);

  @override
  void run() {
    p2.GoogleMessage1.fromBuffer(_message1Proto2Input);
    p3.GoogleMessage1.fromBuffer(_message1Proto3Input);
    GoogleMessage2.fromBuffer(_message2Input);
  }
}

void main() {
  final List<int> message1Proto2Input =
      readfile('datasets/google_message1_proto2.pb');
  final List<int> message1Proto3Input =
      readfile('datasets/google_message1_proto3.pb');
  final List<int> message2Input = readfile('datasets/google_message2.pb');
  Benchmark('from_binary', message1Proto2Input, message1Proto3Input,
          message2Input)
      .report();
}
