// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart = 2.12

abstract class Mixin1 {
  String get overriddenString => "mixin1";

  String get interfaceString;
  set interfaceString(String string);
  bool hasInterfaceString();
}

abstract class Mixin2 {
  String get overriddenString => "mixin2";

  bool hasOverriddenHasMethod() => false;
}

abstract class Mixin3 {}
