#!/bin/sh
# Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
# for details. All rights reserved. Use of this source code is governed by a
# BSD-style license that can be found in the LICENSE file.

# Used to regenerate some basic generated Dart code.
# Cannot be a part of normal build process as it will lead to circular
# dependency.

blaze build net/proto2/contrib/dart:protoc_dart
cp blaze-genfiles/net/proto2/contrib/dart/protoc/src/* net/proto2/contrib/dart/protoc/src/protoc
