# Protobuf Benchmarks

This directory contains protobuf benchmarks adapted from [original protobuf](
https://github.com/google/protobuf/tree/master/benchmarks) library.

These benchmarks cover parsing and serializing protobufs both to
binary and JSON formats.

## Prerequisites

Before running benchmarks you first need to compile all involved
protos, which requires installing `protoc` and
[dart-protoc-plugin](https://github.com/dart-lang/dart-protoc-plugin).

```console
$ cd benchmarks
$ ./compile-protos.sh
# This would produce benchmarks/temp folder with output of protoc.
```

## Running benchmarks on the VM

```
$ dart benchmarks/benchmark_vm.dart
```

## Running benchmarks via JavaScript (D8)

```
$ benchmarks/compile-js.sh
$ d8 $DART_SDK/lib/_internal/js_runtime/lib/preambles/d8.js benchmarks/temp/benchmark.js
```
