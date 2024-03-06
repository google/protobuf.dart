abstract mixin class Mixin1 {
  String get overriddenString => 'mixin1';

  String get interfaceString;
  set interfaceString(String string);
  bool hasInterfaceString();
}

abstract mixin class Mixin2 {
  String get overriddenString => 'mixin2';

  bool hasOverriddenHasMethod() => false;
}

abstract mixin class Mixin3 {}
