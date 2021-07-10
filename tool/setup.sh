#!/bin/bash

wget -O protoc.zip https://github.com/protocolbuffers/protobuf/releases/download/v3.17.3/protoc-3.17.3-linux-x86_64.zip
unzip -d protoc protoc.zip
if [[ -z "${GITHUB_ENV}" ]]; then
  # Local mono_repo presubmit run
  export PATH=$PWD/protoc/bin:$PATH
else
  # GitHub Actions
  echo "PATH=$PWD/protoc/bin:$PATH" >> $GITHUB_ENV
fi
