// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:js' as js;

import 'dart:typed_data';

/// Reads the file at the given [path] and return its contents in a List<int>.
Uint8List readfile(String path) {
  // d8 specific implementation.
  js.JsObject jsArrayBuffer = js.context.callMethod('readbuffer', [path]);
  int length = jsArrayBuffer['byteLength'];
  js.JsObject jsInt8View =
      js.JsObject(js.context['Int8Array'], [jsArrayBuffer]);
  Uint8List result = Uint8List(length);
  for (int i = 0; i < length; i++) {
    result[i] = jsInt8View[i];
  }
  return result;
}
