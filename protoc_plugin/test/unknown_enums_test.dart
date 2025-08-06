// Copyright (c) 2023, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:test/test.dart';

import 'gen/enum_test.pb.dart';

void main() {
  group('Enum parsing in maps, lists, messages', () {
    test('Parse known fields', () {
      final json = {
        'enumField': 'Y',
        'mapValueField': {'1': 'Y'},
        'repeatedEnumField': ['Y'],
      };

      final msg = Message();
      msg.mergeFromProto3Json(json);
      expect(msg.enumField, A.Y);
      expect(msg.mapValueField.values.toList(), [A.Y]);
      expect(msg.repeatedEnumField, [A.Y]);
    });

    test('Skip unknown fields', () {
      final json = {
        'enumField': 'Z',
        'mapValueField': {'1': 'X', '2': 'Z', '3': 'Y'},
        'repeatedEnumField': ['X', 'Z', 'Y'],
      };

      final msg = Message();
      msg.enumField = A.Y;
      msg.mergeFromProto3Json(json, ignoreUnknownFields: true);
      expect(msg.enumField, A.Y);
      expect(msg.mapValueField.values.toList(), [A.X, A.Y]);
      expect(msg.repeatedEnumField, [A.X, A.Y]);
    });
  });
}
