#!/bin/bash

wget -O protoc.zip \
  https://github.com/protocolbuffers/protobuf/releases/download/v31.0/protoc-31.0-linux-x86_64.zip
unzip -d protoc protoc.zip

if [[ -z "${GITHUB_ENV}" ]]; then
  # Local run
  export PATH=$PWD/protoc/bin:$PATH
else
  # GitHub Actions
  echo "PATH=$PWD/protoc/bin:$PATH" >> $GITHUB_ENV
fi
