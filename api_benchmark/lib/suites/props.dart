// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../benchmarks/get_strings.dart';
import '../benchmarks/has_strings.dart';
import '../benchmarks/set_strings.dart';
import '../generated/benchmark.pb.dart';

final Suite propsSuite = () {
  final suite = Suite();
  suite.requests.addAll([
    _getStrings(10, null),
    _getStrings(10, 'x'),
    _setStrings(10, null),
    _setStrings(10, 'x'),
    _hasStrings(10, null),
    _hasStrings(10, 'x'),
  ]);

  return suite;
}();

Request _getStrings(int height, String? fill) =>
    GetStringsBenchmark(height, fill).makeRequest();
Request _setStrings(int height, String? fill) =>
    SetStringsBenchmark(height, fill).makeRequest();
Request _hasStrings(int height, String? fill) =>
    HasStringsBenchmark(height, fill).makeRequest();
