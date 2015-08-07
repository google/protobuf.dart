#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protoc_options_test;

import 'package:protoc_plugin/src/plugin.pb.dart';
import 'package:protoc_plugin/protoc.dart';
import 'package:test/test.dart';


void main() {
  test('testValidGeneratorOptions', () {
      checkValid(String parameter, Map expected) {
      var request = new CodeGeneratorRequest();
      if (parameter != null) request.parameter = parameter;
      var response = new CodeGeneratorResponse();
      var options = parseGenerationOptions(request, response);
      expect(options, new isInstanceOf<GenerationOptions>());
      expect(response.error, '');
      expect(options.fieldNameOverrides, equals(expected));
    }

    checkValid(null, {});
    checkValid('', {});
    checkValid(',', {});
    checkValid(',,,', {});
    checkValid('  , , ,', {});

    checkValid('field_name=a|b', {'.a' : 'b'});
    checkValid('field_name = a | b,,,', {'.a' : 'b'});
    checkValid('field_name=a|b,field_name=p.C|d', {'.a' : 'b', '.p.C' : 'd'});
    checkValid(' field_name = a | b,  , field_name = p.C | d ',
               {'.a' : 'b', '.p.C' : 'd'});
  });

  test('testInvalidGeneratorOptions', () {
      checkInvalid(String parameter) {
      var request = new CodeGeneratorRequest();
      if (parameter != null) request.parameter = parameter;
      var response = new CodeGeneratorResponse();
      var options = parseGenerationOptions(request, response);
      expect(options, isNull);
    }

    checkInvalid('abc');
    checkInvalid('abc,def');
    checkInvalid('field_name=');
    checkInvalid('field_name=a');
    checkInvalid('field_name=a|');
    checkInvalid('field_name=|');
    checkInvalid('field_name=|b');
  });
}
