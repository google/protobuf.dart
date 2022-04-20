// Copyright(c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:mirrors';

/// Returns the names of the public properties and non-static methods of a
/// class. Also visits its superclasses, recursively.
Set<String> findMemberNames(String importName, Symbol classSymbol) {
  var lib = currentMirrorSystem().libraries[Uri.parse(importName)]!;
  var cls = lib.declarations[classSymbol] as ClassMirror?;

  var result = <String>{};

  void addNames(ClassMirror cls) {
    var prefixToRemove = MirrorSystem.getName(cls.simpleName) + '.';

    String chooseName(Symbol sym) {
      var name = MirrorSystem.getName(sym);
      if (name.startsWith(prefixToRemove)) {
        return name.substring(prefixToRemove.length);
      }
      return name;
    }

    for (var decl in cls.declarations.values) {
      if (!decl.isPrivate &&
          decl is! VariableMirror &&
          decl is! TypeVariableMirror) {
        result.add(chooseName(decl.simpleName));
      }
    }
  }

  while (cls != null) {
    addNames(cls);
    cls = cls.superclass;
  }

  return result..removeAll(_staticMethods);
}

// We don't consider static methods as reserved as it's not possible to
// override or shadow a static method in a subclass. However `dart:mirrors`
// does not provide a `isStatic` property on declarations so we can't check for
// static methods in `findMemberNames`. Instead we need to hard-code static
// methods of `GeneratedMessage` and its superclasses here and manually remove
// these in `findMemberNames`.
const _staticMethods = {
  // These were added in Dart 2.14:
  'hash',
  'hashAll',
  'hashAllUnordered',
};
