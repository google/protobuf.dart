# Benchmark of api functions

## Compiling the protos:

```sh
$ ./compile_protos.sh
```

## Run on the vm:

```sh
$ pub run props_vm.dart
$ pub run readjson_vm.dart
```

## Run in a browser:

```sh
$ pub run build_runner serve web:8181
```

Navigate to: [http://localhost:8181/props.html] or [http://localhost:8181/readjson.html].
