#!/usr/bin/env python3

# Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Compiles benchmark programs in `bin/` to native and JS, in parallel.

import multiprocessing
import os
import subprocess
import time

try:
    os.mkdir('out')
except:
    pass

n_cpus = multiprocessing.cpu_count()

print('n_cpus:', n_cpus)

processes = []

def wait_processes():
    global processes

    while True:
        new_processes = []

        # Remove finished processes from the pool
        for p in processes:
            ret = p.poll()

            if ret == None:
                new_processes.append(p)
                continue

            if ret != 0:
                print('Process returned %' % ret)
                sys.exit(1)

        processes = new_processes

        if len(processes) == n_cpus:
            time.sleep(1)
        else:
            return

def run_cmd(args):
    if len(processes) >= n_cpus:
        wait_processes()

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
