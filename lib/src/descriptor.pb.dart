///
//  Generated code. Do not modify.
///
library proto2_descriptor;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import 'descriptor.pbenum.dart';

export 'descriptor.pbenum.dart';

class FileDescriptorSet extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileDescriptorSet')
    ..pp/*<FileDescriptorProto>*/(1, 'file', PbFieldType.PM, FileDescriptorProto.$checkItem, FileDescriptorProto.create)
  ;

  FileDescriptorSet() : super();
  FileDescriptorSet.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FileDescriptorSet.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FileDescriptorSet clone() => new FileDescriptorSet()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileDescriptorSet create() => new FileDescriptorSet();
  static PbList<FileDescriptorSet> createRepeated() => new PbList<FileDescriptorSet>();
  static FileDescriptorSet getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFileDescriptorSet();
    return _defaultInstance;
  }
  static FileDescriptorSet _defaultInstance;
  static void $checkItem(FileDescriptorSet v) {
    if (v is !FileDescriptorSet) checkItemFailed(v, 'FileDescriptorSet');
  }

  List<FileDescriptorProto> get file => $_get(0, 1, null);
}

class _ReadonlyFileDescriptorSet extends FileDescriptorSet with ReadonlyMessageMixin {}

class FileDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileDescriptorProto')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..a/*<String>*/(2, 'package', PbFieldType.OS)
    ..p/*<String>*/(3, 'dependency', PbFieldType.PS)
    ..pp/*<DescriptorProto>*/(4, 'messageType', PbFieldType.PM, DescriptorProto.$checkItem, DescriptorProto.create)
    ..pp/*<EnumDescriptorProto>*/(5, 'enumType', PbFieldType.PM, EnumDescriptorProto.$checkItem, EnumDescriptorProto.create)
    ..pp/*<ServiceDescriptorProto>*/(6, 'service', PbFieldType.PM, ServiceDescriptorProto.$checkItem, ServiceDescriptorProto.create)
    ..pp/*<FieldDescriptorProto>*/(7, 'extension', PbFieldType.PM, FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..a/*<FileOptions>*/(8, 'options', PbFieldType.OM, FileOptions.getDefault, FileOptions.create)
    ..a/*<SourceCodeInfo>*/(9, 'sourceCodeInfo', PbFieldType.OM, SourceCodeInfo.getDefault, SourceCodeInfo.create)
    ..p/*<int>*/(10, 'publicDependency', PbFieldType.P3)
    ..p/*<int>*/(11, 'weakDependency', PbFieldType.P3)
  ;

  FileDescriptorProto() : super();
  FileDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FileDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FileDescriptorProto clone() => new FileDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileDescriptorProto create() => new FileDescriptorProto();
  static PbList<FileDescriptorProto> createRepeated() => new PbList<FileDescriptorProto>();
  static FileDescriptorProto getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFileDescriptorProto();
    return _defaultInstance;
  }
  static FileDescriptorProto _defaultInstance;
  static void $checkItem(FileDescriptorProto v) {
    if (v is !FileDescriptorProto) checkItemFailed(v, 'FileDescriptorProto');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  String get package => $_get(1, 2, '');
  void set package(String v) { $_setString(1, 2, v); }
  bool hasPackage() => $_has(1, 2);
  void clearPackage() => clearField(2);

  List<String> get dependency => $_get(2, 3, null);

  List<DescriptorProto> get messageType => $_get(3, 4, null);

  List<EnumDescriptorProto> get enumType => $_get(4, 5, null);

  List<ServiceDescriptorProto> get service => $_get(5, 6, null);

  List<FieldDescriptorProto> get extension => $_get(6, 7, null);

  FileOptions get options => $_get(7, 8, null);
  void set options(FileOptions v) { setField(8, v); }
  bool hasOptions() => $_has(7, 8);
  void clearOptions() => clearField(8);

  SourceCodeInfo get sourceCodeInfo => $_get(8, 9, null);
  void set sourceCodeInfo(SourceCodeInfo v) { setField(9, v); }
  bool hasSourceCodeInfo() => $_has(8, 9);
  void clearSourceCodeInfo() => clearField(9);

  List<int> get publicDependency => $_get(9, 10, null);

  List<int> get weakDependency => $_get(10, 11, null);
}

class _ReadonlyFileDescriptorProto extends FileDescriptorProto with ReadonlyMessageMixin {}

