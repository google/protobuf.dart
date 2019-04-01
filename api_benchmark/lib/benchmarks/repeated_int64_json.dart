// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.repeated_int64_json;

import 'package:fixnum/fixnum.dart';

import '../benchmark.dart';
import '../generated/benchmark.pb.dart'
    show BenchmarkID, Request, Params, Sample;
import '../generated/int64grid.pb.dart' as pb;

/// A benchmark that deserializes a grid of repeated ints.
class RepeatedInt64Benchmark extends Benchmark {
  final int width;
  final int height;
  String json;

  RepeatedInt64Benchmark(this.width, this.height) : super($id);

  @override
  get summary => "${id.name}($width x $height ints)";

  @override
  Params makeParams() => Params()
    ..int64RepeatCount = width
    ..messageCount = height;

  @override
  void setup() {
    var grid = _makeGrid(width, height);
    json = grid.writeToJson();
  }

  // makes a rectangle of the of the form:
  // 0 1 2 3
  // 1 2 3 4
  // 2 3 4 5
  static pb.Grid _makeGrid(int width, int height) {
    var grid = pb.Grid();

    for (int y = 0; y < height; y++) {
      var line = pb.Line();
      for (int x = 0; x < width; x++) {
        line.cells.add(Int64(x + y));
      }
      grid.lines.add(line);
    }

    return grid;
  }

  @override
  void run() {
    pb.Grid grid = pb.Grid.fromJson(json);
    var actual = grid.lines[height - 1].cells[width - 1];
    if (actual != width + height - 2) throw "failed; got ${actual}";
  }

  @override
  void setCounts(Sample s) {
    s.counts.int64Reads = width * height * s.loopCount;
  }

  @override
  measureSample(Sample s) => int64ReadsPerMillisecond(s);

  @override
  get measureSampleUnits => "int64 reads/ms";

  static const $id = BenchmarkID.READ_INT64_REPEATED_JSON;
  static final $type = BenchmarkType($id, $create);
  static RepeatedInt64Benchmark $create(Request r) {
    assert(r.params.hasInt64RepeatCount());
    assert(r.params.hasMessageCount());
    return RepeatedInt64Benchmark(
        r.params.int64RepeatCount, r.params.messageCount);
  }
}
