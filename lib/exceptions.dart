// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class InvalidDefaultValue implements Exception {
  final String message;

  InvalidDefaultValue.double(String fieldName, String invalidValue) : message =
      'InvalidDefaultValue: protoc found invalid default value ($invalidValue)'
      ' for the double field $fieldName';
}