class DescriptorProto_ExtensionRange extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DescriptorProto_ExtensionRange')
    ..a/*<int>*/(1, 'start', PbFieldType.O3)
    ..a/*<int>*/(2, 'end', PbFieldType.O3)
    ..hasRequiredFields = false
  ;

  DescriptorProto_ExtensionRange() : super();
  DescriptorProto_ExtensionRange.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DescriptorProto_ExtensionRange.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DescriptorProto_ExtensionRange clone() => new DescriptorProto_ExtensionRange()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DescriptorProto_ExtensionRange create() => new DescriptorProto_ExtensionRange();
  static PbList<DescriptorProto_ExtensionRange> createRepeated() => new PbList<DescriptorProto_ExtensionRange>();
  static DescriptorProto_ExtensionRange getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDescriptorProto_ExtensionRange();
    return _defaultInstance;
  }
  static DescriptorProto_ExtensionRange _defaultInstance;
  static void $checkItem(DescriptorProto_ExtensionRange v) {
    if (v is !DescriptorProto_ExtensionRange) checkItemFailed(v, 'DescriptorProto_ExtensionRange');
  }

  int get start => $_get(0, 1, 0);
  void set start(int v) { $_setUnsignedInt32(0, 1, v); }
  bool hasStart() => $_has(0, 1);
  void clearStart() => clearField(1);

  int get end => $_get(1, 2, 0);
  void set end(int v) { $_setUnsignedInt32(1, 2, v); }
  bool hasEnd() => $_has(1, 2);
  void clearEnd() => clearField(2);
}

class _ReadonlyDescriptorProto_ExtensionRange extends DescriptorProto_ExtensionRange with ReadonlyMessageMixin {}

class DescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DescriptorProto')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..pp/*<FieldDescriptorProto>*/(2, 'field', PbFieldType.PM, FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..pp/*<DescriptorProto>*/(3, 'nestedType', PbFieldType.PM, DescriptorProto.$checkItem, DescriptorProto.create)
    ..pp/*<EnumDescriptorProto>*/(4, 'enumType', PbFieldType.PM, EnumDescriptorProto.$checkItem, EnumDescriptorProto.create)
    ..pp/*<DescriptorProto_ExtensionRange>*/(5, 'extensionRange', PbFieldType.PM, DescriptorProto_ExtensionRange.$checkItem, DescriptorProto_ExtensionRange.create)
    ..pp/*<FieldDescriptorProto>*/(6, 'extension', PbFieldType.PM, FieldDescriptorProto.$checkItem, FieldDescriptorProto.create)
    ..a/*<MessageOptions>*/(7, 'options', PbFieldType.OM, MessageOptions.getDefault, MessageOptions.create)
  ;

  DescriptorProto() : super();
  DescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DescriptorProto clone() => new DescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DescriptorProto create() => new DescriptorProto();
  static PbList<DescriptorProto> createRepeated() => new PbList<DescriptorProto>();
  static DescriptorProto getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyDescriptorProto();
    return _defaultInstance;
  }
  static DescriptorProto _defaultInstance;
  static void $checkItem(DescriptorProto v) {
    if (v is !DescriptorProto) checkItemFailed(v, 'DescriptorProto');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  List<FieldDescriptorProto> get field => $_get(1, 2, null);

  List<DescriptorProto> get nestedType => $_get(2, 3, null);

  List<EnumDescriptorProto> get enumType => $_get(3, 4, null);

  List<DescriptorProto_ExtensionRange> get extensionRange => $_get(4, 5, null);

  List<FieldDescriptorProto> get extension => $_get(5, 6, null);

  MessageOptions get options => $_get(6, 7, null);
  void set options(MessageOptions v) { setField(7, v); }
  bool hasOptions() => $_has(6, 7);
  void clearOptions() => clearField(7);
}

class _ReadonlyDescriptorProto extends DescriptorProto with ReadonlyMessageMixin {}

class FieldDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FieldDescriptorProto')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..a/*<String>*/(2, 'extendee', PbFieldType.OS)
    ..a/*<int>*/(3, 'number', PbFieldType.O3)
    ..e/*<FieldDescriptorProto_Label>*/(4, 'label', PbFieldType.OE, FieldDescriptorProto_Label.LABEL_OPTIONAL, FieldDescriptorProto_Label.valueOf)
    ..e/*<FieldDescriptorProto_Type>*/(5, 'type', PbFieldType.OE, FieldDescriptorProto_Type.TYPE_DOUBLE, FieldDescriptorProto_Type.valueOf)
    ..a/*<String>*/(6, 'typeName', PbFieldType.OS)
    ..a/*<String>*/(7, 'defaultValue', PbFieldType.OS)
    ..a/*<FieldOptions>*/(8, 'options', PbFieldType.OM, FieldOptions.getDefault, FieldOptions.create)
  ;

  FieldDescriptorProto() : super();
  FieldDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FieldDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FieldDescriptorProto clone() => new FieldDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FieldDescriptorProto create() => new FieldDescriptorProto();
  static PbList<FieldDescriptorProto> createRepeated() => new PbList<FieldDescriptorProto>();
  static FieldDescriptorProto getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFieldDescriptorProto();
    return _defaultInstance;
  }
  static FieldDescriptorProto _defaultInstance;
  static void $checkItem(FieldDescriptorProto v) {
    if (v is !FieldDescriptorProto) checkItemFailed(v, 'FieldDescriptorProto');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  String get extendee => $_get(1, 2, '');
  void set extendee(String v) { $_setString(1, 2, v); }
  bool hasExtendee() => $_has(1, 2);
  void clearExtendee() => clearField(2);

  int get number => $_get(2, 3, 0);
  void set number(int v) { $_setUnsignedInt32(2, 3, v); }
  bool hasNumber() => $_has(2, 3);
  void clearNumber() => clearField(3);

  FieldDescriptorProto_Label get label => $_get(3, 4, null);
  void set label(FieldDescriptorProto_Label v) { setField(4, v); }
  bool hasLabel() => $_has(3, 4);
  void clearLabel() => clearField(4);

  FieldDescriptorProto_Type get type => $_get(4, 5, null);
  void set type(FieldDescriptorProto_Type v) { setField(5, v); }
  bool hasType() => $_has(4, 5);
  void clearType() => clearField(5);

  String get typeName => $_get(5, 6, '');
  void set typeName(String v) { $_setString(5, 6, v); }
  bool hasTypeName() => $_has(5, 6);
  void clearTypeName() => clearField(6);

  String get defaultValue => $_get(6, 7, '');
  void set defaultValue(String v) { $_setString(6, 7, v); }
  bool hasDefaultValue() => $_has(6, 7);
  void clearDefaultValue() => clearField(7);

  FieldOptions get options => $_get(7, 8, null);
  void set options(FieldOptions v) { setField(8, v); }
  bool hasOptions() => $_has(7, 8);
  void clearOptions() => clearField(8);
}

class _ReadonlyFieldDescriptorProto extends FieldDescriptorProto with ReadonlyMessageMixin {}

class EnumDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumDescriptorProto')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..pp/*<EnumValueDescriptorProto>*/(2, 'value', PbFieldType.PM, EnumValueDescriptorProto.$checkItem, EnumValueDescriptorProto.create)
    ..a/*<EnumOptions>*/(3, 'options', PbFieldType.OM, EnumOptions.getDefault, EnumOptions.create)
  ;

  EnumDescriptorProto() : super();
  EnumDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EnumDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EnumDescriptorProto clone() => new EnumDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumDescriptorProto create() => new EnumDescriptorProto();
  static PbList<EnumDescriptorProto> createRepeated() => new PbList<EnumDescriptorProto>();
  static EnumDescriptorProto getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyEnumDescriptorProto();
    return _defaultInstance;
  }
  static EnumDescriptorProto _defaultInstance;
  static void $checkItem(EnumDescriptorProto v) {
    if (v is !EnumDescriptorProto) checkItemFailed(v, 'EnumDescriptorProto');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  List<EnumValueDescriptorProto> get value => $_get(1, 2, null);

  EnumOptions get options => $_get(2, 3, null);
  void set options(EnumOptions v) { setField(3, v); }
  bool hasOptions() => $_has(2, 3);
  void clearOptions() => clearField(3);
}

class _ReadonlyEnumDescriptorProto extends EnumDescriptorProto with ReadonlyMessageMixin {}

class EnumValueDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumValueDescriptorProto')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..a/*<int>*/(2, 'number', PbFieldType.O3)
    ..a/*<EnumValueOptions>*/(3, 'options', PbFieldType.OM, EnumValueOptions.getDefault, EnumValueOptions.create)
  ;

  EnumValueDescriptorProto() : super();
  EnumValueDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EnumValueDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EnumValueDescriptorProto clone() => new EnumValueDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumValueDescriptorProto create() => new EnumValueDescriptorProto();
  static PbList<EnumValueDescriptorProto> createRepeated() => new PbList<EnumValueDescriptorProto>();
  static EnumValueDescriptorProto getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyEnumValueDescriptorProto();
    return _defaultInstance;
  }
  static EnumValueDescriptorProto _defaultInstance;
  static void $checkItem(EnumValueDescriptorProto v) {
    if (v is !EnumValueDescriptorProto) checkItemFailed(v, 'EnumValueDescriptorProto');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  int get number => $_get(1, 2, 0);
  void set number(int v) { $_setUnsignedInt32(1, 2, v); }
  bool hasNumber() => $_has(1, 2);
  void clearNumber() => clearField(2);

  EnumValueOptions get options => $_get(2, 3, null);
  void set options(EnumValueOptions v) { setField(3, v); }
  bool hasOptions() => $_has(2, 3);
  void clearOptions() => clearField(3);
}

class _ReadonlyEnumValueDescriptorProto extends EnumValueDescriptorProto with ReadonlyMessageMixin {}

class ServiceDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceDescriptorProto')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..pp/*<MethodDescriptorProto>*/(2, 'method', PbFieldType.PM, MethodDescriptorProto.$checkItem, MethodDescriptorProto.create)
    ..a/*<ServiceOptions>*/(3, 'options', PbFieldType.OM, ServiceOptions.getDefault, ServiceOptions.create)
    ..pp/*<StreamDescriptorProto>*/(4, 'stream', PbFieldType.PM, StreamDescriptorProto.$checkItem, StreamDescriptorProto.create)
  ;

  ServiceDescriptorProto() : super();
  ServiceDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceDescriptorProto clone() => new ServiceDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ServiceDescriptorProto create() => new ServiceDescriptorProto();
  static PbList<ServiceDescriptorProto> createRepeated() => new PbList<ServiceDescriptorProto>();
  static ServiceDescriptorProto getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyServiceDescriptorProto();
    return _defaultInstance;
  }
  static ServiceDescriptorProto _defaultInstance;
  static void $checkItem(ServiceDescriptorProto v) {
    if (v is !ServiceDescriptorProto) checkItemFailed(v, 'ServiceDescriptorProto');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  List<MethodDescriptorProto> get method => $_get(1, 2, null);

  ServiceOptions get options => $_get(2, 3, null);
  void set options(ServiceOptions v) { setField(3, v); }
  bool hasOptions() => $_has(2, 3);
  void clearOptions() => clearField(3);

  List<StreamDescriptorProto> get stream => $_get(3, 4, null);
}

class _ReadonlyServiceDescriptorProto extends ServiceDescriptorProto with ReadonlyMessageMixin {}

class MethodDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MethodDescriptorProto')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..a/*<String>*/(2, 'inputType', PbFieldType.OS)
    ..a/*<String>*/(3, 'outputType', PbFieldType.OS)
    ..a/*<MethodOptions>*/(4, 'options', PbFieldType.OM, MethodOptions.getDefault, MethodOptions.create)
  ;

  MethodDescriptorProto() : super();
  MethodDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MethodDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MethodDescriptorProto clone() => new MethodDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MethodDescriptorProto create() => new MethodDescriptorProto();
  static PbList<MethodDescriptorProto> createRepeated() => new PbList<MethodDescriptorProto>();
  static MethodDescriptorProto getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyMethodDescriptorProto();
    return _defaultInstance;
  }
  static MethodDescriptorProto _defaultInstance;
  static void $checkItem(MethodDescriptorProto v) {
    if (v is !MethodDescriptorProto) checkItemFailed(v, 'MethodDescriptorProto');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  String get inputType => $_get(1, 2, '');
  void set inputType(String v) { $_setString(1, 2, v); }
  bool hasInputType() => $_has(1, 2);
  void clearInputType() => clearField(2);

  String get outputType => $_get(2, 3, '');
  void set outputType(String v) { $_setString(2, 3, v); }
  bool hasOutputType() => $_has(2, 3);
  void clearOutputType() => clearField(3);

  MethodOptions get options => $_get(3, 4, null);
  void set options(MethodOptions v) { setField(4, v); }
  bool hasOptions() => $_has(3, 4);
  void clearOptions() => clearField(4);
}

class _ReadonlyMethodDescriptorProto extends MethodDescriptorProto with ReadonlyMessageMixin {}

class StreamDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('StreamDescriptorProto')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..a/*<String>*/(2, 'clientMessageType', PbFieldType.OS)
    ..a/*<String>*/(3, 'serverMessageType', PbFieldType.OS)
    ..a/*<StreamOptions>*/(4, 'options', PbFieldType.OM, StreamOptions.getDefault, StreamOptions.create)
  ;

  StreamDescriptorProto() : super();
  StreamDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  StreamDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  StreamDescriptorProto clone() => new StreamDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static StreamDescriptorProto create() => new StreamDescriptorProto();
  static PbList<StreamDescriptorProto> createRepeated() => new PbList<StreamDescriptorProto>();
  static StreamDescriptorProto getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyStreamDescriptorProto();
    return _defaultInstance;
  }
  static StreamDescriptorProto _defaultInstance;
  static void $checkItem(StreamDescriptorProto v) {
    if (v is !StreamDescriptorProto) checkItemFailed(v, 'StreamDescriptorProto');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  String get clientMessageType => $_get(1, 2, '');
  void set clientMessageType(String v) { $_setString(1, 2, v); }
  bool hasClientMessageType() => $_has(1, 2);
  void clearClientMessageType() => clearField(2);

  String get serverMessageType => $_get(2, 3, '');
  void set serverMessageType(String v) { $_setString(2, 3, v); }
  bool hasServerMessageType() => $_has(2, 3);
  void clearServerMessageType() => clearField(3);

  StreamOptions get options => $_get(3, 4, null);
  void set options(StreamOptions v) { setField(4, v); }
  bool hasOptions() => $_has(3, 4);
  void clearOptions() => clearField(4);
}

