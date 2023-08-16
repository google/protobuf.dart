// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../benchmark.dart';
import '../generated/benchmark.pb.dart'
    show BenchmarkID, Params, Request, Sample;
import '../generated/string_grid.pb.dart' as pb;

/// A benchmark that sets each value in a grid of string fields.
class SetStringsBenchmark extends Benchmark {
  static const width = 10;
  final int height;
  final String? fillValue;
  late pb.Grid10 grid;

  SetStringsBenchmark(this.height, this.fillValue) : super($id);

  @override
  String get summary {
    final fill = fillValue == null ? 'null' : "'$fillValue'";
    return '${id.name}($height x $fill)';
  }

  @override
  Params makeParams() {
    final p = Params()..messageCount = height;
    if (fillValue != null) p.stringValue = fillValue!;
    return p;
  }

  @override
  void setup() {
    grid = _makeGrid(width, height, fillValue);
  }

  // makes a rectangle where no fields have been set.
  static pb.Grid10 _makeGrid(int width, int height, String? fillValue) {
    final grid = pb.Grid10();

    for (var y = 0; y < height; y++) {
      final line = pb.Line10();
      if (fillValue != null) {
        for (var x = 0; x < width; x++) {
          final tag = getTagForColumn(line, x);
          line.setField(tag, fillValue);
        }
      }
      grid.lines.add(line);
    }

    return grid;
  }

  static int getTagForColumn(pb.Line10 line, int x) {
    return line.getTagNumber('cell${x + 1}')!; // assume x start from 1
  }

  @override
  int exercise() {
    const reps = 100;
    for (var i = 0; i < reps; i++) {
      run();
    }
    return reps;
  }

  @override
  void run() {
    final newValue = '';
    for (final line in grid.lines) {
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
  void setCounts(Sample m) {
    m.counts.stringWrites = width * height * m.loopCount;
  }

  @override
  double measureSample(Sample? s) => stringWritesPerMillisecond(s);

  @override
  String get measureSampleUnits => 'string writes/ms';

  static const $id = BenchmarkID.SET_STRINGS;
  static final $type = BenchmarkType($id, $create);

  static SetStringsBenchmark $create(Request r) {
    assert(r.params.hasMessageCount());
    String? value;
    if (r.params.hasStringValue()) value = r.params.stringValue;
    return SetStringsBenchmark(r.params.messageCount, value);
  }
}
