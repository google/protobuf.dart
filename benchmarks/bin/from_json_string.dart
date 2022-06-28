// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf_benchmarks/readfile.dart';
import 'package:protobuf_benchmarks/generated/google_message1_proto2.pb.dart'
    as p2;
import 'package:protobuf_benchmarks/generated/google_message1_proto3.pb.dart'
    as p3;
import 'package:protobuf_benchmarks/generated/google_message2.pb.dart';

import 'package:benchmark_harness/benchmark_harness.dart';

class Benchmark extends BenchmarkBase {
  late final String _message1Proto2JsonString;
  late final String _message1Proto3JsonString;
  late final String _message2JsonString;

  Benchmark(String name, List<int> message1Proto2Input,
      List<int> message1Proto3Input, List<int> message2Input)
      : super(name) {
    _message1Proto2JsonString =
        p2.GoogleMessage1.fromBuffer(message1Proto2Input).writeToJson();
    _message1Proto3JsonString =
        p3.GoogleMessage1.fromBuffer(message1Proto3Input).writeToJson();
    _message2JsonString =
        GoogleMessage2.fromBuffer(message2Input).writeToJson();
  }

  @override
  void run() {
    p2.GoogleMessage1.fromJson(_message1Proto2JsonString);
    p3.GoogleMessage1.fromJson(_message1Proto3JsonString);
    GoogleMessage2.fromJson(_message2JsonString);
  }
}

void main() {
  List<int> message1Proto2Input =
      readfile('datasets/google_message1_proto2.pb');
  List<int> message1Proto3Input =
      readfile('datasets/google_message1_proto3.pb');
  List<int> message2Input = readfile('datasets/google_message2.pb');
  Benchmark('protobuf_from_json_string', message1Proto2Input,
          message1Proto3Input, message2Input)
      .report();
}