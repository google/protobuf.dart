// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'intgrid.pb.dart' as pb;
import 'harness.dart';

/// A benchmark that deserializes a grid of repeated ints.
class RepeatedInt32Benchmark extends ThroughputBenchmark {
  final int width;
  final int height;
  String json;

  RepeatedInt32Benchmark(int width, int height)
      : super("ReadJsonRepeatedInts: ${width}x${height} ints"),
        this.width = width,
        this.height = height;

  void setup() {
    var grid = makeRepeatedInt32Grid(width, height);
    json = grid.writeToJson();
  }

  void run() {
    pb.Grid grid = new pb.Grid.fromJson(json);
    var actual = grid.lines[height - 1].cells[width - 1];
    if (actual != width + height - 2) throw "failed; got ${actual}";
  }

  get unitsPerRun => width * height;

  get units => "ints";
}

// makes a rectangle of the of the form:
// 0 1 2 3
// 1 2 3 4
// 2 3 4 5
pb.Grid makeRepeatedInt32Grid(int width, int height) {
  var grid = new pb.Grid();

  for (int y = 0; y < height; y++) {
    var line = new pb.Line();
    for (int x = 0; x < width; x++) {
      line.cells.add(x + y);
    }
    grid.lines.add(line);
  }

  return grid;
}

/// A benchmark that deserializes a grid of int fields.
class Int32FieldBenchmark extends ThroughputBenchmark {
  final int width;
  final int height;
  String json;

  Int32FieldBenchmark(int width, int height)
      : super("ReadJsonIntFields: ${width}x${height} ints"),
        this.width = width,
        this.height = height;

  void setup() {
    var grid = makeRepeatedInt32Grid(width, height);
    json = grid.writeToJson();
  }

  void run() {
    pb.Grid grid = new pb.Grid.fromJson(json);
    var actual = grid.lines[height - 1].cells[width - 1];
    if (actual != width + height - 2) throw "failed; got ${actual}";
  }

  get unitsPerRun => width * height;

  get units => "ints";
}

// makes a rectangle of the of the form:
// 0 1 2 3
// 1 2 3 4
// 2 3 4 5
pb.Grid10 makeInt32FieldGrid(int width, int height) {
  if (width >= 10) throw new ArgumentError("Line10 only contains 10 fields");
  var grid = new pb.Grid10();

  for (int y = 0; y < height; y++) {
    var line = new pb.Line10();
    for (int x = 0; x < width; x++) {
      int tag = line.getTagNumber('cell${x+1}'); // assume x start from 1
      line.setField(tag, x + y);
    }
    grid.lines.add(line);
  }

  return grid;
}

main() {
  // Runs multiple times to make sure it's repeatable.
  print("individual int32 fields (1 per message):");
  new Int32FieldBenchmark(1, 100).report();
  new Int32FieldBenchmark(1, 100).report();
  new Int32FieldBenchmark(1, 100).report();

  print("\nindividual int32 fields (10 per message):");
  new Int32FieldBenchmark(10, 100).report();
  new Int32FieldBenchmark(10, 100).report();
  new Int32FieldBenchmark(10, 100).report();

  print("\nrepeated int32 fields (1 per field):");
  new RepeatedInt32Benchmark(1, 100).report();
  new RepeatedInt32Benchmark(1, 100).report();
  new RepeatedInt32Benchmark(1, 100).report();

  print("\nrepeated int32 fields (10 per field):");
  new RepeatedInt32Benchmark(10, 100).report();
  new RepeatedInt32Benchmark(10, 100).report();
  new RepeatedInt32Benchmark(10, 100).report();

  print("\nlonger repeated fields:");

  // Growth in width (more ints in each repeated field)
  new RepeatedInt32Benchmark(10, 100).report();
  new RepeatedInt32Benchmark(20, 100).report();
  new RepeatedInt32Benchmark(30, 100).report();
  new RepeatedInt32Benchmark(40, 100).report();
  new RepeatedInt32Benchmark(50, 100).report();

  print("\nmore messages:");

  // Growth in height (more line objects)
  new RepeatedInt32Benchmark(10, 100).report();
  new RepeatedInt32Benchmark(10, 200).report();
  new RepeatedInt32Benchmark(10, 300).report();
  new RepeatedInt32Benchmark(10, 400).report();
  new RepeatedInt32Benchmark(10, 500).report();
}
