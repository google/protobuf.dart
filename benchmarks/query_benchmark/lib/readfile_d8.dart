import 'dart:js' as js;

import 'dart:typed_data';

/// Reads the file at the given [path] and return its contents in a List<int>.
Uint8List readfile(String path) {
  // d8 specific implementation.
  js.JsObject jsArrayBuffer = js.context.callMethod('readbuffer', [path]);
  int length = jsArrayBuffer['byteLength'];
  js.JsObject jsInt8View = new js.JsObject(js.context['Int8Array'], [jsArrayBuffer]);
  Uint8List result = new Uint8List(length);
  for (int i = 0; i < length; i++) {
    result[i] = jsInt8View[i];
  }
  return result;
}
