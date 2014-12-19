///
//  Generated code. Do not modify.
///
library proto2;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

class FileDescriptorSet extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileDescriptorSet')
    ..m(1, 'file', FileDescriptorProto.create, FileDescriptorProto.createRepeated)
  ;

  FileDescriptorSet() : super();
  FileDescriptorSet.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FileDescriptorSet.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FileDescriptorSet clone() => new FileDescriptorSet()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileDescriptorSet create() => new FileDescriptorSet();
  static PbList<FileDescriptorSet> createRepeated() => new PbList<FileDescriptorSet>();

  List<FileDescriptorProto> get file => getField(1);
}

class FileDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileDescriptorProto')
    ..a(1, 'name', GeneratedMessage.OS)
    ..a(2, 'package', GeneratedMessage.OS)
    ..p(3, 'dependency', GeneratedMessage.PS)
    ..p(10, 'publicDependency', GeneratedMessage.P3)
    ..p(11, 'weakDependency', GeneratedMessage.P3)
    ..m(4, 'messageType', DescriptorProto.create, DescriptorProto.createRepeated)
    ..m(5, 'enumType', EnumDescriptorProto.create, EnumDescriptorProto.createRepeated)
    ..m(6, 'service', ServiceDescriptorProto.create, ServiceDescriptorProto.createRepeated)
    ..m(7, 'extension', FieldDescriptorProto.create, FieldDescriptorProto.createRepeated)
    ..a(8, 'options', GeneratedMessage.OM, FileOptions.create, FileOptions.create)
    ..a(9, 'sourceCodeInfo', GeneratedMessage.OM, SourceCodeInfo.create, SourceCodeInfo.create)
  ;

  FileDescriptorProto() : super();
  FileDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FileDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FileDescriptorProto clone() => new FileDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileDescriptorProto create() => new FileDescriptorProto();
  static PbList<FileDescriptorProto> createRepeated() => new PbList<FileDescriptorProto>();

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  String get package => getField(2);
  void set package(String v) { setField(2, v); }
  bool hasPackage() => hasField(2);
  void clearPackage() => clearField(2);

  List<String> get dependency => getField(3);

  List<int> get publicDependency => getField(10);

  List<int> get weakDependency => getField(11);

  List<DescriptorProto> get messageType => getField(4);

  List<EnumDescriptorProto> get enumType => getField(5);

  List<ServiceDescriptorProto> get service => getField(6);

  List<FieldDescriptorProto> get extension => getField(7);

  FileOptions get options => getField(8);
  void set options(FileOptions v) { setField(8, v); }
  bool hasOptions() => hasField(8);
  void clearOptions() => clearField(8);

  SourceCodeInfo get sourceCodeInfo => getField(9);
  void set sourceCodeInfo(SourceCodeInfo v) { setField(9, v); }
  bool hasSourceCodeInfo() => hasField(9);
  void clearSourceCodeInfo() => clearField(9);
}

class DescriptorProto_ExtensionRange extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DescriptorProto_ExtensionRange')
    ..a(1, 'start', GeneratedMessage.O3)
    ..a(2, 'end', GeneratedMessage.O3)
    ..hasRequiredFields = false
  ;

  DescriptorProto_ExtensionRange() : super();
  DescriptorProto_ExtensionRange.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DescriptorProto_ExtensionRange.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DescriptorProto_ExtensionRange clone() => new DescriptorProto_ExtensionRange()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DescriptorProto_ExtensionRange create() => new DescriptorProto_ExtensionRange();
  static PbList<DescriptorProto_ExtensionRange> createRepeated() => new PbList<DescriptorProto_ExtensionRange>();

  int get start => getField(1);
  void set start(int v) { setField(1, v); }
  bool hasStart() => hasField(1);
  void clearStart() => clearField(1);

  int get end => getField(2);
  void set end(int v) { setField(2, v); }
  bool hasEnd() => hasField(2);
  void clearEnd() => clearField(2);
}

class DescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('DescriptorProto')
    ..a(1, 'name', GeneratedMessage.OS)
    ..m(2, 'field', FieldDescriptorProto.create, FieldDescriptorProto.createRepeated)
    ..m(6, 'extension', FieldDescriptorProto.create, FieldDescriptorProto.createRepeated)
    ..m(3, 'nestedType', DescriptorProto.create, DescriptorProto.createRepeated)
    ..m(4, 'enumType', EnumDescriptorProto.create, EnumDescriptorProto.createRepeated)
    ..m(5, 'extensionRange', DescriptorProto_ExtensionRange.create, DescriptorProto_ExtensionRange.createRepeated)
    ..a(7, 'options', GeneratedMessage.OM, MessageOptions.create, MessageOptions.create)
  ;

  DescriptorProto() : super();
  DescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  DescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  DescriptorProto clone() => new DescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static DescriptorProto create() => new DescriptorProto();
  static PbList<DescriptorProto> createRepeated() => new PbList<DescriptorProto>();

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  List<FieldDescriptorProto> get field => getField(2);

  List<FieldDescriptorProto> get extension => getField(6);

  List<DescriptorProto> get nestedType => getField(3);

  List<EnumDescriptorProto> get enumType => getField(4);

  List<DescriptorProto_ExtensionRange> get extensionRange => getField(5);

  MessageOptions get options => getField(7);
  void set options(MessageOptions v) { setField(7, v); }
  bool hasOptions() => hasField(7);
  void clearOptions() => clearField(7);
}

class FieldDescriptorProto_Type extends ProtobufEnum {
  static const FieldDescriptorProto_Type TYPE_DOUBLE = const FieldDescriptorProto_Type._(1, 'TYPE_DOUBLE');
  static const FieldDescriptorProto_Type TYPE_FLOAT = const FieldDescriptorProto_Type._(2, 'TYPE_FLOAT');
  static const FieldDescriptorProto_Type TYPE_INT64 = const FieldDescriptorProto_Type._(3, 'TYPE_INT64');
  static const FieldDescriptorProto_Type TYPE_UINT64 = const FieldDescriptorProto_Type._(4, 'TYPE_UINT64');
  static const FieldDescriptorProto_Type TYPE_INT32 = const FieldDescriptorProto_Type._(5, 'TYPE_INT32');
  static const FieldDescriptorProto_Type TYPE_FIXED64 = const FieldDescriptorProto_Type._(6, 'TYPE_FIXED64');
  static const FieldDescriptorProto_Type TYPE_FIXED32 = const FieldDescriptorProto_Type._(7, 'TYPE_FIXED32');
  static const FieldDescriptorProto_Type TYPE_BOOL = const FieldDescriptorProto_Type._(8, 'TYPE_BOOL');
  static const FieldDescriptorProto_Type TYPE_STRING = const FieldDescriptorProto_Type._(9, 'TYPE_STRING');
  static const FieldDescriptorProto_Type TYPE_GROUP = const FieldDescriptorProto_Type._(10, 'TYPE_GROUP');
  static const FieldDescriptorProto_Type TYPE_MESSAGE = const FieldDescriptorProto_Type._(11, 'TYPE_MESSAGE');
  static const FieldDescriptorProto_Type TYPE_BYTES = const FieldDescriptorProto_Type._(12, 'TYPE_BYTES');
  static const FieldDescriptorProto_Type TYPE_UINT32 = const FieldDescriptorProto_Type._(13, 'TYPE_UINT32');
  static const FieldDescriptorProto_Type TYPE_ENUM = const FieldDescriptorProto_Type._(14, 'TYPE_ENUM');
  static const FieldDescriptorProto_Type TYPE_SFIXED32 = const FieldDescriptorProto_Type._(15, 'TYPE_SFIXED32');
  static const FieldDescriptorProto_Type TYPE_SFIXED64 = const FieldDescriptorProto_Type._(16, 'TYPE_SFIXED64');
  static const FieldDescriptorProto_Type TYPE_SINT32 = const FieldDescriptorProto_Type._(17, 'TYPE_SINT32');
  static const FieldDescriptorProto_Type TYPE_SINT64 = const FieldDescriptorProto_Type._(18, 'TYPE_SINT64');

