// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.suite.json;

import '../benchmarks/int32_json.dart';
import '../benchmarks/repeated_int32_json.dart';
import '../benchmarks/int64_json.dart';
import '../benchmarks/repeated_int64_json.dart';
import '../benchmarks/string_json.dart';
import '../benchmarks/repeated_string_json.dart';
import '../generated/benchmark.pb.dart' show Suite;

final Suite jsonSuite = () {
  var suite = Suite();
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
    _string(1, 100, 10),
    _string(2, 100, 10),
    _string(10, 100, 10),
    _string(10, 200, 10),
    _string(10, 100, 100),
    _repeatedString(1, 100, 10),
    _repeatedString(2, 100, 10),
    _repeatedString(10, 100, 10),
    _repeatedString(10, 200, 10),
    _repeatedString(10, 100, 100),
  ]);

  return suite;
}();

_int32(int width, int height) => Int32Benchmark(width, height).makeRequest();

_repeatedInt32(int width, int height) =>
    RepeatedInt32Benchmark(width, height).makeRequest();

_int64(int width, int height) => Int64Benchmark(width, height).makeRequest();

_repeatedInt64(int width, int height) =>
    RepeatedInt64Benchmark(width, height).makeRequest();

_string(int width, int height, int size) =>
    StringBenchmark(width, height, size).makeRequest();

_repeatedString(int width, int height, int size) =>
    RepeatedStringBenchmark(width, height, size).makeRequest();
