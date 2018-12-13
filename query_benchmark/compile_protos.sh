#!/usr/bin/env bash
rm -rf lib/generated
mkdir lib/generated
protoc --dart_out=lib/generated --plugin=../protoc_plugin/bin/protoc-gen-dart -Iprotos protos/*.proto
dartfmt -w lib/generated
