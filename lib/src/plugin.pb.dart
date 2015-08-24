///
//  Generated code. Do not modify.
///
library proto2.compiler_plugin;

import 'package:protobuf/protobuf.dart';
import 'descriptor.pb.dart' as proto2;

class CodeGeneratorRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorRequest')
    ..p(1, 'fileToGenerate', PbFieldType.PS)
    ..a(2, 'parameter', PbFieldType.OS)
    ..pp(15, 'protoFile', PbFieldType.PM, proto2.FileDescriptorProto.$checkItem, proto2.FileDescriptorProto.create)
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

  List<String> get fileToGenerate => getField(1);

  String get parameter => getField(2);
  void set parameter(String v) { setField(2, v); }
  bool hasParameter() => hasField(2);
  void clearParameter() => clearField(2);

  List<proto2.FileDescriptorProto> get protoFile => getField(15);
}

class _ReadonlyCodeGeneratorRequest extends CodeGeneratorRequest with ReadonlyMessageMixin {}

class CodeGeneratorResponse_File extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorResponse_File')
    ..a(1, 'name', PbFieldType.OS)
    ..a(2, 'insertionPoint', PbFieldType.OS)
    ..a(15, 'content', PbFieldType.OS)
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

  String get name => getField(1);
  void set name(String v) { setField(1, v); }
  bool hasName() => hasField(1);
  void clearName() => clearField(1);

  String get insertionPoint => getField(2);
  void set insertionPoint(String v) { setField(2, v); }
  bool hasInsertionPoint() => hasField(2);
  void clearInsertionPoint() => clearField(2);

  String get content => getField(15);
  void set content(String v) { setField(15, v); }
  bool hasContent() => hasField(15);
  void clearContent() => clearField(15);
}

class _ReadonlyCodeGeneratorResponse_File extends CodeGeneratorResponse_File with ReadonlyMessageMixin {}

class CodeGeneratorResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorResponse')
    ..a(1, 'error', PbFieldType.OS)
    ..pp(15, 'file', PbFieldType.PM, CodeGeneratorResponse_File.$checkItem, CodeGeneratorResponse_File.create)
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

  String get error => getField(1);
  void set error(String v) { setField(1, v); }
  bool hasError() => hasField(1);
  void clearError() => clearField(1);

  List<CodeGeneratorResponse_File> get file => getField(15);
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

