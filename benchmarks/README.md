## Running benchmarks

- Compile protos with `./tool/compile_protos.sh`
- **JIT:** Run benchmark programs in `bin/`, e.g. `dart bin/from_binary.dart`
- **AOT and JS:**
  - Compile benchmark programs to native and JS with
    `./tool/compile_benchmarks.sh`. If you have Python 3 installed, you can
    also run `./tool/compile_benchmarks.py` to compile benchmarks in parallel.
  - Run benchmark programs in `out/`:
    AOT: `./out/from_binary.exe`
    JS: `d8 $DART_SDK/lib/_internal/js_runtime/lib/preambles/d8.js out/from_binary.js`
