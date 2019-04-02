///
//  Generated code. Do not modify.
//  source: dart_options.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core
    show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

class DartMixin extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DartMixin',
      package: const $pb.PackageName('dart_options'))
    ..aOS(1, 'name')
    ..aOS(2, 'importFrom')
    ..aOS(3, 'parent')
    ..hasRequiredFields = false;

  DartMixin() : super();
  DartMixin.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DartMixin.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DartMixin clone() => DartMixin()..mergeFromMessage(this);
  DartMixin copyWith(void Function(DartMixin) updates) =>
      super.copyWith((message) => updates(message as DartMixin));
  $pb.BuilderInfo get info_ => _i;
  static DartMixin create() => DartMixin();
  DartMixin createEmptyInstance() => create();
  static $pb.PbList<DartMixin> createRepeated() => $pb.PbList<DartMixin>();
  static DartMixin getDefault() => _defaultInstance ??= create()..freeze();
  static DartMixin _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.String get importFrom => $_getS(1, '');
  set importFrom($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasImportFrom() => $_has(1);
  void clearImportFrom() => clearField(2);

  $core.String get parent => $_getS(2, '');
  set parent($core.String v) {
    $_setString(2, v);
  }

  $core.bool hasParent() => $_has(2);
  void clearParent() => clearField(3);
}

class Imports extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i =
      $pb.BuilderInfo('Imports', package: const $pb.PackageName('dart_options'))
        ..pc<DartMixin>(1, 'mixins', $pb.PbFieldType.PM, DartMixin.create)
        ..hasRequiredFields = false;

  Imports() : super();
  Imports.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Imports.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Imports clone() => Imports()..mergeFromMessage(this);
  Imports copyWith(void Function(Imports) updates) =>
      super.copyWith((message) => updates(message as Imports));
  $pb.BuilderInfo get info_ => _i;
  static Imports create() => Imports();
  Imports createEmptyInstance() => create();
  static $pb.PbList<Imports> createRepeated() => $pb.PbList<Imports>();
  static Imports getDefault() => _defaultInstance ??= create()..freeze();
  static Imports _defaultInstance;

  $core.List<DartMixin> get mixins => $_getList(0);
}

class Dart_options {
  static final $pb.Extension imports = $pb.Extension<Imports>(
      'google.protobuf.FileOptions',
      'imports',
      28125061,
      $pb.PbFieldType.OM,
      Imports.getDefault,
      Imports.create);
  static final $pb.Extension defaultMixin = $pb.Extension<$core.String>(
      'google.protobuf.FileOptions',
      'defaultMixin',
      96128839,
      $pb.PbFieldType.OS);
  static final $pb.Extension mixin = $pb.Extension<$core.String>(
      'google.protobuf.MessageOptions', 'mixin', 96128839, $pb.PbFieldType.OS);
  static final $pb.Extension overrideGetter = $pb.Extension<$core.bool>(
      'google.protobuf.FieldOptions',
      'overrideGetter',
      28205290,
      $pb.PbFieldType.OB);
  static final $pb.Extension overrideSetter = $pb.Extension<$core.bool>(
      'google.protobuf.FieldOptions',
      'overrideSetter',
      28937366,
      $pb.PbFieldType.OB);
  static final $pb.Extension overrideHasMethod = $pb.Extension<$core.bool>(
      'google.protobuf.FieldOptions',
      'overrideHasMethod',
      28937461,
      $pb.PbFieldType.OB);
  static final $pb.Extension overrideClearMethod = $pb.Extension<$core.bool>(
      'google.protobuf.FieldOptions',
      'overrideClearMethod',
      28907907,
      $pb.PbFieldType.OB);
  static final $pb.Extension dartName = $pb.Extension<$core.String>(
      'google.protobuf.FieldOptions', 'dartName', 28700919, $pb.PbFieldType.OS);
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
