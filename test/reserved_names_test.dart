#!/usr/bin/env dart
// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library reserved_names_test;

import 'dart:mirrors' as mirrors;

import 'package:unittest/unittest.dart';

import '../lib/protoc.dart' show MessageGenerator;

import 'test_util.dart';

void main() {
  test('testReservedNamesList', () {
    Set<String> names = new Set<String>();
    fillConflictingNames(mirrors.ClassMirror cls) {
      String className = mirrors.MirrorSystem.getName(cls.simpleName);
      names.addAll(
          cls
          .constructors
          .values
          .where((ctor) => !ctor.isPrivate)
          .map((m) => mirrors.MirrorSystem.getName(m.simpleName))
          .map((n) => n.startsWith(className + '.')
                      ? n.substring(className.length + 1) : n)
          .toList());
      names.addAll(
          cls
          .members
          .values
          .where((_) => !_.isPrivate && _ is !mirrors.VariableMirror)
          .map((m) => mirrors.MirrorSystem.getName(m.simpleName)).toList());
    }

    var cls = mirrors.currentMirrorSystem()
        .libraries[Uri.parse('package:protobuf/protobuf.dart')]
        .classes[#GeneratedMessage];
    do {
      fillConflictingNames(cls);
      cls = cls.superclass;
    } while (cls != null);

    var x = new Set<String>()..addAll(MessageGenerator.reservedNames);
    expect(names.toList()..sort(), equals(x.toList()..sort()));
  });
}
