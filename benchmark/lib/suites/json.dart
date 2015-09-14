// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.suite.json;

import '../benchmarks/int32_json.dart';
import '../benchmarks/repeated_int32_json.dart';
import '../benchmarks/int64_json.dart';
import '../benchmarks/repeated_int64_json.dart';
import '../generated/benchmark.pb.dart' show Request, Suite;

final jsonSuite = () {
  var suite = new Suite();
  suite.requests.addAll([
    _int32(1, 100),
    _int32(2, 100),
    _int32(10, 100),
    _int32(10, 200),
    _repeatedInt32(1, 100),
    _repeatedInt32(2, 100),
    _repeatedInt32(10, 100),
    _repeatedInt32(10, 200),
    _int64(1, 100),
    _int64(2, 100),
    _int64(10, 100),
    _int64(10, 200),
    _repeatedInt64(1, 100),
    _repeatedInt64(2, 100),
    _repeatedInt64(10, 100),
    _repeatedInt64(10, 200),
  ]);

  return suite;
}();

_int32(int width, int height) =>
    new Int32Benchmark(width, height).makeRequest();

_repeatedInt32(int width, int height) =>
    new RepeatedInt32Benchmark(width, height).makeRequest();

_int64(int width, int height) =>
    new Int64Benchmark(width, height).makeRequest();

_repeatedInt64(int width, int height) =>
    new RepeatedInt64Benchmark(width, height).makeRequest();