  static const List<FieldDescriptorProto_Type> values = const <FieldDescriptorProto_Type> [
    TYPE_DOUBLE,
    TYPE_FLOAT,
    TYPE_INT64,
    TYPE_UINT64,
    TYPE_INT32,
    TYPE_FIXED64,
    TYPE_FIXED32,
    TYPE_BOOL,
    TYPE_STRING,
    TYPE_GROUP,
    TYPE_MESSAGE,
    TYPE_BYTES,
    TYPE_UINT32,
    TYPE_ENUM,
    TYPE_SFIXED32,
    TYPE_SFIXED64,
    TYPE_SINT32,
    TYPE_SINT64,
  ];

  static final Map<int, FieldDescriptorProto_Type> _byValue = ProtobufEnum.initByValue(values);
  static FieldDescriptorProto_Type valueOf(int value) => _byValue[value];

  const FieldDescriptorProto_Type._(int v, String n) : super(v, n);
}

class FieldDescriptorProto_Label extends ProtobufEnum {
  static const FieldDescriptorProto_Label LABEL_OPTIONAL = const FieldDescriptorProto_Label._(1, 'LABEL_OPTIONAL');
  static const FieldDescriptorProto_Label LABEL_REQUIRED = const FieldDescriptorProto_Label._(2, 'LABEL_REQUIRED');
  static const FieldDescriptorProto_Label LABEL_REPEATED = const FieldDescriptorProto_Label._(3, 'LABEL_REPEATED');

  static const List<FieldDescriptorProto_Label> values = const <FieldDescriptorProto_Label> [
    LABEL_OPTIONAL,
    LABEL_REQUIRED,
    LABEL_REPEATED,
  ];

  static final Map<int, FieldDescriptorProto_Label> _byValue = ProtobufEnum.initByValue(values);
  static FieldDescriptorProto_Label valueOf(int value) => _byValue[value];

  const FieldDescriptorProto_Label._(int v, String n) : super(v, n);
}

class FieldDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FieldDescriptorProto')
    ..a(1, 'name', GeneratedMessage.OS)
    ..a(3, 'number', GeneratedMessage.O3)
    ..e(4, 'label', GeneratedMessage.OE, FieldDescriptorProto_Label.LABEL_OPTIONAL, (var v) => FieldDescriptorProto_Label.valueOf(v))
    ..e(5, 'type', GeneratedMessage.OE, FieldDescriptorProto_Type.TYPE_DOUBLE, (var v) => FieldDescriptorProto_Type.valueOf(v))
    ..a(6, 'typeName', GeneratedMessage.OS)
    ..a(2, 'extendee', GeneratedMessage.OS)
    ..a(7, 'defaultValue', GeneratedMessage.OS)
    ..a(8, 'options', GeneratedMessage.OM, FieldOptions.create, FieldOptions.create)
  ;

  FieldDescriptorProto() : super();
  FieldDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FieldDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FieldDescriptorProto clone() => new FieldDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FieldDescriptorProto create() => new FieldDescriptorProto();
  static PbList<FieldDescriptorProto> createRepeated() => new PbList<FieldDescriptorProto>();

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  int get number => getField(3);
  void set number(int v) { setField(3, v); }
  bool hasNumber() => hasField(3);
  void clearNumber() => clearField(3);

  FieldDescriptorProto_Label get label => getField(4);
  void set label(FieldDescriptorProto_Label v) { setField(4, v); }
  bool hasLabel() => hasField(4);
  void clearLabel() => clearField(4);

  FieldDescriptorProto_Type get type => getField(5);
  void set type(FieldDescriptorProto_Type v) { setField(5, v); }
  bool hasType() => hasField(5);
  void clearType() => clearField(5);

  String get typeName => getField(6);
  void set typeName(String v) { setField(6, v); }
  bool hasTypeName() => hasField(6);
  void clearTypeName() => clearField(6);

  String get extendee => getField(2);
  void set extendee(String v) { setField(2, v); }
  bool hasExtendee() => hasField(2);
  void clearExtendee() => clearField(2);

  String get defaultValue => getField(7);
  void set defaultValue(String v) { setField(7, v); }
  bool hasDefaultValue() => hasField(7);
  void clearDefaultValue() => clearField(7);

  FieldOptions get options => getField(8);
  void set options(FieldOptions v) { setField(8, v); }
  bool hasOptions() => hasField(8);
  void clearOptions() => clearField(8);
}

class EnumDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumDescriptorProto')
    ..a(1, 'name', GeneratedMessage.OS)
    ..m(2, 'value', EnumValueDescriptorProto.create, EnumValueDescriptorProto.createRepeated)
    ..a(3, 'options', GeneratedMessage.OM, EnumOptions.create, EnumOptions.create)
  ;

  EnumDescriptorProto() : super();
  EnumDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EnumDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EnumDescriptorProto clone() => new EnumDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumDescriptorProto create() => new EnumDescriptorProto();
  static PbList<EnumDescriptorProto> createRepeated() => new PbList<EnumDescriptorProto>();

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  List<EnumValueDescriptorProto> get value => getField(2);

  EnumOptions get options => getField(3);
  void set options(EnumOptions v) { setField(3, v); }
  bool hasOptions() => hasField(3);
  void clearOptions() => clearField(3);
}

class EnumValueDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumValueDescriptorProto')
    ..a(1, 'name', GeneratedMessage.OS)
    ..a(2, 'number', GeneratedMessage.O3)
    ..a(3, 'options', GeneratedMessage.OM, EnumValueOptions.create, EnumValueOptions.create)
  ;

  EnumValueDescriptorProto() : super();
  EnumValueDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EnumValueDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EnumValueDescriptorProto clone() => new EnumValueDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumValueDescriptorProto create() => new EnumValueDescriptorProto();
  static PbList<EnumValueDescriptorProto> createRepeated() => new PbList<EnumValueDescriptorProto>();

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  int get number => getField(2);
  void set number(int v) { setField(2, v); }
  bool hasNumber() => hasField(2);
  void clearNumber() => clearField(2);

  EnumValueOptions get options => getField(3);
  void set options(EnumValueOptions v) { setField(3, v); }
  bool hasOptions() => hasField(3);
  void clearOptions() => clearField(3);
}

class ServiceDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceDescriptorProto')
    ..a(1, 'name', GeneratedMessage.OS)
    ..m(2, 'method', MethodDescriptorProto.create, MethodDescriptorProto.createRepeated)
    ..m(4, 'stream', StreamDescriptorProto.create, StreamDescriptorProto.createRepeated)
    ..a(3, 'options', GeneratedMessage.OM, ServiceOptions.create, ServiceOptions.create)
  ;

  ServiceDescriptorProto() : super();
  ServiceDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceDescriptorProto clone() => new ServiceDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ServiceDescriptorProto create() => new ServiceDescriptorProto();
  static PbList<ServiceDescriptorProto> createRepeated() => new PbList<ServiceDescriptorProto>();

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  List<MethodDescriptorProto> get method => getField(2);

  List<StreamDescriptorProto> get stream => getField(4);

  ServiceOptions get options => getField(3);
  void set options(ServiceOptions v) { setField(3, v); }
  bool hasOptions() => hasField(3);
  void clearOptions() => clearField(3);
}

class MethodDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MethodDescriptorProto')
    ..a(1, 'name', GeneratedMessage.OS)
    ..a(2, 'inputType', GeneratedMessage.OS)
    ..a(3, 'outputType', GeneratedMessage.OS)
    ..a(4, 'options', GeneratedMessage.OM, MethodOptions.create, MethodOptions.create)
  ;

  MethodDescriptorProto() : super();
  MethodDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MethodDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MethodDescriptorProto clone() => new MethodDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MethodDescriptorProto create() => new MethodDescriptorProto();
  static PbList<MethodDescriptorProto> createRepeated() => new PbList<MethodDescriptorProto>();

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  String get inputType => getField(2);
  void set inputType(String v) { setField(2, v); }
  bool hasInputType() => hasField(2);
  void clearInputType() => clearField(2);

  String get outputType => getField(3);
  void set outputType(String v) { setField(3, v); }
  bool hasOutputType() => hasField(3);
  void clearOutputType() => clearField(3);

  MethodOptions get options => getField(4);
  void set options(MethodOptions v) { setField(4, v); }
  bool hasOptions() => hasField(4);
  void clearOptions() => clearField(4);
}

