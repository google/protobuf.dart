#!/usr/bin/env bash
rm -rf lib/generated
mkdir lib/generated
protoc --dart_out=lib/generated --plugin=protoc-gen-dart=run_protoc_plugin.sh -Iprotos protos/*.proto
dart format lib/generated
