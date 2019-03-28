// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc.benchmark.index;

import "../benchmark.dart";

import "int32_json.dart";
import "int64_json.dart";
import "string_json.dart";

import "repeated_int32_json.dart";
import "repeated_int64_json.dart";
import "repeated_string_json.dart";

import "get_strings.dart";
import "set_strings.dart";
import "has_strings.dart";

import '../generated/benchmark.pb.dart' as pb;

/// Creates the appropriate Benchmark instance for a protobuf.
Benchmark createBenchmark(pb.Request r) {
  var type = allBenchmarks[r.id];
  if (type == null) {
    throw ArgumentError("unknown benchmark: ${r.id.name}");
  }
  return type.create(r);
}

final Map<pb.BenchmarkID, BenchmarkType> allBenchmarks = _makeTypeMap([
  Int32Benchmark.$type,
  Int64Benchmark.$type,
  StringBenchmark.$type,
  RepeatedInt32Benchmark.$type,
  RepeatedInt64Benchmark.$type,
  RepeatedStringBenchmark.$type,
  GetStringsBenchmark.$type,
  SetStringsBenchmark.$type,
  HasStringsBenchmark.$type,
]);

Map<pb.BenchmarkID, BenchmarkType> _makeTypeMap(List<BenchmarkType> types) {
  var out = <pb.BenchmarkID, BenchmarkType>{};
  for (var type in types) {
    if (out.containsKey(type.id)) {
      throw "already added: $type.id.name";
    }
    out[type.id] = type;
  }
  return Map.unmodifiable(out);
}
