///
//  Generated code. Do not modify.
//  source: descriptor.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' as $core
    show int, bool, double, String, List, Map, override, Deprecated;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'descriptor.pbenum.dart';

export 'descriptor.pbenum.dart';

class FileDescriptorSet extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileDescriptorSet',
      package: const $pb.PackageName('google.protobuf'))
    ..pc<FileDescriptorProto>(
        1, 'file', $pb.PbFieldType.PM, FileDescriptorProto.create);

  FileDescriptorSet() : super();
  FileDescriptorSet.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileDescriptorSet.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileDescriptorSet clone() => FileDescriptorSet()..mergeFromMessage(this);
  FileDescriptorSet copyWith(void Function(FileDescriptorSet) updates) =>
      super.copyWith((message) => updates(message as FileDescriptorSet));
  $pb.BuilderInfo get info_ => _i;
  static FileDescriptorSet create() => FileDescriptorSet();
  FileDescriptorSet createEmptyInstance() => create();
  static $pb.PbList<FileDescriptorSet> createRepeated() =>
      $pb.PbList<FileDescriptorSet>();
  static FileDescriptorSet getDefault() =>
      _defaultInstance ??= create()..freeze();
  static FileDescriptorSet _defaultInstance;

  $core.List<FileDescriptorProto> get file => $_getList(0);
}

class FileDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'package')
    ..pPS(3, 'dependency')
    ..pc<DescriptorProto>(
        4, 'messageType', $pb.PbFieldType.PM, DescriptorProto.create)
    ..pc<EnumDescriptorProto>(
        5, 'enumType', $pb.PbFieldType.PM, EnumDescriptorProto.create)
    ..pc<ServiceDescriptorProto>(
        6, 'service', $pb.PbFieldType.PM, ServiceDescriptorProto.create)
    ..pc<FieldDescriptorProto>(
        7, 'extension', $pb.PbFieldType.PM, FieldDescriptorProto.create)
    ..a<FileOptions>(8, 'options', $pb.PbFieldType.OM, FileOptions.getDefault,
        FileOptions.create)
    ..a<SourceCodeInfo>(9, 'sourceCodeInfo', $pb.PbFieldType.OM,
        SourceCodeInfo.getDefault, SourceCodeInfo.create)
    ..p<$core.int>(10, 'publicDependency', $pb.PbFieldType.P3)
    ..p<$core.int>(11, 'weakDependency', $pb.PbFieldType.P3)
    ..aOS(12, 'syntax');

  FileDescriptorProto() : super();
  FileDescriptorProto.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileDescriptorProto.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileDescriptorProto clone() => FileDescriptorProto()..mergeFromMessage(this);
  FileDescriptorProto copyWith(void Function(FileDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as FileDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static FileDescriptorProto create() => FileDescriptorProto();
  FileDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<FileDescriptorProto> createRepeated() =>
      $pb.PbList<FileDescriptorProto>();
  static FileDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static FileDescriptorProto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.String get package => $_getS(1, '');
  set package($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasPackage() => $_has(1);
  void clearPackage() => clearField(2);

  $core.List<$core.String> get dependency => $_getList(2);

  $core.List<DescriptorProto> get messageType => $_getList(3);

  $core.List<EnumDescriptorProto> get enumType => $_getList(4);

  $core.List<ServiceDescriptorProto> get service => $_getList(5);

  $core.List<FieldDescriptorProto> get extension => $_getList(6);

  FileOptions get options => $_getN(7);
  set options(FileOptions v) {
    setField(8, v);
  }

  $core.bool hasOptions() => $_has(7);
  void clearOptions() => clearField(8);

  SourceCodeInfo get sourceCodeInfo => $_getN(8);
  set sourceCodeInfo(SourceCodeInfo v) {
    setField(9, v);
  }

  $core.bool hasSourceCodeInfo() => $_has(8);
  void clearSourceCodeInfo() => clearField(9);

  $core.List<$core.int> get publicDependency => $_getList(9);

  $core.List<$core.int> get weakDependency => $_getList(10);

  $core.String get syntax => $_getS(11, '');
  set syntax($core.String v) {
    $_setString(11, v);
  }

  $core.bool hasSyntax() => $_has(11);
  void clearSyntax() => clearField(12);
}

class DescriptorProto_ExtensionRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'DescriptorProto.ExtensionRange',
      package: const $pb.PackageName('google.protobuf'))
    ..a<$core.int>(1, 'start', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'end', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DescriptorProto_ExtensionRange() : super();
  DescriptorProto_ExtensionRange.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto_ExtensionRange.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto_ExtensionRange clone() =>
      DescriptorProto_ExtensionRange()..mergeFromMessage(this);
  DescriptorProto_ExtensionRange copyWith(
          void Function(DescriptorProto_ExtensionRange) updates) =>
      super.copyWith(
          (message) => updates(message as DescriptorProto_ExtensionRange));
  $pb.BuilderInfo get info_ => _i;
  static DescriptorProto_ExtensionRange create() =>
      DescriptorProto_ExtensionRange();
  DescriptorProto_ExtensionRange createEmptyInstance() => create();
  static $pb.PbList<DescriptorProto_ExtensionRange> createRepeated() =>
      $pb.PbList<DescriptorProto_ExtensionRange>();
  static DescriptorProto_ExtensionRange getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DescriptorProto_ExtensionRange _defaultInstance;

  $core.int get start => $_get(0, 0);
  set start($core.int v) {
    $_setSignedInt32(0, v);
  }

  $core.bool hasStart() => $_has(0);
  void clearStart() => clearField(1);

  $core.int get end => $_get(1, 0);
  set end($core.int v) {
    $_setSignedInt32(1, v);
  }

  $core.bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}

class DescriptorProto_ReservedRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'DescriptorProto.ReservedRange',
      package: const $pb.PackageName('google.protobuf'))
    ..a<$core.int>(1, 'start', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'end', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DescriptorProto_ReservedRange() : super();
  DescriptorProto_ReservedRange.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto_ReservedRange.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto_ReservedRange clone() =>
      DescriptorProto_ReservedRange()..mergeFromMessage(this);
  DescriptorProto_ReservedRange copyWith(
          void Function(DescriptorProto_ReservedRange) updates) =>
      super.copyWith(
          (message) => updates(message as DescriptorProto_ReservedRange));
  $pb.BuilderInfo get info_ => _i;
  static DescriptorProto_ReservedRange create() =>
      DescriptorProto_ReservedRange();
  DescriptorProto_ReservedRange createEmptyInstance() => create();
  static $pb.PbList<DescriptorProto_ReservedRange> createRepeated() =>
      $pb.PbList<DescriptorProto_ReservedRange>();
  static DescriptorProto_ReservedRange getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DescriptorProto_ReservedRange _defaultInstance;

  $core.int get start => $_get(0, 0);
  set start($core.int v) {
    $_setSignedInt32(0, v);
  }

  $core.bool hasStart() => $_has(0);
  void clearStart() => clearField(1);

  $core.int get end => $_get(1, 0);
  set end($core.int v) {
    $_setSignedInt32(1, v);
  }

  $core.bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}

class DescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('DescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pc<FieldDescriptorProto>(
        2, 'field', $pb.PbFieldType.PM, FieldDescriptorProto.create)
    ..pc<DescriptorProto>(
        3, 'nestedType', $pb.PbFieldType.PM, DescriptorProto.create)
    ..pc<EnumDescriptorProto>(
        4, 'enumType', $pb.PbFieldType.PM, EnumDescriptorProto.create)
    ..pc<DescriptorProto_ExtensionRange>(5, 'extensionRange',
        $pb.PbFieldType.PM, DescriptorProto_ExtensionRange.create)
    ..pc<FieldDescriptorProto>(
        6, 'extension', $pb.PbFieldType.PM, FieldDescriptorProto.create)
    ..a<MessageOptions>(7, 'options', $pb.PbFieldType.OM,
        MessageOptions.getDefault, MessageOptions.create)
    ..pc<OneofDescriptorProto>(
        8, 'oneofDecl', $pb.PbFieldType.PM, OneofDescriptorProto.create)
    ..pc<DescriptorProto_ReservedRange>(9, 'reservedRange', $pb.PbFieldType.PM,
        DescriptorProto_ReservedRange.create)
    ..pPS(10, 'reservedName');

  DescriptorProto() : super();
  DescriptorProto.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto clone() => DescriptorProto()..mergeFromMessage(this);
  DescriptorProto copyWith(void Function(DescriptorProto) updates) =>
      super.copyWith((message) => updates(message as DescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static DescriptorProto create() => DescriptorProto();
  DescriptorProto createEmptyInstance() => create();
  static $pb.PbList<DescriptorProto> createRepeated() =>
      $pb.PbList<DescriptorProto>();
  static DescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DescriptorProto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.List<FieldDescriptorProto> get field => $_getList(1);

  $core.List<DescriptorProto> get nestedType => $_getList(2);

  $core.List<EnumDescriptorProto> get enumType => $_getList(3);

  $core.List<DescriptorProto_ExtensionRange> get extensionRange => $_getList(4);

  $core.List<FieldDescriptorProto> get extension => $_getList(5);

  MessageOptions get options => $_getN(6);
  set options(MessageOptions v) {
    setField(7, v);
  }

  $core.bool hasOptions() => $_has(6);
  void clearOptions() => clearField(7);

  $core.List<OneofDescriptorProto> get oneofDecl => $_getList(7);

  $core.List<DescriptorProto_ReservedRange> get reservedRange => $_getList(8);

  $core.List<$core.String> get reservedName => $_getList(9);
}

class FieldDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FieldDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'extendee')
    ..a<$core.int>(3, 'number', $pb.PbFieldType.O3)
    ..e<FieldDescriptorProto_Label>(
        4,
        'label',
        $pb.PbFieldType.OE,
        FieldDescriptorProto_Label.LABEL_OPTIONAL,
        FieldDescriptorProto_Label.valueOf,
        FieldDescriptorProto_Label.values)
    ..e<FieldDescriptorProto_Type>(
        5,
        'type',
        $pb.PbFieldType.OE,
        FieldDescriptorProto_Type.TYPE_DOUBLE,
        FieldDescriptorProto_Type.valueOf,
        FieldDescriptorProto_Type.values)
    ..aOS(6, 'typeName')
    ..aOS(7, 'defaultValue')
    ..a<FieldOptions>(8, 'options', $pb.PbFieldType.OM, FieldOptions.getDefault,
        FieldOptions.create)
    ..a<$core.int>(9, 'oneofIndex', $pb.PbFieldType.O3)
    ..aOS(10, 'jsonName');

  FieldDescriptorProto() : super();
  FieldDescriptorProto.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FieldDescriptorProto.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FieldDescriptorProto clone() =>
      FieldDescriptorProto()..mergeFromMessage(this);
  FieldDescriptorProto copyWith(void Function(FieldDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as FieldDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static FieldDescriptorProto create() => FieldDescriptorProto();
  FieldDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<FieldDescriptorProto> createRepeated() =>
      $pb.PbList<FieldDescriptorProto>();
  static FieldDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static FieldDescriptorProto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.String get extendee => $_getS(1, '');
  set extendee($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasExtendee() => $_has(1);
  void clearExtendee() => clearField(2);

  $core.int get number => $_get(2, 0);
  set number($core.int v) {
    $_setSignedInt32(2, v);
  }

  $core.bool hasNumber() => $_has(2);
  void clearNumber() => clearField(3);

  FieldDescriptorProto_Label get label => $_getN(3);
  set label(FieldDescriptorProto_Label v) {
    setField(4, v);
  }

  $core.bool hasLabel() => $_has(3);
  void clearLabel() => clearField(4);

  FieldDescriptorProto_Type get type => $_getN(4);
  set type(FieldDescriptorProto_Type v) {
    setField(5, v);
  }

  $core.bool hasType() => $_has(4);
  void clearType() => clearField(5);

  $core.String get typeName => $_getS(5, '');
  set typeName($core.String v) {
    $_setString(5, v);
  }

  $core.bool hasTypeName() => $_has(5);
  void clearTypeName() => clearField(6);

  $core.String get defaultValue => $_getS(6, '');
  set defaultValue($core.String v) {
    $_setString(6, v);
  }

  $core.bool hasDefaultValue() => $_has(6);
  void clearDefaultValue() => clearField(7);

  FieldOptions get options => $_getN(7);
  set options(FieldOptions v) {
    setField(8, v);
  }

  $core.bool hasOptions() => $_has(7);
  void clearOptions() => clearField(8);

  $core.int get oneofIndex => $_get(8, 0);
  set oneofIndex($core.int v) {
    $_setSignedInt32(8, v);
  }

  $core.bool hasOneofIndex() => $_has(8);
  void clearOneofIndex() => clearField(9);

  $core.String get jsonName => $_getS(9, '');
  set jsonName($core.String v) {
    $_setString(9, v);
  }

  $core.bool hasJsonName() => $_has(9);
  void clearJsonName() => clearField(10);
}

class OneofDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OneofDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..a<OneofOptions>(2, 'options', $pb.PbFieldType.OM, OneofOptions.getDefault,
        OneofOptions.create);

  OneofDescriptorProto() : super();
  OneofDescriptorProto.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  OneofDescriptorProto.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  OneofDescriptorProto clone() =>
      OneofDescriptorProto()..mergeFromMessage(this);
  OneofDescriptorProto copyWith(void Function(OneofDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as OneofDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static OneofDescriptorProto create() => OneofDescriptorProto();
  OneofDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<OneofDescriptorProto> createRepeated() =>
      $pb.PbList<OneofDescriptorProto>();
  static OneofDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static OneofDescriptorProto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  OneofOptions get options => $_getN(1);
  set options(OneofOptions v) {
    setField(2, v);
  }

  $core.bool hasOptions() => $_has(1);
  void clearOptions() => clearField(2);
}

class EnumDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EnumDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pc<EnumValueDescriptorProto>(
        2, 'value', $pb.PbFieldType.PM, EnumValueDescriptorProto.create)
    ..a<EnumOptions>(3, 'options', $pb.PbFieldType.OM, EnumOptions.getDefault,
        EnumOptions.create);

  EnumDescriptorProto() : super();
  EnumDescriptorProto.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumDescriptorProto.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumDescriptorProto clone() => EnumDescriptorProto()..mergeFromMessage(this);
  EnumDescriptorProto copyWith(void Function(EnumDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as EnumDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static EnumDescriptorProto create() => EnumDescriptorProto();
  EnumDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<EnumDescriptorProto> createRepeated() =>
      $pb.PbList<EnumDescriptorProto>();
  static EnumDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static EnumDescriptorProto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.List<EnumValueDescriptorProto> get value => $_getList(1);

  EnumOptions get options => $_getN(2);
  set options(EnumOptions v) {
    setField(3, v);
  }

  $core.bool hasOptions() => $_has(2);
  void clearOptions() => clearField(3);
}

class EnumValueDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EnumValueDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..a<$core.int>(2, 'number', $pb.PbFieldType.O3)
    ..a<EnumValueOptions>(3, 'options', $pb.PbFieldType.OM,
        EnumValueOptions.getDefault, EnumValueOptions.create);

  EnumValueDescriptorProto() : super();
  EnumValueDescriptorProto.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumValueDescriptorProto.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumValueDescriptorProto clone() =>
      EnumValueDescriptorProto()..mergeFromMessage(this);
  EnumValueDescriptorProto copyWith(
          void Function(EnumValueDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as EnumValueDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static EnumValueDescriptorProto create() => EnumValueDescriptorProto();
  EnumValueDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<EnumValueDescriptorProto> createRepeated() =>
      $pb.PbList<EnumValueDescriptorProto>();
  static EnumValueDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static EnumValueDescriptorProto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.int get number => $_get(1, 0);
  set number($core.int v) {
    $_setSignedInt32(1, v);
  }

  $core.bool hasNumber() => $_has(1);
  void clearNumber() => clearField(2);

  EnumValueOptions get options => $_getN(2);
  set options(EnumValueOptions v) {
    setField(3, v);
  }

  $core.bool hasOptions() => $_has(2);
  void clearOptions() => clearField(3);
}

class ServiceDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ServiceDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pc<MethodDescriptorProto>(
        2, 'method', $pb.PbFieldType.PM, MethodDescriptorProto.create)
    ..a<ServiceOptions>(3, 'options', $pb.PbFieldType.OM,
        ServiceOptions.getDefault, ServiceOptions.create);

  ServiceDescriptorProto() : super();
  ServiceDescriptorProto.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ServiceDescriptorProto.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ServiceDescriptorProto clone() =>
      ServiceDescriptorProto()..mergeFromMessage(this);
  ServiceDescriptorProto copyWith(
          void Function(ServiceDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as ServiceDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static ServiceDescriptorProto create() => ServiceDescriptorProto();
  ServiceDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<ServiceDescriptorProto> createRepeated() =>
      $pb.PbList<ServiceDescriptorProto>();
  static ServiceDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ServiceDescriptorProto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.List<MethodDescriptorProto> get method => $_getList(1);

  ServiceOptions get options => $_getN(2);
  set options(ServiceOptions v) {
    setField(3, v);
  }

  $core.bool hasOptions() => $_has(2);
  void clearOptions() => clearField(3);
}

class MethodDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MethodDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'inputType')
    ..aOS(3, 'outputType')
    ..a<MethodOptions>(4, 'options', $pb.PbFieldType.OM,
        MethodOptions.getDefault, MethodOptions.create)
    ..aOB(5, 'clientStreaming')
    ..aOB(6, 'serverStreaming');

  MethodDescriptorProto() : super();
  MethodDescriptorProto.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MethodDescriptorProto.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MethodDescriptorProto clone() =>
      MethodDescriptorProto()..mergeFromMessage(this);
  MethodDescriptorProto copyWith(
          void Function(MethodDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as MethodDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static MethodDescriptorProto create() => MethodDescriptorProto();
  MethodDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<MethodDescriptorProto> createRepeated() =>
      $pb.PbList<MethodDescriptorProto>();
  static MethodDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static MethodDescriptorProto _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.String get inputType => $_getS(1, '');
  set inputType($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasInputType() => $_has(1);
  void clearInputType() => clearField(2);

  $core.String get outputType => $_getS(2, '');
  set outputType($core.String v) {
    $_setString(2, v);
  }

  $core.bool hasOutputType() => $_has(2);
  void clearOutputType() => clearField(3);

  MethodOptions get options => $_getN(3);
  set options(MethodOptions v) {
    setField(4, v);
  }

  $core.bool hasOptions() => $_has(3);
  void clearOptions() => clearField(4);

  $core.bool get clientStreaming => $_get(4, false);
  set clientStreaming($core.bool v) {
    $_setBool(4, v);
  }

  $core.bool hasClientStreaming() => $_has(4);
  void clearClientStreaming() => clearField(5);

  $core.bool get serverStreaming => $_get(5, false);
  set serverStreaming($core.bool v) {
    $_setBool(5, v);
  }

  $core.bool hasServerStreaming() => $_has(5);
  void clearServerStreaming() => clearField(6);
}

class FileOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FileOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'javaPackage')
    ..aOS(8, 'javaOuterClassname')
    ..e<FileOptions_OptimizeMode>(
        9,
        'optimizeFor',
        $pb.PbFieldType.OE,
        FileOptions_OptimizeMode.SPEED,
        FileOptions_OptimizeMode.valueOf,
        FileOptions_OptimizeMode.values)
    ..aOB(10, 'javaMultipleFiles')
    ..aOS(11, 'goPackage')
    ..aOB(16, 'ccGenericServices')
    ..aOB(17, 'javaGenericServices')
    ..aOB(18, 'pyGenericServices')
    ..aOB(20, 'javaGenerateEqualsAndHash')
    ..aOB(23, 'deprecated')
    ..aOB(27, 'javaStringCheckUtf8')
    ..aOB(31, 'ccEnableArenas')
    ..aOS(36, 'objcClassPrefix')
    ..aOS(37, 'csharpNamespace')
    ..aOS(39, 'swiftPrefix')
    ..aOS(40, 'phpClassPrefix')
    ..aOS(41, 'phpNamespace')
    ..pc<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.create)
    ..hasExtensions = true;

  FileOptions() : super();
  FileOptions.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileOptions.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileOptions clone() => FileOptions()..mergeFromMessage(this);
  FileOptions copyWith(void Function(FileOptions) updates) =>
      super.copyWith((message) => updates(message as FileOptions));
  $pb.BuilderInfo get info_ => _i;
  static FileOptions create() => FileOptions();
  FileOptions createEmptyInstance() => create();
  static $pb.PbList<FileOptions> createRepeated() => $pb.PbList<FileOptions>();
  static FileOptions getDefault() => _defaultInstance ??= create()..freeze();
  static FileOptions _defaultInstance;

  $core.String get javaPackage => $_getS(0, '');
  set javaPackage($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasJavaPackage() => $_has(0);
  void clearJavaPackage() => clearField(1);

  $core.String get javaOuterClassname => $_getS(1, '');
  set javaOuterClassname($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasJavaOuterClassname() => $_has(1);
  void clearJavaOuterClassname() => clearField(8);

  FileOptions_OptimizeMode get optimizeFor => $_getN(2);
  set optimizeFor(FileOptions_OptimizeMode v) {
    setField(9, v);
  }

  $core.bool hasOptimizeFor() => $_has(2);
  void clearOptimizeFor() => clearField(9);

  $core.bool get javaMultipleFiles => $_get(3, false);
  set javaMultipleFiles($core.bool v) {
    $_setBool(3, v);
  }

  $core.bool hasJavaMultipleFiles() => $_has(3);
  void clearJavaMultipleFiles() => clearField(10);

  $core.String get goPackage => $_getS(4, '');
  set goPackage($core.String v) {
    $_setString(4, v);
  }

  $core.bool hasGoPackage() => $_has(4);
  void clearGoPackage() => clearField(11);

  $core.bool get ccGenericServices => $_get(5, false);
  set ccGenericServices($core.bool v) {
    $_setBool(5, v);
  }

  $core.bool hasCcGenericServices() => $_has(5);
  void clearCcGenericServices() => clearField(16);

  $core.bool get javaGenericServices => $_get(6, false);
  set javaGenericServices($core.bool v) {
    $_setBool(6, v);
  }

  $core.bool hasJavaGenericServices() => $_has(6);
  void clearJavaGenericServices() => clearField(17);

  $core.bool get pyGenericServices => $_get(7, false);
  set pyGenericServices($core.bool v) {
    $_setBool(7, v);
  }

  $core.bool hasPyGenericServices() => $_has(7);
  void clearPyGenericServices() => clearField(18);

  @$core.Deprecated('This field is deprecated.')
  $core.bool get javaGenerateEqualsAndHash => $_get(8, false);
  @$core.Deprecated('This field is deprecated.')
  set javaGenerateEqualsAndHash($core.bool v) {
    $_setBool(8, v);
  }

  @$core.Deprecated('This field is deprecated.')
  $core.bool hasJavaGenerateEqualsAndHash() => $_has(8);
  @$core.Deprecated('This field is deprecated.')
  void clearJavaGenerateEqualsAndHash() => clearField(20);

  $core.bool get deprecated => $_get(9, false);
  set deprecated($core.bool v) {
    $_setBool(9, v);
  }

  $core.bool hasDeprecated() => $_has(9);
  void clearDeprecated() => clearField(23);

  $core.bool get javaStringCheckUtf8 => $_get(10, false);
  set javaStringCheckUtf8($core.bool v) {
    $_setBool(10, v);
  }

  $core.bool hasJavaStringCheckUtf8() => $_has(10);
  void clearJavaStringCheckUtf8() => clearField(27);

  $core.bool get ccEnableArenas => $_get(11, false);
  set ccEnableArenas($core.bool v) {
    $_setBool(11, v);
  }

  $core.bool hasCcEnableArenas() => $_has(11);
  void clearCcEnableArenas() => clearField(31);

  $core.String get objcClassPrefix => $_getS(12, '');
  set objcClassPrefix($core.String v) {
    $_setString(12, v);
  }

  $core.bool hasObjcClassPrefix() => $_has(12);
  void clearObjcClassPrefix() => clearField(36);

  $core.String get csharpNamespace => $_getS(13, '');
  set csharpNamespace($core.String v) {
    $_setString(13, v);
  }

  $core.bool hasCsharpNamespace() => $_has(13);
  void clearCsharpNamespace() => clearField(37);

  $core.String get swiftPrefix => $_getS(14, '');
  set swiftPrefix($core.String v) {
    $_setString(14, v);
  }

  $core.bool hasSwiftPrefix() => $_has(14);
  void clearSwiftPrefix() => clearField(39);

  $core.String get phpClassPrefix => $_getS(15, '');
  set phpClassPrefix($core.String v) {
    $_setString(15, v);
  }

  $core.bool hasPhpClassPrefix() => $_has(15);
  void clearPhpClassPrefix() => clearField(40);

  $core.String get phpNamespace => $_getS(16, '');
  set phpNamespace($core.String v) {
    $_setString(16, v);
  }

  $core.bool hasPhpNamespace() => $_has(16);
  void clearPhpNamespace() => clearField(41);

  $core.List<UninterpretedOption> get uninterpretedOption => $_getList(17);
}

class MessageOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MessageOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(1, 'messageSetWireFormat')
    ..aOB(2, 'noStandardDescriptorAccessor')
    ..aOB(3, 'deprecated')
    ..aOB(7, 'mapEntry')
    ..pc<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.create)
    ..hasExtensions = true;

  MessageOptions() : super();
  MessageOptions.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MessageOptions.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MessageOptions clone() => MessageOptions()..mergeFromMessage(this);
  MessageOptions copyWith(void Function(MessageOptions) updates) =>
      super.copyWith((message) => updates(message as MessageOptions));
  $pb.BuilderInfo get info_ => _i;
  static MessageOptions create() => MessageOptions();
  MessageOptions createEmptyInstance() => create();
  static $pb.PbList<MessageOptions> createRepeated() =>
      $pb.PbList<MessageOptions>();
  static MessageOptions getDefault() => _defaultInstance ??= create()..freeze();
  static MessageOptions _defaultInstance;

  $core.bool get messageSetWireFormat => $_get(0, false);
  set messageSetWireFormat($core.bool v) {
    $_setBool(0, v);
  }

  $core.bool hasMessageSetWireFormat() => $_has(0);
  void clearMessageSetWireFormat() => clearField(1);

  $core.bool get noStandardDescriptorAccessor => $_get(1, false);
  set noStandardDescriptorAccessor($core.bool v) {
    $_setBool(1, v);
  }

  $core.bool hasNoStandardDescriptorAccessor() => $_has(1);
  void clearNoStandardDescriptorAccessor() => clearField(2);

  $core.bool get deprecated => $_get(2, false);
  set deprecated($core.bool v) {
    $_setBool(2, v);
  }

  $core.bool hasDeprecated() => $_has(2);
  void clearDeprecated() => clearField(3);

  $core.bool get mapEntry => $_get(3, false);
  set mapEntry($core.bool v) {
    $_setBool(3, v);
  }

  $core.bool hasMapEntry() => $_has(3);
  void clearMapEntry() => clearField(7);

  $core.List<UninterpretedOption> get uninterpretedOption => $_getList(4);
}

class FieldOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('FieldOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..e<FieldOptions_CType>(
        1,
        'ctype',
        $pb.PbFieldType.OE,
        FieldOptions_CType.STRING,
        FieldOptions_CType.valueOf,
        FieldOptions_CType.values)
    ..aOB(2, 'packed')
    ..aOB(3, 'deprecated')
    ..aOB(5, 'lazy')
    ..e<FieldOptions_JSType>(
        6,
        'jstype',
        $pb.PbFieldType.OE,
        FieldOptions_JSType.JS_NORMAL,
        FieldOptions_JSType.valueOf,
        FieldOptions_JSType.values)
    ..aOB(10, 'weak')
    ..pc<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.create)
    ..hasExtensions = true;

  FieldOptions() : super();
  FieldOptions.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FieldOptions.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FieldOptions clone() => FieldOptions()..mergeFromMessage(this);
  FieldOptions copyWith(void Function(FieldOptions) updates) =>
      super.copyWith((message) => updates(message as FieldOptions));
  $pb.BuilderInfo get info_ => _i;
  static FieldOptions create() => FieldOptions();
  FieldOptions createEmptyInstance() => create();
  static $pb.PbList<FieldOptions> createRepeated() =>
      $pb.PbList<FieldOptions>();
  static FieldOptions getDefault() => _defaultInstance ??= create()..freeze();
  static FieldOptions _defaultInstance;

  FieldOptions_CType get ctype => $_getN(0);
  set ctype(FieldOptions_CType v) {
    setField(1, v);
  }

  $core.bool hasCtype() => $_has(0);
  void clearCtype() => clearField(1);

  $core.bool get packed => $_get(1, false);
  set packed($core.bool v) {
    $_setBool(1, v);
  }

  $core.bool hasPacked() => $_has(1);
  void clearPacked() => clearField(2);

  $core.bool get deprecated => $_get(2, false);
  set deprecated($core.bool v) {
    $_setBool(2, v);
  }

  $core.bool hasDeprecated() => $_has(2);
  void clearDeprecated() => clearField(3);

  $core.bool get lazy => $_get(3, false);
  set lazy($core.bool v) {
    $_setBool(3, v);
  }

  $core.bool hasLazy() => $_has(3);
  void clearLazy() => clearField(5);

  FieldOptions_JSType get jstype => $_getN(4);
  set jstype(FieldOptions_JSType v) {
    setField(6, v);
  }

  $core.bool hasJstype() => $_has(4);
  void clearJstype() => clearField(6);

  $core.bool get weak => $_get(5, false);
  set weak($core.bool v) {
    $_setBool(5, v);
  }

  $core.bool hasWeak() => $_has(5);
  void clearWeak() => clearField(10);

  $core.List<UninterpretedOption> get uninterpretedOption => $_getList(6);
}

class OneofOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('OneofOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..pc<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.create)
    ..hasExtensions = true;

  OneofOptions() : super();
  OneofOptions.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  OneofOptions.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  OneofOptions clone() => OneofOptions()..mergeFromMessage(this);
  OneofOptions copyWith(void Function(OneofOptions) updates) =>
      super.copyWith((message) => updates(message as OneofOptions));
  $pb.BuilderInfo get info_ => _i;
  static OneofOptions create() => OneofOptions();
  OneofOptions createEmptyInstance() => create();
  static $pb.PbList<OneofOptions> createRepeated() =>
      $pb.PbList<OneofOptions>();
  static OneofOptions getDefault() => _defaultInstance ??= create()..freeze();
  static OneofOptions _defaultInstance;

  $core.List<UninterpretedOption> get uninterpretedOption => $_getList(0);
}

class EnumOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EnumOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(2, 'allowAlias')
    ..aOB(3, 'deprecated')
    ..pc<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.create)
    ..hasExtensions = true;

  EnumOptions() : super();
  EnumOptions.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumOptions.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumOptions clone() => EnumOptions()..mergeFromMessage(this);
  EnumOptions copyWith(void Function(EnumOptions) updates) =>
      super.copyWith((message) => updates(message as EnumOptions));
  $pb.BuilderInfo get info_ => _i;
  static EnumOptions create() => EnumOptions();
  EnumOptions createEmptyInstance() => create();
  static $pb.PbList<EnumOptions> createRepeated() => $pb.PbList<EnumOptions>();
  static EnumOptions getDefault() => _defaultInstance ??= create()..freeze();
  static EnumOptions _defaultInstance;

  $core.bool get allowAlias => $_get(0, false);
  set allowAlias($core.bool v) {
    $_setBool(0, v);
  }

  $core.bool hasAllowAlias() => $_has(0);
  void clearAllowAlias() => clearField(2);

  $core.bool get deprecated => $_get(1, false);
  set deprecated($core.bool v) {
    $_setBool(1, v);
  }

  $core.bool hasDeprecated() => $_has(1);
  void clearDeprecated() => clearField(3);

  $core.List<UninterpretedOption> get uninterpretedOption => $_getList(2);
}

class EnumValueOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('EnumValueOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(1, 'deprecated')
    ..pc<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.create)
    ..hasExtensions = true;

  EnumValueOptions() : super();
  EnumValueOptions.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumValueOptions.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumValueOptions clone() => EnumValueOptions()..mergeFromMessage(this);
  EnumValueOptions copyWith(void Function(EnumValueOptions) updates) =>
      super.copyWith((message) => updates(message as EnumValueOptions));
  $pb.BuilderInfo get info_ => _i;
  static EnumValueOptions create() => EnumValueOptions();
  EnumValueOptions createEmptyInstance() => create();
  static $pb.PbList<EnumValueOptions> createRepeated() =>
      $pb.PbList<EnumValueOptions>();
  static EnumValueOptions getDefault() =>
      _defaultInstance ??= create()..freeze();
  static EnumValueOptions _defaultInstance;

  $core.bool get deprecated => $_get(0, false);
  set deprecated($core.bool v) {
    $_setBool(0, v);
  }

  $core.bool hasDeprecated() => $_has(0);
  void clearDeprecated() => clearField(1);

  $core.List<UninterpretedOption> get uninterpretedOption => $_getList(1);
}

class ServiceOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('ServiceOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(33, 'deprecated')
    ..pc<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.create)
    ..hasExtensions = true;

  ServiceOptions() : super();
  ServiceOptions.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ServiceOptions.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ServiceOptions clone() => ServiceOptions()..mergeFromMessage(this);
  ServiceOptions copyWith(void Function(ServiceOptions) updates) =>
      super.copyWith((message) => updates(message as ServiceOptions));
  $pb.BuilderInfo get info_ => _i;
  static ServiceOptions create() => ServiceOptions();
  ServiceOptions createEmptyInstance() => create();
  static $pb.PbList<ServiceOptions> createRepeated() =>
      $pb.PbList<ServiceOptions>();
  static ServiceOptions getDefault() => _defaultInstance ??= create()..freeze();
  static ServiceOptions _defaultInstance;

  $core.bool get deprecated => $_get(0, false);
  set deprecated($core.bool v) {
    $_setBool(0, v);
  }

  $core.bool hasDeprecated() => $_has(0);
  void clearDeprecated() => clearField(33);

  $core.List<UninterpretedOption> get uninterpretedOption => $_getList(1);
}

class MethodOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('MethodOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(33, 'deprecated')
    ..e<MethodOptions_IdempotencyLevel>(
        34,
        'idempotencyLevel',
        $pb.PbFieldType.OE,
        MethodOptions_IdempotencyLevel.IDEMPOTENCY_UNKNOWN,
        MethodOptions_IdempotencyLevel.valueOf,
        MethodOptions_IdempotencyLevel.values)
    ..pc<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.create)
    ..hasExtensions = true;

  MethodOptions() : super();
  MethodOptions.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MethodOptions.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MethodOptions clone() => MethodOptions()..mergeFromMessage(this);
  MethodOptions copyWith(void Function(MethodOptions) updates) =>
      super.copyWith((message) => updates(message as MethodOptions));
  $pb.BuilderInfo get info_ => _i;
  static MethodOptions create() => MethodOptions();
  MethodOptions createEmptyInstance() => create();
  static $pb.PbList<MethodOptions> createRepeated() =>
      $pb.PbList<MethodOptions>();
  static MethodOptions getDefault() => _defaultInstance ??= create()..freeze();
  static MethodOptions _defaultInstance;

  $core.bool get deprecated => $_get(0, false);
  set deprecated($core.bool v) {
    $_setBool(0, v);
  }

  $core.bool hasDeprecated() => $_has(0);
  void clearDeprecated() => clearField(33);

  MethodOptions_IdempotencyLevel get idempotencyLevel => $_getN(1);
  set idempotencyLevel(MethodOptions_IdempotencyLevel v) {
    setField(34, v);
  }

  $core.bool hasIdempotencyLevel() => $_has(1);
  void clearIdempotencyLevel() => clearField(34);

  $core.List<UninterpretedOption> get uninterpretedOption => $_getList(2);
}

