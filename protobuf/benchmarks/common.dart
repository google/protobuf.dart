// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: uri_has_not_been_generated,undefined_identifier

/// Common platform independent benchmark infrastructure that can run
/// both on the VM and when compiled to JavaScript.
library common;

import 'dart:typed_data';

import 'package:benchmark_harness/benchmark_harness.dart';
import 'package:protobuf/protobuf.dart';

import 'temp/benchmarks.pb.dart';
import 'temp/datasets/google_message1/proto2/benchmark_message1_proto2.pb.dart'
    as p2;
import 'temp/datasets/google_message1/proto3/benchmark_message1_proto3.pb.dart'
    as p3;
import 'temp/datasets/google_message2/benchmark_message2.pb.dart';
import 'temp/datasets/google_message3/benchmark_message3.pb.dart';
import 'temp/datasets/google_message4/benchmark_message4.pb.dart';

/// Represents a dataset, a list of protobufs payloads, used for benchmarking.
/// All payloads are instances of the same message.
/// Datasets are loaded from BenchmarkDataset proto (see benchmark.proto).
class Dataset {
  final String name;

  /// Functions that can deserialize all payloads in this dataset.
  final Factories factories;

  /// List of packed payloads, which can be deserialized using [factories].
  /// Used for binary deserialization benchmarks.
  final List<Uint8List> packed = <Uint8List>[];

  /// Messages deserialized from [packed] and then serialized back into JSON.
  /// Used for JSON serialization benchmarks.
  final List<String> asJson = <String>[];

  /// Messages deserialized from [packed]. Used in serialization benchmarks.
  final List<GeneratedMessage> unpacked = <GeneratedMessage>[];

  /// Create [Dataset] from a [BenchmarkDataset] proto.
  factory Dataset.fromBinary(List<int> binary) {
    final dataSet = BenchmarkDataset.fromBuffer(binary);

    final factories = Factories.forMessage(dataSet.messageName);
    final ds = Dataset._(dataSet.name, factories);

    for (var payload in dataSet.payload) {
      final bytes = Uint8List.fromList(payload);
      final msg = factories.fromBuffer(bytes);
      ds.packed.add(bytes);
      ds.unpacked.add(msg);
      ds.asJson.add(msg.writeToJson());
    }

    return ds;
  }

  Dataset._(this.name, this.factories);
}

typedef FromBufferFactory = dynamic Function(List<int> binary);
typedef FromJsonFactory = dynamic Function(String json);

class Factories {
  final FromBufferFactory fromBuffer;
  final FromJsonFactory fromJson;

  static Factories forMessage(String name) =>
      _factories[name] ?? (throw 'Unsupported message: ${name}');

  /// Mapping between [BenchmarkProto.messageName] and corresponding
  /// deserialization factories.
  static final _factories = {
    'benchmarks.proto2.GoogleMessage1': Factories._(
        fromBuffer: (List<int> binary) => p2.GoogleMessage1.fromBuffer(binary),
        fromJson: (String json) => p2.GoogleMessage1.fromJson(json)),
    'benchmarks.proto3.GoogleMessage1': Factories._(
        fromBuffer: (List<int> binary) => p3.GoogleMessage1.fromBuffer(binary),
        fromJson: (String json) => p3.GoogleMessage1.fromJson(json)),
    'benchmarks.proto2.GoogleMessage2': Factories._(
        fromBuffer: (List<int> binary) => GoogleMessage2.fromBuffer(binary),
        fromJson: (String json) => GoogleMessage2.fromJson(json)),
    'benchmarks.google_message3.GoogleMessage3': Factories._(
        fromBuffer: (List<int> binary) => GoogleMessage3.fromBuffer(binary),
        fromJson: (String json) => GoogleMessage3.fromJson(json)),
    'benchmarks.google_message4.GoogleMessage4': Factories._(
        fromBuffer: (List<int> binary) => GoogleMessage4.fromBuffer(binary),
        fromJson: (String json) => GoogleMessage4.fromJson(json)),
  };

  Factories._({this.fromBuffer, this.fromJson});
}

/// Base for all protobuf benchmarks.
abstract class _ProtobufBenchmark extends BenchmarkBase {
  final List<Dataset> datasets;

  _ProtobufBenchmark(this.datasets, String name) : super(name);
}

/// Binary deserialization benchmark.
class FromBinaryBenchmark extends _ProtobufBenchmark {
  FromBinaryBenchmark(datasets) : super(datasets, 'FromBinary');

  @override
  void run() {
    for (var i = 0; i < datasets.length; i++) {
      final ds = datasets[i];
      final f = ds.factories.fromBuffer;
      for (var j = 0; j < ds.packed.length; j++) {
        f(ds.packed[j]);
      }
    }
  }
}

/// Binary serialization benchmark.
class ToBinaryBenchmark extends _ProtobufBenchmark {
  ToBinaryBenchmark(datasets) : super(datasets, 'ToBinary');

  @override
  void run() {
    for (var i = 0; i < datasets.length; i++) {
      final ds = datasets[i];
      for (var j = 0; j < ds.unpacked.length; j++) {
        ds.unpacked[j].writeToBuffer();
      }
    }
  }
}

/// JSON deserialization benchmark.
class FromJsonBenchmark extends _ProtobufBenchmark {
  FromJsonBenchmark(datasets) : super(datasets, 'FromJson');

  @override
  void run() {
    for (var i = 0; i < datasets.length; i++) {
      final ds = datasets[i];
      final f = ds.factories.fromJson;
      for (var j = 0; j < ds.asJson.length; j++) {
        f(ds.asJson[j]);
      }
    }
  }
}

/// JSON serialization benchmark.
class ToJsonBenchmark extends _ProtobufBenchmark {
  ToJsonBenchmark(datasets) : super(datasets, 'ToJson');

  @override
  void run() {
    for (var i = 0; i < datasets.length; i++) {
      final ds = datasets[i];
      for (var j = 0; j < ds.unpacked.length; j++) {
        ds.unpacked[j].writeToJson();
      }
    }
  }
}
