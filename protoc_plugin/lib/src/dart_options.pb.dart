///
//  Generated code. Do not modify.
//  source: dart_options.proto
//
// @dart = 2.3
// ignore_for_file: annotate_overrides,camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type,unnecessary_this,prefer_final_fields

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

class DartMixin extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DartMixin',
      package: const $pb.PackageName('dart_options'),
      createEmptyInstance: create)
    ..aOS(1, 'name')
    ..aOS(2, 'importFrom')
    ..aOS(3, 'parent')
    ..hasRequiredFields = false;

  DartMixin._() : super();
  factory DartMixin() => create();
  factory DartMixin.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DartMixin.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DartMixin clone() => DartMixin()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DartMixin copyWith(void Function(DartMixin) updates) =>
      super.copyWith((message) =>
          updates(message as DartMixin)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static DartMixin create() => DartMixin._();
  DartMixin createEmptyInstance() => create();
  static $pb.PbList<DartMixin> createRepeated() => $pb.PbList<DartMixin>();
  @$core.pragma('dart2js:noInline')
  static DartMixin getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DartMixin>(create);
  static DartMixin _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get importFrom => $_getSZ(1);
  @$pb.TagNumber(2)
  set importFrom($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasImportFrom() => $_has(1);
  @$pb.TagNumber(2)
  void clearImportFrom() => clearField(2);

  @$pb.TagNumber(3)
  $core.String get parent => $_getSZ(2);
  @$pb.TagNumber(3)
  set parent($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasParent() => $_has(2);
  @$pb.TagNumber(3)
  void clearParent() => clearField(3);
}

class Imports extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Imports',
      package: const $pb.PackageName('dart_options'),
      createEmptyInstance: create)
    ..pc<DartMixin>(1, 'mixins', $pb.PbFieldType.PM,
        subBuilder: DartMixin.create)
    ..hasRequiredFields = false;

  Imports._() : super();
  factory Imports() => create();
  factory Imports.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Imports.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Imports clone() => Imports()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Imports copyWith(void Function(Imports) updates) =>
      super.copyWith((message) =>
          updates(message as Imports)); // ignore: deprecated_member_use
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Imports create() => Imports._();
  Imports createEmptyInstance() => create();
  static $pb.PbList<Imports> createRepeated() => $pb.PbList<Imports>();
  @$core.pragma('dart2js:noInline')
  static Imports getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Imports>(create);
  static Imports _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<DartMixin> get mixins => $_getList(0);
}

class Dart_options {
  static final $pb.Extension imports = $pb.Extension<Imports>(
      'google.protobuf.FileOptions', 'imports', 28125061, $pb.PbFieldType.OM,
      defaultOrMaker: Imports.getDefault, subBuilder: Imports.create);
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
