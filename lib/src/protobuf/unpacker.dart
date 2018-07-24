// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

typedef UnpackerFunction<T> = T Function(List<int> value,
    {ExtensionRegistry extensionRegistry});

class Unpacker<T> {
  final UnpackerFunction<T> _fromBuffer;
  final String _typeName;

  Unpacker(UnpackerFunction fromBuffer, String typeName)
      : _fromBuffer = fromBuffer,
        _typeName = typeName;

  T unpack(List<int> value, String typeUrl,
      {ExtensionRegistry extensionRegistry = ExtensionRegistry.EMPTY}) {
    if (_typeName != typeNameFromUrl(typeUrl)) {
      throw new InvalidProtocolBufferException.wrongAnyMessage(
          typeNameFromUrl(typeUrl), _typeName);
    }
    return _fromBuffer(value, extensionRegistry: extensionRegistry);
  }
}

String typeNameFromUrl(String typeUrl) {
  int index = typeUrl.lastIndexOf('/');
  return index == -1 ? typeUrl : typeUrl.substring(index + 1);
}
