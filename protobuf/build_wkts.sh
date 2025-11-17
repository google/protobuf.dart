#!/bin/bash

# This scripts generates the classes for well-known protobuf types which are
# included in the package.

set -e
set -x

mkdir -p lib/well_known_types/google/protobuf

protoc \
    --dart_out=lib/well_known_types \
    --plugin=protoc-gen-dart=$(realpath '../protoc_plugin/bin/protoc-gen-dart-debug') \
    google/protobuf/*.proto

# Remove empty .pbenum files.
rm lib/well_known_types/google/protobuf/any.pbenum.dart
rm lib/well_known_types/google/protobuf/api.pbenum.dart
rm lib/well_known_types/google/protobuf/duration.pbenum.dart
rm lib/well_known_types/google/protobuf/empty.pbenum.dart
rm lib/well_known_types/google/protobuf/field_mask.pbenum.dart
rm lib/well_known_types/google/protobuf/source_context.pbenum.dart
rm lib/well_known_types/google/protobuf/timestamp.pbenum.dart
rm lib/well_known_types/google/protobuf/wrappers.pbenum.dart
