///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library google.protobuf_descriptor;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import 'descriptor.pbenum.dart';

export 'descriptor.pbenum.dart';

class FileDescriptorSet extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileDescriptorSet')
    ..pp<FileDescriptorProto>(1, 'file', PbFieldType.PM,
        FileDescriptorProto.$checkItem, FileDescriptorProto.create);

  FileDescriptorSet() : super();
  FileDescriptorSet.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileDescriptorSet.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileDescriptorSet clone() => new FileDescriptorSet()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileDescriptorSet create() => new FileDescriptorSet();
  static PbList<FileDescriptorSet> createRepeated() =>
      new PbList<FileDescriptorSet>();
  static FileDescriptorSet getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyFileDescriptorSet();
    return _defaultInstance;
  }

  static FileDescriptorSet _defaultInstance;
  static void $checkItem(FileDescriptorSet v) {
    if (v is! FileDescriptorSet) checkItemFailed(v, 'FileDescriptorSet');
  }

  List<FileDescriptorProto> get file => $_getList(0);
}

class _ReadonlyFileDescriptorSet extends FileDescriptorSet
    with ReadonlyMessageMixin {}

class FileDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileDescriptorProto')
    ..aOS(1, 'name')
    ..aOS(2, 'package')
    ..pPS(3, 'dependency')
    ..pp<DescriptorProto>(4, 'messageType', PbFieldType.PM,
        DescriptorProto.$checkItem, DescriptorProto.create)
    ..pp<EnumDescriptorProto>(5, 'enumType', PbFieldType.PM,
        EnumDescriptorProto.$checkItem, EnumDescriptorProto.create)
    ..pp<ServiceDescriptorProto>(6, 'service', PbFieldType.PM,
        ServiceDescriptorProto.$checkItem, ServiceDescriptorProto.create)
    ..pp<FieldDescriptorProto>(7, 'extension', PbFieldType.PM,
        FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..a<FileOptions>(8, 'options', PbFieldType.OM, FileOptions.getDefault,
        FileOptions.create)
    ..a<SourceCodeInfo>(9, 'sourceCodeInfo', PbFieldType.OM,
        SourceCodeInfo.getDefault, SourceCodeInfo.create)
    ..p<int>(10, 'publicDependency', PbFieldType.P3)
    ..p<int>(11, 'weakDependency', PbFieldType.P3)
    ..aOS(12, 'syntax');

  FileDescriptorProto() : super();
  FileDescriptorProto.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileDescriptorProto.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileDescriptorProto clone() =>
      new FileDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileDescriptorProto create() => new FileDescriptorProto();
  static PbList<FileDescriptorProto> createRepeated() =>
      new PbList<FileDescriptorProto>();
  static FileDescriptorProto getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyFileDescriptorProto();
    return _defaultInstance;
  }

  static FileDescriptorProto _defaultInstance;
  static void $checkItem(FileDescriptorProto v) {
    if (v is! FileDescriptorProto) checkItemFailed(v, 'FileDescriptorProto');
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

class _ReadonlyFileDescriptorProto extends FileDescriptorProto
    with ReadonlyMessageMixin {}

class DescriptorProto_ExtensionRange extends GeneratedMessage {
  static final BuilderInfo _i =
      new BuilderInfo('DescriptorProto_ExtensionRange')
        ..a<int>(1, 'start', PbFieldType.O3)
        ..a<int>(2, 'end', PbFieldType.O3)
        ..hasRequiredFields = false;

  DescriptorProto_ExtensionRange() : super();
  DescriptorProto_ExtensionRange.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto_ExtensionRange.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto_ExtensionRange clone() =>
      new DescriptorProto_ExtensionRange()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DescriptorProto_ExtensionRange create() =>
      new DescriptorProto_ExtensionRange();
  static PbList<DescriptorProto_ExtensionRange> createRepeated() =>
      new PbList<DescriptorProto_ExtensionRange>();
  static DescriptorProto_ExtensionRange getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDescriptorProto_ExtensionRange();
    return _defaultInstance;
  }

  static DescriptorProto_ExtensionRange _defaultInstance;
  static void $checkItem(DescriptorProto_ExtensionRange v) {
    if (v is! DescriptorProto_ExtensionRange)
      checkItemFailed(v, 'DescriptorProto_ExtensionRange');
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

class _ReadonlyDescriptorProto_ExtensionRange
    extends DescriptorProto_ExtensionRange with ReadonlyMessageMixin {}

class DescriptorProto_ReservedRange extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DescriptorProto_ReservedRange')
    ..a<int>(1, 'start', PbFieldType.O3)
    ..a<int>(2, 'end', PbFieldType.O3)
    ..hasRequiredFields = false;

  DescriptorProto_ReservedRange() : super();
  DescriptorProto_ReservedRange.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto_ReservedRange.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto_ReservedRange clone() =>
      new DescriptorProto_ReservedRange()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DescriptorProto_ReservedRange create() =>
      new DescriptorProto_ReservedRange();
  static PbList<DescriptorProto_ReservedRange> createRepeated() =>
      new PbList<DescriptorProto_ReservedRange>();
  static DescriptorProto_ReservedRange getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDescriptorProto_ReservedRange();
    return _defaultInstance;
  }

  static DescriptorProto_ReservedRange _defaultInstance;
  static void $checkItem(DescriptorProto_ReservedRange v) {
    if (v is! DescriptorProto_ReservedRange)
      checkItemFailed(v, 'DescriptorProto_ReservedRange');
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

class _ReadonlyDescriptorProto_ReservedRange
    extends DescriptorProto_ReservedRange with ReadonlyMessageMixin {}

class DescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DescriptorProto')
    ..aOS(1, 'name')
    ..pp<FieldDescriptorProto>(2, 'field', PbFieldType.PM,
        FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..pp<DescriptorProto>(3, 'nestedType', PbFieldType.PM,
        DescriptorProto.$checkItem, DescriptorProto.create)
    ..pp<EnumDescriptorProto>(4, 'enumType', PbFieldType.PM,
        EnumDescriptorProto.$checkItem, EnumDescriptorProto.create)
    ..pp<DescriptorProto_ExtensionRange>(
        5,
        'extensionRange',
        PbFieldType.PM,
        DescriptorProto_ExtensionRange.$checkItem,
        DescriptorProto_ExtensionRange.create)
    ..pp<FieldDescriptorProto>(6, 'extension', PbFieldType.PM,
        FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..a<MessageOptions>(7, 'options', PbFieldType.OM, MessageOptions.getDefault,
        MessageOptions.create)
    ..pp<OneofDescriptorProto>(8, 'oneofDecl', PbFieldType.PM,
        OneofDescriptorProto.$checkItem, OneofDescriptorProto.create)
    ..pp<DescriptorProto_ReservedRange>(
        9,
        'reservedRange',
        PbFieldType.PM,
        DescriptorProto_ReservedRange.$checkItem,
        DescriptorProto_ReservedRange.create)
    ..pPS(10, 'reservedName');

  DescriptorProto() : super();
  DescriptorProto.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  DescriptorProto.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  DescriptorProto clone() => new DescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DescriptorProto create() => new DescriptorProto();
  static PbList<DescriptorProto> createRepeated() =>
      new PbList<DescriptorProto>();
  static DescriptorProto getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyDescriptorProto();
    return _defaultInstance;
  }

  static DescriptorProto _defaultInstance;
  static void $checkItem(DescriptorProto v) {
    if (v is! DescriptorProto) checkItemFailed(v, 'DescriptorProto');
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

class _ReadonlyDescriptorProto extends DescriptorProto
    with ReadonlyMessageMixin {}

class FieldDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FieldDescriptorProto')
    ..aOS(1, 'name')
    ..aOS(2, 'extendee')
    ..a<int>(3, 'number', PbFieldType.O3)
    ..e<FieldDescriptorProto_Label>(
        4,
        'label',
        PbFieldType.OE,
        FieldDescriptorProto_Label.LABEL_OPTIONAL,
        FieldDescriptorProto_Label.valueOf,
        FieldDescriptorProto_Label.values)
    ..e<FieldDescriptorProto_Type>(
        5,
        'type',
        PbFieldType.OE,
        FieldDescriptorProto_Type.TYPE_DOUBLE,
        FieldDescriptorProto_Type.valueOf,
        FieldDescriptorProto_Type.values)
    ..aOS(6, 'typeName')
    ..aOS(7, 'defaultValue')
    ..a<FieldOptions>(8, 'options', PbFieldType.OM, FieldOptions.getDefault,
        FieldOptions.create)
    ..a<int>(9, 'oneofIndex', PbFieldType.O3)
    ..aOS(10, 'jsonName');

  FieldDescriptorProto() : super();
  FieldDescriptorProto.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FieldDescriptorProto.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FieldDescriptorProto clone() =>
      new FieldDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FieldDescriptorProto create() => new FieldDescriptorProto();
  static PbList<FieldDescriptorProto> createRepeated() =>
      new PbList<FieldDescriptorProto>();
  static FieldDescriptorProto getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyFieldDescriptorProto();
    return _defaultInstance;
  }

  static FieldDescriptorProto _defaultInstance;
  static void $checkItem(FieldDescriptorProto v) {
    if (v is! FieldDescriptorProto) checkItemFailed(v, 'FieldDescriptorProto');
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

class _ReadonlyFieldDescriptorProto extends FieldDescriptorProto
    with ReadonlyMessageMixin {}

class OneofDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('OneofDescriptorProto')
    ..aOS(1, 'name')
    ..a<OneofOptions>(2, 'options', PbFieldType.OM, OneofOptions.getDefault,
        OneofOptions.create);

  OneofDescriptorProto() : super();
  OneofDescriptorProto.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  OneofDescriptorProto.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  OneofDescriptorProto clone() =>
      new OneofDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static OneofDescriptorProto create() => new OneofDescriptorProto();
  static PbList<OneofDescriptorProto> createRepeated() =>
      new PbList<OneofDescriptorProto>();
  static OneofDescriptorProto getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyOneofDescriptorProto();
    return _defaultInstance;
  }

  static OneofDescriptorProto _defaultInstance;
  static void $checkItem(OneofDescriptorProto v) {
    if (v is! OneofDescriptorProto) checkItemFailed(v, 'OneofDescriptorProto');
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

class _ReadonlyOneofDescriptorProto extends OneofDescriptorProto
    with ReadonlyMessageMixin {}

class EnumDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumDescriptorProto')
    ..aOS(1, 'name')
    ..pp<EnumValueDescriptorProto>(2, 'value', PbFieldType.PM,
        EnumValueDescriptorProto.$checkItem, EnumValueDescriptorProto.create)
    ..a<EnumOptions>(3, 'options', PbFieldType.OM, EnumOptions.getDefault,
        EnumOptions.create);

  EnumDescriptorProto() : super();
  EnumDescriptorProto.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumDescriptorProto.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumDescriptorProto clone() =>
      new EnumDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumDescriptorProto create() => new EnumDescriptorProto();
  static PbList<EnumDescriptorProto> createRepeated() =>
      new PbList<EnumDescriptorProto>();
  static EnumDescriptorProto getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyEnumDescriptorProto();
    return _defaultInstance;
  }

  static EnumDescriptorProto _defaultInstance;
  static void $checkItem(EnumDescriptorProto v) {
    if (v is! EnumDescriptorProto) checkItemFailed(v, 'EnumDescriptorProto');
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

class _ReadonlyEnumDescriptorProto extends EnumDescriptorProto
    with ReadonlyMessageMixin {}

class EnumValueDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumValueDescriptorProto')
    ..aOS(1, 'name')
    ..a<int>(2, 'number', PbFieldType.O3)
    ..a<EnumValueOptions>(3, 'options', PbFieldType.OM,
        EnumValueOptions.getDefault, EnumValueOptions.create);

  EnumValueDescriptorProto() : super();
  EnumValueDescriptorProto.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumValueDescriptorProto.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumValueDescriptorProto clone() =>
      new EnumValueDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumValueDescriptorProto create() => new EnumValueDescriptorProto();
  static PbList<EnumValueDescriptorProto> createRepeated() =>
      new PbList<EnumValueDescriptorProto>();
  static EnumValueDescriptorProto getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyEnumValueDescriptorProto();
    return _defaultInstance;
  }

  static EnumValueDescriptorProto _defaultInstance;
  static void $checkItem(EnumValueDescriptorProto v) {
    if (v is! EnumValueDescriptorProto)
      checkItemFailed(v, 'EnumValueDescriptorProto');
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

class _ReadonlyEnumValueDescriptorProto extends EnumValueDescriptorProto
    with ReadonlyMessageMixin {}

class ServiceDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceDescriptorProto')
    ..aOS(1, 'name')
    ..pp<MethodDescriptorProto>(2, 'method', PbFieldType.PM,
        MethodDescriptorProto.$checkItem, MethodDescriptorProto.create)
    ..a<ServiceOptions>(3, 'options', PbFieldType.OM, ServiceOptions.getDefault,
        ServiceOptions.create);

  ServiceDescriptorProto() : super();
  ServiceDescriptorProto.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ServiceDescriptorProto.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ServiceDescriptorProto clone() =>
      new ServiceDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ServiceDescriptorProto create() => new ServiceDescriptorProto();
  static PbList<ServiceDescriptorProto> createRepeated() =>
      new PbList<ServiceDescriptorProto>();
  static ServiceDescriptorProto getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyServiceDescriptorProto();
    return _defaultInstance;
  }

  static ServiceDescriptorProto _defaultInstance;
  static void $checkItem(ServiceDescriptorProto v) {
    if (v is! ServiceDescriptorProto)
      checkItemFailed(v, 'ServiceDescriptorProto');
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

class _ReadonlyServiceDescriptorProto extends ServiceDescriptorProto
    with ReadonlyMessageMixin {}

class MethodDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MethodDescriptorProto')
    ..aOS(1, 'name')
    ..aOS(2, 'inputType')
    ..aOS(3, 'outputType')
    ..a<MethodOptions>(4, 'options', PbFieldType.OM, MethodOptions.getDefault,
        MethodOptions.create)
    ..aOB(5, 'clientStreaming')
    ..aOB(6, 'serverStreaming');

  MethodDescriptorProto() : super();
  MethodDescriptorProto.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MethodDescriptorProto.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MethodDescriptorProto clone() =>
      new MethodDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MethodDescriptorProto create() => new MethodDescriptorProto();
  static PbList<MethodDescriptorProto> createRepeated() =>
      new PbList<MethodDescriptorProto>();
  static MethodDescriptorProto getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyMethodDescriptorProto();
    return _defaultInstance;
  }

  static MethodDescriptorProto _defaultInstance;
  static void $checkItem(MethodDescriptorProto v) {
    if (v is! MethodDescriptorProto)
      checkItemFailed(v, 'MethodDescriptorProto');
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

class _ReadonlyMethodDescriptorProto extends MethodDescriptorProto
    with ReadonlyMessageMixin {}

class FileOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileOptions')
    ..aOS(1, 'javaPackage')
    ..aOS(8, 'javaOuterClassname')
    ..e<FileOptions_OptimizeMode>(
        9,
        'optimizeFor',
        PbFieldType.OE,
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
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  FileOptions() : super();
  FileOptions.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FileOptions.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FileOptions clone() => new FileOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileOptions create() => new FileOptions();
  static PbList<FileOptions> createRepeated() => new PbList<FileOptions>();
  static FileOptions getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFileOptions();
    return _defaultInstance;
  }

  static FileOptions _defaultInstance;
  static void $checkItem(FileOptions v) {
    if (v is! FileOptions) checkItemFailed(v, 'FileOptions');
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

class _ReadonlyFileOptions extends FileOptions with ReadonlyMessageMixin {}

class MessageOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MessageOptions')
    ..aOB(1, 'messageSetWireFormat')
    ..aOB(2, 'noStandardDescriptorAccessor')
    ..aOB(3, 'deprecated')
    ..aOB(7, 'mapEntry')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  MessageOptions() : super();
  MessageOptions.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MessageOptions.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MessageOptions clone() => new MessageOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MessageOptions create() => new MessageOptions();
  static PbList<MessageOptions> createRepeated() =>
      new PbList<MessageOptions>();
  static MessageOptions getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyMessageOptions();
    return _defaultInstance;
  }

  static MessageOptions _defaultInstance;
  static void $checkItem(MessageOptions v) {
    if (v is! MessageOptions) checkItemFailed(v, 'MessageOptions');
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

class _ReadonlyMessageOptions extends MessageOptions with ReadonlyMessageMixin {
}

class FieldOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FieldOptions')
    ..e<FieldOptions_CType>(
        1,
        'ctype',
        PbFieldType.OE,
        FieldOptions_CType.STRING,
        FieldOptions_CType.valueOf,
        FieldOptions_CType.values)
    ..aOB(2, 'packed')
    ..aOB(3, 'deprecated')
    ..aOB(5, 'lazy')
    ..e<FieldOptions_JSType>(
        6,
        'jstype',
        PbFieldType.OE,
        FieldOptions_JSType.JS_NORMAL,
        FieldOptions_JSType.valueOf,
        FieldOptions_JSType.values)
    ..aOB(10, 'weak')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  FieldOptions() : super();
  FieldOptions.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  FieldOptions.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  FieldOptions clone() => new FieldOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FieldOptions create() => new FieldOptions();
  static PbList<FieldOptions> createRepeated() => new PbList<FieldOptions>();
  static FieldOptions getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyFieldOptions();
    return _defaultInstance;
  }

  static FieldOptions _defaultInstance;
  static void $checkItem(FieldOptions v) {
    if (v is! FieldOptions) checkItemFailed(v, 'FieldOptions');
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

class _ReadonlyFieldOptions extends FieldOptions with ReadonlyMessageMixin {}

class OneofOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('OneofOptions')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  OneofOptions() : super();
  OneofOptions.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  OneofOptions.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  OneofOptions clone() => new OneofOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static OneofOptions create() => new OneofOptions();
  static PbList<OneofOptions> createRepeated() => new PbList<OneofOptions>();
  static OneofOptions getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyOneofOptions();
    return _defaultInstance;
  }

  static OneofOptions _defaultInstance;
  static void $checkItem(OneofOptions v) {
    if (v is! OneofOptions) checkItemFailed(v, 'OneofOptions');
  }

  List<UninterpretedOption> get uninterpretedOption => $_getList(0);
}

class _ReadonlyOneofOptions extends OneofOptions with ReadonlyMessageMixin {}

class EnumOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumOptions')
    ..aOB(2, 'allowAlias')
    ..aOB(3, 'deprecated')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  EnumOptions() : super();
  EnumOptions.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumOptions.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumOptions clone() => new EnumOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumOptions create() => new EnumOptions();
  static PbList<EnumOptions> createRepeated() => new PbList<EnumOptions>();
  static EnumOptions getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyEnumOptions();
    return _defaultInstance;
  }

  static EnumOptions _defaultInstance;
  static void $checkItem(EnumOptions v) {
    if (v is! EnumOptions) checkItemFailed(v, 'EnumOptions');
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

class _ReadonlyEnumOptions extends EnumOptions with ReadonlyMessageMixin {}

class EnumValueOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumValueOptions')
    ..aOB(1, 'deprecated')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  EnumValueOptions() : super();
  EnumValueOptions.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  EnumValueOptions.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  EnumValueOptions clone() => new EnumValueOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumValueOptions create() => new EnumValueOptions();
  static PbList<EnumValueOptions> createRepeated() =>
      new PbList<EnumValueOptions>();
  static EnumValueOptions getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyEnumValueOptions();
    return _defaultInstance;
  }

  static EnumValueOptions _defaultInstance;
  static void $checkItem(EnumValueOptions v) {
    if (v is! EnumValueOptions) checkItemFailed(v, 'EnumValueOptions');
  }

  bool get deprecated => $_get(0, false);
  set deprecated(bool v) {
    $_setBool(0, v);
  }

  bool hasDeprecated() => $_has(0);
  void clearDeprecated() => clearField(1);

  List<UninterpretedOption> get uninterpretedOption => $_getList(1);
}

class _ReadonlyEnumValueOptions extends EnumValueOptions
    with ReadonlyMessageMixin {}

class ServiceOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceOptions')
    ..aOB(33, 'deprecated')
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  ServiceOptions() : super();
  ServiceOptions.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  ServiceOptions.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  ServiceOptions clone() => new ServiceOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ServiceOptions create() => new ServiceOptions();
  static PbList<ServiceOptions> createRepeated() =>
      new PbList<ServiceOptions>();
  static ServiceOptions getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyServiceOptions();
    return _defaultInstance;
  }

  static ServiceOptions _defaultInstance;
  static void $checkItem(ServiceOptions v) {
    if (v is! ServiceOptions) checkItemFailed(v, 'ServiceOptions');
  }

  bool get deprecated => $_get(0, false);
  set deprecated(bool v) {
    $_setBool(0, v);
  }

  bool hasDeprecated() => $_has(0);
  void clearDeprecated() => clearField(33);

  List<UninterpretedOption> get uninterpretedOption => $_getList(1);
}

