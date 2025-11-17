// This is a generated file - do not edit.
//
// Generated from google/protobuf/type.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/any.pb.dart' as $1;
import 'package:protobuf/well_known_types/google/protobuf/source_context.pb.dart'
    as $0;
import 'package:protobuf/well_known_types/google/protobuf/type.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;
export 'package:protobuf/well_known_types/google/protobuf/type.pbenum.dart';

/// A protocol buffer message type.
///
/// New usages of this message as an alternative to DescriptorProto are strongly
/// discouraged. This message does not reliability preserve all information
/// necessary to model the schema and preserve semantics. Instead make use of
/// FileDescriptorSet which preserves the necessary information.
class Type extends $pb.GeneratedMessage {
  factory Type({
    $core.String? name,
    $core.Iterable<Field>? fields,
    $core.Iterable<$core.String>? oneofs,
    $core.Iterable<Option>? options,
    $0.SourceContext? sourceContext,
    Syntax? syntax,
    $core.String? edition,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (fields != null) result.fields.addAll(fields);
    if (oneofs != null) result.oneofs.addAll(oneofs);
    if (options != null) result.options.addAll(options);
    if (sourceContext != null) result.sourceContext = sourceContext;
    if (syntax != null) result.syntax = syntax;
    if (edition != null) result.edition = edition;
    return result;
  }

  Type._();

  factory Type.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Type.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Type',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'google.protobuf'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..pPM<Field>(2, _omitFieldNames ? '' : 'fields', subBuilder: Field.create)
    ..pPS(3, _omitFieldNames ? '' : 'oneofs')
    ..pPM<Option>(4, _omitFieldNames ? '' : 'options',
        subBuilder: Option.create)
    ..aOM<$0.SourceContext>(5, _omitFieldNames ? '' : 'sourceContext',
        subBuilder: $0.SourceContext.create)
    ..aE<Syntax>(6, _omitFieldNames ? '' : 'syntax', enumValues: Syntax.values)
    ..aOS(7, _omitFieldNames ? '' : 'edition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Type clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Type copyWith(void Function(Type) updates) =>
      super.copyWith((message) => updates(message as Type)) as Type;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Type create() => Type._();
  @$core.override
  Type createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Type getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Type>(create);
  static Type? _defaultInstance;

  /// The fully qualified message name.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// The list of fields.
  @$pb.TagNumber(2)
  $pb.PbList<Field> get fields => $_getList(1);

  /// The list of types appearing in `oneof` definitions in this type.
  @$pb.TagNumber(3)
  $pb.PbList<$core.String> get oneofs => $_getList(2);

  /// The protocol buffer options.
  @$pb.TagNumber(4)
  $pb.PbList<Option> get options => $_getList(3);

  /// The source context.
  @$pb.TagNumber(5)
  $0.SourceContext get sourceContext => $_getN(4);
  @$pb.TagNumber(5)
  set sourceContext($0.SourceContext value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceContext() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceContext() => $_clearField(5);
  @$pb.TagNumber(5)
  $0.SourceContext ensureSourceContext() => $_ensure(4);

  /// The source syntax.
  @$pb.TagNumber(6)
  Syntax get syntax => $_getN(5);
  @$pb.TagNumber(6)
  set syntax(Syntax value) => $_setField(6, value);
  @$pb.TagNumber(6)
  $core.bool hasSyntax() => $_has(5);
  @$pb.TagNumber(6)
  void clearSyntax() => $_clearField(6);

  /// The source edition string, only valid when syntax is SYNTAX_EDITIONS.
  @$pb.TagNumber(7)
  $core.String get edition => $_getSZ(6);
  @$pb.TagNumber(7)
  set edition($core.String value) => $_setString(6, value);
  @$pb.TagNumber(7)
  $core.bool hasEdition() => $_has(6);
  @$pb.TagNumber(7)
  void clearEdition() => $_clearField(7);
}

/// A single field of a message type.
///
/// New usages of this message as an alternative to FieldDescriptorProto are
/// strongly discouraged. This message does not reliability preserve all
/// information necessary to model the schema and preserve semantics. Instead
/// make use of FileDescriptorSet which preserves the necessary information.
class Field extends $pb.GeneratedMessage {
  factory Field({
    Field_Kind? kind,
    Field_Cardinality? cardinality,
    $core.int? number,
    $core.String? name,
    $core.String? typeUrl,
    $core.int? oneofIndex,
    $core.bool? packed,
    $core.Iterable<Option>? options,
    $core.String? jsonName,
    $core.String? defaultValue,
  }) {
    final result = create();
    if (kind != null) result.kind = kind;
    if (cardinality != null) result.cardinality = cardinality;
    if (number != null) result.number = number;
    if (name != null) result.name = name;
    if (typeUrl != null) result.typeUrl = typeUrl;
    if (oneofIndex != null) result.oneofIndex = oneofIndex;
    if (packed != null) result.packed = packed;
    if (options != null) result.options.addAll(options);
    if (jsonName != null) result.jsonName = jsonName;
    if (defaultValue != null) result.defaultValue = defaultValue;
    return result;
  }

  Field._();

  factory Field.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Field.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Field',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'google.protobuf'),
      createEmptyInstance: create)
    ..aE<Field_Kind>(1, _omitFieldNames ? '' : 'kind',
        enumValues: Field_Kind.values)
    ..aE<Field_Cardinality>(2, _omitFieldNames ? '' : 'cardinality',
        enumValues: Field_Cardinality.values)
    ..aI(3, _omitFieldNames ? '' : 'number')
    ..aOS(4, _omitFieldNames ? '' : 'name')
    ..aOS(6, _omitFieldNames ? '' : 'typeUrl')
    ..aI(7, _omitFieldNames ? '' : 'oneofIndex')
    ..aOB(8, _omitFieldNames ? '' : 'packed')
    ..pPM<Option>(9, _omitFieldNames ? '' : 'options',
        subBuilder: Option.create)
    ..aOS(10, _omitFieldNames ? '' : 'jsonName')
    ..aOS(11, _omitFieldNames ? '' : 'defaultValue')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Field clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Field copyWith(void Function(Field) updates) =>
      super.copyWith((message) => updates(message as Field)) as Field;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Field create() => Field._();
  @$core.override
  Field createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Field getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Field>(create);
  static Field? _defaultInstance;

  /// The field type.
  @$pb.TagNumber(1)
  Field_Kind get kind => $_getN(0);
  @$pb.TagNumber(1)
  set kind(Field_Kind value) => $_setField(1, value);
  @$pb.TagNumber(1)
  $core.bool hasKind() => $_has(0);
  @$pb.TagNumber(1)
  void clearKind() => $_clearField(1);

  /// The field cardinality.
  @$pb.TagNumber(2)
  Field_Cardinality get cardinality => $_getN(1);
  @$pb.TagNumber(2)
  set cardinality(Field_Cardinality value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasCardinality() => $_has(1);
  @$pb.TagNumber(2)
  void clearCardinality() => $_clearField(2);

  /// The field number.
  @$pb.TagNumber(3)
  $core.int get number => $_getIZ(2);
  @$pb.TagNumber(3)
  set number($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasNumber() => $_has(2);
  @$pb.TagNumber(3)
  void clearNumber() => $_clearField(3);

  /// The field name.
  @$pb.TagNumber(4)
  $core.String get name => $_getSZ(3);
  @$pb.TagNumber(4)
  set name($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasName() => $_has(3);
  @$pb.TagNumber(4)
  void clearName() => $_clearField(4);

  /// The field type URL, without the scheme, for message or enumeration
  /// types. Example: `"type.googleapis.com/google.protobuf.Timestamp"`.
  @$pb.TagNumber(6)
  $core.String get typeUrl => $_getSZ(4);
  @$pb.TagNumber(6)
  set typeUrl($core.String value) => $_setString(4, value);
  @$pb.TagNumber(6)
  $core.bool hasTypeUrl() => $_has(4);
  @$pb.TagNumber(6)
  void clearTypeUrl() => $_clearField(6);

  /// The index of the field type in `Type.oneofs`, for message or enumeration
  /// types. The first type has index 1; zero means the type is not in the list.
  @$pb.TagNumber(7)
  $core.int get oneofIndex => $_getIZ(5);
  @$pb.TagNumber(7)
  set oneofIndex($core.int value) => $_setSignedInt32(5, value);
  @$pb.TagNumber(7)
  $core.bool hasOneofIndex() => $_has(5);
  @$pb.TagNumber(7)
  void clearOneofIndex() => $_clearField(7);

  /// Whether to use alternative packed wire representation.
  @$pb.TagNumber(8)
  $core.bool get packed => $_getBF(6);
  @$pb.TagNumber(8)
  set packed($core.bool value) => $_setBool(6, value);
  @$pb.TagNumber(8)
  $core.bool hasPacked() => $_has(6);
  @$pb.TagNumber(8)
  void clearPacked() => $_clearField(8);

  /// The protocol buffer options.
  @$pb.TagNumber(9)
  $pb.PbList<Option> get options => $_getList(7);

  /// The field JSON name.
  @$pb.TagNumber(10)
  $core.String get jsonName => $_getSZ(8);
  @$pb.TagNumber(10)
  set jsonName($core.String value) => $_setString(8, value);
  @$pb.TagNumber(10)
  $core.bool hasJsonName() => $_has(8);
  @$pb.TagNumber(10)
  void clearJsonName() => $_clearField(10);

  /// The string value of the default value of this field. Proto2 syntax only.
  @$pb.TagNumber(11)
  $core.String get defaultValue => $_getSZ(9);
  @$pb.TagNumber(11)
  set defaultValue($core.String value) => $_setString(9, value);
  @$pb.TagNumber(11)
  $core.bool hasDefaultValue() => $_has(9);
  @$pb.TagNumber(11)
  void clearDefaultValue() => $_clearField(11);
}

/// Enum type definition.
///
/// New usages of this message as an alternative to EnumDescriptorProto are
/// strongly discouraged. This message does not reliability preserve all
/// information necessary to model the schema and preserve semantics. Instead
/// make use of FileDescriptorSet which preserves the necessary information.
class Enum extends $pb.GeneratedMessage {
  factory Enum({
    $core.String? name,
    $core.Iterable<EnumValue>? enumvalue,
    $core.Iterable<Option>? options,
    $0.SourceContext? sourceContext,
    Syntax? syntax,
    $core.String? edition,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (enumvalue != null) result.enumvalue.addAll(enumvalue);
    if (options != null) result.options.addAll(options);
    if (sourceContext != null) result.sourceContext = sourceContext;
    if (syntax != null) result.syntax = syntax;
    if (edition != null) result.edition = edition;
    return result;
  }

  Enum._();

  factory Enum.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Enum.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Enum',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'google.protobuf'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..pPM<EnumValue>(2, _omitFieldNames ? '' : 'enumvalue',
        subBuilder: EnumValue.create)
    ..pPM<Option>(3, _omitFieldNames ? '' : 'options',
        subBuilder: Option.create)
    ..aOM<$0.SourceContext>(4, _omitFieldNames ? '' : 'sourceContext',
        subBuilder: $0.SourceContext.create)
    ..aE<Syntax>(5, _omitFieldNames ? '' : 'syntax', enumValues: Syntax.values)
    ..aOS(6, _omitFieldNames ? '' : 'edition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Enum clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Enum copyWith(void Function(Enum) updates) =>
      super.copyWith((message) => updates(message as Enum)) as Enum;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Enum create() => Enum._();
  @$core.override
  Enum createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Enum getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Enum>(create);
  static Enum? _defaultInstance;

  /// Enum type name.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Enum value definitions.
  @$pb.TagNumber(2)
  $pb.PbList<EnumValue> get enumvalue => $_getList(1);

  /// Protocol buffer options.
  @$pb.TagNumber(3)
  $pb.PbList<Option> get options => $_getList(2);

  /// The source context.
  @$pb.TagNumber(4)
  $0.SourceContext get sourceContext => $_getN(3);
  @$pb.TagNumber(4)
  set sourceContext($0.SourceContext value) => $_setField(4, value);
  @$pb.TagNumber(4)
  $core.bool hasSourceContext() => $_has(3);
  @$pb.TagNumber(4)
  void clearSourceContext() => $_clearField(4);
  @$pb.TagNumber(4)
  $0.SourceContext ensureSourceContext() => $_ensure(3);

  /// The source syntax.
  @$pb.TagNumber(5)
  Syntax get syntax => $_getN(4);
  @$pb.TagNumber(5)
  set syntax(Syntax value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSyntax() => $_has(4);
  @$pb.TagNumber(5)
  void clearSyntax() => $_clearField(5);

  /// The source edition string, only valid when syntax is SYNTAX_EDITIONS.
  @$pb.TagNumber(6)
  $core.String get edition => $_getSZ(5);
  @$pb.TagNumber(6)
  set edition($core.String value) => $_setString(5, value);
  @$pb.TagNumber(6)
  $core.bool hasEdition() => $_has(5);
  @$pb.TagNumber(6)
  void clearEdition() => $_clearField(6);
}

/// Enum value definition.
///
/// New usages of this message as an alternative to EnumValueDescriptorProto are
/// strongly discouraged. This message does not reliability preserve all
/// information necessary to model the schema and preserve semantics. Instead
/// make use of FileDescriptorSet which preserves the necessary information.
class EnumValue extends $pb.GeneratedMessage {
  factory EnumValue({
    $core.String? name,
    $core.int? number,
    $core.Iterable<Option>? options,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (number != null) result.number = number;
    if (options != null) result.options.addAll(options);
    return result;
  }

  EnumValue._();

  factory EnumValue.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory EnumValue.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'EnumValue',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'google.protobuf'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aI(2, _omitFieldNames ? '' : 'number')
    ..pPM<Option>(3, _omitFieldNames ? '' : 'options',
        subBuilder: Option.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnumValue clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  EnumValue copyWith(void Function(EnumValue) updates) =>
      super.copyWith((message) => updates(message as EnumValue)) as EnumValue;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static EnumValue create() => EnumValue._();
  @$core.override
  EnumValue createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static EnumValue getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<EnumValue>(create);
  static EnumValue? _defaultInstance;

  /// Enum value name.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// Enum value number.
  @$pb.TagNumber(2)
  $core.int get number => $_getIZ(1);
  @$pb.TagNumber(2)
  set number($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasNumber() => $_has(1);
  @$pb.TagNumber(2)
  void clearNumber() => $_clearField(2);

  /// Protocol buffer options.
  @$pb.TagNumber(3)
  $pb.PbList<Option> get options => $_getList(2);
}

/// A protocol buffer option, which can be attached to a message, field,
/// enumeration, etc.
///
/// New usages of this message as an alternative to FileOptions, MessageOptions,
/// FieldOptions, EnumOptions, EnumValueOptions, ServiceOptions, or MethodOptions
/// are strongly discouraged.
class Option extends $pb.GeneratedMessage {
  factory Option({
    $core.String? name,
    $1.Any? value,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (value != null) result.value = value;
    return result;
  }

  Option._();

  factory Option.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Option.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Option',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'google.protobuf'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOM<$1.Any>(2, _omitFieldNames ? '' : 'value', subBuilder: $1.Any.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Option clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Option copyWith(void Function(Option) updates) =>
      super.copyWith((message) => updates(message as Option)) as Option;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Option create() => Option._();
  @$core.override
  Option createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Option getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Option>(create);
  static Option? _defaultInstance;

  /// The option's name. For protobuf built-in options (options defined in
  /// descriptor.proto), this is the short name. For example, `"map_entry"`.
  /// For custom options, it should be the fully-qualified name. For example,
  /// `"google.api.http"`.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// The option's value packed in an Any message. If the value is a primitive,
  /// the corresponding wrapper type defined in google/protobuf/wrappers.proto
  /// should be used. If the value is an enum, it should be stored as an int32
  /// value using the google.protobuf.Int32Value type.
  @$pb.TagNumber(2)
  $1.Any get value => $_getN(1);
  @$pb.TagNumber(2)
  set value($1.Any value) => $_setField(2, value);
  @$pb.TagNumber(2)
  $core.bool hasValue() => $_has(1);
  @$pb.TagNumber(2)
  void clearValue() => $_clearField(2);
  @$pb.TagNumber(2)
  $1.Any ensureValue() => $_ensure(1);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
