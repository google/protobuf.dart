// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library dart_name_test;

import 'package:test/test.dart';
import 'package:protoc_plugin/names.dart' as names;
import 'package:protoc_plugin/src/descriptor.pb.dart';
import 'package:protoc_plugin/src/dart_options.pb.dart';

import '../out/protos/dart_name.pb.dart';

Matcher throwsMessage(String msg) => throwsA(new _ToStringMatcher(equals(msg)));

class _ToStringMatcher extends CustomMatcher {
  _ToStringMatcher(Matcher matcher)
      : super("object where toString() returns", "toString()", matcher);
  featureValueOf(actual) => actual.toString();
}

void main() {
  test('Can access a field that was renamed using dart_name option', () {
    var msg = new DartName();
    expect(msg.hasRenamedField(), false);
    msg.renamedField = 'test';
    expect(msg.hasRenamedField(), true);
    expect(msg.renamedField, 'test');
    msg.clearRenamedField();
    expect(msg.hasRenamedField(), false);
  });

  test('Can swap field names using dart_name option', () {
    var msg = new SwapNames();
    msg.first = "one";
    msg.second = "two";
    expect(msg.getField(1), "two");
    expect(msg.getField(2), "one");
  });

  test("Can take another field's name using dart_name option", () {
    var msg = new TakeExistingName();
    msg.first = "one";
    expect(msg.getField(2), "one");
    msg.first_1 = "renamed";
    expect(msg.getField(1), "renamed");
  });

  test('Throws exception for dart_name option containing a space', () {
    var descriptor = new DescriptorProto()
      ..name = 'Example'
      ..field.add(stringField("first", 1, "hello world"));
    expect(() {
      names.messageFieldNames(descriptor);
    },
        throwsMessage("Example.first: dart_name option is invalid: "
            "'hello world' is not a valid Dart field name"));
  });

  test('Throws exception for dart_name option set to reserved word', () {
    var descriptor = new DescriptorProto()
      ..name = 'Example'
      ..field.add(stringField("first", 1, "class"));
    expect(() {
      names.messageFieldNames(descriptor);
    },
        throwsMessage("Example.first: "
            "dart_name option is invalid: 'class' is already used"));
  });

  test('Throws exception for duplicate dart_name options', () {
    var descriptor = new DescriptorProto()
      ..name = 'Example'
      ..field.addAll([
        stringField("first", 1, "renamed"),
        stringField("second", 2, "renamed"),
      ]);
    expect(() {
      names.messageFieldNames(descriptor);
    },
        throwsMessage("Example.second: "
            "dart_name option is invalid: 'renamed' is already used"));
  });
}

FieldDescriptorProto stringField(String name, int number, String dartName) {
  return new FieldDescriptorProto()
    ..name = name
    ..number = number
    ..label = FieldDescriptorProto_Label.LABEL_OPTIONAL
    ..type = FieldDescriptorProto_Type.TYPE_STRING
    ..options =
        (new FieldOptions()..setExtension(Dart_options.dartName, dartName));
}
