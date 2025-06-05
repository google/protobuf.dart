// Copyright(c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:mirrors';

/// Returns the names of the public properties and non-static methods of a
/// class. Also visits its superclasses, recursively.
Set<String> findMemberNames(String importName, Symbol classSymbol) {
  final lib = currentMirrorSystem().libraries[Uri.parse(importName)]!;
  var cls = lib.declarations[classSymbol] as ClassMirror?;

  final result = <String>{};

  void addNames(ClassMirror cls) {
    final prefixToRemove = '${MirrorSystem.getName(cls.simpleName)}.';

    String chooseName(Symbol sym) {
      final name = MirrorSystem.getName(sym);
      if (name.startsWith(prefixToRemove)) {
        return name.substring(prefixToRemove.length);
      }
      return name;
    }

    for (final decl in cls.declarations.values) {
      if (!decl.isPrivate &&
          decl is! VariableMirror &&
          decl is! TypeVariableMirror &&
          !(decl is MethodMirror && decl.isStatic)) {
        result.add(chooseName(decl.simpleName));
      }
    }
  }

  while (cls != null) {
    addNames(cls);
    cls = cls.superclass;
  }

  return result;
}
