# Protobuf Benchmarks

This directory contains protobuf benchmarks adapted from [original protobuf](
https://github.com/google/protobuf/tree/master/benchmarks) library.

These benchmarks cover parsing and serializing protobufs both to binary and
JSON formats, and hash code generation for messages.

## Prerequisites

Before running benchmarks you first need to compile all involved protos, which
requires installing `protoc` and [protoc_plugin](../../protoc_plugin).

```console
$ ./compile_protos.sh
```

This compiles test protos to Dart.

## Running benchmarks on the VM

```
$ dart bin/benchmark_vm.dart
```

## Running benchmarks via JavaScript (D8)

```
$ ./compile_js.sh
$ d8 $DART_SDK/lib/_internal/js_runtime/lib/preambles/d8.js bin/benchmark.js
```

Note: if you are seeing a "Error reading file" error while running the JS
benchmarks it means that you are in the wrong directory. Run the `d8` command
shown above in `protobuf_benchmarks/` directory.
