///
//  Generated code. Do not modify.
///
// ignore_for_file: non_constant_identifier_names,library_prefixes
library google.protobuf.compiler_plugin;

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, override;

import 'package:protobuf/protobuf.dart';

import 'descriptor.pb.dart' as $google$protobuf;

class Version extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('Version')
    ..a<int>(1, 'major', PbFieldType.O3)
    ..a<int>(2, 'minor', PbFieldType.O3)
    ..a<int>(3, 'patch', PbFieldType.O3)
    ..aOS(4, 'suffix')
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

  int get major => $_get(0, 0);
  set major(int v) {
    $_setUnsignedInt32(0, v);
  }

  bool hasMajor() => $_has(0);
  void clearMajor() => clearField(1);

  int get minor => $_get(1, 0);
  set minor(int v) {
    $_setUnsignedInt32(1, v);
  }

  bool hasMinor() => $_has(1);
  void clearMinor() => clearField(2);

  int get patch => $_get(2, 0);
  set patch(int v) {
    $_setUnsignedInt32(2, v);
  }

  bool hasPatch() => $_has(2);
  void clearPatch() => clearField(3);

  String get suffix => $_getS(3, '');
  set suffix(String v) {
    $_setString(3, v);
  }

  bool hasSuffix() => $_has(3);
  void clearSuffix() => clearField(4);
}

class _ReadonlyVersion extends Version with ReadonlyMessageMixin {}

class CodeGeneratorRequest extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorRequest')
    ..pPS(1, 'fileToGenerate')
    ..aOS(2, 'parameter')
    ..a<Version>(3, 'compilerVersion', PbFieldType.OM, Version.getDefault,
        Version.create)
    ..pp<$google$protobuf.FileDescriptorProto>(
        15,
        'protoFile',
        PbFieldType.PM,
        $google$protobuf.FileDescriptorProto.$checkItem,
        $google$protobuf.FileDescriptorProto.create);

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

  List<String> get fileToGenerate => $_getList(0);

  String get parameter => $_getS(1, '');
  set parameter(String v) {
    $_setString(1, v);
  }

  bool hasParameter() => $_has(1);
  void clearParameter() => clearField(2);

  Version get compilerVersion => $_getN(2);
  set compilerVersion(Version v) {
    setField(3, v);
  }

  bool hasCompilerVersion() => $_has(2);
  void clearCompilerVersion() => clearField(3);

  List<$google$protobuf.FileDescriptorProto> get protoFile => $_getList(3);
}

class _ReadonlyCodeGeneratorRequest extends CodeGeneratorRequest
    with ReadonlyMessageMixin {}

class CodeGeneratorResponse_File extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorResponse_File')
    ..aOS(1, 'name')
    ..aOS(2, 'insertionPoint')
    ..aOS(15, 'content')
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

  String get name => $_getS(0, '');
  set name(String v) {
    $_setString(0, v);
  }

  bool hasName() => $_has(0);
  void clearName() => clearField(1);

  String get insertionPoint => $_getS(1, '');
  set insertionPoint(String v) {
    $_setString(1, v);
  }

  bool hasInsertionPoint() => $_has(1);
  void clearInsertionPoint() => clearField(2);

  String get content => $_getS(2, '');
  set content(String v) {
    $_setString(2, v);
  }

  bool hasContent() => $_has(2);
  void clearContent() => clearField(15);
}

class _ReadonlyCodeGeneratorResponse_File extends CodeGeneratorResponse_File
    with ReadonlyMessageMixin {}

class CodeGeneratorResponse extends GeneratedMessage {
  static final BuilderInfo _i = new BuilderInfo('CodeGeneratorResponse')
    ..aOS(1, 'error')
    ..pp<CodeGeneratorResponse_File>(
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

  String get error => $_getS(0, '');
  set error(String v) {
    $_setString(0, v);
  }

  bool hasError() => $_has(0);
  void clearError() => clearField(1);

  List<CodeGeneratorResponse_File> get file => $_getList(1);
}

class _ReadonlyCodeGeneratorResponse extends CodeGeneratorResponse
    with ReadonlyMessageMixin {}