class _ReadonlyStreamDescriptorProto extends StreamDescriptorProto with ReadonlyMessageMixin {}

class FileOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileOptions')
    ..a/*<String>*/(1, 'javaPackage', PbFieldType.OS)
    ..a/*<String>*/(8, 'javaOuterClassname', PbFieldType.OS)
    ..e/*<FileOptions_OptimizeMode>*/(9, 'optimizeFor', PbFieldType.OE, FileOptions_OptimizeMode.SPEED, FileOptions_OptimizeMode.valueOf)
    ..a/*<bool>*/(10, 'javaMultipleFiles', PbFieldType.OB)
    ..a/*<bool>*/(16, 'ccGenericServices', PbFieldType.OB)
    ..a/*<bool>*/(17, 'javaGenericServices', PbFieldType.OB)
    ..a/*<bool>*/(18, 'pyGenericServices', PbFieldType.OB)
    ..a/*<bool>*/(20, 'javaGenerateEqualsAndHash', PbFieldType.OB)
    ..pp/*<UninterpretedOption>*/(999, 'uninterpretedOption', PbFieldType.PM, UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true
  ;

  FileOptions() : super();
  FileOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FileOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
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
    if (v is !FileOptions) checkItemFailed(v, 'FileOptions');
  }

  String get javaPackage => $_get(0, 1, '');
  void set javaPackage(String v) { $_setString(0, 1, v); }
  bool hasJavaPackage() => $_has(0, 1);
  void clearJavaPackage() => clearField(1);

  String get javaOuterClassname => $_get(1, 8, '');
  void set javaOuterClassname(String v) { $_setString(1, 8, v); }
  bool hasJavaOuterClassname() => $_has(1, 8);
  void clearJavaOuterClassname() => clearField(8);

  FileOptions_OptimizeMode get optimizeFor => $_get(2, 9, null);
  void set optimizeFor(FileOptions_OptimizeMode v) { setField(9, v); }
  bool hasOptimizeFor() => $_has(2, 9);
  void clearOptimizeFor() => clearField(9);

  bool get javaMultipleFiles => $_get(3, 10, false);
  void set javaMultipleFiles(bool v) { $_setBool(3, 10, v); }
  bool hasJavaMultipleFiles() => $_has(3, 10);
  void clearJavaMultipleFiles() => clearField(10);

  bool get ccGenericServices => $_get(4, 16, false);
  void set ccGenericServices(bool v) { $_setBool(4, 16, v); }
  bool hasCcGenericServices() => $_has(4, 16);
  void clearCcGenericServices() => clearField(16);

  bool get javaGenericServices => $_get(5, 17, false);
  void set javaGenericServices(bool v) { $_setBool(5, 17, v); }
  bool hasJavaGenericServices() => $_has(5, 17);
  void clearJavaGenericServices() => clearField(17);

  bool get pyGenericServices => $_get(6, 18, false);
  void set pyGenericServices(bool v) { $_setBool(6, 18, v); }
  bool hasPyGenericServices() => $_has(6, 18);
  void clearPyGenericServices() => clearField(18);

  bool get javaGenerateEqualsAndHash => $_get(7, 20, false);
  void set javaGenerateEqualsAndHash(bool v) { $_setBool(7, 20, v); }
  bool hasJavaGenerateEqualsAndHash() => $_has(7, 20);
  void clearJavaGenerateEqualsAndHash() => clearField(20);

  List<UninterpretedOption> get uninterpretedOption => $_get(8, 999, null);
}

class _ReadonlyFileOptions extends FileOptions with ReadonlyMessageMixin {}

class MessageOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MessageOptions')
    ..a/*<bool>*/(1, 'messageSetWireFormat', PbFieldType.OB)
    ..a/*<bool>*/(2, 'noStandardDescriptorAccessor', PbFieldType.OB)
    ..pp/*<UninterpretedOption>*/(999, 'uninterpretedOption', PbFieldType.PM, UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true
  ;

  MessageOptions() : super();
  MessageOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MessageOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MessageOptions clone() => new MessageOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MessageOptions create() => new MessageOptions();
  static PbList<MessageOptions> createRepeated() => new PbList<MessageOptions>();
  static MessageOptions getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyMessageOptions();
    return _defaultInstance;
  }
  static MessageOptions _defaultInstance;
  static void $checkItem(MessageOptions v) {
    if (v is !MessageOptions) checkItemFailed(v, 'MessageOptions');
  }

  bool get messageSetWireFormat => $_get(0, 1, false);
  void set messageSetWireFormat(bool v) { $_setBool(0, 1, v); }
  bool hasMessageSetWireFormat() => $_has(0, 1);
  void clearMessageSetWireFormat() => clearField(1);

  bool get noStandardDescriptorAccessor => $_get(1, 2, false);
  void set noStandardDescriptorAccessor(bool v) { $_setBool(1, 2, v); }
  bool hasNoStandardDescriptorAccessor() => $_has(1, 2);
  void clearNoStandardDescriptorAccessor() => clearField(2);

  List<UninterpretedOption> get uninterpretedOption => $_get(2, 999, null);
}

