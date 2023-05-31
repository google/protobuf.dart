// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart' show Int64;

import '../benchmark.dart';
import '../generated/benchmark.pb.dart'
    show BenchmarkID, Params, Request, Sample;
import '../generated/int64grid.pb.dart' as pb;

/// A benchmark that deserializes a grid of int fields.
class Int64Benchmark extends Benchmark {
  final int width;
  final int height;
  late String json;
  int? lastFieldTag;

  Int64Benchmark(this.width, this.height) : super($id);

  @override
  String get summary => '${id.name}($width x $height int64s)';

  @override
  Params makeParams() => Params()
    ..int64FieldCount = width
    ..messageCount = height;

  @override
  void setup() {
    final grid = _makeGrid(width, height);
    json = grid.writeToJson();
    lastFieldTag = getTagForColumn(pb.Line10(), width - 1);
  }

  // makes a rectangle of the of the form:
  // 0 1 2 3
  // 1 2 3 4
  // 2 3 4 5
  static pb.Grid10 _makeGrid(int width, int height) {
    if (width > 10) throw ArgumentError('width out of range: $width');
    final grid = pb.Grid10();

    for (var y = 0; y < height; y++) {
      final line = pb.Line10();
      for (var x = 0; x < width; x++) {
        final tag = getTagForColumn(line, x)!;
        line.setField(tag, Int64(x + y));
      }
      grid.lines.add(line);
    }

    return grid;
  }

  static int? getTagForColumn(pb.Line10 line, int x) {
    return line.getTagNumber('cell${x + 1}'); // assume x start from 1
  }

  @override
  void run() {
    final grid = pb.Grid10.fromJson(json);
    final actual = grid.lines[height - 1].getField(lastFieldTag!);
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

  static const $id = BenchmarkID.READ_INT64_FIELDS_JSON;
  static final $type = BenchmarkType($id, $create);

  static Int64Benchmark $create(Request r) {
    assert(r.params.hasInt64FieldCount());
    assert(r.params.hasMessageCount());
    return Int64Benchmark(r.params.int64FieldCount, r.params.messageCount);
  }
}
