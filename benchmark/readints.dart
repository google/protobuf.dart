// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'intgrid.pb.dart' as pb;
import 'harness.dart';

/// A benchmark that deserializes a grid of ints.
class Benchmark extends ThroughputBenchmark {
  final int width;
  final int height;
  String json;

  Benchmark(int width, int height)
      : super("ReadJsonInts: ${width}x${height} ints"),
        this.width = width,
        this.height = height;

  void setup() {
    var grid = makeGrid(width, height);
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
pb.Grid makeGrid(int width, int height) {
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

main() {
  // Check stability
  new Benchmark(10, 100).report();
  new Benchmark(10, 100).report();
  new Benchmark(10, 100).report();

  print("\nlonger lines:");

  // Growth in width (more ints in each repeated field)
  new Benchmark(10, 100).report();
  new Benchmark(20, 100).report();
  new Benchmark(30, 100).report();
  new Benchmark(40, 100).report();
  new Benchmark(50, 100).report();

  print("\nmore lines:");

  // Growth in height (more line objects)
  new Benchmark(10, 100).report();
  new Benchmark(10, 200).report();
  new Benchmark(10, 300).report();
  new Benchmark(10, 400).report();
  new Benchmark(10, 500).report();
}
