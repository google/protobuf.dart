#!/usr/bin/env dart
// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library const_generator_test;

import 'package:protoc_plugin/const_generator.dart';
import 'package:protoc_plugin/indenting_writer.dart';
import 'package:test/test.dart';

String toConst(val) {
  var out = IndentingWriter();
  writeJsonConst(out, val);
  return out.toString();
}

void main() {
  test('writeJsonConst examples', () {
    expect(toConst(null), "null");
    expect(toConst(true), "true");
    expect(toConst(false), "false");
    expect(toConst(123), "123");
    expect(toConst(123.456), "123.456");
  });

  test('writeJsonConst string examples', () {
    expect(toConst(""), "''");
    expect(toConst("hello"), "'hello'");
    expect(toConst(r"backslash: \"), r"r'backslash: \'");
    expect(toConst(r"hello $world"), r"r'hello $world'");
    expect(toConst("She said, 'hello.'"), '''"She said, 'hello.'"''');
    expect(toConst('''single: ' double: "'''), """'''single: ' double: "'''""");
    var triple = '"""';
    expect(toConst("""single: ' double: " triple: '''"""),
        """${triple}single: ' double: " triple: '''$triple""");
    expect(
        toConst("""single: ' double: " triples: ''' and $triple!"""),
        "r'''\n"
        "single: ' double: \" triples: ''' \"'''\" r''' and $triple!'''");
  });

  test('writeJsonConst list examples', () {
    expect(toConst([]), "const []");
    expect(toConst([1, 2, 3]), "const [1, 2, 3]");
    expect(
        toConst([
          [1, 2],
          [3, 4]
        ]),
        'const [\n'
        '  const [1, 2],\n'
        '  const [3, 4],\n'
        ']');
  });

  test('writeJsonConst map examples', () {
    expect(toConst({}), "const {}");
    expect(toConst({"a": 1, "b": 2}), "const {'a': 1, 'b': 2}");
    expect(
        toConst({
          "a": {"x": 1},
          "b": {"x": 2}
        }),
        "const {\n"
        "  'a': const {'x': 1},\n"
        "  'b': const {'x': 2},\n"
        "}");
  });
}