class UninterpretedOption_NamePart extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'UninterpretedOption.NamePart',
      package: const $pb.PackageName('google.protobuf'))
    ..aQS(1, 'namePart')
    ..a<$core.bool>(2, 'isExtension', $pb.PbFieldType.QB);

  UninterpretedOption_NamePart() : super();
  UninterpretedOption_NamePart.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UninterpretedOption_NamePart.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UninterpretedOption_NamePart clone() =>
      UninterpretedOption_NamePart()..mergeFromMessage(this);
  UninterpretedOption_NamePart copyWith(
          void Function(UninterpretedOption_NamePart) updates) =>
      super.copyWith(
          (message) => updates(message as UninterpretedOption_NamePart));
  $pb.BuilderInfo get info_ => _i;
  static UninterpretedOption_NamePart create() =>
      UninterpretedOption_NamePart();
  UninterpretedOption_NamePart createEmptyInstance() => create();
  static $pb.PbList<UninterpretedOption_NamePart> createRepeated() =>
      $pb.PbList<UninterpretedOption_NamePart>();
  static UninterpretedOption_NamePart getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UninterpretedOption_NamePart _defaultInstance;

  $core.String get namePart => $_getS(0, '');
  set namePart($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasNamePart() => $_has(0);
  void clearNamePart() => clearField(1);

  $core.bool get isExtension => $_get(1, false);
  set isExtension($core.bool v) {
    $_setBool(1, v);
  }

  $core.bool hasIsExtension() => $_has(1);
  void clearIsExtension() => clearField(2);
}

