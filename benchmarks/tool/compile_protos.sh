#!/bin/bash

# Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

SCRIPT_DIR=$(dirname "${BASH_SOURCE}")
BENCHMARK_DIR=$SCRIPT_DIR/..

# These protos don't have any imports
SIMPLE_PROTOS=(
    "protos/google_message1_proto2.proto"
    "protos/google_message1_proto3.proto"
    "protos/google_message2.proto"
)

set -x
set -e

mkdir -p lib/generated

protoc --dart_out=lib/generated --plugin=protoc-gen-dart=tool/run_protoc_plugin.sh \
    -I$BENCHMARK_DIR/protos \
    "${SIMPLE_PROTOS[@]/#/$BENCHMARK_DIR/}"

protoc --dart_out=lib/generated --plugin=protoc-gen-dart=tool/run_protoc_plugin.sh \
    -I$BENCHMARK_DIR/protos/query_benchmark \
    $BENCHMARK_DIR/protos/query_benchmark/*.proto

dart format lib/generated
