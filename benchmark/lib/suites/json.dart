// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.suite.json;

import '../benchmarks/int32_json.dart';
import '../benchmarks/repeated_int32_json.dart';
import '../generated/benchmark.pb.dart' show Request, Suite;

final jsonSuite = () {
  var suite = new Suite();
  suite.requests.addAll([
    _newRequest(1, 100),
    _newRequest(10, 100),
    _newRepeatedRequest(1, 100),
    _newRepeatedRequest(10, 100),
  ]);

  // Growth in width (more ints in each repeated field)
  for (var i = 10; i <= 50; i += 10) {
    suite.requests.add(_newRepeatedRequest(i, 100, once: true));
  }

  // Growth in height (more messagse)
  for (var i = 100; i <= 500; i += 100) {
    suite.requests.add(_newRepeatedRequest(10, i, once: true));
  }

  return suite;
}();

_newRequest(int width, int height) =>
    new Int32Benchmark(width, height).makeRequest();

_newRepeatedRequest(int width, int height, {bool once: false}) =>
    new RepeatedInt32Benchmark(width, height)
        .makeRequest(new Duration(milliseconds: 200), once ? 1 : 3);
