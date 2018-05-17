#!/bin/sh
# Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Compile benchmark_js to JavaScript using dart2js.

mkdir -p temp

dart2js --trust-type-annotations        \
        --trust-primitives              \
        -o benchmarks/temp/benchmark.js \
        benchmarks/benchmark_js.dart
