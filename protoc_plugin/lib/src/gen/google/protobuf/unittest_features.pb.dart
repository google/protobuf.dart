// This is a generated file - do not edit.
//
// Generated from google/protobuf/unittest_features.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'unittest_features.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'unittest_features.pbenum.dart';

class TestMessage_Nested extends $pb.GeneratedMessage {
  factory TestMessage_Nested() => create();

  TestMessage_Nested._();

  factory TestMessage_Nested.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestMessage_Nested.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestMessage.Nested',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;
  static final testNested = $pb.Extension<TestFeatures>(
      _omitMessageNames ? '' : 'google.protobuf.FeatureSet',
      _omitFieldNames ? '' : 'testNested',
      9997,
      $pb.PbFieldType.OM,
      defaultOrMaker: TestFeatures.getDefault,
      subBuilder: TestFeatures.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestMessage_Nested clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestMessage_Nested copyWith(void Function(TestMessage_Nested) updates) =>
      super.copyWith((message) => updates(message as TestMessage_Nested))
          as TestMessage_Nested;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestMessage_Nested create() => TestMessage_Nested._();
  @$core.override
  TestMessage_Nested createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TestMessage_Nested getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestMessage_Nested>(create);
  static TestMessage_Nested? _defaultInstance;
}

class TestMessage extends $pb.GeneratedMessage {
  factory TestMessage() => create();

  TestMessage._();

  factory TestMessage.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestMessage.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestMessage',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'),
      createEmptyInstance: create)
    ..hasRequiredFields = false;
  static final testMessage = $pb.Extension<TestFeatures>(
      _omitMessageNames ? '' : 'google.protobuf.FeatureSet',
      _omitFieldNames ? '' : 'testMessage',
      9998,
      $pb.PbFieldType.OM,
      defaultOrMaker: TestFeatures.getDefault,
      subBuilder: TestFeatures.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestMessage clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestMessage copyWith(void Function(TestMessage) updates) =>
      super.copyWith((message) => updates(message as TestMessage))
          as TestMessage;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestMessage create() => TestMessage._();
  @$core.override
  TestMessage createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TestMessage getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestMessage>(create);
  static TestMessage? _defaultInstance;
}

class TestFeatures extends $pb.GeneratedMessage {
  factory TestFeatures({
    EnumFeature? fileFeature,
    EnumFeature? extensionRangeFeature,
    EnumFeature? messageFeature,
    EnumFeature? fieldFeature,
    EnumFeature? oneofFeature,
    EnumFeature? enumFeature,
    EnumFeature? enumEntryFeature,
    EnumFeature? serviceFeature,
    EnumFeature? methodFeature,
    EnumFeature? multipleFeature,
    $core.bool? boolFieldFeature,
    EnumFeature? sourceFeature,
    EnumFeature? sourceFeature2,
    EnumFeature? removedFeature,
    EnumFeature? futureFeature,
    EnumFeature? legacyFeature,
    ValueLifetimeFeature? valueLifetimeFeature,
  }) {
    final result = create();
    if (fileFeature != null) result.fileFeature = fileFeature;
    if (extensionRangeFeature != null)
      result.extensionRangeFeature = extensionRangeFeature;
    if (messageFeature != null) result.messageFeature = messageFeature;
    if (fieldFeature != null) result.fieldFeature = fieldFeature;
    if (oneofFeature != null) result.oneofFeature = oneofFeature;
    if (enumFeature != null) result.enumFeature = enumFeature;
    if (enumEntryFeature != null) result.enumEntryFeature = enumEntryFeature;
    if (serviceFeature != null) result.serviceFeature = serviceFeature;
    if (methodFeature != null) result.methodFeature = methodFeature;
    if (multipleFeature != null) result.multipleFeature = multipleFeature;
    if (boolFieldFeature != null) result.boolFieldFeature = boolFieldFeature;
    if (sourceFeature != null) result.sourceFeature = sourceFeature;
    if (sourceFeature2 != null) result.sourceFeature2 = sourceFeature2;
    if (removedFeature != null) result.removedFeature = removedFeature;
    if (futureFeature != null) result.futureFeature = futureFeature;
    if (legacyFeature != null) result.legacyFeature = legacyFeature;
    if (valueLifetimeFeature != null)
      result.valueLifetimeFeature = valueLifetimeFeature;
    return result;
  }

