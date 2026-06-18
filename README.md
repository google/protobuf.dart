[![CI status](https://github.com/google/protobuf.dart/workflows/Dart%20CI/badge.svg)](https://github.com/google/protobuf.dart/actions?query=workflow%3A%22Dart%22+branch%3Amaster)

## Protobuf support for Dart

[Protocol Buffers](https://developers.google.com/protocol-buffers) (protobuf)
are Google's language-neutral, platform-neutral, extensible mechanism for
serializing structured data.

This repository is home to packages related to
[protobuf for Dart](https://pub.dev/documentation/protobuf/latest/).

Package | Description | Published Version
--- | --- | ---
[protobuf](protobuf/) | A support library for the generated code | [![pub package](https://img.shields.io/pub/v/protobuf.svg)](https://pub.dev/packages/protobuf)
[protoc_plugin](protoc_plugin/) | A Dart back-end for the protoc compiler | [![pub package](https://img.shields.io/pub/v/protoc_plugin.svg)](https://pub.dev/packages/protoc_plugin)
[api_benchmark](api_benchmark/) | Benchmarking for various API calls |
[query_benchmark](query_benchmark/) | Benchmark for encoding and decoding of a "real-world" protobuf |

## Publishing automation

For information about our publishing automation and release process, see
https://github.com/dart-lang/ecosystem/wiki/Publishing-automation.
---

## Repository Overview

**What it is:** Fork of Google's protobuf.dart repository with a customized `protoc-gen-dart` plugin used by Macadam.CarCheck.

**What it does:**
- Provides the Dart protobuf runtime library
- Custom `protoc-gen-dart` plugin modified to allow a configurable binary size limit (overcoming the hardcoded 64MB limit for large metadata packages)

**Tech Stack:** Dart

**Key Components:**
- `protobuf/` — Dart protobuf runtime
- `protoc_plugin/` — protoc code generator plugin (**customized by Macadam**)
- `benchmarks/` / `api_benchmark/` — performance benchmarks
- `tool/` — build tools

**Why We Fork:** The upstream plugin hardcodes a 64MB size limit for binary files. Macadam metadata packages can exceed this, so we modified the generator to accept a configurable limit.

**How to Build the Custom Plugin:**
```bash
dart compile exe .\protoc_plugin\bin\protoc_plugin.dart
# Rename output to protoc-gen-dart.exe
# Place in root of Macadam.CarCheck repo
```
