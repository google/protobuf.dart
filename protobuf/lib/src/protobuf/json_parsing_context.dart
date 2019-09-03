// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

class JsonParsingContext {
  // A list of indices into maps and lists pointing to the current root.
  final List<String> path = <String>[];
  final bool ignoreUnknownFields;
  final bool supportNamesWithUnderscores;
  JsonParsingContext(
      this.ignoreUnknownFields, this.supportNamesWithUnderscores);

  /// Returns a FormatException pointing to the current [path].
  Exception parseException(String message) {
    String formattedPath = path.map((s) => '[\"$s\"]').join();
    return FormatException(
        'Protobuf JSON decoding failed at: root$formattedPath. $message');
  }
}
