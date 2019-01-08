///
//  Generated code. Do not modify.
//  source: descriptor.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart' as $pb;

import 'descriptor.pbenum.dart';

export 'descriptor.pbenum.dart';

class FileDescriptorSet extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FileDescriptorSet',
      package: const $pb.PackageName('google.protobuf'))
    ..pp<FileDescriptorProto>(1, 'file', $pb.PbFieldType.PM,
        FileDescriptorProto.$checkItem, FileDescriptorProto.create);

  FileDescriptorSet() : super();
  FileDescriptorSet.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileDescriptorSet.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileDescriptorSet clone() => new FileDescriptorSet()..mergeFromMessage(this);
  FileDescriptorSet copyWith(void Function(FileDescriptorSet) updates) =>
      super.copyWith((message) => updates(message as FileDescriptorSet));
  $pb.BuilderInfo get info_ => _i;
  static FileDescriptorSet create() => new FileDescriptorSet();
  FileDescriptorSet createEmptyInstance() => create();
  static $pb.PbList<FileDescriptorSet> createRepeated() =>
      new $pb.PbList<FileDescriptorSet>();
  static FileDescriptorSet getDefault() =>
      _defaultInstance ??= create()..freeze();
  static FileDescriptorSet _defaultInstance;
  static void $checkItem(FileDescriptorSet v) {
    if (v is! FileDescriptorSet)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<FileDescriptorProto> get file => $_getList(0);
}

class FileDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FileDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'package')
    ..pPS(3, 'dependency')
    ..pp<DescriptorProto>(4, 'messageType', $pb.PbFieldType.PM,
        DescriptorProto.$checkItem, DescriptorProto.create)
    ..pp<EnumDescriptorProto>(5, 'enumType', $pb.PbFieldType.PM,
        EnumDescriptorProto.$checkItem, EnumDescriptorProto.create)
    ..pp<ServiceDescriptorProto>(6, 'service', $pb.PbFieldType.PM,
        ServiceDescriptorProto.$checkItem, ServiceDescriptorProto.create)
    ..pp<FieldDescriptorProto>(7, 'extension', $pb.PbFieldType.PM,
        FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..a<FileOptions>(8, 'options', $pb.PbFieldType.OM, FileOptions.getDefault,
        FileOptions.create)
    ..a<SourceCodeInfo>(9, 'sourceCodeInfo', $pb.PbFieldType.OM,
        SourceCodeInfo.getDefault, SourceCodeInfo.create)
    ..p<int>(10, 'publicDependency', $pb.PbFieldType.P3)
    ..p<int>(11, 'weakDependency', $pb.PbFieldType.P3)
    ..aOS(12, 'syntax');

  FileDescriptorProto() : super();
  FileDescriptorProto.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileDescriptorProto.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileDescriptorProto clone() =>
      new FileDescriptorProto()..mergeFromMessage(this);
  FileDescriptorProto copyWith(void Function(FileDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as FileDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static FileDescriptorProto create() => new FileDescriptorProto();
  FileDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<FileDescriptorProto> createRepeated() =>
      new $pb.PbList<FileDescriptorProto>();
  static FileDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static FileDescriptorProto _defaultInstance;
  static void $checkItem(FileDescriptorProto v) {
    if (v is! FileDescriptorProto)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get package => $_getS(1, '');
  set package(String v) {
    $_setString(1, v);
  }

  bool hasPackage() => $_has(1);
  void clearPackage() => clearField(2);

  List<String> get dependency => $_getList(2);

  List<DescriptorProto> get messageType => $_getList(3);

  List<EnumDescriptorProto> get enumType => $_getList(4);

  List<ServiceDescriptorProto> get service => $_getList(5);

  List<FieldDescriptorProto> get extension => $_getList(6);

  FileOptions get options => $_getN(7);
  set options(FileOptions v) {
    setField(8, v);
  }

  bool hasOptions() => $_has(7);
  void clearOptions() => clearField(8);

  SourceCodeInfo get sourceCodeInfo => $_getN(8);
  set sourceCodeInfo(SourceCodeInfo v) {
    setField(9, v);
  }

  bool hasSourceCodeInfo() => $_has(8);
  void clearSourceCodeInfo() => clearField(9);

  List<int> get publicDependency => $_getList(9);

  List<int> get weakDependency => $_getList(10);

  String get syntax => $_getS(11, '');
  set syntax(String v) {
    $_setString(11, v);
  }

  bool hasSyntax() => $_has(11);
  void clearSyntax() => clearField(12);
}

class DescriptorProto_ExtensionRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'DescriptorProto.ExtensionRange',
      package: const $pb.PackageName('google.protobuf'))
    ..a<int>(1, 'start', $pb.PbFieldType.O3)
    ..a<int>(2, 'end', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DescriptorProto_ExtensionRange() : super();
  DescriptorProto_ExtensionRange.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto_ExtensionRange.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto_ExtensionRange clone() =>
      new DescriptorProto_ExtensionRange()..mergeFromMessage(this);
  DescriptorProto_ExtensionRange copyWith(
          void Function(DescriptorProto_ExtensionRange) updates) =>
      super.copyWith(
          (message) => updates(message as DescriptorProto_ExtensionRange));
  $pb.BuilderInfo get info_ => _i;
  static DescriptorProto_ExtensionRange create() =>
      new DescriptorProto_ExtensionRange();
  DescriptorProto_ExtensionRange createEmptyInstance() => create();
  static $pb.PbList<DescriptorProto_ExtensionRange> createRepeated() =>
      new $pb.PbList<DescriptorProto_ExtensionRange>();
  static DescriptorProto_ExtensionRange getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DescriptorProto_ExtensionRange _defaultInstance;
  static void $checkItem(DescriptorProto_ExtensionRange v) {
    if (v is! DescriptorProto_ExtensionRange)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get start => $_get(0, 0);
  set start(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasStart() => $_has(0);
  void clearStart() => clearField(1);

  int get end => $_get(1, 0);
  set end(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}

class DescriptorProto_ReservedRange extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'DescriptorProto.ReservedRange',
      package: const $pb.PackageName('google.protobuf'))
    ..a<int>(1, 'start', $pb.PbFieldType.O3)
    ..a<int>(2, 'end', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  DescriptorProto_ReservedRange() : super();
  DescriptorProto_ReservedRange.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto_ReservedRange.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto_ReservedRange clone() =>
      new DescriptorProto_ReservedRange()..mergeFromMessage(this);
  DescriptorProto_ReservedRange copyWith(
          void Function(DescriptorProto_ReservedRange) updates) =>
      super.copyWith(
          (message) => updates(message as DescriptorProto_ReservedRange));
  $pb.BuilderInfo get info_ => _i;
  static DescriptorProto_ReservedRange create() =>
      new DescriptorProto_ReservedRange();
  DescriptorProto_ReservedRange createEmptyInstance() => create();
  static $pb.PbList<DescriptorProto_ReservedRange> createRepeated() =>
      new $pb.PbList<DescriptorProto_ReservedRange>();
  static DescriptorProto_ReservedRange getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DescriptorProto_ReservedRange _defaultInstance;
  static void $checkItem(DescriptorProto_ReservedRange v) {
    if (v is! DescriptorProto_ReservedRange)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get start => $_get(0, 0);
  set start(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasStart() => $_has(0);
  void clearStart() => clearField(1);

  int get end => $_get(1, 0);
  set end(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasEnd() => $_has(1);
  void clearEnd() => clearField(2);
}

class DescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('DescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pp<FieldDescriptorProto>(2, 'field', $pb.PbFieldType.PM,
        FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..pp<DescriptorProto>(3, 'nestedType', $pb.PbFieldType.PM,
        DescriptorProto.$checkItem, DescriptorProto.create)
    ..pp<EnumDescriptorProto>(4, 'enumType', $pb.PbFieldType.PM,
        EnumDescriptorProto.$checkItem, EnumDescriptorProto.create)
    ..pp<DescriptorProto_ExtensionRange>(
        5,
        'extensionRange',
        $pb.PbFieldType.PM,
        DescriptorProto_ExtensionRange.$checkItem,
        DescriptorProto_ExtensionRange.create)
    ..pp<FieldDescriptorProto>(6, 'extension', $pb.PbFieldType.PM,
        FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..a<MessageOptions>(7, 'options', $pb.PbFieldType.OM,
        MessageOptions.getDefault, MessageOptions.create)
    ..pp<OneofDescriptorProto>(8, 'oneofDecl', $pb.PbFieldType.PM,
        OneofDescriptorProto.$checkItem, OneofDescriptorProto.create)
    ..pp<DescriptorProto_ReservedRange>(
        9,
        'reservedRange',
        $pb.PbFieldType.PM,
        DescriptorProto_ReservedRange.$checkItem,
        DescriptorProto_ReservedRange.create)
    ..pPS(10, 'reservedName');

  DescriptorProto() : super();
  DescriptorProto.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto clone() => new DescriptorProto()..mergeFromMessage(this);
  DescriptorProto copyWith(void Function(DescriptorProto) updates) =>
      super.copyWith((message) => updates(message as DescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static DescriptorProto create() => new DescriptorProto();
  DescriptorProto createEmptyInstance() => create();
  static $pb.PbList<DescriptorProto> createRepeated() =>
      new $pb.PbList<DescriptorProto>();
  static DescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static DescriptorProto _defaultInstance;
  static void $checkItem(DescriptorProto v) {
    if (v is! DescriptorProto) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  List<FieldDescriptorProto> get field => $_getList(1);

  List<DescriptorProto> get nestedType => $_getList(2);

  List<EnumDescriptorProto> get enumType => $_getList(3);

  List<DescriptorProto_ExtensionRange> get extensionRange => $_getList(4);

  List<FieldDescriptorProto> get extension => $_getList(5);

  MessageOptions get options => $_getN(6);
  set options(MessageOptions v) {
    setField(7, v);
  }

  bool hasOptions() => $_has(6);
  void clearOptions() => clearField(7);

  List<OneofDescriptorProto> get oneofDecl => $_getList(7);

  List<DescriptorProto_ReservedRange> get reservedRange => $_getList(8);

  List<String> get reservedName => $_getList(9);
}

class FieldDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FieldDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'extendee')
    ..a<int>(3, 'number', $pb.PbFieldType.O3)
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
    ..a<int>(9, 'oneofIndex', $pb.PbFieldType.O3)
    ..aOS(10, 'jsonName');

  FieldDescriptorProto() : super();
  FieldDescriptorProto.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FieldDescriptorProto.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FieldDescriptorProto clone() =>
      new FieldDescriptorProto()..mergeFromMessage(this);
  FieldDescriptorProto copyWith(void Function(FieldDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as FieldDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static FieldDescriptorProto create() => new FieldDescriptorProto();
  FieldDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<FieldDescriptorProto> createRepeated() =>
      new $pb.PbList<FieldDescriptorProto>();
  static FieldDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static FieldDescriptorProto _defaultInstance;
  static void $checkItem(FieldDescriptorProto v) {
    if (v is! FieldDescriptorProto)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get extendee => $_getS(1, '');
  set extendee(String v) {
    $_setString(1, v);
  }

  bool hasExtendee() => $_has(1);
  void clearExtendee() => clearField(2);

  int get number => $_get(2, 0);
  set number(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasNumber() => $_has(2);
  void clearNumber() => clearField(3);

  FieldDescriptorProto_Label get label => $_getN(3);
  set label(FieldDescriptorProto_Label v) {
    setField(4, v);
  }

  bool hasLabel() => $_has(3);
  void clearLabel() => clearField(4);

  FieldDescriptorProto_Type get type => $_getN(4);
  set type(FieldDescriptorProto_Type v) {
    setField(5, v);
  }

  bool hasType() => $_has(4);
  void clearType() => clearField(5);

  String get typeName => $_getS(5, '');
  set typeName(String v) {
    $_setString(5, v);
  }

  bool hasTypeName() => $_has(5);
  void clearTypeName() => clearField(6);

  String get defaultValue => $_getS(6, '');
  set defaultValue(String v) {
    $_setString(6, v);
  }

  bool hasDefaultValue() => $_has(6);
  void clearDefaultValue() => clearField(7);

  FieldOptions get options => $_getN(7);
  set options(FieldOptions v) {
    setField(8, v);
  }

  bool hasOptions() => $_has(7);
  void clearOptions() => clearField(8);

  int get oneofIndex => $_get(8, 0);
  set oneofIndex(int v) {
    $_setSignedInt32(8, v);
  }

  bool hasOneofIndex() => $_has(8);
  void clearOneofIndex() => clearField(9);

  String get jsonName => $_getS(9, '');
  set jsonName(String v) {
    $_setString(9, v);
  }

  bool hasJsonName() => $_has(9);
  void clearJsonName() => clearField(10);
}

class OneofDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OneofDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..a<OneofOptions>(2, 'options', $pb.PbFieldType.OM, OneofOptions.getDefault,
        OneofOptions.create);

  OneofDescriptorProto() : super();
  OneofDescriptorProto.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  OneofDescriptorProto.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  OneofDescriptorProto clone() =>
      new OneofDescriptorProto()..mergeFromMessage(this);
  OneofDescriptorProto copyWith(void Function(OneofDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as OneofDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static OneofDescriptorProto create() => new OneofDescriptorProto();
  OneofDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<OneofDescriptorProto> createRepeated() =>
      new $pb.PbList<OneofDescriptorProto>();
  static OneofDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static OneofDescriptorProto _defaultInstance;
  static void $checkItem(OneofDescriptorProto v) {
    if (v is! OneofDescriptorProto)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  OneofOptions get options => $_getN(1);
  set options(OneofOptions v) {
    setField(2, v);
  }

  bool hasOptions() => $_has(1);
  void clearOptions() => clearField(2);
}

class EnumDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('EnumDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pp<EnumValueDescriptorProto>(2, 'value', $pb.PbFieldType.PM,
        EnumValueDescriptorProto.$checkItem, EnumValueDescriptorProto.create)
    ..a<EnumOptions>(3, 'options', $pb.PbFieldType.OM, EnumOptions.getDefault,
        EnumOptions.create);

  EnumDescriptorProto() : super();
  EnumDescriptorProto.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumDescriptorProto.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumDescriptorProto clone() =>
      new EnumDescriptorProto()..mergeFromMessage(this);
  EnumDescriptorProto copyWith(void Function(EnumDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as EnumDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static EnumDescriptorProto create() => new EnumDescriptorProto();
  EnumDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<EnumDescriptorProto> createRepeated() =>
      new $pb.PbList<EnumDescriptorProto>();
  static EnumDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static EnumDescriptorProto _defaultInstance;
  static void $checkItem(EnumDescriptorProto v) {
    if (v is! EnumDescriptorProto)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  List<EnumValueDescriptorProto> get value => $_getList(1);

  EnumOptions get options => $_getN(2);
  set options(EnumOptions v) {
    setField(3, v);
  }

  bool hasOptions() => $_has(2);
  void clearOptions() => clearField(3);
}

class EnumValueDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'EnumValueDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..a<int>(2, 'number', $pb.PbFieldType.O3)
    ..a<EnumValueOptions>(3, 'options', $pb.PbFieldType.OM,
        EnumValueOptions.getDefault, EnumValueOptions.create);

  EnumValueDescriptorProto() : super();
  EnumValueDescriptorProto.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumValueDescriptorProto.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumValueDescriptorProto clone() =>
      new EnumValueDescriptorProto()..mergeFromMessage(this);
  EnumValueDescriptorProto copyWith(
          void Function(EnumValueDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as EnumValueDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static EnumValueDescriptorProto create() => new EnumValueDescriptorProto();
  EnumValueDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<EnumValueDescriptorProto> createRepeated() =>
      new $pb.PbList<EnumValueDescriptorProto>();
  static EnumValueDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static EnumValueDescriptorProto _defaultInstance;
  static void $checkItem(EnumValueDescriptorProto v) {
    if (v is! EnumValueDescriptorProto)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  int get number => $_get(1, 0);
  set number(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasNumber() => $_has(1);
  void clearNumber() => clearField(2);

  EnumValueOptions get options => $_getN(2);
  set options(EnumValueOptions v) {
    setField(3, v);
  }

  bool hasOptions() => $_has(2);
  void clearOptions() => clearField(3);
}

class ServiceDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'ServiceDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..pp<MethodDescriptorProto>(2, 'method', $pb.PbFieldType.PM,
        MethodDescriptorProto.$checkItem, MethodDescriptorProto.create)
    ..a<ServiceOptions>(3, 'options', $pb.PbFieldType.OM,
        ServiceOptions.getDefault, ServiceOptions.create);

  ServiceDescriptorProto() : super();
  ServiceDescriptorProto.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ServiceDescriptorProto.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ServiceDescriptorProto clone() =>
      new ServiceDescriptorProto()..mergeFromMessage(this);
  ServiceDescriptorProto copyWith(
          void Function(ServiceDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as ServiceDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static ServiceDescriptorProto create() => new ServiceDescriptorProto();
  ServiceDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<ServiceDescriptorProto> createRepeated() =>
      new $pb.PbList<ServiceDescriptorProto>();
  static ServiceDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static ServiceDescriptorProto _defaultInstance;
  static void $checkItem(ServiceDescriptorProto v) {
    if (v is! ServiceDescriptorProto)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  List<MethodDescriptorProto> get method => $_getList(1);

  ServiceOptions get options => $_getN(2);
  set options(ServiceOptions v) {
    setField(3, v);
  }

  bool hasOptions() => $_has(2);
  void clearOptions() => clearField(3);
}

class MethodDescriptorProto extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MethodDescriptorProto',
      package: const $pb.PackageName('google.protobuf'))
    ..aOS(1, 'name')
    ..aOS(2, 'inputType')
    ..aOS(3, 'outputType')
    ..a<MethodOptions>(4, 'options', $pb.PbFieldType.OM,
        MethodOptions.getDefault, MethodOptions.create)
    ..aOB(5, 'clientStreaming')
    ..aOB(6, 'serverStreaming');

  MethodDescriptorProto() : super();
  MethodDescriptorProto.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MethodDescriptorProto.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MethodDescriptorProto clone() =>
      new MethodDescriptorProto()..mergeFromMessage(this);
  MethodDescriptorProto copyWith(
          void Function(MethodDescriptorProto) updates) =>
      super.copyWith((message) => updates(message as MethodDescriptorProto));
  $pb.BuilderInfo get info_ => _i;
  static MethodDescriptorProto create() => new MethodDescriptorProto();
  MethodDescriptorProto createEmptyInstance() => create();
  static $pb.PbList<MethodDescriptorProto> createRepeated() =>
      new $pb.PbList<MethodDescriptorProto>();
  static MethodDescriptorProto getDefault() =>
      _defaultInstance ??= create()..freeze();
  static MethodDescriptorProto _defaultInstance;
  static void $checkItem(MethodDescriptorProto v) {
    if (v is! MethodDescriptorProto)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get inputType => $_getS(1, '');
  set inputType(String v) {
    $_setString(1, v);
  }

  bool hasInputType() => $_has(1);
  void clearInputType() => clearField(2);

  String get outputType => $_getS(2, '');
  set outputType(String v) {
    $_setString(2, v);
  }

  bool hasOutputType() => $_has(2);
  void clearOutputType() => clearField(3);

  MethodOptions get options => $_getN(3);
  set options(MethodOptions v) {
    setField(4, v);
  }

  bool hasOptions() => $_has(3);
  void clearOptions() => clearField(4);

  bool get clientStreaming => $_get(4, false);
  set clientStreaming(bool v) {
    $_setBool(4, v);
  }

  bool hasClientStreaming() => $_has(4);
  void clearClientStreaming() => clearField(5);

  bool get serverStreaming => $_get(5, false);
  set serverStreaming(bool v) {
    $_setBool(5, v);
  }

  bool hasServerStreaming() => $_has(5);
  void clearServerStreaming() => clearField(6);
}

class FileOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FileOptions',
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
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  FileOptions() : super();
  FileOptions.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileOptions.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileOptions clone() => new FileOptions()..mergeFromMessage(this);
  FileOptions copyWith(void Function(FileOptions) updates) =>
      super.copyWith((message) => updates(message as FileOptions));
  $pb.BuilderInfo get info_ => _i;
  static FileOptions create() => new FileOptions();
  FileOptions createEmptyInstance() => create();
  static $pb.PbList<FileOptions> createRepeated() =>
      new $pb.PbList<FileOptions>();
  static FileOptions getDefault() => _defaultInstance ??= create()..freeze();
  static FileOptions _defaultInstance;
  static void $checkItem(FileOptions v) {
    if (v is! FileOptions) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get javaPackage => $_getS(0, '');
  set javaPackage(String v) {
    $_setString(0, v);
  }

  bool hasJavaPackage() => $_has(0);
  void clearJavaPackage() => clearField(1);

  String get javaOuterClassname => $_getS(1, '');
  set javaOuterClassname(String v) {
    $_setString(1, v);
  }

  bool hasJavaOuterClassname() => $_has(1);
  void clearJavaOuterClassname() => clearField(8);

  FileOptions_OptimizeMode get optimizeFor => $_getN(2);
  set optimizeFor(FileOptions_OptimizeMode v) {
    setField(9, v);
  }

  bool hasOptimizeFor() => $_has(2);
  void clearOptimizeFor() => clearField(9);

  bool get javaMultipleFiles => $_get(3, false);
  set javaMultipleFiles(bool v) {
    $_setBool(3, v);
  }

  bool hasJavaMultipleFiles() => $_has(3);
  void clearJavaMultipleFiles() => clearField(10);

  String get goPackage => $_getS(4, '');
  set goPackage(String v) {
    $_setString(4, v);
  }

  bool hasGoPackage() => $_has(4);
  void clearGoPackage() => clearField(11);

  bool get ccGenericServices => $_get(5, false);
  set ccGenericServices(bool v) {
    $_setBool(5, v);
  }

  bool hasCcGenericServices() => $_has(5);
  void clearCcGenericServices() => clearField(16);

  bool get javaGenericServices => $_get(6, false);
  set javaGenericServices(bool v) {
    $_setBool(6, v);
  }

  bool hasJavaGenericServices() => $_has(6);
  void clearJavaGenericServices() => clearField(17);

  bool get pyGenericServices => $_get(7, false);
  set pyGenericServices(bool v) {
    $_setBool(7, v);
  }

  bool hasPyGenericServices() => $_has(7);
  void clearPyGenericServices() => clearField(18);

  bool get javaGenerateEqualsAndHash => $_get(8, false);
  set javaGenerateEqualsAndHash(bool v) {
    $_setBool(8, v);
  }

  bool hasJavaGenerateEqualsAndHash() => $_has(8);
  void clearJavaGenerateEqualsAndHash() => clearField(20);

  bool get deprecated => $_get(9, false);
  set deprecated(bool v) {
    $_setBool(9, v);
  }

  bool hasDeprecated() => $_has(9);
  void clearDeprecated() => clearField(23);

  bool get javaStringCheckUtf8 => $_get(10, false);
  set javaStringCheckUtf8(bool v) {
    $_setBool(10, v);
  }

  bool hasJavaStringCheckUtf8() => $_has(10);
  void clearJavaStringCheckUtf8() => clearField(27);

  bool get ccEnableArenas => $_get(11, false);
  set ccEnableArenas(bool v) {
    $_setBool(11, v);
  }

  bool hasCcEnableArenas() => $_has(11);
  void clearCcEnableArenas() => clearField(31);

  String get objcClassPrefix => $_getS(12, '');
  set objcClassPrefix(String v) {
    $_setString(12, v);
  }

  bool hasObjcClassPrefix() => $_has(12);
  void clearObjcClassPrefix() => clearField(36);

  String get csharpNamespace => $_getS(13, '');
  set csharpNamespace(String v) {
    $_setString(13, v);
  }

  bool hasCsharpNamespace() => $_has(13);
  void clearCsharpNamespace() => clearField(37);

  String get swiftPrefix => $_getS(14, '');
  set swiftPrefix(String v) {
    $_setString(14, v);
  }

  bool hasSwiftPrefix() => $_has(14);
  void clearSwiftPrefix() => clearField(39);

  String get phpClassPrefix => $_getS(15, '');
  set phpClassPrefix(String v) {
    $_setString(15, v);
  }

  bool hasPhpClassPrefix() => $_has(15);
  void clearPhpClassPrefix() => clearField(40);

  String get phpNamespace => $_getS(16, '');
  set phpNamespace(String v) {
    $_setString(16, v);
  }

  bool hasPhpNamespace() => $_has(16);
  void clearPhpNamespace() => clearField(41);

  List<UninterpretedOption> get uninterpretedOption => $_getList(17);
}

class MessageOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MessageOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(1, 'messageSetWireFormat')
    ..aOB(2, 'noStandardDescriptorAccessor')
    ..aOB(3, 'deprecated')
    ..aOB(7, 'mapEntry')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  MessageOptions() : super();
  MessageOptions.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MessageOptions.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MessageOptions clone() => new MessageOptions()..mergeFromMessage(this);
  MessageOptions copyWith(void Function(MessageOptions) updates) =>
      super.copyWith((message) => updates(message as MessageOptions));
  $pb.BuilderInfo get info_ => _i;
  static MessageOptions create() => new MessageOptions();
  MessageOptions createEmptyInstance() => create();
  static $pb.PbList<MessageOptions> createRepeated() =>
      new $pb.PbList<MessageOptions>();
  static MessageOptions getDefault() => _defaultInstance ??= create()..freeze();
  static MessageOptions _defaultInstance;
  static void $checkItem(MessageOptions v) {
    if (v is! MessageOptions) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get messageSetWireFormat => $_get(0, false);
  set messageSetWireFormat(bool v) {
    $_setBool(0, v);
  }

  bool hasMessageSetWireFormat() => $_has(0);
  void clearMessageSetWireFormat() => clearField(1);

  bool get noStandardDescriptorAccessor => $_get(1, false);
  set noStandardDescriptorAccessor(bool v) {
    $_setBool(1, v);
  }

  bool hasNoStandardDescriptorAccessor() => $_has(1);
  void clearNoStandardDescriptorAccessor() => clearField(2);

  bool get deprecated => $_get(2, false);
  set deprecated(bool v) {
    $_setBool(2, v);
  }

  bool hasDeprecated() => $_has(2);
  void clearDeprecated() => clearField(3);

  bool get mapEntry => $_get(3, false);
  set mapEntry(bool v) {
    $_setBool(3, v);
  }

  bool hasMapEntry() => $_has(3);
  void clearMapEntry() => clearField(7);

  List<UninterpretedOption> get uninterpretedOption => $_getList(4);
}

class FieldOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('FieldOptions',
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
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  FieldOptions() : super();
  FieldOptions.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FieldOptions.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FieldOptions clone() => new FieldOptions()..mergeFromMessage(this);
  FieldOptions copyWith(void Function(FieldOptions) updates) =>
      super.copyWith((message) => updates(message as FieldOptions));
  $pb.BuilderInfo get info_ => _i;
  static FieldOptions create() => new FieldOptions();
  FieldOptions createEmptyInstance() => create();
  static $pb.PbList<FieldOptions> createRepeated() =>
      new $pb.PbList<FieldOptions>();
  static FieldOptions getDefault() => _defaultInstance ??= create()..freeze();
  static FieldOptions _defaultInstance;
  static void $checkItem(FieldOptions v) {
    if (v is! FieldOptions) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  FieldOptions_CType get ctype => $_getN(0);
  set ctype(FieldOptions_CType v) {
    setField(1, v);
  }

  bool hasCtype() => $_has(0);
  void clearCtype() => clearField(1);

  bool get packed => $_get(1, false);
  set packed(bool v) {
    $_setBool(1, v);
  }

  bool hasPacked() => $_has(1);
  void clearPacked() => clearField(2);

  bool get deprecated => $_get(2, false);
  set deprecated(bool v) {
    $_setBool(2, v);
  }

  bool hasDeprecated() => $_has(2);
  void clearDeprecated() => clearField(3);

  bool get lazy => $_get(3, false);
  set lazy(bool v) {
    $_setBool(3, v);
  }

  bool hasLazy() => $_has(3);
  void clearLazy() => clearField(5);

  FieldOptions_JSType get jstype => $_getN(4);
  set jstype(FieldOptions_JSType v) {
    setField(6, v);
  }

  bool hasJstype() => $_has(4);
  void clearJstype() => clearField(6);

  bool get weak => $_get(5, false);
  set weak(bool v) {
    $_setBool(5, v);
  }

  bool hasWeak() => $_has(5);
  void clearWeak() => clearField(10);

  List<UninterpretedOption> get uninterpretedOption => $_getList(6);
}

class OneofOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('OneofOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  OneofOptions() : super();
  OneofOptions.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  OneofOptions.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  OneofOptions clone() => new OneofOptions()..mergeFromMessage(this);
  OneofOptions copyWith(void Function(OneofOptions) updates) =>
      super.copyWith((message) => updates(message as OneofOptions));
  $pb.BuilderInfo get info_ => _i;
  static OneofOptions create() => new OneofOptions();
  OneofOptions createEmptyInstance() => create();
  static $pb.PbList<OneofOptions> createRepeated() =>
      new $pb.PbList<OneofOptions>();
  static OneofOptions getDefault() => _defaultInstance ??= create()..freeze();
  static OneofOptions _defaultInstance;
  static void $checkItem(OneofOptions v) {
    if (v is! OneofOptions) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<UninterpretedOption> get uninterpretedOption => $_getList(0);
}

class EnumOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('EnumOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(2, 'allowAlias')
    ..aOB(3, 'deprecated')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  EnumOptions() : super();
  EnumOptions.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumOptions.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumOptions clone() => new EnumOptions()..mergeFromMessage(this);
  EnumOptions copyWith(void Function(EnumOptions) updates) =>
      super.copyWith((message) => updates(message as EnumOptions));
  $pb.BuilderInfo get info_ => _i;
  static EnumOptions create() => new EnumOptions();
  EnumOptions createEmptyInstance() => create();
  static $pb.PbList<EnumOptions> createRepeated() =>
      new $pb.PbList<EnumOptions>();
  static EnumOptions getDefault() => _defaultInstance ??= create()..freeze();
  static EnumOptions _defaultInstance;
  static void $checkItem(EnumOptions v) {
    if (v is! EnumOptions) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get allowAlias => $_get(0, false);
  set allowAlias(bool v) {
    $_setBool(0, v);
  }

  bool hasAllowAlias() => $_has(0);
  void clearAllowAlias() => clearField(2);

  bool get deprecated => $_get(1, false);
  set deprecated(bool v) {
    $_setBool(1, v);
  }

  bool hasDeprecated() => $_has(1);
  void clearDeprecated() => clearField(3);

  List<UninterpretedOption> get uninterpretedOption => $_getList(2);
}

class EnumValueOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('EnumValueOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(1, 'deprecated')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  EnumValueOptions() : super();
  EnumValueOptions.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumValueOptions.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumValueOptions clone() => new EnumValueOptions()..mergeFromMessage(this);
  EnumValueOptions copyWith(void Function(EnumValueOptions) updates) =>
      super.copyWith((message) => updates(message as EnumValueOptions));
  $pb.BuilderInfo get info_ => _i;
  static EnumValueOptions create() => new EnumValueOptions();
  EnumValueOptions createEmptyInstance() => create();
  static $pb.PbList<EnumValueOptions> createRepeated() =>
      new $pb.PbList<EnumValueOptions>();
  static EnumValueOptions getDefault() =>
      _defaultInstance ??= create()..freeze();
  static EnumValueOptions _defaultInstance;
  static void $checkItem(EnumValueOptions v) {
    if (v is! EnumValueOptions) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get deprecated => $_get(0, false);
  set deprecated(bool v) {
    $_setBool(0, v);
  }

  bool hasDeprecated() => $_has(0);
  void clearDeprecated() => clearField(1);

  List<UninterpretedOption> get uninterpretedOption => $_getList(1);
}

class ServiceOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('ServiceOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(33, 'deprecated')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  ServiceOptions() : super();
  ServiceOptions.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ServiceOptions.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ServiceOptions clone() => new ServiceOptions()..mergeFromMessage(this);
  ServiceOptions copyWith(void Function(ServiceOptions) updates) =>
      super.copyWith((message) => updates(message as ServiceOptions));
  $pb.BuilderInfo get info_ => _i;
  static ServiceOptions create() => new ServiceOptions();
  ServiceOptions createEmptyInstance() => create();
  static $pb.PbList<ServiceOptions> createRepeated() =>
      new $pb.PbList<ServiceOptions>();
  static ServiceOptions getDefault() => _defaultInstance ??= create()..freeze();
  static ServiceOptions _defaultInstance;
  static void $checkItem(ServiceOptions v) {
    if (v is! ServiceOptions) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get deprecated => $_get(0, false);
  set deprecated(bool v) {
    $_setBool(0, v);
  }

  bool hasDeprecated() => $_has(0);
  void clearDeprecated() => clearField(33);

  List<UninterpretedOption> get uninterpretedOption => $_getList(1);
}

class MethodOptions extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('MethodOptions',
      package: const $pb.PackageName('google.protobuf'))
    ..aOB(33, 'deprecated')
    ..e<MethodOptions_IdempotencyLevel>(
        34,
        'idempotencyLevel',
        $pb.PbFieldType.OE,
        MethodOptions_IdempotencyLevel.IDEMPOTENCY_UNKNOWN,
        MethodOptions_IdempotencyLevel.valueOf,
        MethodOptions_IdempotencyLevel.values)
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', $pb.PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  MethodOptions() : super();
  MethodOptions.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MethodOptions.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MethodOptions clone() => new MethodOptions()..mergeFromMessage(this);
  MethodOptions copyWith(void Function(MethodOptions) updates) =>
      super.copyWith((message) => updates(message as MethodOptions));
  $pb.BuilderInfo get info_ => _i;
  static MethodOptions create() => new MethodOptions();
  MethodOptions createEmptyInstance() => create();
  static $pb.PbList<MethodOptions> createRepeated() =>
      new $pb.PbList<MethodOptions>();
  static MethodOptions getDefault() => _defaultInstance ??= create()..freeze();
  static MethodOptions _defaultInstance;
  static void $checkItem(MethodOptions v) {
    if (v is! MethodOptions) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  bool get deprecated => $_get(0, false);
  set deprecated(bool v) {
    $_setBool(0, v);
  }

  bool hasDeprecated() => $_has(0);
  void clearDeprecated() => clearField(33);

  MethodOptions_IdempotencyLevel get idempotencyLevel => $_getN(1);
  set idempotencyLevel(MethodOptions_IdempotencyLevel v) {
    setField(34, v);
  }

  bool hasIdempotencyLevel() => $_has(1);
  void clearIdempotencyLevel() => clearField(34);

  List<UninterpretedOption> get uninterpretedOption => $_getList(2);
}

class UninterpretedOption_NamePart extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'UninterpretedOption.NamePart',
      package: const $pb.PackageName('google.protobuf'))
    ..aQS(1, 'namePart')
    ..a<bool>(2, 'isExtension', $pb.PbFieldType.QB);

  UninterpretedOption_NamePart() : super();
  UninterpretedOption_NamePart.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UninterpretedOption_NamePart.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UninterpretedOption_NamePart clone() =>
      new UninterpretedOption_NamePart()..mergeFromMessage(this);
  UninterpretedOption_NamePart copyWith(
          void Function(UninterpretedOption_NamePart) updates) =>
      super.copyWith(
          (message) => updates(message as UninterpretedOption_NamePart));
  $pb.BuilderInfo get info_ => _i;
  static UninterpretedOption_NamePart create() =>
      new UninterpretedOption_NamePart();
  UninterpretedOption_NamePart createEmptyInstance() => create();
  static $pb.PbList<UninterpretedOption_NamePart> createRepeated() =>
      new $pb.PbList<UninterpretedOption_NamePart>();
  static UninterpretedOption_NamePart getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UninterpretedOption_NamePart _defaultInstance;
  static void $checkItem(UninterpretedOption_NamePart v) {
    if (v is! UninterpretedOption_NamePart)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get namePart => $_getS(0, '');
  set namePart(String v) {
    $_setString(0, v);
  }

  bool hasNamePart() => $_has(0);
  void clearNamePart() => clearField(1);

  bool get isExtension => $_get(1, false);
  set isExtension(bool v) {
    $_setBool(1, v);
  }

  bool hasIsExtension() => $_has(1);
  void clearIsExtension() => clearField(2);
}

class UninterpretedOption extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('UninterpretedOption',
      package: const $pb.PackageName('google.protobuf'))
    ..pp<UninterpretedOption_NamePart>(
        2,
        'name',
        $pb.PbFieldType.PM,
        UninterpretedOption_NamePart.$checkItem,
        UninterpretedOption_NamePart.create)
    ..aOS(3, 'identifierValue')
    ..a<Int64>(4, 'positiveIntValue', $pb.PbFieldType.OU6, Int64.ZERO)
    ..aInt64(5, 'negativeIntValue')
    ..a<double>(6, 'doubleValue', $pb.PbFieldType.OD)
    ..a<List<int>>(7, 'stringValue', $pb.PbFieldType.OY)
    ..aOS(8, 'aggregateValue');

  UninterpretedOption() : super();
  UninterpretedOption.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UninterpretedOption.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UninterpretedOption clone() =>
      new UninterpretedOption()..mergeFromMessage(this);
  UninterpretedOption copyWith(void Function(UninterpretedOption) updates) =>
      super.copyWith((message) => updates(message as UninterpretedOption));
  $pb.BuilderInfo get info_ => _i;
  static UninterpretedOption create() => new UninterpretedOption();
  UninterpretedOption createEmptyInstance() => create();
  static $pb.PbList<UninterpretedOption> createRepeated() =>
      new $pb.PbList<UninterpretedOption>();
  static UninterpretedOption getDefault() =>
      _defaultInstance ??= create()..freeze();
  static UninterpretedOption _defaultInstance;
  static void $checkItem(UninterpretedOption v) {
    if (v is! UninterpretedOption)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<UninterpretedOption_NamePart> get name => $_getList(0);

  String get identifierValue => $_getS(1, '');
  set identifierValue(String v) {
    $_setString(1, v);
  }

  bool hasIdentifierValue() => $_has(1);
  void clearIdentifierValue() => clearField(3);

  Int64 get positiveIntValue => $_getI64(2);
  set positiveIntValue(Int64 v) {
    $_setInt64(2, v);
  }

  bool hasPositiveIntValue() => $_has(2);
  void clearPositiveIntValue() => clearField(4);

  Int64 get negativeIntValue => $_getI64(3);
  set negativeIntValue(Int64 v) {
    $_setInt64(3, v);
  }

  bool hasNegativeIntValue() => $_has(3);
  void clearNegativeIntValue() => clearField(5);

  double get doubleValue => $_getN(4);
  set doubleValue(double v) {
    $_setDouble(4, v);
  }

  bool hasDoubleValue() => $_has(4);
  void clearDoubleValue() => clearField(6);

  List<int> get stringValue => $_getN(5);
  set stringValue(List<int> v) {
    $_setBytes(5, v);
  }

  bool hasStringValue() => $_has(5);
  void clearStringValue() => clearField(7);

  String get aggregateValue => $_getS(6, '');
  set aggregateValue(String v) {
    $_setString(6, v);
  }

  bool hasAggregateValue() => $_has(6);
  void clearAggregateValue() => clearField(8);
}

class SourceCodeInfo_Location extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'SourceCodeInfo.Location',
      package: const $pb.PackageName('google.protobuf'))
    ..p<int>(1, 'path', $pb.PbFieldType.K3)
    ..p<int>(2, 'span', $pb.PbFieldType.K3)
    ..aOS(3, 'leadingComments')
    ..aOS(4, 'trailingComments')
    ..pPS(6, 'leadingDetachedComments')
    ..hasRequiredFields = false;

  SourceCodeInfo_Location() : super();
  SourceCodeInfo_Location.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SourceCodeInfo_Location.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SourceCodeInfo_Location clone() =>
      new SourceCodeInfo_Location()..mergeFromMessage(this);
  SourceCodeInfo_Location copyWith(
          void Function(SourceCodeInfo_Location) updates) =>
      super.copyWith((message) => updates(message as SourceCodeInfo_Location));
  $pb.BuilderInfo get info_ => _i;
  static SourceCodeInfo_Location create() => new SourceCodeInfo_Location();
  SourceCodeInfo_Location createEmptyInstance() => create();
  static $pb.PbList<SourceCodeInfo_Location> createRepeated() =>
      new $pb.PbList<SourceCodeInfo_Location>();
  static SourceCodeInfo_Location getDefault() =>
      _defaultInstance ??= create()..freeze();
  static SourceCodeInfo_Location _defaultInstance;
  static void $checkItem(SourceCodeInfo_Location v) {
    if (v is! SourceCodeInfo_Location)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get path => $_getList(0);

  List<int> get span => $_getList(1);

  String get leadingComments => $_getS(2, '');
  set leadingComments(String v) {
    $_setString(2, v);
  }

  bool hasLeadingComments() => $_has(2);
  void clearLeadingComments() => clearField(3);

  String get trailingComments => $_getS(3, '');
  set trailingComments(String v) {
    $_setString(3, v);
  }

  bool hasTrailingComments() => $_has(3);
  void clearTrailingComments() => clearField(4);

  List<String> get leadingDetachedComments => $_getList(4);
}

class SourceCodeInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('SourceCodeInfo',
      package: const $pb.PackageName('google.protobuf'))
    ..pp<SourceCodeInfo_Location>(1, 'location', $pb.PbFieldType.PM,
        SourceCodeInfo_Location.$checkItem, SourceCodeInfo_Location.create)
    ..hasRequiredFields = false;

  SourceCodeInfo() : super();
  SourceCodeInfo.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SourceCodeInfo.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SourceCodeInfo clone() => new SourceCodeInfo()..mergeFromMessage(this);
  SourceCodeInfo copyWith(void Function(SourceCodeInfo) updates) =>
      super.copyWith((message) => updates(message as SourceCodeInfo));
  $pb.BuilderInfo get info_ => _i;
  static SourceCodeInfo create() => new SourceCodeInfo();
  SourceCodeInfo createEmptyInstance() => create();
  static $pb.PbList<SourceCodeInfo> createRepeated() =>
      new $pb.PbList<SourceCodeInfo>();
  static SourceCodeInfo getDefault() => _defaultInstance ??= create()..freeze();
  static SourceCodeInfo _defaultInstance;
  static void $checkItem(SourceCodeInfo v) {
    if (v is! SourceCodeInfo) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<SourceCodeInfo_Location> get location => $_getList(0);
}

class GeneratedCodeInfo_Annotation extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo(
      'GeneratedCodeInfo.Annotation',
      package: const $pb.PackageName('google.protobuf'))
    ..p<int>(1, 'path', $pb.PbFieldType.K3)
    ..aOS(2, 'sourceFile')
    ..a<int>(3, 'begin', $pb.PbFieldType.O3)
    ..a<int>(4, 'end', $pb.PbFieldType.O3)
    ..hasRequiredFields = false;

  GeneratedCodeInfo_Annotation() : super();
  GeneratedCodeInfo_Annotation.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GeneratedCodeInfo_Annotation.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GeneratedCodeInfo_Annotation clone() =>
      new GeneratedCodeInfo_Annotation()..mergeFromMessage(this);
  GeneratedCodeInfo_Annotation copyWith(
          void Function(GeneratedCodeInfo_Annotation) updates) =>
      super.copyWith(
          (message) => updates(message as GeneratedCodeInfo_Annotation));
  $pb.BuilderInfo get info_ => _i;
  static GeneratedCodeInfo_Annotation create() =>
      new GeneratedCodeInfo_Annotation();
  GeneratedCodeInfo_Annotation createEmptyInstance() => create();
  static $pb.PbList<GeneratedCodeInfo_Annotation> createRepeated() =>
      new $pb.PbList<GeneratedCodeInfo_Annotation>();
  static GeneratedCodeInfo_Annotation getDefault() =>
      _defaultInstance ??= create()..freeze();
  static GeneratedCodeInfo_Annotation _defaultInstance;
  static void $checkItem(GeneratedCodeInfo_Annotation v) {
    if (v is! GeneratedCodeInfo_Annotation)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<int> get path => $_getList(0);

  String get sourceFile => $_getS(1, '');
  set sourceFile(String v) {
    $_setString(1, v);
  }

  bool hasSourceFile() => $_has(1);
  void clearSourceFile() => clearField(2);

  int get begin => $_get(2, 0);
  set begin(int v) {
    $_setSignedInt32(2, v);
  }

  bool hasBegin() => $_has(2);
  void clearBegin() => clearField(3);

  int get end => $_get(3, 0);
  set end(int v) {
    $_setSignedInt32(3, v);
  }

  bool hasEnd() => $_has(3);
  void clearEnd() => clearField(4);
}

class GeneratedCodeInfo extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = new $pb.BuilderInfo('GeneratedCodeInfo',
      package: const $pb.PackageName('google.protobuf'))
    ..pp<GeneratedCodeInfo_Annotation>(
        1,
        'annotation',
        $pb.PbFieldType.PM,
        GeneratedCodeInfo_Annotation.$checkItem,
        GeneratedCodeInfo_Annotation.create)
    ..hasRequiredFields = false;

  GeneratedCodeInfo() : super();
  GeneratedCodeInfo.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GeneratedCodeInfo.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GeneratedCodeInfo clone() => new GeneratedCodeInfo()..mergeFromMessage(this);
  GeneratedCodeInfo copyWith(void Function(GeneratedCodeInfo) updates) =>
      super.copyWith((message) => updates(message as GeneratedCodeInfo));
  $pb.BuilderInfo get info_ => _i;
  static GeneratedCodeInfo create() => new GeneratedCodeInfo();
  GeneratedCodeInfo createEmptyInstance() => create();
  static $pb.PbList<GeneratedCodeInfo> createRepeated() =>
      new $pb.PbList<GeneratedCodeInfo>();
  static GeneratedCodeInfo getDefault() =>
      _defaultInstance ??= create()..freeze();
  static GeneratedCodeInfo _defaultInstance;
  static void $checkItem(GeneratedCodeInfo v) {
    if (v is! GeneratedCodeInfo)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  List<GeneratedCodeInfo_Annotation> get annotation => $_getList(0);
}
