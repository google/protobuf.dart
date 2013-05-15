#!/usr/bin/env sh

OUTPUT_DIR='out/protos'

mkdir -p $OUTPUT_DIR

protoc --dart_out=$OUTPUT_DIR -Itest/protos $(cat <<END
test/protos/google/protobuf/unittest.proto
test/protos/google/protobuf/unittest_import.proto
test/protos/google/protobuf/unittest_optimize_for.proto
test/protos/multiple_files_test.proto
test/protos/nested_extension.proto
test/protos/non_nested_extension.proto
END
)
