// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart';

import '../benchmark.dart';
import '../generated/benchmark.pb.dart'
    show BenchmarkID, Params, Request, Sample;
import '../generated/int64grid.pb.dart' as pb;

/// A benchmark that deserializes a grid of repeated ints.
class RepeatedInt64Benchmark extends Benchmark {
  final int width;
  final int height;
  late String json;

  RepeatedInt64Benchmark(this.width, this.height) : super($id);

  @override
  String get summary => '${id.name}($width x $height ints)';

  @override
  Params makeParams() => Params()
    ..int64RepeatCount = width
    ..messageCount = height;

  @override
  void setup() {
    final grid = _makeGrid(width, height);
    json = grid.writeToJson();
  }

  // makes a rectangle of the of the form:
  // 0 1 2 3
  // 1 2 3 4
  // 2 3 4 5
  static pb.Grid _makeGrid(int width, int height) {
    final grid = pb.Grid();

    for (var y = 0; y < height; y++) {
      final line = pb.Line();
      for (var x = 0; x < width; x++) {
        line.cells.add(Int64(x + y));
      }
      grid.lines.add(line);
    }

    return grid;
  }

  @override
  void run() {
    final grid = pb.Grid.fromJson(json);
    final actual = grid.lines[height - 1].cells[width - 1];
    if (actual != width + height - 2) throw 'failed; got $actual';
  }

  @override
  void setCounts(Sample m) {
    m.counts.int64Reads = width * height * m.loopCount;
  }

  @override
  double measureSample(Sample? s) => int64ReadsPerMillisecond(s);

  @override
  String get measureSampleUnits => 'int64 reads/ms';

  static const $id = BenchmarkID.READ_INT64_REPEATED_JSON;
  static final $type = BenchmarkType($id, $create);
  static RepeatedInt64Benchmark $create(Request r) {
    assert(r.params.hasInt64RepeatCount());
    assert(r.params.hasMessageCount());
    return RepeatedInt64Benchmark(
        r.params.int64RepeatCount, r.params.messageCount);
  }
}
