// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// Client side context.
class ClientContext {
  // TODO: Place client side specific information here.
}

/// Client interface.
///
/// This must be implemented by protobuf clients which are passed to the
/// generated client stub class at construction.
abstract class RpcClient {
  Future<List<int>> Invoke(
      ClientContext ctx, String methodName, List<int> request);
}
