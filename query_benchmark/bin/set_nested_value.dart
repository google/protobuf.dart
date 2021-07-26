// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf/protobuf.dart';
import 'package:query_benchmark/benchmark.dart';
import 'package:query_benchmark/generated/f0.pb.dart' as f0;
import 'package:query_benchmark/generated/f19.pb.dart' as f19;
import 'package:query_benchmark/generated/f2.pb.dart' as f2;
import 'package:query_benchmark/readfile.dart';

main() {
  final path =
      const String.fromEnvironment('testfile', defaultValue: 'testdata/500.pb');

  List<int> encoded = readfile(path);
  f0.A0 a = f0.A0.fromBuffer(encoded)..freeze();
  print(
    formatReport(
      title: 'protobuf_decode',
      duration: measure(() => a.rebuild((f0.A0 a0Builder) {
            a0Builder.a4.last = a0Builder.a4.last.rebuild((f2.A1 a1builder) {
              a1builder.a378.rebuild(
                  (f19.A220 a220builder) => a220builder.a234 = 'new_value');
            });
          })),
    ),
  );
}