class _ReadonlyMessageOptions extends MessageOptions with ReadonlyMessageMixin {}

class FieldOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FieldOptions')
    ..e/*<FieldOptions_CType>*/(1, 'ctype', PbFieldType.OE, FieldOptions_CType.STRING, FieldOptions_CType.valueOf)
    ..a/*<bool>*/(2, 'packed', PbFieldType.OB)
    ..a/*<bool>*/(3, 'deprecated', PbFieldType.OB)
    ..a/*<bool>*/(5, 'lazy', PbFieldType.OB)
    ..a/*<String>*/(9, 'experimentalMapKey', PbFieldType.OS)
    ..pp/*<UninterpretedOption>*/(999, 'uninterpretedOption', PbFieldType.PM, UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true
  ;

  FieldOptions() : super();
  FieldOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FieldOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FieldOptions clone() => new FieldOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FieldOptions create() => new FieldOptions();
  static PbList<FieldOptions> createRepeated() => new PbList<FieldOptions>();
  static FieldOptions getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyFieldOptions();
    return _defaultInstance;
  }
  static FieldOptions _defaultInstance;
  static void $checkItem(FieldOptions v) {
    if (v is !FieldOptions) checkItemFailed(v, 'FieldOptions');
  }

  FieldOptions_CType get ctype => $_get(0, 1, null);
  void set ctype(FieldOptions_CType v) { setField(1, v); }
  bool hasCtype() => $_has(0, 1);
  void clearCtype() => clearField(1);

  bool get packed => $_get(1, 2, false);
  void set packed(bool v) { $_setBool(1, 2, v); }
  bool hasPacked() => $_has(1, 2);
  void clearPacked() => clearField(2);

  bool get deprecated => $_get(2, 3, false);
  void set deprecated(bool v) { $_setBool(2, 3, v); }
  bool hasDeprecated() => $_has(2, 3);
  void clearDeprecated() => clearField(3);

  bool get lazy => $_get(3, 5, false);
  void set lazy(bool v) { $_setBool(3, 5, v); }
  bool hasLazy() => $_has(3, 5);
  void clearLazy() => clearField(5);

  String get experimentalMapKey => $_get(4, 9, '');
  void set experimentalMapKey(String v) { $_setString(4, 9, v); }
  bool hasExperimentalMapKey() => $_has(4, 9);
  void clearExperimentalMapKey() => clearField(9);

  List<UninterpretedOption> get uninterpretedOption => $_get(5, 999, null);
}

class _ReadonlyFieldOptions extends FieldOptions with ReadonlyMessageMixin {}

class EnumOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumOptions')
    ..a/*<bool>*/(2, 'allowAlias', PbFieldType.OB, true)
    ..pp/*<UninterpretedOption>*/(999, 'uninterpretedOption', PbFieldType.PM, UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true
  ;

  EnumOptions() : super();
  EnumOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EnumOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
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
    if (v is !EnumOptions) checkItemFailed(v, 'EnumOptions');
  }

  bool get allowAlias => $_get(0, 2, true);
  void set allowAlias(bool v) { $_setBool(0, 2, v); }
  bool hasAllowAlias() => $_has(0, 2);
  void clearAllowAlias() => clearField(2);

  List<UninterpretedOption> get uninterpretedOption => $_get(1, 999, null);
}

class _ReadonlyEnumOptions extends EnumOptions with ReadonlyMessageMixin {}

class EnumValueOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumValueOptions')
    ..pp/*<UninterpretedOption>*/(999, 'uninterpretedOption', PbFieldType.PM, UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true
  ;

  EnumValueOptions() : super();
  EnumValueOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EnumValueOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EnumValueOptions clone() => new EnumValueOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumValueOptions create() => new EnumValueOptions();
  static PbList<EnumValueOptions> createRepeated() => new PbList<EnumValueOptions>();
  static EnumValueOptions getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyEnumValueOptions();
    return _defaultInstance;
  }
  static EnumValueOptions _defaultInstance;
  static void $checkItem(EnumValueOptions v) {
    if (v is !EnumValueOptions) checkItemFailed(v, 'EnumValueOptions');
  }

  List<UninterpretedOption> get uninterpretedOption => $_get(0, 999, null);
}

class _ReadonlyEnumValueOptions extends EnumValueOptions with ReadonlyMessageMixin {}

class ServiceOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceOptions')
    ..pp/*<UninterpretedOption>*/(999, 'uninterpretedOption', PbFieldType.PM, UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true
  ;

  ServiceOptions() : super();
  ServiceOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceOptions clone() => new ServiceOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ServiceOptions create() => new ServiceOptions();
  static PbList<ServiceOptions> createRepeated() => new PbList<ServiceOptions>();
  static ServiceOptions getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyServiceOptions();
    return _defaultInstance;
  }
  static ServiceOptions _defaultInstance;
  static void $checkItem(ServiceOptions v) {
    if (v is !ServiceOptions) checkItemFailed(v, 'ServiceOptions');
  }

  List<UninterpretedOption> get uninterpretedOption => $_get(0, 999, null);
}

class _ReadonlyServiceOptions extends ServiceOptions with ReadonlyMessageMixin {}

class MethodOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MethodOptions')
    ..pp/*<UninterpretedOption>*/(999, 'uninterpretedOption', PbFieldType.PM, UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true
  ;

  MethodOptions() : super();
  MethodOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MethodOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MethodOptions clone() => new MethodOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MethodOptions create() => new MethodOptions();
  static PbList<MethodOptions> createRepeated() => new PbList<MethodOptions>();
  static MethodOptions getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyMethodOptions();
    return _defaultInstance;
  }
  static MethodOptions _defaultInstance;
  static void $checkItem(MethodOptions v) {
    if (v is !MethodOptions) checkItemFailed(v, 'MethodOptions');
  }

  List<UninterpretedOption> get uninterpretedOption => $_get(0, 999, null);
}

class _ReadonlyMethodOptions extends MethodOptions with ReadonlyMessageMixin {}

class StreamOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('StreamOptions')
    ..pp/*<UninterpretedOption>*/(999, 'uninterpretedOption', PbFieldType.PM, UninterpretedOption.$checkItem, UninterpretedOption.create)
    ..hasExtensions = true
  ;

  StreamOptions() : super();
  StreamOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  StreamOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  StreamOptions clone() => new StreamOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static StreamOptions create() => new StreamOptions();
  static PbList<StreamOptions> createRepeated() => new PbList<StreamOptions>();
  static StreamOptions getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyStreamOptions();
    return _defaultInstance;
  }
  static StreamOptions _defaultInstance;
  static void $checkItem(StreamOptions v) {
    if (v is !StreamOptions) checkItemFailed(v, 'StreamOptions');
  }

  List<UninterpretedOption> get uninterpretedOption => $_get(0, 999, null);
}

class _ReadonlyStreamOptions extends StreamOptions with ReadonlyMessageMixin {}

class UninterpretedOption_NamePart extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UninterpretedOption_NamePart')
    ..a/*<String>*/(1, 'namePart', PbFieldType.QS)
    ..a/*<bool>*/(2, 'isExtension', PbFieldType.QB)
  ;

  UninterpretedOption_NamePart() : super();
  UninterpretedOption_NamePart.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UninterpretedOption_NamePart.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UninterpretedOption_NamePart clone() => new UninterpretedOption_NamePart()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UninterpretedOption_NamePart create() => new UninterpretedOption_NamePart();
  static PbList<UninterpretedOption_NamePart> createRepeated() => new PbList<UninterpretedOption_NamePart>();
  static UninterpretedOption_NamePart getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUninterpretedOption_NamePart();
    return _defaultInstance;
  }
  static UninterpretedOption_NamePart _defaultInstance;
  static void $checkItem(UninterpretedOption_NamePart v) {
    if (v is !UninterpretedOption_NamePart) checkItemFailed(v, 'UninterpretedOption_NamePart');
  }

  String get namePart => $_get(0, 1, '');
  void set namePart(String v) { $_setString(0, 1, v); }
  bool hasNamePart() => $_has(0, 1);
  void clearNamePart() => clearField(1);

  bool get isExtension => $_get(1, 2, false);
  void set isExtension(bool v) { $_setBool(1, 2, v); }
  bool hasIsExtension() => $_has(1, 2);
  void clearIsExtension() => clearField(2);
}

class _ReadonlyUninterpretedOption_NamePart extends UninterpretedOption_NamePart with ReadonlyMessageMixin {}

