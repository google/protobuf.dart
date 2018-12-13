#!/usr/bin/env bash
rm -rf lib/generated
mkdir lib/generated
protoc --dart_out=lib/generated --plugin=run_protoc_plugin.sh -Iprotos protos/*.proto
dartfmt -w lib/generated
