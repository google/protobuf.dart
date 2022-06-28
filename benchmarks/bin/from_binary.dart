// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf_benchmarks/readfile.dart';
import 'package:protobuf_benchmarks/generated/google_message1_proto2.pb.dart'
    as p2;
import 'package:protobuf_benchmarks/generated/google_message1_proto3.pb.dart'
    as p3;
import 'package:protobuf_benchmarks/generated/google_message2.pb.dart';

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';

class Benchmark extends BenchmarkBase {
  late final Uint8List _message1Proto2Input;
  late final Uint8List _message1Proto3Input;
  late final Uint8List _message2Input;

  Benchmark(String name, List<int> message1Proto2Input,
      List<int> message1Proto3Input, List<int> message2Input)
      : super(name) {
    _message1Proto2Input = Uint8List.fromList(message1Proto2Input);
    _message1Proto3Input = Uint8List.fromList(message1Proto3Input);
    _message2Input = Uint8List.fromList(message2Input);
  }

  @override
  void run() {
    p2.GoogleMessage1.fromBuffer(_message1Proto2Input);
    p3.GoogleMessage1.fromBuffer(_message1Proto3Input);
    GoogleMessage2.fromBuffer(_message2Input);
  }
}

void main() {
  List<int> message1Proto2Input =
      readfile('datasets/google_message1_proto2.pb');
  List<int> message1Proto3Input =
      readfile('datasets/google_message1_proto3.pb');
  List<int> message2Input = readfile('datasets/google_message2.pb');
  Benchmark('protobuf_from_binary', message1Proto2Input, message1Proto3Input,
          message2Input)
      .report();
}