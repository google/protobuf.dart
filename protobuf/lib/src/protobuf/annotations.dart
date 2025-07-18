// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'internal.dart';

/// Annotation for marking accessors that belong together.
class TagNumber {
  final int tagNumber;

  /// Annotation for marking accessors that belong together.
  ///
  /// Allows tooling to associate related accessors. The [tagNumber] is the
  /// protobuf field tag associated with the annotated accessor.
  const TagNumber(this.tagNumber);
}

/// Use to annotate generated gRPC classes with the ID of the corresponding
/// service.
class GrpcServiceName {
  const GrpcServiceName(this.serviceId);

  // This field is used by static analyzers.
  final String serviceId;
}
