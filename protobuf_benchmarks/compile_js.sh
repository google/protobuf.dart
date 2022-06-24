#!/bin/sh
# Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Compile benchmark_js to JavaScript using dart2js.

SCRIPT_DIR=$(dirname "${BASH_SOURCE}")

dart compile js                             \
        -O4                                 \
        -o "${SCRIPT_DIR}"/bin/benchmark.js \
        "${SCRIPT_DIR}"/bin/benchmark_js.dart
