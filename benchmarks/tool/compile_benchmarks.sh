#!/bin/bash

# Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

SCRIPT_DIR=$(dirname "${BASH_SOURCE}")
BENCHMARK_DIR=$SCRIPT_DIR/..

set -e

mkdir -p out

for bench in bin/*.dart; do
    file=$(basename $bench)
    file_no_ext=${file%.dart}
    exe_out="out/$file_no_ext.exe"
    js_out="out/$file_no_ext.js"

    echo "$file -> $exe_out"
    dart compile exe $bench -o $exe_out
    echo ''

    echo "$file -> $js_out"
    dart compile js -O4 $bench -o $js_out
    echo ''
done
