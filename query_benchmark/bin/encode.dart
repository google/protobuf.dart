// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:query_benchmark/benchmark.dart';
import 'package:query_benchmark/generated/f0.pb.dart' as f0;
import 'package:query_benchmark/readfile.dart';

main() {
  final path =
      const String.fromEnvironment('testfile', defaultValue: 'testdata/500.pb');

  List<int> encoded = readfile(path);
  f0.A0 a = f0.A0.fromBuffer(encoded);
  print(
    formatReport(
      title: 'protobuf_encode',
      duration: measure(() => a.writeToBuffer()),
    ),
  );
}
