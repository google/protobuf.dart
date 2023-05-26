// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/src/generated/plugin.pb.dart';
import 'package:protoc_plugin/src/options.dart';
import 'package:test/test.dart';

void main() {
  test('testValidGeneratorOptions', () {
    void checkValid(String? parameter) {
      final request = CodeGeneratorRequest();
      if (parameter != null) request.parameter = parameter;
      final response = CodeGeneratorResponse();
      final options = parseGenerationOptions(request, response);
      expect(options, TypeMatcher<GenerationOptions>());
      expect(response.error, '');
    }

    checkValid(null);
    checkValid('');
    checkValid(',');
    checkValid(',,,');
    checkValid('  , , ,');
  });

  test('testInvalidGeneratorOptions', () {
    void checkInvalid(String parameter) {
      final request = CodeGeneratorRequest();
      request.parameter = parameter;
      final response = CodeGeneratorResponse();
      final options = parseGenerationOptions(request, response);
      expect(options, isNull);
    }

    checkInvalid('abc');
    checkInvalid('abc,def');
  });
}