class UninterpretedOption extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UninterpretedOption')
    ..pp/*<UninterpretedOption_NamePart>*/(2, 'name', PbFieldType.PM, UninterpretedOption_NamePart.$checkItem, UninterpretedOption_NamePart.create)
    ..a/*<String>*/(3, 'identifierValue', PbFieldType.OS)
    ..a/*<Int64>*/(4, 'positiveIntValue', PbFieldType.OU6, Int64.ZERO)
    ..a/*<Int64>*/(5, 'negativeIntValue', PbFieldType.O6, Int64.ZERO)
    ..a/*<double>*/(6, 'doubleValue', PbFieldType.OD)
    ..a/*<List<int>>*/(7, 'stringValue', PbFieldType.OY)
    ..a/*<String>*/(8, 'aggregateValue', PbFieldType.OS)
  ;

  UninterpretedOption() : super();
  UninterpretedOption.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UninterpretedOption.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UninterpretedOption clone() => new UninterpretedOption()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UninterpretedOption create() => new UninterpretedOption();
  static PbList<UninterpretedOption> createRepeated() => new PbList<UninterpretedOption>();
  static UninterpretedOption getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyUninterpretedOption();
    return _defaultInstance;
  }
  static UninterpretedOption _defaultInstance;
  static void $checkItem(UninterpretedOption v) {
    if (v is !UninterpretedOption) checkItemFailed(v, 'UninterpretedOption');
  }

  List<UninterpretedOption_NamePart> get name => $_get(0, 2, null);

  String get identifierValue => $_get(1, 3, '');
  void set identifierValue(String v) { $_setString(1, 3, v); }
  bool hasIdentifierValue() => $_has(1, 3);
  void clearIdentifierValue() => clearField(3);

  Int64 get positiveIntValue => $_get(2, 4, null);
  void set positiveIntValue(Int64 v) { $_setInt64(2, 4, v); }
  bool hasPositiveIntValue() => $_has(2, 4);
  void clearPositiveIntValue() => clearField(4);

  Int64 get negativeIntValue => $_get(3, 5, null);
  void set negativeIntValue(Int64 v) { $_setInt64(3, 5, v); }
  bool hasNegativeIntValue() => $_has(3, 5);
  void clearNegativeIntValue() => clearField(5);

  double get doubleValue => $_get(4, 6, null);
  void set doubleValue(double v) { $_setDouble(4, 6, v); }
  bool hasDoubleValue() => $_has(4, 6);
  void clearDoubleValue() => clearField(6);

  List<int> get stringValue => $_get(5, 7, null);
  void set stringValue(List<int> v) { $_setBytes(5, 7, v); }
  bool hasStringValue() => $_has(5, 7);
  void clearStringValue() => clearField(7);

  String get aggregateValue => $_get(6, 8, '');
  void set aggregateValue(String v) { $_setString(6, 8, v); }
  bool hasAggregateValue() => $_has(6, 8);
  void clearAggregateValue() => clearField(8);
}

class _ReadonlyUninterpretedOption extends UninterpretedOption with ReadonlyMessageMixin {}

class SourceCodeInfo_Location extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SourceCodeInfo_Location')
    ..p/*<int>*/(1, 'path', PbFieldType.K3)
    ..p/*<int>*/(2, 'span', PbFieldType.K3)
    ..hasRequiredFields = false
  ;

  SourceCodeInfo_Location() : super();
  SourceCodeInfo_Location.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SourceCodeInfo_Location.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SourceCodeInfo_Location clone() => new SourceCodeInfo_Location()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SourceCodeInfo_Location create() => new SourceCodeInfo_Location();
  static PbList<SourceCodeInfo_Location> createRepeated() => new PbList<SourceCodeInfo_Location>();
  static SourceCodeInfo_Location getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySourceCodeInfo_Location();
    return _defaultInstance;
  }
  static SourceCodeInfo_Location _defaultInstance;
  static void $checkItem(SourceCodeInfo_Location v) {
    if (v is !SourceCodeInfo_Location) checkItemFailed(v, 'SourceCodeInfo_Location');
  }

  List<int> get path => $_get(0, 1, null);

  List<int> get span => $_get(1, 2, null);
}

class _ReadonlySourceCodeInfo_Location extends SourceCodeInfo_Location with ReadonlyMessageMixin {}

class SourceCodeInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SourceCodeInfo')
    ..pp/*<SourceCodeInfo_Location>*/(1, 'location', PbFieldType.PM, SourceCodeInfo_Location.$checkItem, SourceCodeInfo_Location.create)
    ..hasRequiredFields = false
  ;

  SourceCodeInfo() : super();
  SourceCodeInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SourceCodeInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SourceCodeInfo clone() => new SourceCodeInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SourceCodeInfo create() => new SourceCodeInfo();
  static PbList<SourceCodeInfo> createRepeated() => new PbList<SourceCodeInfo>();
  static SourceCodeInfo getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlySourceCodeInfo();
    return _defaultInstance;
  }
  static SourceCodeInfo _defaultInstance;
  static void $checkItem(SourceCodeInfo v) {
    if (v is !SourceCodeInfo) checkItemFailed(v, 'SourceCodeInfo');
  }

  List<SourceCodeInfo_Location> get location => $_get(0, 1, null);
}

class _ReadonlySourceCodeInfo extends SourceCodeInfo with ReadonlyMessageMixin {}

