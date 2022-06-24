// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// JS protobuf serialization/deserialization benchmark.
//
// Loads benchmark [Dataset]s from the predefined list of files
// using D8's builtin readbuffer.

import 'package:protobuf_benchmarks/common.dart';

import 'dart:typed_data';

import 'package:js/js.dart';

/// Read the file at the given [path] and return its contents in
/// an [ByteBuffer].
@JS()
external ByteBuffer readbuffer(String path);

/// Read the [file] and return its contents in
/// a Uint8List.
Uint8List readAsBytesSync(String file) {
  return Uint8List.view(readbuffer(file));
}

void main() {
  final datasets = datasetFiles
      .map((file) => Dataset.fromBinary(readAsBytesSync(file)))
      .toList(growable: false);

  run(datasets);
}
