// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert' show jsonDecode, jsonEncode;

import '../internal.dart';
import 'json.dart';

String writeToJsonString(FieldSet fs) => jsonEncode(writeToJsonMap(fs));

/// Merge fields from a [json] string.
void mergeFromJsonString(
  FieldSet fs,
  String json,
  ExtensionRegistry? registry,
) {
  final jsonMap = jsonDecode(json);
  if (jsonMap is! Map<String, dynamic>) {
    throw ArgumentError.value(json, 'json', 'Does not parse to a JSON object.');
  }
  mergeFromJsonMap(fs, jsonMap, registry);
}
