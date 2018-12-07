// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:query_benchmark/generated/f0.pb.dart' as f0;
import 'package:query_benchmark/benchmark.dart';
import 'package:query_benchmark/readfile.dart';

main() {
  String path = const String.fromEnvironment('testfile') ?? 'testdata/500.pb';

  List<int> encoded = readfile(path);
  print(
    formatReport(
      title: 'protobuf_decode',
      duration: measure(() => f0.A0.fromBuffer(encoded)),
    ),
  );
}
