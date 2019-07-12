// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

PbMixin wellKnownMixinForFullName(String qualifiedName) =>
    _wellKnownMixins[qualifiedName];

const _wellKnownMixins = {
  'google.protobuf.Any': PbMixin('AnyMixin',
      importFrom: 'package:protobuf/src/protobuf/mixins/well_known.dart',
      injectedHelpers: [
        '''
/// Creates a new [Any] encoding [message].
///
/// The [typeUrl] will be [typeUrlPrefix]/`fullName` where `fullName` is
/// the fully qualified name of the type of [message].
static Any pack($_protobufImportPrefix.GeneratedMessage message,
{$_coreImportPrefix.String typeUrlPrefix = 'type.googleapis.com'}) {
  final result = create();
  $_mixinImportPrefix.AnyMixin.packIntoAny(result, message,
      typeUrlPrefix: typeUrlPrefix);
  return result;
}'''
      ]),
  'google.protobuf.Timestamp': PbMixin('TimestampMixin',
      importFrom: 'package:protobuf/src/protobuf/mixins/well_known.dart',
      injectedHelpers: [
        '''
/// Creates a new instance from [dateTime].
///
/// Time zone information will not be preserved.
static Timestamp fromDateTime($_coreImportPrefix.DateTime dateTime) {
  final result = create();
  $_mixinImportPrefix.TimestampMixin.setFromDateTime(result, dateTime);
  return result;
}'''
    ]),
};
