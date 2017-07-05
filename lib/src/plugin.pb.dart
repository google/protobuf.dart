///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names
// ignore_for_file: library_prefixes
library google.protobuf.compiler_plugin;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;
import 'package:protobuf/protobuf.dart';

import 'descriptor.pb.dart' as google$protobuf;

class Version extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Version')
    ..a/*<int>*/(1, 'major', PbFieldType.O3)
    ..a/*<int>*/(2, 'minor', PbFieldType.O3)
    ..a/*<int>*/(3, 'patch', PbFieldType.O3)
    ..a/*<String>*/(4, 'suffix', PbFieldType.OS)
    ..hasRequiredFields = false;

  Version() : super();
  Version.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Version.fromJson(String i, [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Version clone() => new Version()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static Version create() => new Version();
  static PbList<Version> createRepeated() => new PbList<Version>();
  static Version getDefault() {
    if (_defaultInstance == null) _defaultInstance = new _ReadonlyVersion();
    return _defaultInstance;
  }

  static Version _defaultInstance;
  static void $checkItem(Version v) {
    if (v is! Version) checkItemFailed(v, 'Version');
  }

  int get major => $_get(0, 1, 0);
  set major(int v) {
    $_setUnsignedInt32(0, 1, v);
  }

  bool hasMajor() => $_has(0, 1);
  void clearMajor() => clearField(1);

  int get minor => $_get(1, 2, 0);
  set minor(int v) {
    $_setUnsignedInt32(1, 2, v);
  }

  bool hasMinor() => $_has(1, 2);
  void clearMinor() => clearField(2);

  int get patch => $_get(2, 3, 0);
  set patch(int v) {
    $_setUnsignedInt32(2, 3, v);
  }

  bool hasPatch() => $_has(2, 3);
  void clearPatch() => clearField(3);

  String get suffix => $_get(3, 4, '');
  set suffix(String v) {
    $_setString(3, 4, v);
  }

  bool hasSuffix() => $_has(3, 4);
  void clearSuffix() => clearField(4);
}

class _ReadonlyVersion extends Version with ReadonlyMessageMixin {}

class CodeGeneratorRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorRequest')
    ..p/*<String>*/(1, 'fileToGenerate', PbFieldType.PS)
    ..a/*<String>*/(2, 'parameter', PbFieldType.OS)
    ..a/*<Version>*/(3, 'compilerVersion', PbFieldType.OM, Version.getDefault,
        Version.create)
    ..pp/*<google$protobuf.FileDescriptorProto>*/(
        15,
        'protoFile',
        PbFieldType.PM,
        google$protobuf.FileDescriptorProto.$checkItem,
        google$protobuf.FileDescriptorProto.create);

  CodeGeneratorRequest() : super();
  CodeGeneratorRequest.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorRequest.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  CodeGeneratorRequest clone() =>
      new CodeGeneratorRequest()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CodeGeneratorRequest create() => new CodeGeneratorRequest();
  static PbList<CodeGeneratorRequest> createRepeated() =>
      new PbList<CodeGeneratorRequest>();
  static CodeGeneratorRequest getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyCodeGeneratorRequest();
    return _defaultInstance;
  }

  static CodeGeneratorRequest _defaultInstance;
  static void $checkItem(CodeGeneratorRequest v) {
    if (v is! CodeGeneratorRequest) checkItemFailed(v, 'CodeGeneratorRequest');
  }

  List<String> get fileToGenerate => $_get(0, 1, null);

  String get parameter => $_get(1, 2, '');
  set parameter(String v) {
    $_setString(1, 2, v);
  }

  bool hasParameter() => $_has(1, 2);
  void clearParameter() => clearField(2);

  Version get compilerVersion => $_get(2, 3, null);
  set compilerVersion(Version v) {
    setField(3, v);
  }

  bool hasCompilerVersion() => $_has(2, 3);
  void clearCompilerVersion() => clearField(3);

  List<google$protobuf.FileDescriptorProto> get protoFile => $_get(3, 15, null);
}

