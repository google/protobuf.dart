// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.set_strings;

import '../benchmark.dart';
import '../generated/benchmark.pb.dart'
    show BenchmarkID, Request, Params, Sample;
import '../generated/string_grid.pb.dart' as pb;

/// A benchmark that sets each value in a grid of string fields.
class SetStringsBenchmark extends Benchmark {
  static const width = 10;
  final int height;
  final String fillValue;
  pb.Grid10 grid;

  SetStringsBenchmark(this.height, this.fillValue) : super($id);

  @override
  get summary {
    var fill = fillValue == null ? "null" : "'$fillValue'";
    return "${id.name}($height x $fill)";
  }

  @override
  Params makeParams() {
    var p = Params()..messageCount = height;
    if (fillValue != null) p.stringValue = fillValue;
    return p;
  }

  @override
  void setup() {
    grid = _makeGrid(width, height, fillValue);
  }

  // makes a rectangle where no fields have been set.
  static pb.Grid10 _makeGrid(int width, int height, String fillValue) {
    var grid = pb.Grid10();

    for (int y = 0; y < height; y++) {
      var line = pb.Line10();
      if (fillValue != null) {
        for (int x = 0; x < width; x++) {
          int tag = getTagForColumn(line, x);
          line.setField(tag, fillValue);
        }
      }
      grid.lines.add(line);
    }

    return grid;
  }

  static int getTagForColumn(pb.Line10 line, int x) {
    return line.getTagNumber('cell${x + 1}'); // assume x start from 1
  }

  @override
  int exercise() {
    const reps = 100;
    for (int i = 0; i < reps; i++) {
      run();
    }
    return reps;
  }

  @override
  void run() {
    var newValue = "";
    for (var line in grid.lines) {
      line.cell1 = newValue;
      line.cell2 = newValue;
      line.cell3 = newValue;
      line.cell4 = newValue;
      line.cell5 = newValue;
      line.cell6 = newValue;
      line.cell7 = newValue;
      line.cell8 = newValue;
      line.cell9 = newValue;
      line.cell10 = newValue;
    }
  }

  @override
  void setCounts(Sample s) {
    s.counts.stringWrites = width * height * s.loopCount;
  }

  @override
  measureSample(Sample s) => stringWritesPerMillisecond(s);

  @override
  get measureSampleUnits => "string writes/ms";

  static const $id = BenchmarkID.SET_STRINGS;
  static final $type = BenchmarkType($id, $create);

  static SetStringsBenchmark $create(Request r) {
    assert(r.params.hasMessageCount());
    var value = null;
    if (r.params.hasStringValue()) value = r.params.stringValue;
    return SetStringsBenchmark(r.params.messageCount, value);
  }
}
