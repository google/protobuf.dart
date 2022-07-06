## Running benchmarks

- Compile protos with `./tool/compile_protos.sh`

- **JIT:** Run benchmark programs in `bin/`, e.g. `dart bin/from_binary.dart`

- **AOT and JS:**

  - Compile benchmark programs to native, JS, and JIT snapshots with
    `./tool/compile_benchmarks.dart`

  - Run benchmark programs in `out/`:
    - AOT: `./out/from_binary.exe`
    - JS: `d8 $DART_SDK/lib/_internal/js_runtime/lib/preambles/d8.js out/from_binary.js`

## Development

`protoc_version` file specifies the version of protoc Golem will use when
building the benchmarks, and allows updating the protoc version without
changing Golem.