class _ReadonlyCodeGeneratorRequest extends CodeGeneratorRequest
    with ReadonlyMessageMixin {}

class CodeGeneratorResponse_File extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorResponse_File')
    ..a/*<String>*/(1, 'name', PbFieldType.OS)
    ..a/*<String>*/(2, 'insertionPoint', PbFieldType.OS)
    ..a/*<String>*/(15, 'content', PbFieldType.OS)
    ..hasRequiredFields = false;

  CodeGeneratorResponse_File() : super();
  CodeGeneratorResponse_File.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorResponse_File.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  CodeGeneratorResponse_File clone() =>
      new CodeGeneratorResponse_File()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CodeGeneratorResponse_File create() =>
      new CodeGeneratorResponse_File();
  static PbList<CodeGeneratorResponse_File> createRepeated() =>
      new PbList<CodeGeneratorResponse_File>();
  static CodeGeneratorResponse_File getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyCodeGeneratorResponse_File();
    return _defaultInstance;
  }

  static CodeGeneratorResponse_File _defaultInstance;
  static void $checkItem(CodeGeneratorResponse_File v) {
    if (v is! CodeGeneratorResponse_File)
      checkItemFailed(v, 'CodeGeneratorResponse_File');
  }

  String get name => $_get(0, 1, '');
  set name(String v) {
    $_setString(0, 1, v);
  }

  bool hasName() => $_has(0, 1);
  void clearName() => clearField(1);

  String get insertionPoint => $_get(1, 2, '');
  set insertionPoint(String v) {
    $_setString(1, 2, v);
  }

  bool hasInsertionPoint() => $_has(1, 2);
  void clearInsertionPoint() => clearField(2);

  String get content => $_get(2, 15, '');
  set content(String v) {
    $_setString(2, 15, v);
  }

  bool hasContent() => $_has(2, 15);
  void clearContent() => clearField(15);
}

class _ReadonlyCodeGeneratorResponse_File extends CodeGeneratorResponse_File
    with ReadonlyMessageMixin {}

class CodeGeneratorResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorResponse')
    ..a/*<String>*/(1, 'error', PbFieldType.OS)
    ..pp/*<CodeGeneratorResponse_File>*/(
        15,
        'file',
        PbFieldType.PM,
        CodeGeneratorResponse_File.$checkItem,
        CodeGeneratorResponse_File.create)
    ..hasRequiredFields = false;

  CodeGeneratorResponse() : super();
  CodeGeneratorResponse.fromBuffer(List<int> i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorResponse.fromJson(String i,
      [ExtensionRegistry r = ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  CodeGeneratorResponse clone() =>
      new CodeGeneratorResponse()..mergeFromMessage(this);
  BuilderInfo get info_ => _i;
  static CodeGeneratorResponse create() => new CodeGeneratorResponse();
  static PbList<CodeGeneratorResponse> createRepeated() =>
      new PbList<CodeGeneratorResponse>();
  static CodeGeneratorResponse getDefault() {
    if (_defaultInstance == null)
      _defaultInstance = new _ReadonlyCodeGeneratorResponse();
    return _defaultInstance;
  }

  static CodeGeneratorResponse _defaultInstance;
  static void $checkItem(CodeGeneratorResponse v) {
    if (v is! CodeGeneratorResponse)
      checkItemFailed(v, 'CodeGeneratorResponse');
  }

  String get error => $_get(0, 1, '');
  set error(String v) {
    $_setString(0, 1, v);
  }

  bool hasError() => $_has(0, 1);
  void clearError() => clearField(1);

  List<CodeGeneratorResponse_File> get file => $_get(1, 15, null);
}

class _ReadonlyCodeGeneratorResponse extends CodeGeneratorResponse
    with ReadonlyMessageMixin {}
