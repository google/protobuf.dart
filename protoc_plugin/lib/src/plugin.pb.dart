///
//  Generated code. Do not modify.
//  source: plugin.proto
///
// ignore_for_file: non_constant_identifier_names,library_prefixes,unused_import

// ignore: UNUSED_SHOWN_NAME
import 'dart:core' show int, bool, double, String, List, Map, override;

import 'package:protobuf/protobuf.dart' as $pb;

import 'descriptor.pb.dart' as $0;

class Version extends $pb.GeneratedMessage<Version> {
  static final $pb.BuilderInfo<Version> _i = new $pb.BuilderInfo<Version>(
      'Version',
      package: const $pb.PackageName('google.protobuf.compiler'),
      builder: create)
    ..a<int>(1, 'major', $pb.PbFieldType.O3)
    ..a<int>(2, 'minor', $pb.PbFieldType.O3)
    ..a<int>(3, 'patch', $pb.PbFieldType.O3)
    ..aOS(4, 'suffix')
    ..hasRequiredFields = false;

  Version() : super();
  Version.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Version.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  $pb.BuilderInfo<Version> get info_ => _i;
  static Version create() => new Version();
  static $pb.PbList<Version> createRepeated() => new $pb.PbList<Version>();
  static Version getDefault() => _defaultInstance ??= create()..freeze();
  static Version _defaultInstance;
  static void $checkItem(Version v) {
    if (v is! Version) $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  int get major => $_get(0, 0);
  set major(int v) {
    $_setSignedInt32(0, v);
  }

  bool hasMajor() => $_has(0);
  void clearMajor() => clearField(1);

  int get minor => $_get(1, 0);
  set minor(int v) {
    $_setSignedInt32(1, v);
  }

  bool hasMinor() => $_has(1);
  void clearMinor() => clearField(2);

  int get patch => $_get(2, 0);
  set patch(int v) {
    $_setSignedInt32(2, v);
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

class CodeGeneratorRequest extends $pb.GeneratedMessage<CodeGeneratorRequest> {
  static final $pb.BuilderInfo<CodeGeneratorRequest> _i =
      new $pb.BuilderInfo<CodeGeneratorRequest>('CodeGeneratorRequest',
          package: const $pb.PackageName('google.protobuf.compiler'),
          builder: create)
        ..pPS(1, 'fileToGenerate')
        ..aOS(2, 'parameter')
        ..a<Version>(3, 'compilerVersion', $pb.PbFieldType.OM,
            Version.getDefault, Version.create)
        ..pp<$0.FileDescriptorProto>(15, 'protoFile', $pb.PbFieldType.PM,
            $0.FileDescriptorProto.$checkItem, $0.FileDescriptorProto.create);

  CodeGeneratorRequest() : super();
  CodeGeneratorRequest.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorRequest.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  $pb.BuilderInfo<CodeGeneratorRequest> get info_ => _i;
  static CodeGeneratorRequest create() => new CodeGeneratorRequest();
  static $pb.PbList<CodeGeneratorRequest> createRepeated() =>
      new $pb.PbList<CodeGeneratorRequest>();
  static CodeGeneratorRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static CodeGeneratorRequest _defaultInstance;
  static void $checkItem(CodeGeneratorRequest v) {
    if (v is! CodeGeneratorRequest)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

  List<$0.FileDescriptorProto> get protoFile => $_getList(3);
}

class CodeGeneratorResponse_File
    extends $pb.GeneratedMessage<CodeGeneratorResponse_File> {
  static final $pb.BuilderInfo<CodeGeneratorResponse_File> _i =
      new $pb.BuilderInfo<CodeGeneratorResponse_File>(
          'CodeGeneratorResponse.File',
          package: const $pb.PackageName('google.protobuf.compiler'),
          builder: create)
        ..aOS(1, 'name')
        ..aOS(2, 'insertionPoint')
        ..aOS(15, 'content')
        ..hasRequiredFields = false;

  CodeGeneratorResponse_File() : super();
  CodeGeneratorResponse_File.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorResponse_File.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  $pb.BuilderInfo<CodeGeneratorResponse_File> get info_ => _i;
  static CodeGeneratorResponse_File create() =>
      new CodeGeneratorResponse_File();
  static $pb.PbList<CodeGeneratorResponse_File> createRepeated() =>
      new $pb.PbList<CodeGeneratorResponse_File>();
  static CodeGeneratorResponse_File getDefault() =>
      _defaultInstance ??= create()..freeze();
  static CodeGeneratorResponse_File _defaultInstance;
  static void $checkItem(CodeGeneratorResponse_File v) {
    if (v is! CodeGeneratorResponse_File)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
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

class CodeGeneratorResponse
    extends $pb.GeneratedMessage<CodeGeneratorResponse> {
  static final $pb.BuilderInfo<CodeGeneratorResponse> _i =
      new $pb.BuilderInfo<CodeGeneratorResponse>('CodeGeneratorResponse',
          package: const $pb.PackageName('google.protobuf.compiler'),
          builder: create)
        ..aOS(1, 'error')
        ..pp<CodeGeneratorResponse_File>(
            15,
            'file',
            $pb.PbFieldType.PM,
            CodeGeneratorResponse_File.$checkItem,
            CodeGeneratorResponse_File.create)
        ..hasRequiredFields = false;

  CodeGeneratorResponse() : super();
  CodeGeneratorResponse.fromBuffer(List<int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorResponse.fromJson(String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  $pb.BuilderInfo<CodeGeneratorResponse> get info_ => _i;
  static CodeGeneratorResponse create() => new CodeGeneratorResponse();
  static $pb.PbList<CodeGeneratorResponse> createRepeated() =>
      new $pb.PbList<CodeGeneratorResponse>();
  static CodeGeneratorResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static CodeGeneratorResponse _defaultInstance;
  static void $checkItem(CodeGeneratorResponse v) {
    if (v is! CodeGeneratorResponse)
      $pb.checkItemFailed(v, _i.qualifiedMessageName);
  }

  String get error => $_getS(0, '');
  set error(String v) {
    $_setString(0, v);
  }

  bool hasError() => $_has(0);
  void clearError() => clearField(1);

  List<CodeGeneratorResponse_File> get file => $_getList(1);
}