class UninterpretedOption extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('UninterpretedOption',
      package: const $pb.PackageName('google.protobuf'))
    ..pc<UninterpretedOption_NamePart>(
        2, 'name', $pb.PbFieldType.PM, UninterpretedOption_NamePart.create)
    ..aOS(3, 'identifierValue')
    ..a<Int64>(4, 'positiveIntValue', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aInt64(5, 'negativeIntValue')
    ..a<$core.double>(6, 'doubleValue', $pb.PbFieldType.OD)
    ..a<$core.List<$core.int>>(7, 'stringValue', $pb.PbFieldType.OY)
    ..aOS(8, 'aggregateValue');

  UninterpretedOption() : super();
  UninterpretedOption.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UninterpretedOption.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UninterpretedOption clone() => UninterpretedOption()..mergeFromMessage(this);
  UninterpretedOption copyWith(void Function(UninterpretedOption) updates) =>
      super.copyWith((message) => updates(message as UninterpretedOption));
  $pb.BuilderInfo get info_ => _i;
  static UninterpretedOption create() => UninterpretedOption();
  UninterpretedOption createEmptyInstance() => create();
  static $pb.PbList<UninterpretedOption> createRepeated() =>
      $pb.PbList<UninterpretedOption>();
  static UninterpretedOption getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UninterpretedOption _defaultInstance;

  $core.List<UninterpretedOption_NamePart> get name => $_getList(0);

  $core.String get identifierValue => $_getS(1, '');
  set identifierValue($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasIdentifierValue() => $_has(1);
  void clearIdentifierValue() => clearField(3);

  Int64 get positiveIntValue => $_getI64(2);
  set positiveIntValue(Int64 v) {
    $_setInt64(2, v);
  }

  $core.bool hasPositiveIntValue() => $_has(2);
  void clearPositiveIntValue() => clearField(4);

  Int64 get negativeIntValue => $_getI64(3);
  set negativeIntValue(Int64 v) {
    $_setInt64(3, v);
  }

  $core.bool hasNegativeIntValue() => $_has(3);
  void clearNegativeIntValue() => clearField(5);

  $core.double get doubleValue => $_getN(4);
  set doubleValue($core.double v) {
    $_setDouble(4, v);
  }

  $core.bool hasDoubleValue() => $_has(4);
  void clearDoubleValue() => clearField(6);

  $core.List<$core.int> get stringValue => $_getN(5);
  set stringValue($core.List<$core.int> v) {
    $_setBytes(5, v);
  }

  $core.bool hasStringValue() => $_has(5);
  void clearStringValue() => clearField(7);

  $core.String get aggregateValue => $_getS(6, '');
  set aggregateValue($core.String v) {
    $_setString(6, v);
  }

  $core.bool hasAggregateValue() => $_has(6);
  void clearAggregateValue() => clearField(8);
}

class SourceCodeInfo_Location extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SourceCodeInfo.Location',
      package: const $pb.PackageName('google.protobuf'))
    ..p<$core.int>(1, 'path', $pb.PbFieldType.K3)
    ..p<$core.int>(2, 'span', $pb.PbFieldType.K3)
    ..aOS(3, 'leadingComments')
    ..aOS(4, 'trailingComments')
    ..pPS(6, 'leadingDetachedComments')
    ..hasRequiredFields = false;

  SourceCodeInfo_Location() : super();
  SourceCodeInfo_Location.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SourceCodeInfo_Location.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SourceCodeInfo_Location clone() =>
      SourceCodeInfo_Location()..mergeFromMessage(this);
  SourceCodeInfo_Location copyWith(
          void Function(SourceCodeInfo_Location) updates) =>
      super.copyWith((message) => updates(message as SourceCodeInfo_Location));
  $pb.BuilderInfo get info_ => _i;
  static SourceCodeInfo_Location create() => SourceCodeInfo_Location();
  SourceCodeInfo_Location createEmptyInstance() => create();
  static $pb.PbList<SourceCodeInfo_Location> createRepeated() =>
      $pb.PbList<SourceCodeInfo_Location>();
  static SourceCodeInfo_Location getDefault() =>
      _defaultInstance ??= create()..freeze();
  static SourceCodeInfo_Location _defaultInstance;

  $core.List<$core.int> get path => $_getList(0);

  $core.List<$core.int> get span => $_getList(1);

  $core.String get leadingComments => $_getS(2, '');
  set leadingComments($core.String v) {
    $_setString(2, v);
  }

  $core.bool hasLeadingComments() => $_has(2);
  void clearLeadingComments() => clearField(3);

  $core.String get trailingComments => $_getS(3, '');
  set trailingComments($core.String v) {
    $_setString(3, v);
  }

  $core.bool hasTrailingComments() => $_has(3);
  void clearTrailingComments() => clearField(4);

  $core.List<$core.String> get leadingDetachedComments => $_getList(4);
}

class SourceCodeInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('SourceCodeInfo',
      package: const $pb.PackageName('google.protobuf'))
    ..pc<SourceCodeInfo_Location>(
        1, 'location', $pb.PbFieldType.PM, SourceCodeInfo_Location.create)
    ..hasRequiredFields = false;

  SourceCodeInfo() : super();
  SourceCodeInfo.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SourceCodeInfo.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SourceCodeInfo clone() => SourceCodeInfo()..mergeFromMessage(this);
  SourceCodeInfo copyWith(void Function(SourceCodeInfo) updates) =>
      super.copyWith((message) => updates(message as SourceCodeInfo));
  $pb.BuilderInfo get info_ => _i;
  static SourceCodeInfo create() => SourceCodeInfo();
  SourceCodeInfo createEmptyInstance() => create();
  static $pb.PbList<SourceCodeInfo> createRepeated() =>
      $pb.PbList<SourceCodeInfo>();
  static SourceCodeInfo getDefault() => _defaultInstance ??= create()..freeze();
  static SourceCodeInfo _defaultInstance;

  $core.List<SourceCodeInfo_Location> get location => $_getList(0);
}

class GeneratedCodeInfo_Annotation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'GeneratedCodeInfo.Annotation',
      package: const $pb.PackageName('google.protobuf'))
    ..p<$core.int>(1, 'path', $pb.PbFieldType.K3)
    ..aOS(2, 'sourceFile')
    ..a<$core.int>(3, 'begin', $pb.PbFieldType.O3)
    ..a<$core.int>(4, 'end', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  GeneratedCodeInfo_Annotation() : super();
  GeneratedCodeInfo_Annotation.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GeneratedCodeInfo_Annotation.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GeneratedCodeInfo_Annotation clone() =>
      GeneratedCodeInfo_Annotation()..mergeFromMessage(this);
  GeneratedCodeInfo_Annotation copyWith(
          void Function(GeneratedCodeInfo_Annotation) updates) =>
      super.copyWith(
          (message) => updates(message as GeneratedCodeInfo_Annotation));
  $pb.BuilderInfo get info_ => _i;
  static GeneratedCodeInfo_Annotation create() =>
      GeneratedCodeInfo_Annotation();
  GeneratedCodeInfo_Annotation createEmptyInstance() => create();
  static $pb.PbList<GeneratedCodeInfo_Annotation> createRepeated() =>
      $pb.PbList<GeneratedCodeInfo_Annotation>();
  static GeneratedCodeInfo_Annotation getDefault() =>
      _defaultInstance ??= create()..freeze();
  static GeneratedCodeInfo_Annotation _defaultInstance;

  $core.List<$core.int> get path => $_getList(0);

  $core.String get sourceFile => $_getS(1, '');
  set sourceFile($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasSourceFile() => $_has(1);
  void clearSourceFile() => clearField(2);

  $core.int get begin => $_get(2, 0);
  set begin($core.int v) {
    $_setSignedInt32(2, v);
  }

  $core.bool hasBegin() => $_has(2);
  void clearBegin() => clearField(3);

  $core.int get end => $_get(3, 0);
  set end($core.int v) {
    $_setSignedInt32(3, v);
  }

  $core.bool hasEnd() => $_has(3);
  void clearEnd() => clearField(4);
}

class GeneratedCodeInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('GeneratedCodeInfo',
      package: const $pb.PackageName('google.protobuf'))
    ..pc<GeneratedCodeInfo_Annotation>(1, 'annotation', $pb.PbFieldType.PM,
        GeneratedCodeInfo_Annotation.create)
    ..hasRequiredFields = false;

  GeneratedCodeInfo() : super();
  GeneratedCodeInfo.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GeneratedCodeInfo.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GeneratedCodeInfo clone() => GeneratedCodeInfo()..mergeFromMessage(this);
  GeneratedCodeInfo copyWith(void Function(GeneratedCodeInfo) updates) =>
      super.copyWith((message) => updates(message as GeneratedCodeInfo));
  $pb.BuilderInfo get info_ => _i;
  static GeneratedCodeInfo create() => GeneratedCodeInfo();
  GeneratedCodeInfo createEmptyInstance() => create();
  static $pb.PbList<GeneratedCodeInfo> createRepeated() =>
      $pb.PbList<GeneratedCodeInfo>();
  static GeneratedCodeInfo getDefault() =>
      _defaultInstance ??= create()..freeze();
  static GeneratedCodeInfo _defaultInstance;

  $core.List<GeneratedCodeInfo_Annotation> get annotation => $_getList(0);
}
