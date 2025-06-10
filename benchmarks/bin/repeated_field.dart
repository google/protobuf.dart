// Copyright (c) 2024, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf_benchmarks/benchmark_base.dart';
import 'package:protobuf_benchmarks/generated/f12.pb.dart' as f12;
import 'package:protobuf_benchmarks/generated/google_message2.pb.dart';

class RepeatedBenchmark extends BenchmarkBase {
  final Uint8List _buffer;

  RepeatedBenchmark(super.name, GoogleMessage2 message)
      : _buffer = message.writeToBuffer();

  @override
  void run() => GoogleMessage2.fromBuffer(_buffer);
}

class RepeatedEnumBenchmark extends BenchmarkBase {
  final Uint8List _buffer;

  RepeatedEnumBenchmark(super.name, f12.A58 message)
      : _buffer = message.writeToBuffer();

  @override
  void run() => f12.A58.fromBuffer(_buffer);
}

void main() {
  const kSize = 500000;

  RepeatedBenchmark(
    'repeated_int64',
    GoogleMessage2(field130: List<Int64>.generate(kSize, Int64.new)),
  ).report();

  RepeatedBenchmark(
    'repeated_string',
    GoogleMessage2(field128: List<String>.generate(kSize, (i) => i.toString())),
  ).report();

  RepeatedEnumBenchmark(
    'repeated_enum',
    f12.A58(a306: List<f12.A322>.generate(kSize, (_) => f12.A322.A324)),
  ).report();
}
