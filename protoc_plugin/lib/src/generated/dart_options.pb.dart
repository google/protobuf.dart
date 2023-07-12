//
//  Generated code. Do not modify.
//  source: dart_options.proto
//
// @dart = 2.12

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// A mixin that can be used in the 'with' clause of the generated Dart class
/// for a proto message.
class DartMixin extends $pb.GeneratedMessage {
  factory DartMixin() => create();
  DartMixin._() : super();
  factory DartMixin.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DartMixin.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DartMixin',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dart_options'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'importFrom')
    ..aOS(3, _omitFieldNames ? '' : 'parent')
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  DartMixin clone() => DartMixin()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  DartMixin copyWith(void Function(DartMixin) updates) =>
      super.copyWith((message) => updates(message as DartMixin)) as DartMixin;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DartMixin create() => DartMixin._();
  DartMixin createEmptyInstance() => create();
  static $pb.PbList<DartMixin> createRepeated() => $pb.PbList<DartMixin>();
  @$core.pragma('dart2js:noInline')
  static DartMixin getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<DartMixin>(create);
  static DartMixin? _defaultInstance;

  /// The name of the mixin class.
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

  /// A URI pointing to the Dart library that defines the mixin.
  /// The generated Dart code will use this in an import statement.
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

  /// The name of another mixin to be applied ahead of this one.
  /// The generated class for the message will inherit from all mixins
  /// in the parent chain.
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

/// Defines additional Dart imports to be used with messages in this file.
class Imports extends $pb.GeneratedMessage {
  factory Imports() => create();
  Imports._() : super();
  factory Imports.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Imports.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Imports',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'dart_options'),
      createEmptyInstance: create)
    ..pc<DartMixin>(1, _omitFieldNames ? '' : 'mixins', $pb.PbFieldType.PM,
        subBuilder: DartMixin.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.deepCopy] instead. '
      'Will be removed in next major version')
  Imports clone() => Imports()..mergeFromMessage(this);
  @$core.Deprecated('Using this can add significant overhead to your binary. '
      'Use [GeneratedMessageGenericExtensions.rebuild] instead. '
      'Will be removed in next major version')
  Imports copyWith(void Function(Imports) updates) =>
      super.copyWith((message) => updates(message as Imports)) as Imports;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Imports create() => Imports._();
  Imports createEmptyInstance() => create();
  static $pb.PbList<Imports> createRepeated() => $pb.PbList<Imports>();
  @$core.pragma('dart2js:noInline')
  static Imports getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Imports>(create);
  static Imports? _defaultInstance;

  ///  Mixins to be used on messages in this file.
  ///  These mixins are in addition to internally defined mixins (e.g PbMapMixin)
  ///  and may override them.
  ///
  ///  Warning: mixins are experimental. The protoc Dart plugin doesn't check
  ///  for name conflicts between mixin class members and generated class members,
  ///  so the generated code may contain errors. Therefore, running dartanalyzer
  ///  on the generated file is a good idea.
  @$pb.TagNumber(1)
  $core.List<DartMixin> get mixins => $_getList(0);
}

class Dart_options {
  static final imports = $pb.Extension<Imports>(
      _omitMessageNames ? '' : 'google.protobuf.FileOptions',
      _omitFieldNames ? '' : 'imports',
      28125061,
      $pb.PbFieldType.OM,
      defaultOrMaker: Imports.getDefault,
      subBuilder: Imports.create);
  static final defaultMixin = $pb.Extension<$core.String>(
      _omitMessageNames ? '' : 'google.protobuf.FileOptions',
      _omitFieldNames ? '' : 'defaultMixin',
      96128839,
      $pb.PbFieldType.OS);
  static final mixin = $pb.Extension<$core.String>(
      _omitMessageNames ? '' : 'google.protobuf.MessageOptions',
      _omitFieldNames ? '' : 'mixin',
      96128839,
      $pb.PbFieldType.OS);
  static final overrideGetter = $pb.Extension<$core.bool>(
      _omitMessageNames ? '' : 'google.protobuf.FieldOptions',
      _omitFieldNames ? '' : 'overrideGetter',
      28205290,
      $pb.PbFieldType.OB);
  static final overrideSetter = $pb.Extension<$core.bool>(
      _omitMessageNames ? '' : 'google.protobuf.FieldOptions',
      _omitFieldNames ? '' : 'overrideSetter',
      28937366,
      $pb.PbFieldType.OB);
  static final overrideHasMethod = $pb.Extension<$core.bool>(
      _omitMessageNames ? '' : 'google.protobuf.FieldOptions',
      _omitFieldNames ? '' : 'overrideHasMethod',
      28937461,
      $pb.PbFieldType.OB);
  static final overrideClearMethod = $pb.Extension<$core.bool>(
      _omitMessageNames ? '' : 'google.protobuf.FieldOptions',
      _omitFieldNames ? '' : 'overrideClearMethod',
      28907907,
      $pb.PbFieldType.OB);
  static final dartName = $pb.Extension<$core.String>(
      _omitMessageNames ? '' : 'google.protobuf.FieldOptions',
      _omitFieldNames ? '' : 'dartName',
      28700919,
      $pb.PbFieldType.OS);
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

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
