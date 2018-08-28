///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart' as $pb;

class DartMixin extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DartMixin')
    ..aOS(1, 'name')
    ..aOS(2, 'importFrom')
    ..aOS(3, 'parent')
    ..hasRequiredFields = false;

  DartMixin() : super();
  DartMixin.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DartMixin.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DartMixin clone() => new DartMixin()..mergeFromMessage(this);
  $pb.BuilderInfo get info_ => _i;
  static DartMixin create() => new DartMixin();
  static $pb.PbList<DartMixin> createRepeated() => new $pb.PbList<DartMixin>();
  static DartMixin getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDartMixin();
    return _defaultInstance;
  }

  static DartMixin _defaultInstance;
  static void $checkItem(DartMixin v) {
    if (v is! DartMixin) $pb.checkItemFailed(v, 'DartMixin');
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get importFrom => $_getS(1, '');
  set importFrom(String v) {
    $_setString(1, v);
  }

  bool hasImportFrom() => $_has(1);
  void clearImportFrom() => clearField(2);

  String get parent => $_getS(2, '');
  set parent(String v) {
    $_setString(2, v);
  }

  bool hasParent() => $_has(2);
  void clearParent() => clearField(3);
}

class _ReadonlyDartMixin extends DartMixin with $pb.ReadonlyMessageMixin {}

class Imports extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('Imports')
    ..pp<DartMixin>(
        1, 'mixins', $pb.PbFieldType.PM, DartMixin.$checkItem, DartMixin.create)
    ..hasRequiredFields = false;

  Imports() : super();
  Imports.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Imports.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Imports clone() => new Imports()..mergeFromMessage(this);
  $pb.BuilderInfo get info_ => _i;
  static Imports create() => new Imports();
  static $pb.PbList<Imports> createRepeated() => new $pb.PbList<Imports>();
  static Imports getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyImports();
    return _defaultInstance;
  }

  static Imports _defaultInstance;
  static void $checkItem(Imports v) {
    if (v is! Imports) $pb.checkItemFailed(v, 'Imports');
  }

  List<DartMixin> get mixins => $_getList(0);
}

class _ReadonlyImports extends Imports with $pb.ReadonlyMessageMixin {}

class Dart_options {
  static final $pb.Extension imports = new $pb.Extension<Imports>(
      'FileOptions',
      'imports',
      28125061,
      $pb.PbFieldType.OM,
      Imports.getDefault,
      Imports.create);
  static final $pb.Extension defaultMixin = new $pb.Extension<String>(
      'FileOptions', 'defaultMixin', 96128839, $pb.PbFieldType.OS);
  static final $pb.Extension mixin = new $pb.Extension<String>(
      'MessageOptions', 'mixin', 96128839, $pb.PbFieldType.OS);
  static final $pb.Extension overrideGetter = new $pb.Extension<bool>(
      'FieldOptions', 'overrideGetter', 28205290, $pb.PbFieldType.OB);
  static final $pb.Extension overrideSetter = new $pb.Extension<bool>(
      'FieldOptions', 'overrideSetter', 28937366, $pb.PbFieldType.OB);
  static final $pb.Extension overrideHasMethod = new $pb.Extension<bool>(
      'FieldOptions', 'overrideHasMethod', 28937461, $pb.PbFieldType.OB);
  static final $pb.Extension overrideClearMethod = new $pb.Extension<bool>(
      'FieldOptions', 'overrideClearMethod', 28907907, $pb.PbFieldType.OB);
  static final $pb.Extension dartName = new $pb.Extension<String>(
      'FieldOptions', 'dartName', 28700919, $pb.PbFieldType.OS);
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(imports);
    registry.add(defaultMixin);
    registry.add(mixin);
    registry.add(overrideGetter);
    registry.add(overrideSetter);
    registry.add(overrideHasMethod);
    registry.add(overrideClearMethod);
    registry.add(dartName);
  }
}
