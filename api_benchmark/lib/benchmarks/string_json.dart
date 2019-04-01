// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.string_json;

import '../benchmark.dart';
import '../generated/benchmark.pb.dart'
    show BenchmarkID, Request, Params, Sample;
import '../generated/string_grid.pb.dart' as pb;

/// A benchmark that deserializes a grid of string fields.
class StringBenchmark extends Benchmark {
  final int width;
  final int height;
  final int stringSize;
  String json;
  int lastFieldTag;

  StringBenchmark(this.width, this.height, this.stringSize) : super($id);

  @override
  get summary => "${id.name}($width x $height x $stringSize)";

  @override
  Params makeParams() => Params()
    ..stringFieldCount = width
    ..messageCount = height
    ..stringSize = stringSize;

  @override
  void setup() {
    var grid = _makeGrid(width, height, stringSize);
    json = grid.writeToJson();
    lastFieldTag = getTagForColumn(pb.Line10(), width - 1);
  }

  // makes a rectangle of the of the form:
  // "01" "12" "23" "34"
  // "12" "23" "34" "45"
  // "23" "34" "45" "56"
  static pb.Grid10 _makeGrid(int width, int height, int stringSize) {
    if (width > 10) throw ArgumentError("width out of range: ${width}");
    var grid = pb.Grid10();

    int zero = "0".codeUnits[0];

    for (int y = 0; y < height; y++) {
      var line = pb.Line10();
      for (int x = 0; x < width; x++) {
        int tag = getTagForColumn(line, x);
        var charCodes = <int>[];
        for (var i = 0; i < stringSize; i++) {
          charCodes.add(zero + ((x + y + i) % 10));
        }
        line.setField(tag, String.fromCharCodes(charCodes));
      }
      grid.lines.add(line);
    }

    return grid;
  }

  static int getTagForColumn(pb.Line10 line, int x) {
    return line.getTagNumber('cell${x + 1}'); // assume x start from 1
  }

  @override
  void run() {
    pb.Grid10 grid = pb.Grid10.fromJson(json);
    var actual = grid.lines[height - 1].getField(lastFieldTag);
    if (actual.length != stringSize) throw "failed; got ${actual}";
  }

  @override
  void setCounts(Sample s) {
    s.counts.stringReads = width * height * s.loopCount;
  }

  @override
  measureSample(Sample s) => stringReadsPerMillisecond(s);

  @override
  get measureSampleUnits => "string reads/ms";

  static const $id = BenchmarkID.READ_STRING_FIELDS_JSON;
  static final $type = BenchmarkType($id, $create);

  static StringBenchmark $create(Request r) {
    assert(r.params.hasStringFieldCount());
    assert(r.params.hasMessageCount());
    assert(r.params.hasStringSize());
    return StringBenchmark(
        r.params.stringFieldCount, r.params.messageCount, r.params.stringSize);
  }
}
