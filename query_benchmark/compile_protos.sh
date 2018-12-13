#!/usr/bin/env bash
rm -rf lib/generated
mkdir lib/generated
protoc --dart_out=lib/generated -Iprotos protos/*.proto --plugin=../protoc_plugin/protoc_gen_dart
dartfmt -w lib/generated
