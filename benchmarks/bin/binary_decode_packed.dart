// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:math';
import 'dart:typed_data';

import 'package:fixnum/fixnum.dart';
import 'package:protobuf_benchmarks/benchmark_base.dart';
import 'package:protobuf_benchmarks/generated/packed_fields.pb.dart';

PackedFields? sink;

class PackedInt32DecodingBenchmark extends BenchmarkBase {
  late final Uint8List encoded;

  PackedInt32DecodingBenchmark() : super('PackedInt32Decoding') {
    final rand = Random(123);
    final message = PackedFields();
    for (var i = 0; i < 1000000; i += 1) {
      message.packedInt32.add(rand.nextInt(2147483647));
    }
    encoded = message.writeToBuffer();
  }

  @override
  void run() {
    sink = PackedFields()..mergeFromBuffer(encoded);
  }
}

class PackedInt64DecodingBenchmark extends BenchmarkBase {
  late final Uint8List encoded;

  PackedInt64DecodingBenchmark() : super('PackedInt64Decoding') {
    final rand = Random(123);
    final message = PackedFields();
    for (var i = 0; i < 1000000; i += 1) {
      // Note: `Random` cannot generate more than the number below.
      message.packedInt64.add(Int64(rand.nextInt(4294967296)));
    }
    encoded = message.writeToBuffer();
  }

  @override
  void run() {
    sink = PackedFields()..mergeFromBuffer(encoded);
  }
}

class PackedUint32DecodingBenchmark extends BenchmarkBase {
  late final Uint8List encoded;

  PackedUint32DecodingBenchmark() : super('PackedUint32Decoding') {
    final rand = Random(123);
    final message = PackedFields();
    for (var i = 0; i < 1000000; i += 1) {
      message.packedUint32.add(rand.nextInt(4294967295));
    }
    encoded = message.writeToBuffer();
  }

  @override
  void run() {
    sink = PackedFields()..mergeFromBuffer(encoded);
  }
}

class PackedUint64DecodingBenchmark extends BenchmarkBase {
  late final Uint8List encoded;

  PackedUint64DecodingBenchmark() : super('PackedUint64Decoding') {
    final rand = Random(123);
    final message = PackedFields();
    for (var i = 0; i < 1000000; i += 1) {
      // Note: `Random` cannot generate more than the number below.
      message.packedUint64.add(Int64(rand.nextInt(4294967296)));
    }
    encoded = message.writeToBuffer();
  }

  @override
  void run() {
    sink = PackedFields()..mergeFromBuffer(encoded);
  }
}

class PackedSint32DecodingBenchmark extends BenchmarkBase {
  late final Uint8List encoded;

  PackedSint32DecodingBenchmark() : super('PackedSint32Decoding') {
    final rand = Random(123);
    final message = PackedFields();
    for (var i = 0; i < 1000000; i += 1) {
      message.packedSint32.add(rand.nextInt(2147483647));
    }
    encoded = message.writeToBuffer();
  }

  @override
  void run() {
    sink = PackedFields()..mergeFromBuffer(encoded);
  }
}

class PackedSint64DecodingBenchmark extends BenchmarkBase {
  late final Uint8List encoded;

  PackedSint64DecodingBenchmark() : super('PackedSint64Decoding') {
    final rand = Random(123);
    final message = PackedFields();
    for (var i = 0; i < 1000000; i += 1) {
      // Note: `Random` cannot generate more than the number below.
      message.packedSint64.add(Int64(rand.nextInt(4294967296)));
    }
    encoded = message.writeToBuffer();
  }

  @override
  void run() {
    sink = PackedFields()..mergeFromBuffer(encoded);
  }
}

class PackedBoolDecodingBenchmark extends BenchmarkBase {
  late final Uint8List encoded;

  PackedBoolDecodingBenchmark() : super('PackedBoolDecoding') {
    final rand = Random(123);
    final message = PackedFields();
    for (var i = 0; i < 1000000; i += 1) {
      message.packedBool.add(rand.nextBool());
    }
    encoded = message.writeToBuffer();
  }

  @override
  void run() {
    sink = PackedFields()..mergeFromBuffer(encoded);
  }
}

class PackedEnumDecodingBenchmark extends BenchmarkBase {
  late final Uint8List encoded;

  PackedEnumDecodingBenchmark() : super('PackedEnumDecoding') {
    final rand = Random(123);
    final message = PackedFields();
    final numEnums = Enum1.values.length;
    for (var i = 0; i < 1000000; i += 1) {
      message.packedEnum1.add(Enum1.values[rand.nextInt(numEnums)]);
    }
    encoded = message.writeToBuffer();
  }

  @override
  void setup() {
    // Decode different enums to prevent TFA from specializing enum decoding
    // code to one type.
    final rand = Random(123);
    final message = PackedFields();
    for (var i = 0; i < 100; i += 1) {
      message.packedEnum1.add(Enum1.values[rand.nextInt(Enum1.values.length)]);
    }
    for (var i = 0; i < 100; i += 1) {
      message.packedEnum2.add(Enum2.values[rand.nextInt(Enum2.values.length)]);
    }
    final encoded = message.writeToBuffer();
    final decoded = PackedFields()..mergeFromBuffer(encoded);
    if (decoded.packedEnum1.length != 100) {
      throw AssertionError('BUG');
    }
    if (decoded.packedEnum2.length != 100) {
      throw AssertionError('BUG');
    }
  }

  @override
  void run() {
    sink = PackedFields()..mergeFromBuffer(encoded);
  }
}

void main() {
  PackedInt32DecodingBenchmark().report();
  PackedInt64DecodingBenchmark().report();
  PackedUint32DecodingBenchmark().report();
  PackedUint64DecodingBenchmark().report();
  PackedSint32DecodingBenchmark().report();
  PackedSint64DecodingBenchmark().report();
  PackedBoolDecodingBenchmark().report();
  PackedEnumDecodingBenchmark().report();

  if (int.parse('1') == 0) print(sink);
}
