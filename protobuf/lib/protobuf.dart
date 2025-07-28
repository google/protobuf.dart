// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Runtime library for Dart implementation of [protobufs][1].
///
/// [1]: https://developers.google.com/protocol-buffers
library;

export 'src/protobuf/internal.dart'
    hide
        BuilderInfoInternalExtension,
        ExtensionFieldSet,
        ExtensionFieldSetInternalExtension,
        FieldInfoInternalExtension,
        FieldSet,
        FieldSetInternalExtension,
        GeneratedMessageInternalExtension,
        MapFieldInfoInternalExtension,
        mapKeyFieldNumber,
        mapValueFieldNumber;
