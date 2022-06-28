#!/usr/bin/env python3

# Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# This does the same thing as `compile_benchmarks.sh`, but compiles inputs in
# parallel.
#
# $ time ./tool/compile_benchmarks.py
# ...
# ./tool/compile_benchmarks.py  130.47s user 19.48s system 1074% cpu 13.951 total
#
# $ time ./tool/compile_benchmarks.sh
# ...
# ./tool/compile_benchmarks.sh  91.14s user 20.08s system 137% cpu 1:20.97 total

import os
import subprocess

try:
    os.mkdir('out')
except:
    pass

processes = []

def run_cmd(args):
    print(' '.join(args))

    # Ignore outputs, print error messages
    processes.append(subprocess.Popen(args, stdout=subprocess.DEVNULL))

for file in os.listdir('bin'):
    file = os.path.splitext(file)[0]

    run_cmd(['dart', 'compile', 'exe', f'bin/{file}.dart', '-o', f'out/{file}.exe'])
    run_cmd(['dart', 'compile', 'js', '-O4', f'bin/{file}.dart', '-o', f'out/{file}.js'])

print('Waiting for processes to finish...')

for p in processes:
    p.wait()