class StreamDescriptorProto extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('StreamDescriptorProto')
    ..a(1, 'name', GeneratedMessage.OS)
    ..a(2, 'clientMessageType', GeneratedMessage.OS)
    ..a(3, 'serverMessageType', GeneratedMessage.OS)
    ..a(4, 'options', GeneratedMessage.OM, StreamOptions.create, StreamOptions.create)
  ;

  StreamDescriptorProto() : super();
  StreamDescriptorProto.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  StreamDescriptorProto.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  StreamDescriptorProto clone() => new StreamDescriptorProto()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static StreamDescriptorProto create() => new StreamDescriptorProto();
  static PbList<StreamDescriptorProto> createRepeated() => new PbList<StreamDescriptorProto>();

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  String get clientMessageType => getField(2);
  void set clientMessageType(String v) { setField(2, v); }
  bool hasClientMessageType() => hasField(2);
  void clearClientMessageType() => clearField(2);

  String get serverMessageType => getField(3);
  void set serverMessageType(String v) { setField(3, v); }
  bool hasServerMessageType() => hasField(3);
  void clearServerMessageType() => clearField(3);

  StreamOptions get options => getField(4);
  void set options(StreamOptions v) { setField(4, v); }
  bool hasOptions() => hasField(4);
  void clearOptions() => clearField(4);
}

class FileOptions_OptimizeMode extends ProtobufEnum {
  static const FileOptions_OptimizeMode SPEED = const FileOptions_OptimizeMode._(1, 'SPEED');
  static const FileOptions_OptimizeMode CODE_SIZE = const FileOptions_OptimizeMode._(2, 'CODE_SIZE');
  static const FileOptions_OptimizeMode LITE_RUNTIME = const FileOptions_OptimizeMode._(3, 'LITE_RUNTIME');

  static const List<FileOptions_OptimizeMode> values = const <FileOptions_OptimizeMode> [
    SPEED,
    CODE_SIZE,
    LITE_RUNTIME,
  ];

  static final Map<int, FileOptions_OptimizeMode> _byValue = ProtobufEnum.initByValue(values);
  static FileOptions_OptimizeMode valueOf(int value) => _byValue[value];

  const FileOptions_OptimizeMode._(int v, String n) : super(v, n);
}

class FileOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FileOptions')
    ..a(1, 'javaPackage', GeneratedMessage.OS)
    ..a(8, 'javaOuterClassname', GeneratedMessage.OS)
    ..a(10, 'javaMultipleFiles', GeneratedMessage.OB)
    ..a(20, 'javaGenerateEqualsAndHash', GeneratedMessage.OB)
    ..e(9, 'optimizeFor', GeneratedMessage.OE, FileOptions_OptimizeMode.SPEED, (var v) => FileOptions_OptimizeMode.valueOf(v))
    ..a(16, 'ccGenericServices', GeneratedMessage.OB)
    ..a(17, 'javaGenericServices', GeneratedMessage.OB)
    ..a(18, 'pyGenericServices', GeneratedMessage.OB)
    ..m(999, 'uninterpretedOption', UninterpretedOption.create, UninterpretedOption.createRepeated)
    ..hasExtensions = true
  ;

  FileOptions() : super();
  FileOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FileOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FileOptions clone() => new FileOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FileOptions create() => new FileOptions();
  static PbList<FileOptions> createRepeated() => new PbList<FileOptions>();

  String get javaPackage => getField(1);
  void set javaPackage(String v) { setField(1, v); }
  bool hasJavaPackage() => hasField(1);
  void clearJavaPackage() => clearField(1);

  String get javaOuterClassname => getField(8);
  void set javaOuterClassname(String v) { setField(8, v); }
  bool hasJavaOuterClassname() => hasField(8);
  void clearJavaOuterClassname() => clearField(8);

  bool get javaMultipleFiles => getField(10);
  void set javaMultipleFiles(bool v) { setField(10, v); }
  bool hasJavaMultipleFiles() => hasField(10);
  void clearJavaMultipleFiles() => clearField(10);

  bool get javaGenerateEqualsAndHash => getField(20);
  void set javaGenerateEqualsAndHash(bool v) { setField(20, v); }
  bool hasJavaGenerateEqualsAndHash() => hasField(20);
  void clearJavaGenerateEqualsAndHash() => clearField(20);

  FileOptions_OptimizeMode get optimizeFor => getField(9);
  void set optimizeFor(FileOptions_OptimizeMode v) { setField(9, v); }
  bool hasOptimizeFor() => hasField(9);
  void clearOptimizeFor() => clearField(9);

  bool get ccGenericServices => getField(16);
  void set ccGenericServices(bool v) { setField(16, v); }
  bool hasCcGenericServices() => hasField(16);
  void clearCcGenericServices() => clearField(16);

  bool get javaGenericServices => getField(17);
  void set javaGenericServices(bool v) { setField(17, v); }
  bool hasJavaGenericServices() => hasField(17);
  void clearJavaGenericServices() => clearField(17);

  bool get pyGenericServices => getField(18);
  void set pyGenericServices(bool v) { setField(18, v); }
  bool hasPyGenericServices() => hasField(18);
  void clearPyGenericServices() => clearField(18);

  List<UninterpretedOption> get uninterpretedOption => getField(999);
}

class MessageOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MessageOptions')
    ..a(1, 'messageSetWireFormat', GeneratedMessage.OB)
    ..a(2, 'noStandardDescriptorAccessor', GeneratedMessage.OB)
    ..m(999, 'uninterpretedOption', UninterpretedOption.create, UninterpretedOption.createRepeated)
    ..hasExtensions = true
  ;

  MessageOptions() : super();
  MessageOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MessageOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MessageOptions clone() => new MessageOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MessageOptions create() => new MessageOptions();
  static PbList<MessageOptions> createRepeated() => new PbList<MessageOptions>();

  bool get messageSetWireFormat => getField(1);
  void set messageSetWireFormat(bool v) { setField(1, v); }
  bool hasMessageSetWireFormat() => hasField(1);
  void clearMessageSetWireFormat() => clearField(1);

  bool get noStandardDescriptorAccessor => getField(2);
  void set noStandardDescriptorAccessor(bool v) { setField(2, v); }
  bool hasNoStandardDescriptorAccessor() => hasField(2);
  void clearNoStandardDescriptorAccessor() => clearField(2);

  List<UninterpretedOption> get uninterpretedOption => getField(999);
}

class FieldOptions_CType extends ProtobufEnum {
  static const FieldOptions_CType STRING = const FieldOptions_CType._(0, 'STRING');

  static const List<FieldOptions_CType> values = const <FieldOptions_CType> [
    STRING,
  ];

  static final Map<int, FieldOptions_CType> _byValue = ProtobufEnum.initByValue(values);
  static FieldOptions_CType valueOf(int value) => _byValue[value];

  const FieldOptions_CType._(int v, String n) : super(v, n);
}

class FieldOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('FieldOptions')
    ..e(1, 'ctype', GeneratedMessage.OE, FieldOptions_CType.STRING, (var v) => FieldOptions_CType.valueOf(v))
    ..a(2, 'packed', GeneratedMessage.OB)
    ..a(5, 'lazy', GeneratedMessage.OB)
    ..a(3, 'deprecated', GeneratedMessage.OB)
    ..a(9, 'experimentalMapKey', GeneratedMessage.OS)
    ..m(999, 'uninterpretedOption', UninterpretedOption.create, UninterpretedOption.createRepeated)
    ..hasExtensions = true
  ;

  FieldOptions() : super();
  FieldOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  FieldOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  FieldOptions clone() => new FieldOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static FieldOptions create() => new FieldOptions();
  static PbList<FieldOptions> createRepeated() => new PbList<FieldOptions>();

  FieldOptions_CType get ctype => getField(1);
  void set ctype(FieldOptions_CType v) { setField(1, v); }
  bool hasCtype() => hasField(1);
  void clearCtype() => clearField(1);

  bool get packed => getField(2);
  void set packed(bool v) { setField(2, v); }
  bool hasPacked() => hasField(2);
  void clearPacked() => clearField(2);

  bool get lazy => getField(5);
  void set lazy(bool v) { setField(5, v); }
  bool hasLazy() => hasField(5);
  void clearLazy() => clearField(5);

  bool get deprecated => getField(3);
  void set deprecated(bool v) { setField(3, v); }
  bool hasDeprecated() => hasField(3);
  void clearDeprecated() => clearField(3);

  String get experimentalMapKey => getField(9);
  void set experimentalMapKey(String v) { setField(9, v); }
  bool hasExperimentalMapKey() => hasField(9);
  void clearExperimentalMapKey() => clearField(9);

  List<UninterpretedOption> get uninterpretedOption => getField(999);
}

class EnumOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumOptions')
    ..a(2, 'allowAlias', GeneratedMessage.OB, true)
    ..m(999, 'uninterpretedOption', UninterpretedOption.create, UninterpretedOption.createRepeated)
    ..hasExtensions = true
  ;

  EnumOptions() : super();
  EnumOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EnumOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EnumOptions clone() => new EnumOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumOptions create() => new EnumOptions();
  static PbList<EnumOptions> createRepeated() => new PbList<EnumOptions>();

  bool get allowAlias => getField(2);
  void set allowAlias(bool v) { setField(2, v); }
  bool hasAllowAlias() => hasField(2);
  void clearAllowAlias() => clearField(2);

  List<UninterpretedOption> get uninterpretedOption => getField(999);
}

class EnumValueOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('EnumValueOptions')
    ..m(999, 'uninterpretedOption', UninterpretedOption.create, UninterpretedOption.createRepeated)
    ..hasExtensions = true
  ;

  EnumValueOptions() : super();
  EnumValueOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  EnumValueOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  EnumValueOptions clone() => new EnumValueOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static EnumValueOptions create() => new EnumValueOptions();
  static PbList<EnumValueOptions> createRepeated() => new PbList<EnumValueOptions>();

  List<UninterpretedOption> get uninterpretedOption => getField(999);
}

class ServiceOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('ServiceOptions')
    ..m(999, 'uninterpretedOption', UninterpretedOption.create, UninterpretedOption.createRepeated)
    ..hasExtensions = true
  ;

  ServiceOptions() : super();
  ServiceOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  ServiceOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  ServiceOptions clone() => new ServiceOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static ServiceOptions create() => new ServiceOptions();
  static PbList<ServiceOptions> createRepeated() => new PbList<ServiceOptions>();

  List<UninterpretedOption> get uninterpretedOption => getField(999);
}

class MethodOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('MethodOptions')
    ..m(999, 'uninterpretedOption', UninterpretedOption.create, UninterpretedOption.createRepeated)
    ..hasExtensions = true
  ;

  MethodOptions() : super();
  MethodOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  MethodOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  MethodOptions clone() => new MethodOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static MethodOptions create() => new MethodOptions();
  static PbList<MethodOptions> createRepeated() => new PbList<MethodOptions>();

  List<UninterpretedOption> get uninterpretedOption => getField(999);
}

class StreamOptions extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('StreamOptions')
    ..m(999, 'uninterpretedOption', UninterpretedOption.create, UninterpretedOption.createRepeated)
    ..hasExtensions = true
  ;

  StreamOptions() : super();
  StreamOptions.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  StreamOptions.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  StreamOptions clone() => new StreamOptions()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static StreamOptions create() => new StreamOptions();
  static PbList<StreamOptions> createRepeated() => new PbList<StreamOptions>();

  List<UninterpretedOption> get uninterpretedOption => getField(999);
}

class UninterpretedOption_NamePart extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UninterpretedOption_NamePart')
    ..a(1, 'namePart', GeneratedMessage.QS)
    ..a(2, 'isExtension', GeneratedMessage.QB)
  ;

  UninterpretedOption_NamePart() : super();
  UninterpretedOption_NamePart.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UninterpretedOption_NamePart.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UninterpretedOption_NamePart clone() => new UninterpretedOption_NamePart()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UninterpretedOption_NamePart create() => new UninterpretedOption_NamePart();
  static PbList<UninterpretedOption_NamePart> createRepeated() => new PbList<UninterpretedOption_NamePart>();

  String get namePart => getField(1);
  void set namePart(String v) { setField(1, v); }
  bool hasNamePart() => hasField(1);
  void clearNamePart() => clearField(1);

  bool get isExtension => getField(2);
  void set isExtension(bool v) { setField(2, v); }
  bool hasIsExtension() => hasField(2);
  void clearIsExtension() => clearField(2);
}

