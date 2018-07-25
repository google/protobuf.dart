// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// Unpacks the message in [value] into [instance].
///
/// Throws a [InvalidProtocolBufferException] if [typeUrl] does not correspond
/// with the type of [instance].
///
/// This is a helper method for `Any.unpack`.
void unpackInto<T extends GeneratedMessage>(
    T instance, List<int> value, String typeUrl,
    {ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY}) {
  String typeName = instance.info_.fullName;
  if (typeName != _typeNameFromUrl(typeUrl)) {
    throw new InvalidProtocolBufferException.wrongAnyMessage(
        _typeNameFromUrl(typeUrl), typeName);
  }
  instance.mergeFromBuffer(value, extensionRegistry);
}

String _typeNameFromUrl(String typeUrl) {
  int index = typeUrl.lastIndexOf('/');
  return index == -1 ? typeUrl : typeUrl.substring(index + 1);
}
