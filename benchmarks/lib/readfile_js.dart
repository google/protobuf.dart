// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js_interop';
import 'dart:typed_data';

/// Read the file at the given [path].
///
/// This relies on the `readbuffer` function provided by d8.
@JS()
external JSArrayBuffer readbuffer(String path);

/// Read the file at the given [path].
Uint8List readfile(String path) {
  // Copy the contents to a new `Uint8List` to make sure in dart2wasm we
  // benchmark with the native arrays instead of JS arrays.
  return Uint8List.fromList(readbuffer(path).toDart.asUint8List());
}
