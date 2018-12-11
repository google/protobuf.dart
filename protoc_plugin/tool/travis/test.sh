#!/usr/bin/env bash
set -ev

PATH=$HOME/protoc/bin:$PATH
protoc --version
pub get
make clean run-tests
