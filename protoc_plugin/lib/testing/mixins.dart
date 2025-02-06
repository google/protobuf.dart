mixin Mixin1 {
  String get overriddenString => 'mixin1';

  String get interfaceString;
  set interfaceString(String string);
  bool hasInterfaceString();
}

mixin Mixin2 {
  String get overriddenString => 'mixin2';

  bool hasOverriddenHasMethod() => false;
}

mixin Mixin3 {}
