// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import '../benchmark.dart';
import '../generated/benchmark.pb.dart'
    show BenchmarkID, Params, Request, Sample;
import '../generated/string_grid.pb.dart' as pb;

/// A benchmark that checks the existence of each item in a grid of strings.
class HasStringsBenchmark extends Benchmark {
  static const width = 10;
  final int height;
  final String? fillValue;
  late pb.Grid10 grid;

  HasStringsBenchmark(this.height, this.fillValue) : super($id);

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
    if (fillValue == null) {
      runEmpty();
    } else {
      runFilled();
    }
  }

  void runFilled() {
    var allPresent = true;
    for (final line in grid.lines) {
      allPresent = allPresent && line.hasCell1();
      allPresent = allPresent && line.hasCell2();
      allPresent = allPresent && line.hasCell3();
      allPresent = allPresent && line.hasCell4();
      allPresent = allPresent && line.hasCell5();
      allPresent = allPresent && line.hasCell6();
      allPresent = allPresent && line.hasCell7();
      allPresent = allPresent && line.hasCell8();
      allPresent = allPresent && line.hasCell9();
      allPresent = allPresent && line.hasCell10();
    }
    if (!allPresent) throw 'failed';
  }

  void runEmpty() {
    var allEmpty = true;
    for (final line in grid.lines) {
      allEmpty = allEmpty && !line.hasCell1();
      allEmpty = allEmpty && !line.hasCell2();
      allEmpty = allEmpty && !line.hasCell3();
      allEmpty = allEmpty && !line.hasCell4();
      allEmpty = allEmpty && !line.hasCell5();
      allEmpty = allEmpty && !line.hasCell6();
      allEmpty = allEmpty && !line.hasCell7();
      allEmpty = allEmpty && !line.hasCell8();
      allEmpty = allEmpty && !line.hasCell9();
      allEmpty = allEmpty && !line.hasCell10();
    }
    if (!allEmpty) throw 'failed';
  }

  @override
  void setCounts(Sample m) {
    m.counts.stringReads = width * height * m.loopCount;
  }

  @override
  double measureSample(Sample? s) => stringReadsPerMillisecond(s);

  @override
  String get measureSampleUnits => 'string reads/ms';

  static const $id = BenchmarkID.HAS_STRINGS;
  static final $type = BenchmarkType($id, $create);

  static HasStringsBenchmark $create(Request r) {
    assert(r.params.hasMessageCount());
    String? value;
    if (r.params.hasStringValue()) value = r.params.stringValue;
    return HasStringsBenchmark(r.params.messageCount, value);
  }
}
