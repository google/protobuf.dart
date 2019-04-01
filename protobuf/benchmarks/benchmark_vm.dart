// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// VM protobuf serialization/deserialization benchmark.
///
/// Finds all files matching dataset*.pb pattern and loads benchmark
/// [Dataset]s from them.
library benchmark_vm;

import 'dart:io';

import 'common.dart';

void main(List<String> arguments) {
  final datasetPattern = RegExp(r'dataset\.[._\w]*\.pb$');
  final datasets = Directory(Platform.script.resolve('..').toFilePath())
      .listSync(recursive: true)
      .where((file) => datasetPattern.hasMatch(file.path))
      .map((file) => Dataset.fromBinary((file as File).readAsBytesSync()))
      .toList(growable: false);

  FromBinaryBenchmark(datasets).report();
  ToBinaryBenchmark(datasets).report();
  ToJsonBenchmark(datasets).report();
  FromJsonBenchmark(datasets).report();
}
