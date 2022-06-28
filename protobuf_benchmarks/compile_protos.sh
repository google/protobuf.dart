#!/bin/bash
# Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Compile all protos involed in the benchmarking using protoc compiler.

PROTOS=(
  "benchmarks.proto"
  "datasets/google_message1/proto2/benchmark_message1_proto2.proto"
  "datasets/google_message1/proto3/benchmark_message1_proto3.proto"
  "datasets/google_message2/benchmark_message2.proto"
)

SCRIPT_DIR=$(dirname "${BASH_SOURCE}")

set -x

mkdir -p lib/generated

protoc -I"${SCRIPT_DIR}" --dart_out=lib/generated --plugin=protoc-gen-dart=run_protoc_plugin.sh "${PROTOS[@]/#/$SCRIPT_DIR/}"