class _ReadonlyServiceOptions extends ServiceOptions with ReadonlyMessageMixin {
}

class MethodOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MethodOptions')
    ..aOB(33, 'deprecated')
    ..e<MethodOptions_IdempotencyLevel>(
        34,
        'idempotencyLevel',
        PbFieldType.OE,
        MethodOptions_IdempotencyLevel.IDEMPOTENCY_UNKNOWN,
        MethodOptions_IdempotencyLevel.valueOf,
        MethodOptions_IdempotencyLevel.values)
    ..pp<UninterpretedOption>(999, 'uninterpretedOption', PbFieldType.PM,
        UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true;

  MethodOptions() : super();
  MethodOptions.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  MethodOptions.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  MethodOptions clone() => new MethodOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MethodOptions create() => new MethodOptions();
  static PbList<MethodOptions> createRepeated() => new PbList<MethodOptions>();
  static MethodOptions getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyMethodOptions();
    return _defaultInstance;
  }

  static MethodOptions _defaultInstance;
  static void $checkItem(MethodOptions v) {
    if (v is! MethodOptions) checkItemFailed(v, 'MethodOptions');
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

class _ReadonlyMethodOptions extends MethodOptions with ReadonlyMessageMixin {}

class UninterpretedOption_NamePart extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UninterpretedOption_NamePart')
    ..aQS(1, 'namePart')
    ..a<bool>(2, 'isExtension', PbFieldType.QB);

  UninterpretedOption_NamePart() : super();
  UninterpretedOption_NamePart.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UninterpretedOption_NamePart.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UninterpretedOption_NamePart clone() =>
      new UninterpretedOption_NamePart()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UninterpretedOption_NamePart create() =>
      new UninterpretedOption_NamePart();
  static PbList<UninterpretedOption_NamePart> createRepeated() =>
      new PbList<UninterpretedOption_NamePart>();
  static UninterpretedOption_NamePart getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyUninterpretedOption_NamePart();
    return _defaultInstance;
  }

  static UninterpretedOption_NamePart _defaultInstance;
  static void $checkItem(UninterpretedOption_NamePart v) {
    if (v is! UninterpretedOption_NamePart)
      checkItemFailed(v, 'UninterpretedOption_NamePart');
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

class _ReadonlyUninterpretedOption_NamePart extends UninterpretedOption_NamePart
    with ReadonlyMessageMixin {}

class UninterpretedOption extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UninterpretedOption')
    ..pp<UninterpretedOption_NamePart>(
        2,
        'name',
        PbFieldType.PM,
        UninterpretedOption_NamePart.$checkItem,
        UninterpretedOption_NamePart.create)
    ..aOS(3, 'identifierValue')
    ..a<Int64>(4, 'positiveIntValue', PbFieldType.OU6, Int64.ZERO)
    ..aInt64(5, 'negativeIntValue')
    ..a<double>(6, 'doubleValue', PbFieldType.OD)
    ..a<List<int>>(7, 'stringValue', PbFieldType.OY)
    ..aOS(8, 'aggregateValue');

  UninterpretedOption() : super();
  UninterpretedOption.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  UninterpretedOption.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  UninterpretedOption clone() =>
      new UninterpretedOption()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UninterpretedOption create() => new UninterpretedOption();
  static PbList<UninterpretedOption> createRepeated() =>
      new PbList<UninterpretedOption>();
  static UninterpretedOption getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyUninterpretedOption();
    return _defaultInstance;
  }

  static UninterpretedOption _defaultInstance;
  static void $checkItem(UninterpretedOption v) {
    if (v is! UninterpretedOption) checkItemFailed(v, 'UninterpretedOption');
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

class _ReadonlyUninterpretedOption extends UninterpretedOption
    with ReadonlyMessageMixin {}

class SourceCodeInfo_Location extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SourceCodeInfo_Location')
    ..p<int>(1, 'path', PbFieldType.K3)
    ..p<int>(2, 'span', PbFieldType.K3)
    ..aOS(3, 'leadingComments')
    ..aOS(4, 'trailingComments')
    ..pPS(6, 'leadingDetachedComments')
    ..hasRequiredFields = false;

  SourceCodeInfo_Location() : super();
  SourceCodeInfo_Location.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SourceCodeInfo_Location.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SourceCodeInfo_Location clone() =>
      new SourceCodeInfo_Location()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SourceCodeInfo_Location create() => new SourceCodeInfo_Location();
  static PbList<SourceCodeInfo_Location> createRepeated() =>
      new PbList<SourceCodeInfo_Location>();
  static SourceCodeInfo_Location getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlySourceCodeInfo_Location();
    return _defaultInstance;
  }

  static SourceCodeInfo_Location _defaultInstance;
  static void $checkItem(SourceCodeInfo_Location v) {
    if (v is! SourceCodeInfo_Location)
      checkItemFailed(v, 'SourceCodeInfo_Location');
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

class _ReadonlySourceCodeInfo_Location extends SourceCodeInfo_Location
    with ReadonlyMessageMixin {}

class SourceCodeInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SourceCodeInfo')
    ..pp<SourceCodeInfo_Location>(1, 'location', PbFieldType.PM,
        SourceCodeInfo_Location.$checkItem, SourceCodeInfo_Location.create)
    ..hasRequiredFields = false;

  SourceCodeInfo() : super();
  SourceCodeInfo.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  SourceCodeInfo.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  SourceCodeInfo clone() => new SourceCodeInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SourceCodeInfo create() => new SourceCodeInfo();
  static PbList<SourceCodeInfo> createRepeated() =>
      new PbList<SourceCodeInfo>();
  static SourceCodeInfo getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlySourceCodeInfo();
    return _defaultInstance;
  }

  static SourceCodeInfo _defaultInstance;
  static void $checkItem(SourceCodeInfo v) {
    if (v is! SourceCodeInfo) checkItemFailed(v, 'SourceCodeInfo');
  }

  List<SourceCodeInfo_Location> get location => $_getList(0);
}

