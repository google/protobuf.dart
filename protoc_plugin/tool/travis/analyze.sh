#!/usr/bin/env bash
set -ev

PATH=$HOME/protoc/bin:$PATH
protoc --version
dartanalyzer --version
pub get
make protos
dartanalyzer .
