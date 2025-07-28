## Running benchmarks

- Compile protos with `./tool/compile_protos.sh`

- **JIT:** Run benchmark programs in `bin/`, e.g. `dart bin/from_binary.dart`

- **AOT and JS:**

  - Compile benchmark programs to native, JS, and JIT snapshots with
    `./tool/compile_benchmarks.dart`

  - Run benchmark programs in `out/`:
    - AOT: `./out/from_binary.exe`
    - JS: `d8 $DART_SDK/lib/_internal/js_runtime/lib/preambles/d8.js out/from_binary.js`

- **Wasm:**

  - Get the Dart SDK source code following instructions [here][1], and build
    `dart2wasm_platform` target with `tools/build.py -m release
    dart2wasm_platform`.

  - Make sure `$DART_SDK` environment variable set to the path of [Dart SDK's
    "sdk" directory][1].

  - Compile benchmarks with `./tool/compile_benchmarks.dart --target=<target>`
    where `<target>` is one of:

    - `wasm`: Default optimized build
    - `wasm-omit-checks`: Optimized build with `--omit-checks`

  - Run with: `$DART_SDK/bin/run_dart2wasm_d8 out/from_binary.wasm`, or use
    `.omit-checks.wasm` extension for the `wasm-omit-checks` target:
    `from_binary.omit-checks.wasm`.

[1]: https://github.com/dart-lang/sdk/wiki/Building
[2]: https://github.com/dart-lang/sdk/tree/main/sdk

## Development

`protoc_version` file specifies the version of protoc Golem will use when
building the benchmarks, and allows updating the protoc version without
changing Golem.
