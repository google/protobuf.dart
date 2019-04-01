// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.get_strings;

import '../benchmark.dart';
import '../generated/benchmark.pb.dart'
    show BenchmarkID, Request, Params, Sample;
import '../generated/string_grid.pb.dart' as pb;

/// A benchmark that accesses each value in a grid of string fields.
class GetStringsBenchmark extends Benchmark {
  static const width = 10;
  final int height;
  final String fillValue; // null means start uninitialized.
  pb.Grid10 grid;

  GetStringsBenchmark(this.height, this.fillValue) : super($id);

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
    grid = _makeGrid(height, fillValue);
  }

  // makes a rectangle where every cell has the same value.
  static pb.Grid10 _makeGrid(int height, String fillValue) {
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
    if (fillValue == null) {
      _getDefaults();
    } else {
      _getStrings();
    }
  }

  void _getDefaults() {
    bool ok = true;
    for (var line in grid.lines) {
      ok = ok && line.cell1.isEmpty;
      ok = ok && line.cell2.isEmpty;
      ok = ok && line.cell3.isEmpty;
      ok = ok && line.cell4.isEmpty;
      ok = ok && line.cell5.isEmpty;
      ok = ok && line.cell6.isEmpty;
      ok = ok && line.cell7.isEmpty;
      ok = ok && line.cell8.isEmpty;
      ok = ok && line.cell9.isEmpty;
      ok = ok && line.cell10.isEmpty;
    }
    if (!ok) throw "failed";
  }

  void _getStrings() {
    bool ok = true;
    for (var line in grid.lines) {
      ok = ok && line.cell1.isNotEmpty;
      ok = ok && line.cell2.isNotEmpty;
      ok = ok && line.cell3.isNotEmpty;
      ok = ok && line.cell4.isNotEmpty;
      ok = ok && line.cell5.isNotEmpty;
      ok = ok && line.cell6.isNotEmpty;
      ok = ok && line.cell7.isNotEmpty;
      ok = ok && line.cell8.isNotEmpty;
      ok = ok && line.cell9.isNotEmpty;
      ok = ok && line.cell10.isNotEmpty;
    }
    if (!ok) throw "failed";
  }

  @override
  void setCounts(Sample s) {
    s.counts.stringReads = width * height * s.loopCount;
  }

  @override
  measureSample(Sample s) => stringReadsPerMillisecond(s);

  @override
  get measureSampleUnits => "string reads/ms";

  static const $id = BenchmarkID.GET_STRINGS;
  static final $type = BenchmarkType($id, $create);

  static GetStringsBenchmark $create(Request r) {
    assert(r.params.hasMessageCount());
    var value = null;
    if (r.params.hasStringValue()) value = r.params.stringValue;
    return GetStringsBenchmark(r.params.messageCount, value);
  }
}