  TestFeatures._();

  factory TestFeatures.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory TestFeatures.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'TestFeatures',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'pb'),
      createEmptyInstance: create)
    ..aE<EnumFeature>(1, _omitFieldNames ? '' : 'fileFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(2, _omitFieldNames ? '' : 'extensionRangeFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(3, _omitFieldNames ? '' : 'messageFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(4, _omitFieldNames ? '' : 'fieldFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(5, _omitFieldNames ? '' : 'oneofFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(6, _omitFieldNames ? '' : 'enumFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(7, _omitFieldNames ? '' : 'enumEntryFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(8, _omitFieldNames ? '' : 'serviceFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(9, _omitFieldNames ? '' : 'methodFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(10, _omitFieldNames ? '' : 'multipleFeature',
        enumValues: EnumFeature.values)
    ..aOB(11, _omitFieldNames ? '' : 'boolFieldFeature')
    ..aE<EnumFeature>(15, _omitFieldNames ? '' : 'sourceFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(16, _omitFieldNames ? '' : 'sourceFeature2',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(17, _omitFieldNames ? '' : 'removedFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(18, _omitFieldNames ? '' : 'futureFeature',
        enumValues: EnumFeature.values)
    ..aE<EnumFeature>(19, _omitFieldNames ? '' : 'legacyFeature',
        enumValues: EnumFeature.values)
    ..aE<ValueLifetimeFeature>(
        20, _omitFieldNames ? '' : 'valueLifetimeFeature',
        enumValues: ValueLifetimeFeature.values)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestFeatures clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  TestFeatures copyWith(void Function(TestFeatures) updates) =>
      super.copyWith((message) => updates(message as TestFeatures))
          as TestFeatures;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static TestFeatures create() => TestFeatures._();
  @$core.override
  TestFeatures createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static TestFeatures getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<TestFeatures>(create);
  static TestFeatures? _defaultInstance;

  @$pb.TagNumber(1)
  EnumFeature get fileFeature => $_getN(0);
  @$pb.TagNumber(1)
  set fileFeature(EnumFeature value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasFileFeature() => $_has(0);
  @$pb.TagNumber(1)
  void clearFileFeature() => $_clearField(1);

  @$pb.TagNumber(2)
  EnumFeature get extensionRangeFeature => $_getN(1);
  @$pb.TagNumber(2)
  set extensionRangeFeature(EnumFeature value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasExtensionRangeFeature() => $_has(1);
  @$pb.TagNumber(2)
  void clearExtensionRangeFeature() => $_clearField(2);

  @$pb.TagNumber(3)
  EnumFeature get messageFeature => $_getN(2);
  @$pb.TagNumber(3)
  set messageFeature(EnumFeature value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasMessageFeature() => $_has(2);
  @$pb.TagNumber(3)
  void clearMessageFeature() => $_clearField(3);

  @$pb.TagNumber(4)
  EnumFeature get fieldFeature => $_getN(3);
  @$pb.TagNumber(4)
  set fieldFeature(EnumFeature value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasFieldFeature() => $_has(3);
  @$pb.TagNumber(4)
  void clearFieldFeature() => $_clearField(4);

  @$pb.TagNumber(5)
  EnumFeature get oneofFeature => $_getN(4);
  @$pb.TagNumber(5)
  set oneofFeature(EnumFeature value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasOneofFeature() => $_has(4);
  @$pb.TagNumber(5)
  void clearOneofFeature() => $_clearField(5);

  @$pb.TagNumber(6)
  EnumFeature get enumFeature => $_getN(5);
  @$pb.TagNumber(6)
  set enumFeature(EnumFeature value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasEnumFeature() => $_has(5);
  @$pb.TagNumber(6)
  void clearEnumFeature() => $_clearField(6);

  @$pb.TagNumber(7)
  EnumFeature get enumEntryFeature => $_getN(6);
  @$pb.TagNumber(7)
  set enumEntryFeature(EnumFeature value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasEnumEntryFeature() => $_has(6);
  @$pb.TagNumber(7)
  void clearEnumEntryFeature() => $_clearField(7);

  @$pb.TagNumber(8)
  EnumFeature get serviceFeature => $_getN(7);
  @$pb.TagNumber(8)
  set serviceFeature(EnumFeature value) => $_setField(8, value);
  @$pb.TagNumber(8)
  $core.bool hasServiceFeature() => $_has(7);
  @$pb.TagNumber(8)
  void clearServiceFeature() => $_clearField(8);

  @$pb.TagNumber(9)
  EnumFeature get methodFeature => $_getN(8);
  @$pb.TagNumber(9)
  set methodFeature(EnumFeature value) => $_setField(9, value);
  @$pb.TagNumber(9)
  $core.bool hasMethodFeature() => $_has(8);
  @$pb.TagNumber(9)
  void clearMethodFeature() => $_clearField(9);

  @$pb.TagNumber(10)
  EnumFeature get multipleFeature => $_getN(9);
  @$pb.TagNumber(10)
  set multipleFeature(EnumFeature value) => $_setField(10, value);
  @$pb.TagNumber(10)
  $core.bool hasMultipleFeature() => $_has(9);
  @$pb.TagNumber(10)
  void clearMultipleFeature() => $_clearField(10);

  @$pb.TagNumber(11)
  $core.bool get boolFieldFeature => $_getBF(10);
  @$pb.TagNumber(11)
  set boolFieldFeature($core.bool value) => $_setBool(10, value);
  @$pb.TagNumber(11)
  $core.bool hasBoolFieldFeature() => $_has(10);
  @$pb.TagNumber(11)
  void clearBoolFieldFeature() => $_clearField(11);

  @$pb.TagNumber(15)
  EnumFeature get sourceFeature => $_getN(11);
  @$pb.TagNumber(15)
  set sourceFeature(EnumFeature value) => $_setField(15, value);
  @$pb.TagNumber(15)
  $core.bool hasSourceFeature() => $_has(11);
  @$pb.TagNumber(15)
  void clearSourceFeature() => $_clearField(15);

  @$pb.TagNumber(16)
  EnumFeature get sourceFeature2 => $_getN(12);
  @$pb.TagNumber(16)
  set sourceFeature2(EnumFeature value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasSourceFeature2() => $_has(12);
  @$pb.TagNumber(16)
  void clearSourceFeature2() => $_clearField(16);

  @$pb.TagNumber(17)
  EnumFeature get removedFeature => $_getN(13);
  @$pb.TagNumber(17)
  set removedFeature(EnumFeature value) => $_setField(17, value);
  @$pb.TagNumber(17)
  $core.bool hasRemovedFeature() => $_has(13);
  @$pb.TagNumber(17)
  void clearRemovedFeature() => $_clearField(17);

  @$pb.TagNumber(18)
  EnumFeature get futureFeature => $_getN(14);
  @$pb.TagNumber(18)
  set futureFeature(EnumFeature value) => $_setField(18, value);
  @$pb.TagNumber(18)
  $core.bool hasFutureFeature() => $_has(14);
  @$pb.TagNumber(18)
  void clearFutureFeature() => $_clearField(18);

  @$pb.TagNumber(19)
  EnumFeature get legacyFeature => $_getN(15);
  @$pb.TagNumber(19)
  set legacyFeature(EnumFeature value) => $_setField(19, value);
  @$pb.TagNumber(19)
  $core.bool hasLegacyFeature() => $_has(15);
  @$pb.TagNumber(19)
  void clearLegacyFeature() => $_clearField(19);

  @$pb.TagNumber(20)
  ValueLifetimeFeature get valueLifetimeFeature => $_getN(16);
  @$pb.TagNumber(20)
  set valueLifetimeFeature(ValueLifetimeFeature value) => $_setField(20, value);
  @$pb.TagNumber(20)
  $core.bool hasValueLifetimeFeature() => $_has(16);
  @$pb.TagNumber(20)
  void clearValueLifetimeFeature() => $_clearField(20);
}

class Unittest_features {
  static final test = $pb.Extension<TestFeatures>(
      _omitMessageNames ? '' : 'google.protobuf.FeatureSet',
      _omitFieldNames ? '' : 'test',
      9999,
      $pb.PbFieldType.OM,
      defaultOrMaker: TestFeatures.getDefault,
      subBuilder: TestFeatures.create);
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(test);
  }
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
