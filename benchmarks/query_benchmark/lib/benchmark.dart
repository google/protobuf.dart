// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Returns the average time to execute [f] over [iterations] repetitions.
///
/// Will first run [f] [warmupIterations] times to warm up the runtime.
Duration measure(void Function() f,
    {int warmupIterations = 100, int iterations = 1000}) {
  for (int i = 0; i < warmupIterations; i++) {
    f();
  }
  var s = Stopwatch()..start();
  for (int i = 0; i < iterations; i++) {
    f();
  }
  return s.elapsed ~/ iterations;
}

String formatReport({String title, Duration duration}) {
  return "RunTimeRaw($title): ${duration.inMicroseconds} us";
}
