# protobuf.dart — Copilot Instructions

## Overview
Forked Google protobuf.dart repo with a customized protoc-gen-dart plugin. Used by Macadam.CarCheck to generate Dart code from .proto files.

## Tech Stack
- Language: Dart

## Key Customization
The `protoc_plugin` was modified to allow a configurable binary size limit (default is hardcoded 64MB — Macadam needs larger metadata packages).

## Notes for Copilot
Only the `protoc_plugin` is customized. Build with `dart compile exe .\protoc_plugin\bin\protoc_plugin.dart`. Output goes to Macadam.CarCheck root as `protoc-gen-dart.exe`.
