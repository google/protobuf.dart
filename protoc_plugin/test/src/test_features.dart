// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/protoc.dart';
import 'package:protoc_plugin/src/gen/google/protobuf/descriptor.pb.dart';
import 'package:protoc_plugin/src/gen/google/protobuf/unittest_features.pb.dart';

final testEditionDefaults = pluginFeatureSetDefaults;

// Sets a test-only feature extension that can be applied to any type of descriptor.
dynamic setTestFeature(dynamic descriptor, int value) {
  var features = descriptor;
  if (descriptor is! FeatureSet) {
    descriptor.ensureOptions();
    descriptor.options.ensureFeatures();
    features = descriptor.options.features;
  }
  features.setExtension(
    Unittest_features.test,
    TestFeatures()..multipleFeature = EnumFeature.valueOf(value)!,
  );
  return descriptor;
}

// Retrieves a test-only feature extension on an arbitrary descriptor.
int getTestFeature(FeatureSet features) {
  return features.getExtension(Unittest_features.test).multipleFeature.value;
}
