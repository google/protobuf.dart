// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// Server side context.
class ServerContext {
  // TODO: Place server specific information in this class.
}

/// Abstract class used to implement a Service API.
///
/// The protoc compiler generates subclasses of this class containing abstract
/// methods for each defined service method and a handleCall method that
/// dispatches to the corresponding abstract method.
abstract class GeneratedService {
  Future<List<int>> handleCall(
      ServerContext ctx, String methodName, List<int> request);
}
