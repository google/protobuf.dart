#!/bin/bash

pushd api_benchmark
./compile_protos.sh
popd

pushd benchmarks
./tool/compile_protos.sh
popd

pushd protoc_plugin
make clean
make update-pregenerated
make protos
popd
