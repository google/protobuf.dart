// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../protoc.dart';

/// Utility class for building paths of proto elements: messages, fields, enums, ooneofs.
/// Each proto element contains a path which is a list of integers.
/// They way they are constructed described in SourceCodeInfo proto in
/// https://github.com/protocolbuffers/protobuf/blob/main/src/google/protobuf/descriptor.proto
///
/// To build a path of an element you need to have path of the parent and call
/// one of the methods in this class. It will return the new path.
class Paths {
  // The tag numbers match tags in their containing types. For example, _oneofFieldTag = 8 because
  // its containing descriptor is DescriptorProto which has:
  // repeated OneofDescriptorProto oneof_decl = 8;

  // Matches FileDescriptorProto.message_type = 4.
  static final _topLevelMessageTag = 4;

  // Matches DescriptorProto.nested_type = 3.
  static final _nestedMessageTag = 3;

  // Matches DescriptorProto.field = 2.
  static final _messageFieldTag = 2;

  // Matches DescriptorProto.oneof_decl = 8.
  static final _oneofFieldTag = 8;

  static List<int> buildTopLevelMessagePath(
    List<int> parentPath,
    int messageIndex,
  ) {
    return List.from(parentPath)..addAll([_topLevelMessageTag, messageIndex]);
  }

  static List<int> buildNestedMessagePath(
    List<int> parentPath,
    int messageIndex,
  ) {
    return List.from(parentPath)..addAll([_nestedMessageTag, messageIndex]);
  }

  static List<int> buildFieldPath(List<int> parentPath, ProtobufField field) {
    return List.from(parentPath)
      ..addAll([_messageFieldTag, field.sourcePosition!]);
  }

  static List<int> buildOneofPath(List<int> parentPath, OneofNames oneof) {
    return List.from(parentPath)..addAll([_oneofFieldTag, oneof.index]);
  }
}
