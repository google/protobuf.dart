// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// A collection of [Extension] objects, organized by the message type they
/// extend.
class ExtensionRegistry {
  final Map<String, Map<int, Extension>> _extensions =
      <String, Map<int, Extension>>{};

  static const ExtensionRegistry EMPTY = _EmptyExtensionRegistry();

  /// Stores an [extension] in the registry.
  void add(Extension extension) {
    var map = _extensions.putIfAbsent(
        extension.extendee, () => Map<int, Extension>());
    map[extension.tagNumber] = extension;
  }

  /// Stores all [extensions] in the registry.
  void addAll(Iterable<Extension> extensions) {
    extensions.forEach(add);
  }

  /// Retrieves an extension from the registry that adds tag number [tagNumber]
  /// to the [messageName] message type.
  Extension getExtension(String messageName, int tagNumber) {
    var map = _extensions[messageName];
    if (map != null) {
      return map[tagNumber];
    }
    return null;
  }

  /// Returns a shallow copy of [message], with all extensions in [this] parsed
  /// from its unknownFields.
  ///
  /// If [message] is frozen the result will be as well.
  T reparseMessage<T extends GeneratedMessage>(T message) =>
      _reparseMessage(message, this);
}

T _reparseMessage<T extends GeneratedMessage>(
    T message, ExtensionRegistry extensionRegistry) {
  T result = message.createEmptyInstance();

  result._fieldSet._shallowCopyValues(message._fieldSet);
  UnknownFieldSet resultUnknownFields = result._fieldSet._unknownFields;
  if (resultUnknownFields != null) {
    CodedBufferWriter codedBufferWriter = CodedBufferWriter();
    extensionRegistry._extensions[message.info_.qualifiedMessageName]
        ?.forEach((tagNumber, extension) {
      final UnknownFieldSetField unknownField =
          resultUnknownFields._fields[tagNumber];
      if (unknownField != null) {
        unknownField.writeTo(tagNumber, codedBufferWriter);
      }
      resultUnknownFields._fields.remove(tagNumber);
    });

    result.mergeFromBuffer(codedBufferWriter.toBuffer(), extensionRegistry);
  }
  if (message._fieldSet._isReadOnly) {
    result.freeze();
  }
  return result;
}

class _EmptyExtensionRegistry implements ExtensionRegistry {
  const _EmptyExtensionRegistry();

  get _extensions => const <String, Map<int, Extension>>{};

  void add(Extension extension) {
    throw UnsupportedError('Immutable ExtensionRegistry');
  }

  void addAll(Iterable<Extension> extensions) {
    throw UnsupportedError('Immutable ExtensionRegistry');
  }

  Extension getExtension(String messageName, int tagNumber) => null;

  T reparseMessage<T extends GeneratedMessage>(T message) =>
      _reparseMessage(message, this);
}
