// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show jsonDecode, jsonEncode;

import 'package:protobuf_benchmarks/benchmark_base.dart';
import 'package:protobuf_benchmarks/generated/google_message1_proto2.pb.dart'
    as p2;
import 'package:protobuf_benchmarks/generated/google_message1_proto3.pb.dart'
    as p3;
import 'package:protobuf_benchmarks/generated/google_message2.pb.dart';
import 'package:protobuf_benchmarks/readfile.dart';

class Benchmark extends BenchmarkBase {
  final String _message1Proto2Proto3JsonString;
  final String _message1Proto3Proto3JsonString;
  final String _message2Proto3JsonString;

  Benchmark(super.name, List<int> message1Proto2Input,
      List<int> message1Proto3Input, List<int> message2Input)
      : _message1Proto2Proto3JsonString = jsonEncode(
            p2.GoogleMessage1.fromBuffer(message1Proto2Input).toProto3Json()),
        _message1Proto3Proto3JsonString = jsonEncode(
            p3.GoogleMessage1.fromBuffer(message1Proto3Input).toProto3Json()),
        _message2Proto3JsonString =
            jsonEncode(GoogleMessage2.fromBuffer(message2Input).toProto3Json());

  @override
  void run() {
    p2.GoogleMessage1.create()
        .mergeFromProto3Json(jsonDecode(_message1Proto2Proto3JsonString));
    p3.GoogleMessage1.create()
        .mergeFromProto3Json(jsonDecode(_message1Proto3Proto3JsonString));
    GoogleMessage2.create()
        .mergeFromProto3Json(jsonDecode(_message2Proto3JsonString));
  }
}

void main() {
  final List<int> message1Proto2Input =
      readfile('datasets/google_message1_proto2.pb');
  final List<int> message1Proto3Input =
      readfile('datasets/google_message1_proto3.pb');
  final List<int> message2Input = readfile('datasets/google_message2.pb');
  Benchmark('from_proto3_json_string', message1Proto2Input, message1Proto3Input,
          message2Input)
      .report();
}
