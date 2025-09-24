// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/protoc.dart';
import 'package:test/test.dart';

void main() {
  // The edition defaults should always stay synchronized with the supported
  // edition range we report to protoc. It's not clear that the BUILD file
  // definitions are load-bearing though, so we test them here.
  test('Plugin supported editions are in sync with the defaults constant', () {
    expect(pluginMinSupportedEdition, pluginFeatureSetDefaults.minimumEdition);
    expect(pluginMaxSupportedEdition, pluginFeatureSetDefaults.maximumEdition);
  });
}
