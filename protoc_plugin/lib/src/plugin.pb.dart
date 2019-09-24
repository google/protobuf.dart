///
//  Generated code. Do not modify.
//  source: plugin.proto
//
// @dart = 2.3
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'descriptor.pb.dart' as $0;

class Version extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Version',
      package: const $pb.PackageName('google.protobuf.compiler'),
      createEmptyInstance: create)
    ..a<$core.int>(1, 'major', $pb.PbFieldType.O3)
    ..a<$core.int>(2, 'minor', $pb.PbFieldType.O3)
    ..a<$core.int>(3, 'patch', $pb.PbFieldType.O3)
    ..aOS(4, 'suffix')
    ..hasRequiredFields = false;

  Version._() : super();
  factory Version() => create();
  factory Version.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Version.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  Version clone() => Version()..mergeFromMessage(this);
  Version copyWith(void Function(Version) updates) =>
      super.copyWith((message) => updates(message as Version));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static Version create() => Version._();
  Version createEmptyInstance() => create();
  static $pb.PbList<Version> createRepeated() => $pb.PbList<Version>();
  @$core.pragma('dart2js:noInline')
  static Version getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Version>(create);
  static Version _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get major => $_getIZ(0);
  @$pb.TagNumber(1)
  set major($core.int v) {
    $_setSignedInt32(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasMajor() => $_has(0);
  @$pb.TagNumber(1)
  void clearMajor() => clearField(1);

  @$pb.TagNumber(2)
  $core.int get minor => $_getIZ(1);
  @$pb.TagNumber(2)
  set minor($core.int v) {
    $_setSignedInt32(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasMinor() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinor() => clearField(2);

  @$pb.TagNumber(3)
  $core.int get patch => $_getIZ(2);
  @$pb.TagNumber(3)
  set patch($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasPatch() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatch() => clearField(3);

  @$pb.TagNumber(4)
  $core.String get suffix => $_getSZ(3);
  @$pb.TagNumber(4)
  set suffix($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasSuffix() => $_has(3);
  @$pb.TagNumber(4)
  void clearSuffix() => clearField(4);
}

class CodeGeneratorRequest extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CodeGeneratorRequest',
      package: const $pb.PackageName('google.protobuf.compiler'),
      createEmptyInstance: create)
    ..pPS(1, 'fileToGenerate')
    ..aOS(2, 'parameter')
    ..aOM<Version>(3, 'compilerVersion', subBuilder: Version.create)
    ..pc<$0.FileDescriptorProto>(15, 'protoFile', $pb.PbFieldType.PM,
        subBuilder: $0.FileDescriptorProto.create);

  CodeGeneratorRequest._() : super();
  factory CodeGeneratorRequest() => create();
  factory CodeGeneratorRequest.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CodeGeneratorRequest.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  CodeGeneratorRequest clone() =>
      CodeGeneratorRequest()..mergeFromMessage(this);
  CodeGeneratorRequest copyWith(void Function(CodeGeneratorRequest) updates) =>
      super.copyWith((message) => updates(message as CodeGeneratorRequest));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorRequest create() => CodeGeneratorRequest._();
  CodeGeneratorRequest createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorRequest> createRepeated() =>
      $pb.PbList<CodeGeneratorRequest>();
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodeGeneratorRequest>(create);
  static CodeGeneratorRequest _defaultInstance;

  @$pb.TagNumber(1)
  $core.List<$core.String> get fileToGenerate => $_getList(0);

  @$pb.TagNumber(2)
  $core.String get parameter => $_getSZ(1);
  @$pb.TagNumber(2)
  set parameter($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasParameter() => $_has(1);
  @$pb.TagNumber(2)
  void clearParameter() => clearField(2);

  @$pb.TagNumber(3)
  Version get compilerVersion => $_getN(2);
  @$pb.TagNumber(3)
  set compilerVersion(Version v) {
    setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCompilerVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompilerVersion() => clearField(3);
  @$pb.TagNumber(3)
  Version ensureCompilerVersion() => $_ensure(2);

  @$pb.TagNumber(15)
  $core.List<$0.FileDescriptorProto> get protoFile => $_getList(3);
}

class CodeGeneratorResponse_File extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      'CodeGeneratorResponse.File',
      package: const $pb.PackageName('google.protobuf.compiler'),
      createEmptyInstance: create)
    ..aOS(1, 'name')
    ..aOS(2, 'insertionPoint')
    ..aOS(15, 'content')
    ..hasRequiredFields = false;

  CodeGeneratorResponse_File._() : super();
  factory CodeGeneratorResponse_File() => create();
  factory CodeGeneratorResponse_File.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CodeGeneratorResponse_File.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  CodeGeneratorResponse_File clone() =>
      CodeGeneratorResponse_File()..mergeFromMessage(this);
  CodeGeneratorResponse_File copyWith(
          void Function(CodeGeneratorResponse_File) updates) =>
      super.copyWith(
          (message) => updates(message as CodeGeneratorResponse_File));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorResponse_File create() => CodeGeneratorResponse_File._();
  CodeGeneratorResponse_File createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorResponse_File> createRepeated() =>
      $pb.PbList<CodeGeneratorResponse_File>();
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorResponse_File getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodeGeneratorResponse_File>(create);
  static CodeGeneratorResponse_File _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => clearField(1);

  @$pb.TagNumber(2)
  $core.String get insertionPoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set insertionPoint($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasInsertionPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearInsertionPoint() => clearField(2);

  @$pb.TagNumber(15)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(15)
  set content($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(15)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(15)
  void clearContent() => clearField(15);
}

class CodeGeneratorResponse extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('CodeGeneratorResponse',
      package: const $pb.PackageName('google.protobuf.compiler'),
      createEmptyInstance: create)
    ..aOS(1, 'error')
    ..pc<CodeGeneratorResponse_File>(15, 'file', $pb.PbFieldType.PM,
        subBuilder: CodeGeneratorResponse_File.create)
    ..hasRequiredFields = false;

  CodeGeneratorResponse._() : super();
  factory CodeGeneratorResponse() => create();
  factory CodeGeneratorResponse.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CodeGeneratorResponse.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);
  CodeGeneratorResponse clone() =>
      CodeGeneratorResponse()..mergeFromMessage(this);
  CodeGeneratorResponse copyWith(
          void Function(CodeGeneratorResponse) updates) =>
      super.copyWith((message) => updates(message as CodeGeneratorResponse));
  $pb.BuilderInfo get info_ => _i;
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorResponse create() => CodeGeneratorResponse._();
  CodeGeneratorResponse createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorResponse> createRepeated() =>
      $pb.PbList<CodeGeneratorResponse>();
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodeGeneratorResponse>(create);
  static CodeGeneratorResponse _defaultInstance;

  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => clearField(1);

  @$pb.TagNumber(15)
  $core.List<CodeGeneratorResponse_File> get file => $_getList(1);
}