class _ReadonlySourceCodeInfo extends SourceCodeInfo with ReadonlyMessageMixin {
}

class GeneratedCodeInfo_Annotation extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('GeneratedCodeInfo_Annotation')
    ..p<int>(1, 'path', PbFieldType.K3)
    ..aOS(2, 'sourceFile')
    ..a<int>(3, 'begin', PbFieldType.O3)
    ..a<int>(4, 'end', PbFieldType.O3)
    ..hasRequiredFields = false;

  GeneratedCodeInfo_Annotation() : super();
  GeneratedCodeInfo_Annotation.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GeneratedCodeInfo_Annotation.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GeneratedCodeInfo_Annotation clone() =>
      new GeneratedCodeInfo_Annotation()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static GeneratedCodeInfo_Annotation create() =>
      new GeneratedCodeInfo_Annotation();
  static PbList<GeneratedCodeInfo_Annotation> createRepeated() =>
      new PbList<GeneratedCodeInfo_Annotation>();
  static GeneratedCodeInfo_Annotation getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyGeneratedCodeInfo_Annotation();
    return _defaultInstance;
  }

  static GeneratedCodeInfo_Annotation _defaultInstance;
  static void $checkItem(GeneratedCodeInfo_Annotation v) {
    if (v is! GeneratedCodeInfo_Annotation)
      checkItemFailed(v, 'GeneratedCodeInfo_Annotation');
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

class _ReadonlyGeneratedCodeInfo_Annotation extends GeneratedCodeInfo_Annotation
    with ReadonlyMessageMixin {}

class GeneratedCodeInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('GeneratedCodeInfo')
    ..pp<GeneratedCodeInfo_Annotation>(
        1,
        'annotation',
        PbFieldType.PM,
        GeneratedCodeInfo_Annotation.$checkItem,
        GeneratedCodeInfo_Annotation.create)
    ..hasRequiredFields = false;

  GeneratedCodeInfo() : super();
  GeneratedCodeInfo.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  GeneratedCodeInfo.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  GeneratedCodeInfo clone() => new GeneratedCodeInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static GeneratedCodeInfo create() => new GeneratedCodeInfo();
  static PbList<GeneratedCodeInfo> createRepeated() =>
      new PbList<GeneratedCodeInfo>();
  static GeneratedCodeInfo getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyGeneratedCodeInfo();
    return _defaultInstance;
  }

  static GeneratedCodeInfo _defaultInstance;
  static void $checkItem(GeneratedCodeInfo v) {
    if (v is! GeneratedCodeInfo) checkItemFailed(v, 'GeneratedCodeInfo');
  }

  List<GeneratedCodeInfo_Annotation> get annotation => $_getList(0);
}

class _ReadonlyGeneratedCodeInfo extends GeneratedCodeInfo
    with ReadonlyMessageMixin {}
