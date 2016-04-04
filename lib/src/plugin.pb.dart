///
//  Generated code. Do not modify.
///
library proto2.compiler_plugin;

import 'package:protobuf/protobuf.dart';
import 'descriptor.pb.dart' as proto2;

class CodeGeneratorRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorRequest')
    ..p/*<String>*/(1, 'fileToGenerate', PbFieldType.PS)
    ..a/*<String>*/(2, 'parameter', PbFieldType.OS)
    ..pp/*<proto2.FileDescriptorProto>*/(15, 'protoFile', PbFieldType.PM, proto2.FileDescriptorProto.$checkItem, proto2.FileDescriptorProto.create)
  ;

  CodeGeneratorRequest() : super();
  CodeGeneratorRequest.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CodeGeneratorRequest.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CodeGeneratorRequest clone() => new CodeGeneratorRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CodeGeneratorRequest create() => new CodeGeneratorRequest();
  static PbList<CodeGeneratorRequest> createRepeated() => new PbList<CodeGeneratorRequest>();
  static CodeGeneratorRequest getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCodeGeneratorRequest();
    return _defaultInstance;
  }
  static CodeGeneratorRequest _defaultInstance;
  static void $checkItem(CodeGeneratorRequest v) {
    if (v is !CodeGeneratorRequest) checkItemFailed(v, 'CodeGeneratorRequest');
  }

  List<String> get fileToGenerate => $_get(0, 1, null);

  String get parameter => $_get(1, 2, '');
  void set parameter(String v) { $_setString(1, 2, v); }
  bool hasParameter() => $_has(1, 2);
  void clearParameter() => clearField(2);

  List<proto2.FileDescriptorProto> get protoFile => $_get(2, 15, null);
}

class _ReadonlyCodeGeneratorRequest extends CodeGeneratorRequest with ReadonlyMessageMixin {}

class CodeGeneratorResponse_File extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorResponse_File')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..a/*<String>*/(2, 'insertionPoint', PbFieldType.OS)
    ..a/*<String>*/(15, 'content', PbFieldType.OS)
    ..hasRequiredFields = false
  ;

  CodeGeneratorResponse_File() : super();
  CodeGeneratorResponse_File.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CodeGeneratorResponse_File.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CodeGeneratorResponse_File clone() => new CodeGeneratorResponse_File()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CodeGeneratorResponse_File create() => new CodeGeneratorResponse_File();
  static PbList<CodeGeneratorResponse_File> createRepeated() => new PbList<CodeGeneratorResponse_File>();
  static CodeGeneratorResponse_File getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCodeGeneratorResponse_File();
    return _defaultInstance;
  }
  static CodeGeneratorResponse_File _defaultInstance;
  static void $checkItem(CodeGeneratorResponse_File v) {
    if (v is !CodeGeneratorResponse_File) checkItemFailed(v, 'CodeGeneratorResponse_File');
  }

  String get name => $_get(0, 1, '');
  void set name(String v) { $_setString(0, 1, v); }
  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  String get insertionPoint => $_get(1, 2, '');
  void set insertionPoint(String v) { $_setString(1, 2, v); }
  bool hasInsertionPoint() => $_has(1, 2);
  void clearInsertionPoint() => clearField(2);

  String get content => $_get(2, 15, '');
  void set content(String v) { $_setString(2, 15, v); }
  bool hasContent() => $_has(2, 15);
  void clearContent() => clearField(15);
}

class _ReadonlyCodeGeneratorResponse_File extends CodeGeneratorResponse_File with ReadonlyMessageMixin {}

class CodeGeneratorResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorResponse')
    ..a/*<String>*/(1, 'error', PbFieldType.OS)
    ..pp/*<CodeGeneratorResponse_File>*/(15, 'file', PbFieldType.PM, CodeGeneratorResponse_File.$checkItem, CodeGeneratorResponse_File.create)
    ..hasRequiredFields = false
  ;

  CodeGeneratorResponse() : super();
  CodeGeneratorResponse.fromBuffer(List<int> i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  CodeGeneratorResponse.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  CodeGeneratorResponse clone() => new CodeGeneratorResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CodeGeneratorResponse create() => new CodeGeneratorResponse();
  static PbList<CodeGeneratorResponse> createRepeated() => new PbList<CodeGeneratorResponse>();
  static CodeGeneratorResponse getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyCodeGeneratorResponse();
    return _defaultInstance;
  }
  static CodeGeneratorResponse _defaultInstance;
  static void $checkItem(CodeGeneratorResponse v) {
    if (v is !CodeGeneratorResponse) checkItemFailed(v, 'CodeGeneratorResponse');
  }

  String get error => $_get(0, 1, '');
  void set error(String v) { $_setString(0, 1, v); }
  bool hasError() => $_has(0, 1);
  void clearError() => clearField(1);

  List<CodeGeneratorResponse_File> get file => $_get(1, 15, null);
}

class _ReadonlyCodeGeneratorResponse extends CodeGeneratorResponse with ReadonlyMessageMixin {}

const CodeGeneratorRequest$json = const {
  '1': 'CodeGeneratorRequest',
  '2': const [
    const {'1': 'file_to_generate', '3': 1, '4': 3, '5': 9},
    const {'1': 'parameter', '3': 2, '4': 1, '5': 9},
    const {'1': 'proto_file', '3': 15, '4': 3, '5': 11, '6': '.proto2.FileDescriptorProto'},
  ],
};

const CodeGeneratorResponse$json = const {
  '1': 'CodeGeneratorResponse',
  '2': const [
    const {'1': 'error', '3': 1, '4': 1, '5': 9},
    const {'1': 'file', '3': 15, '4': 3, '5': 11, '6': '.proto2.compiler.CodeGeneratorResponse.File'},
  ],
  '3': const [CodeGeneratorResponse_File$json],
};

const CodeGeneratorResponse_File$json = const {
  '1': 'File',
  '2': const [
    const {'1': 'name', '3': 1, '4': 1, '5': 9},
    const {'1': 'insertion_point', '3': 2, '4': 1, '5': 9},
    const {'1': 'content', '3': 15, '4': 1, '5': 9},
  ],
};

