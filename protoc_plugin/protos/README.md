## What's this?

These are core protos that are used in the protoc_plugin generator. They allow
us to read generation requests from the protoc tool as well as parse extensions
from protos for things like gRPC generation parameter and other config
information.

## Regenerating

To regenerate the Dart code from the current protos, run:

```
make update-pregenerated
```

This will generate the associated Dart code in `lib/src/gen/`.

## Updating the protos

To update the vendored protos to the most recent versions, run:
`dart tool/update_protos.dart`. Then, run `make update-pregenerated` to rebuild
the Dart libraries in `lib/src/gen/`.

The contents of `google/protobuf/` can be found at 
https://github.com/protocolbuffers/protobuf/tree/main/src/google/protobuf.

All other 'google' protos can be found at
https://github.com/googleapis/googleapis/tree/master/google.

`dart_options.proto` is hand-maintained.
