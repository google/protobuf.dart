///
//  Generated code. Do not modify.
//  source: plugin.proto
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name

import 'dart:core' as $core
    show bool, Deprecated, double, int, List, Map, override, String;

import 'package:protobuf/protobuf.dart' as $pb;

import 'descriptor.pb.dart' as $0;

class Version extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Version',
      package: const $pb.PackageName('google.protobuf.compiler'))
    ..a<$core.int>(1, 'major', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'minor', $pb.PbFieldType.O3)
    ..a<$core.int>(3, 'patch', $pb.PbFieldType.O3)
    ..aOS(4, 'suffix')
    ..hasRequiredFields = false;

  Version() : super();
  Version.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  Version.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  Version clone() => Version()..mergeFromMessage(this);
  Version copyWith(void Function(Version) updates) =>
      super.copyWith((message) => updates(message as Version));
  $pb.BuilderInfo get info_ => _i;
  static Version create() => Version();
  Version createEmptyInstance() => create();
  static $pb.PbList<Version> createRepeated() => $pb.PbList<Version>();
  static Version getDefault() => _defaultInstance ??= create()..freeze();
  static Version _defaultInstance;

  $core.int get major => $_get(0, 0);
  set major($core.int v) {
    $_setSignedInt32(0, v);
  }

  $core.bool hasMajor() => $_has(0);
  void clearMajor() => clearField(1);

  $core.int get minor => $_get(1, 0);
  set minor($core.int v) {
    $_setSignedInt32(1, v);
  }

  $core.bool hasMinor() => $_has(1);
  void clearMinor() => clearField(2);

  $core.int get patch => $_get(2, 0);
  set patch($core.int v) {
    $_setSignedInt32(2, v);
  }

  $core.bool hasPatch() => $_has(2);
  void clearPatch() => clearField(3);

  $core.String get suffix => $_getS(3, '');
  set suffix($core.String v) {
    $_setString(3, v);
  }

  $core.bool hasSuffix() => $_has(3);
  void clearSuffix() => clearField(4);
}

class CodeGeneratorRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CodeGeneratorRequest',
      package: const $pb.PackageName('google.protobuf.compiler'))
    ..pPS(1, 'fileToGenerate')
    ..aOS(2, 'parameter')
    ..a<Version>(3, 'compilerVersion', $pb.PbFieldType.OM, Version.getDefault,
        Version.create)
    ..pc<$0.FileDescriptorProto>(
        15, 'protoFile', $pb.PbFieldType.PM, $0.FileDescriptorProto.create);

  CodeGeneratorRequest() : super();
  CodeGeneratorRequest.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorRequest.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  CodeGeneratorRequest clone() =>
      CodeGeneratorRequest()..mergeFromMessage(this);
  CodeGeneratorRequest copyWith(void Function(CodeGeneratorRequest) updates) =>
      super.copyWith((message) => updates(message as CodeGeneratorRequest));
  $pb.BuilderInfo get info_ => _i;
  static CodeGeneratorRequest create() => CodeGeneratorRequest();
  CodeGeneratorRequest createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorRequest> createRepeated() =>
      $pb.PbList<CodeGeneratorRequest>();
  static CodeGeneratorRequest getDefault() =>
      _defaultInstance ??= create()..freeze();
  static CodeGeneratorRequest _defaultInstance;

  $core.List<$core.String> get fileToGenerate => $_getList(0);

  $core.String get parameter => $_getS(1, '');
  set parameter($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasParameter() => $_has(1);
  void clearParameter() => clearField(2);

  Version get compilerVersion => $_getN(2);
  set compilerVersion(Version v) {
    setField(3, v);
  }

  $core.bool hasCompilerVersion() => $_has(2);
  void clearCompilerVersion() => clearField(3);

  $core.List<$0.FileDescriptorProto> get protoFile => $_getList(3);
}

class CodeGeneratorResponse_File extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'CodeGeneratorResponse.File',
      package: const $pb.PackageName('google.protobuf.compiler'))
    ..aOS(1, 'name')
    ..aOS(2, 'insertionPoint')
    ..aOS(15, 'content')
    ..hasRequiredFields = false;

  CodeGeneratorResponse_File() : super();
  CodeGeneratorResponse_File.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorResponse_File.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  CodeGeneratorResponse_File clone() =>
      CodeGeneratorResponse_File()..mergeFromMessage(this);
  CodeGeneratorResponse_File copyWith(
          void Function(CodeGeneratorResponse_File) updates) =>
      super.copyWith(
          (message) => updates(message as CodeGeneratorResponse_File));
  $pb.BuilderInfo get info_ => _i;
  static CodeGeneratorResponse_File create() => CodeGeneratorResponse_File();
  CodeGeneratorResponse_File createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorResponse_File> createRepeated() =>
      $pb.PbList<CodeGeneratorResponse_File>();
  static CodeGeneratorResponse_File getDefault() =>
      _defaultInstance ??= create()..freeze();
  static CodeGeneratorResponse_File _defaultInstance;

  $core.String get name => $_getS(0, '');
  set name($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasName() => $_has(0);
  void clearName() => clearField(1);

  $core.String get insertionPoint => $_getS(1, '');
  set insertionPoint($core.String v) {
    $_setString(1, v);
  }

  $core.bool hasInsertionPoint() => $_has(1);
  void clearInsertionPoint() => clearField(2);

  $core.String get content => $_getS(2, '');
  set content($core.String v) {
    $_setString(2, v);
  }

  $core.bool hasContent() => $_has(2);
  void clearContent() => clearField(15);
}

class CodeGeneratorResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CodeGeneratorResponse',
      package: const $pb.PackageName('google.protobuf.compiler'))
    ..aOS(1, 'error')
    ..pc<CodeGeneratorResponse_File>(
        15, 'file', $pb.PbFieldType.PM, CodeGeneratorResponse_File.create)
    ..hasRequiredFields = false;

  CodeGeneratorResponse() : super();
  CodeGeneratorResponse.fromBuffer($core.List<$core.int> i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromBuffer(i, r);
  CodeGeneratorResponse.fromJson($core.String i,
      [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY])
      : super.fromJson(i, r);
  CodeGeneratorResponse clone() =>
      CodeGeneratorResponse()..mergeFromMessage(this);
  CodeGeneratorResponse copyWith(
          void Function(CodeGeneratorResponse) updates) =>
      super.copyWith((message) => updates(message as CodeGeneratorResponse));
  $pb.BuilderInfo get info_ => _i;
  static CodeGeneratorResponse create() => CodeGeneratorResponse();
  CodeGeneratorResponse createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorResponse> createRepeated() =>
      $pb.PbList<CodeGeneratorResponse>();
  static CodeGeneratorResponse getDefault() =>
      _defaultInstance ??= create()..freeze();
  static CodeGeneratorResponse _defaultInstance;

  $core.String get error => $_getS(0, '');
  set error($core.String v) {
    $_setString(0, v);
  }

  $core.bool hasError() => $_has(0);
  void clearError() => clearField(1);

  $core.List<CodeGeneratorResponse_File> get file => $_getList(1);
}
