// Copyright (c) 2022, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class JsonSerializationContext {
  final bool emitDefaults;

  JsonSerializationContext(this.emitDefaults);
}

class JsonSerializationException implements Exception {
  final String message;

  JsonSerializationException(this.message);

  @override
  String toString() => message;
}
