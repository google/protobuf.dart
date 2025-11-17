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