class UninterpretedOption extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('UninterpretedOption')
    ..m(2, 'name', UninterpretedOption_NamePart.create, UninterpretedOption_NamePart.createRepeated)
    ..a(3, 'identifierValue', GeneratedMessage.OS)
    ..a(4, 'positiveIntValue', GeneratedMessage.OU6, Int64.ZERO)
    ..a(5, 'negativeIntValue', GeneratedMessage.O6, Int64.ZERO)
    ..a(6, 'doubleValue', GeneratedMessage.OD)
    ..a(7, 'stringValue', GeneratedMessage.OY)
    ..a(8, 'aggregateValue', GeneratedMessage.OS)
  ;

  UninterpretedOption() : super();
  UninterpretedOption.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  UninterpretedOption.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  UninterpretedOption clone() => new UninterpretedOption()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static UninterpretedOption create() => new UninterpretedOption();
  static PbList<UninterpretedOption> createRepeated() => new PbList<UninterpretedOption>();

  List<UninterpretedOption_NamePart> get name => getField(2);

  String get identifierValue => getField(3);
  void set identifierValue(String v) { setField(3, v); }
  bool hasIdentifierValue() => hasField(3);
  void clearIdentifierValue() => clearField(3);

  Int64 get positiveIntValue => getField(4);
  void set positiveIntValue(Int64 v) { setField(4, v); }
  bool hasPositiveIntValue() => hasField(4);
  void clearPositiveIntValue() => clearField(4);

  Int64 get negativeIntValue => getField(5);
  void set negativeIntValue(Int64 v) { setField(5, v); }
  bool hasNegativeIntValue() => hasField(5);
  void clearNegativeIntValue() => clearField(5);

  double get doubleValue => getField(6);
  void set doubleValue(double v) { setField(6, v); }
  bool hasDoubleValue() => hasField(6);
  void clearDoubleValue() => clearField(6);

  List<int> get stringValue => getField(7);
  void set stringValue(List<int> v) { setField(7, v); }
  bool hasStringValue() => hasField(7);
  void clearStringValue() => clearField(7);

  String get aggregateValue => getField(8);
  void set aggregateValue(String v) { setField(8, v); }
  bool hasAggregateValue() => hasField(8);
  void clearAggregateValue() => clearField(8);
}

class SourceCodeInfo_Location extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SourceCodeInfo_Location')
    ..a(1, 'path', GeneratedMessage.K3, () => new PbList())
    ..a(2, 'span', GeneratedMessage.K3, () => new PbList())
    ..hasRequiredFields = false
  ;

  SourceCodeInfo_Location() : super();
  SourceCodeInfo_Location.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SourceCodeInfo_Location.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SourceCodeInfo_Location clone() => new SourceCodeInfo_Location()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SourceCodeInfo_Location create() => new SourceCodeInfo_Location();
  static PbList<SourceCodeInfo_Location> createRepeated() => new PbList<SourceCodeInfo_Location>();

  List<int> get path => getField(1);

  List<int> get span => getField(2);
}

class SourceCodeInfo extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('SourceCodeInfo')
    ..m(1, 'location', SourceCodeInfo_Location.create, SourceCodeInfo_Location.createRepeated)
    ..hasRequiredFields = false
  ;

  SourceCodeInfo() : super();
  SourceCodeInfo.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  SourceCodeInfo.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  SourceCodeInfo clone() => new SourceCodeInfo()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static SourceCodeInfo create() => new SourceCodeInfo();
  static PbList<SourceCodeInfo> createRepeated() => new PbList<SourceCodeInfo>();

  List<SourceCodeInfo_Location> get location => getField(1);
}

