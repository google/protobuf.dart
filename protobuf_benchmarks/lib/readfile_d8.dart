// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:typed_data';

import 'package:js/js.dart';

/// Read the file at the given [path].
///
/// This relies on the `readbuffer` function provided by d8.
@JS()
external ByteBuffer readbuffer(String path);

/// Read the file at the given [path].
Uint8List readfile(String path) {
  return Uint8List.view(readbuffer(path));
}
