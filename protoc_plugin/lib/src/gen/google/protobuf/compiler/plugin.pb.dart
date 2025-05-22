//
//  Generated code. Do not modify.
//  source: google/protobuf/compiler/plugin.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names

import 'dart:core' as $core;

import 'package:fixnum/fixnum.dart' as $fixnum;
import 'package:protobuf/protobuf.dart' as $pb;

import '../descriptor.pb.dart' as $2;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'plugin.pbenum.dart';

/// The version number of protocol compiler.
class Version extends $pb.GeneratedMessage {
  factory Version({
    $core.int? major,
    $core.int? minor,
    $core.int? patch,
    $core.String? suffix,
  }) {
    final result = create();
    if (major != null) result.major = major;
    if (minor != null) result.minor = minor;
    if (patch != null) result.patch = patch;
    if (suffix != null) result.suffix = suffix;
    return result;
  }

  Version._();

  factory Version.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Version.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Version',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'google.protobuf.compiler'),
      createEmptyInstance: create)
    ..a<$core.int>(1, _omitFieldNames ? '' : 'major', $pb.PbFieldType.O3)
    ..a<$core.int>(2, _omitFieldNames ? '' : 'minor', $pb.PbFieldType.O3)
    ..a<$core.int>(3, _omitFieldNames ? '' : 'patch', $pb.PbFieldType.O3)
    ..aOS(4, _omitFieldNames ? '' : 'suffix')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Version clone() => Version()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Version copyWith(void Function(Version) updates) =>
      super.copyWith((message) => updates(message as Version)) as Version;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Version create() => Version._();
  @$core.override
  Version createEmptyInstance() => create();
  static $pb.PbList<Version> createRepeated() => $pb.PbList<Version>();
  @$core.pragma('dart2js:noInline')
  static Version getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Version>(create);
  static Version? _defaultInstance;

  @$pb.TagNumber(1)
  $core.int get major => $_getIZ(0);
  @$pb.TagNumber(1)
  set major($core.int value) => $_setSignedInt32(0, value);
  @$pb.TagNumber(1)
  $core.bool hasMajor() => $_has(0);
  @$pb.TagNumber(1)
  void clearMajor() => $_clearField(1);

  @$pb.TagNumber(2)
  $core.int get minor => $_getIZ(1);
  @$pb.TagNumber(2)
  set minor($core.int value) => $_setSignedInt32(1, value);
  @$pb.TagNumber(2)
  $core.bool hasMinor() => $_has(1);
  @$pb.TagNumber(2)
  void clearMinor() => $_clearField(2);

  @$pb.TagNumber(3)
  $core.int get patch => $_getIZ(2);
  @$pb.TagNumber(3)
  set patch($core.int value) => $_setSignedInt32(2, value);
  @$pb.TagNumber(3)
  $core.bool hasPatch() => $_has(2);
  @$pb.TagNumber(3)
  void clearPatch() => $_clearField(3);

  /// A suffix for alpha, beta or rc release, e.g., "alpha-1", "rc2". It should
  /// be empty for mainline stable releases.
  @$pb.TagNumber(4)
  $core.String get suffix => $_getSZ(3);
  @$pb.TagNumber(4)
  set suffix($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasSuffix() => $_has(3);
  @$pb.TagNumber(4)
  void clearSuffix() => $_clearField(4);
}

/// An encoded CodeGeneratorRequest is written to the plugin's stdin.
class CodeGeneratorRequest extends $pb.GeneratedMessage {
  factory CodeGeneratorRequest({
    $core.Iterable<$core.String>? fileToGenerate,
    $core.String? parameter,
    Version? compilerVersion,
    $core.Iterable<$2.FileDescriptorProto>? protoFile,
    $core.Iterable<$2.FileDescriptorProto>? sourceFileDescriptors,
  }) {
    final result = create();
    if (fileToGenerate != null) result.fileToGenerate.addAll(fileToGenerate);
    if (parameter != null) result.parameter = parameter;
    if (compilerVersion != null) result.compilerVersion = compilerVersion;
    if (protoFile != null) result.protoFile.addAll(protoFile);
    return result;
  }

  CodeGeneratorRequest._();

  factory CodeGeneratorRequest.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CodeGeneratorRequest.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CodeGeneratorRequest',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'google.protobuf.compiler'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'fileToGenerate')
    ..aOS(2, _omitFieldNames ? '' : 'parameter')
    ..aOM<Version>(3, _omitFieldNames ? '' : 'compilerVersion',
        subBuilder: Version.create)
    ..pc<$2.FileDescriptorProto>(
        15, _omitFieldNames ? '' : 'protoFile', $pb.PbFieldType.PM,
        subBuilder: $2.FileDescriptorProto.create)
    ..pc<$2.FileDescriptorProto>(
        17, _omitFieldNames ? '' : 'sourceFileDescriptors', $pb.PbFieldType.PM,
        subBuilder: $2.FileDescriptorProto.create);

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodeGeneratorRequest clone() =>
      CodeGeneratorRequest()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodeGeneratorRequest copyWith(void Function(CodeGeneratorRequest) updates) =>
      super.copyWith((message) => updates(message as CodeGeneratorRequest))
          as CodeGeneratorRequest;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CodeGeneratorRequest create() => CodeGeneratorRequest._();
  @$core.override
  CodeGeneratorRequest createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorRequest> createRepeated() =>
      $pb.PbList<CodeGeneratorRequest>();
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorRequest getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodeGeneratorRequest>(create);
  static CodeGeneratorRequest? _defaultInstance;

  /// The .proto files that were explicitly listed on the command-line.  The
  /// code generator should generate code only for these files.  Each file's
  /// descriptor will be included in proto_file, below.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get fileToGenerate => $_getList(0);

  /// The generator parameter passed on the command-line.
  @$pb.TagNumber(2)
  $core.String get parameter => $_getSZ(1);
  @$pb.TagNumber(2)
  set parameter($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasParameter() => $_has(1);
  @$pb.TagNumber(2)
  void clearParameter() => $_clearField(2);

  /// The version number of protocol compiler.
  @$pb.TagNumber(3)
  Version get compilerVersion => $_getN(2);
  @$pb.TagNumber(3)
  set compilerVersion(Version value) => $_setField(3, value);
  @$pb.TagNumber(3)
  $core.bool hasCompilerVersion() => $_has(2);
  @$pb.TagNumber(3)
  void clearCompilerVersion() => $_clearField(3);
  @$pb.TagNumber(3)
  Version ensureCompilerVersion() => $_ensure(2);

  /// FileDescriptorProtos for all files in files_to_generate and everything
  /// they import.  The files will appear in topological order, so each file
  /// appears before any file that imports it.
  ///
  /// Note: the files listed in files_to_generate will include runtime-retention
  /// options only, but all other files will include source-retention options.
  /// The source_file_descriptors field below is available in case you need
  /// source-retention options for files_to_generate.
  ///
  /// protoc guarantees that all proto_files will be written after
  /// the fields above, even though this is not technically guaranteed by the
  /// protobuf wire format.  This theoretically could allow a plugin to stream
  /// in the FileDescriptorProtos and handle them one by one rather than read
  /// the entire set into memory at once.  However, as of this writing, this
  /// is not similarly optimized on protoc's end -- it will store all fields in
  /// memory at once before sending them to the plugin.
  ///
  /// Type names of fields and extensions in the FileDescriptorProto are always
  /// fully qualified.
  @$pb.TagNumber(15)
  $pb.PbList<$2.FileDescriptorProto> get protoFile => $_getList(3);

  /// File descriptors with all options, including source-retention options.
  /// These descriptors are only provided for the files listed in
  /// files_to_generate.
  @$pb.TagNumber(17)
  $pb.PbList<$2.FileDescriptorProto> get sourceFileDescriptors => $_getList(4);
}

/// Represents a single generated file.
class CodeGeneratorResponse_File extends $pb.GeneratedMessage {
  factory CodeGeneratorResponse_File({
    $core.String? name,
    $core.String? insertionPoint,
    $core.String? content,
    $2.GeneratedCodeInfo? generatedCodeInfo,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (insertionPoint != null) result.insertionPoint = insertionPoint;
    if (content != null) result.content = content;
    if (generatedCodeInfo != null) result.generatedCodeInfo = generatedCodeInfo;
    return result;
  }

  CodeGeneratorResponse_File._();

  factory CodeGeneratorResponse_File.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CodeGeneratorResponse_File.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CodeGeneratorResponse.File',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'google.protobuf.compiler'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'insertionPoint')
    ..aOS(15, _omitFieldNames ? '' : 'content')
    ..aOM<$2.GeneratedCodeInfo>(16, _omitFieldNames ? '' : 'generatedCodeInfo',
        subBuilder: $2.GeneratedCodeInfo.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodeGeneratorResponse_File clone() =>
      CodeGeneratorResponse_File()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodeGeneratorResponse_File copyWith(
          void Function(CodeGeneratorResponse_File) updates) =>
      super.copyWith(
              (message) => updates(message as CodeGeneratorResponse_File))
          as CodeGeneratorResponse_File;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CodeGeneratorResponse_File create() => CodeGeneratorResponse_File._();
  @$core.override
  CodeGeneratorResponse_File createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorResponse_File> createRepeated() =>
      $pb.PbList<CodeGeneratorResponse_File>();
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorResponse_File getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodeGeneratorResponse_File>(create);
  static CodeGeneratorResponse_File? _defaultInstance;

  /// The file name, relative to the output directory.  The name must not
  /// contain "." or ".." components and must be relative, not be absolute (so,
  /// the file cannot lie outside the output directory).  "/" must be used as
  /// the path separator, not "\".
  ///
  /// If the name is omitted, the content will be appended to the previous
  /// file.  This allows the generator to break large files into small chunks,
  /// and allows the generated text to be streamed back to protoc so that large
  /// files need not reside completely in memory at one time.  Note that as of
  /// this writing protoc does not optimize for this -- it will read the entire
  /// CodeGeneratorResponse before writing files to disk.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// If non-empty, indicates that the named file should already exist, and the
  /// content here is to be inserted into that file at a defined insertion
  /// point.  This feature allows a code generator to extend the output
  /// produced by another code generator.  The original generator may provide
  /// insertion points by placing special annotations in the file that look
  /// like:
  ///   @@protoc_insertion_point(NAME)
  /// The annotation can have arbitrary text before and after it on the line,
  /// which allows it to be placed in a comment.  NAME should be replaced with
  /// an identifier naming the point -- this is what other generators will use
  /// as the insertion_point.  Code inserted at this point will be placed
  /// immediately above the line containing the insertion point (thus multiple
  /// insertions to the same point will come out in the order they were added).
  /// The double-@ is intended to make it unlikely that the generated code
  /// could contain things that look like insertion points by accident.
  ///
  /// For example, the C++ code generator places the following line in the
  /// .pb.h files that it generates:
  ///   // @@protoc_insertion_point(namespace_scope)
  /// This line appears within the scope of the file's package namespace, but
  /// outside of any particular class.  Another plugin can then specify the
  /// insertion_point "namespace_scope" to generate additional classes or
  /// other declarations that should be placed in this scope.
  ///
  /// Note that if the line containing the insertion point begins with
  /// whitespace, the same whitespace will be added to every line of the
  /// inserted text.  This is useful for languages like Python, where
  /// indentation matters.  In these languages, the insertion point comment
  /// should be indented the same amount as any inserted code will need to be
  /// in order to work correctly in that context.
  ///
  /// The code generator that generates the initial file and the one which
  /// inserts into it must both run as part of a single invocation of protoc.
  /// Code generators are executed in the order in which they appear on the
  /// command line.
  ///
  /// If |insertion_point| is present, |name| must also be present.
  @$pb.TagNumber(2)
  $core.String get insertionPoint => $_getSZ(1);
  @$pb.TagNumber(2)
  set insertionPoint($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasInsertionPoint() => $_has(1);
  @$pb.TagNumber(2)
  void clearInsertionPoint() => $_clearField(2);

  /// The file contents.
  @$pb.TagNumber(15)
  $core.String get content => $_getSZ(2);
  @$pb.TagNumber(15)
  set content($core.String value) => $_setString(2, value);
  @$pb.TagNumber(15)
  $core.bool hasContent() => $_has(2);
  @$pb.TagNumber(15)
  void clearContent() => $_clearField(15);

  /// Information describing the file content being inserted. If an insertion
  /// point is used, this information will be appropriately offset and inserted
  /// into the code generation metadata for the generated files.
  @$pb.TagNumber(16)
  $2.GeneratedCodeInfo get generatedCodeInfo => $_getN(3);
  @$pb.TagNumber(16)
  set generatedCodeInfo($2.GeneratedCodeInfo value) => $_setField(16, value);
  @$pb.TagNumber(16)
  $core.bool hasGeneratedCodeInfo() => $_has(3);
  @$pb.TagNumber(16)
  void clearGeneratedCodeInfo() => $_clearField(16);
  @$pb.TagNumber(16)
  $2.GeneratedCodeInfo ensureGeneratedCodeInfo() => $_ensure(3);
}

/// The plugin writes an encoded CodeGeneratorResponse to stdout.
class CodeGeneratorResponse extends $pb.GeneratedMessage {
  factory CodeGeneratorResponse({
    $core.String? error,
    $fixnum.Int64? supportedFeatures,
    $core.int? minimumEdition,
    $core.int? maximumEdition,
    $core.Iterable<CodeGeneratorResponse_File>? file,
  }) {
    final result = create();
    if (error != null) result.error = error;
    if (supportedFeatures != null) result.supportedFeatures = supportedFeatures;
    if (file != null) result.file.addAll(file);
    return result;
  }

  CodeGeneratorResponse._();

  factory CodeGeneratorResponse.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory CodeGeneratorResponse.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CodeGeneratorResponse',
      package: const $pb.PackageName(
          _omitMessageNames ? '' : 'google.protobuf.compiler'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'error')
    ..a<$fixnum.Int64>(
        2, _omitFieldNames ? '' : 'supportedFeatures', $pb.PbFieldType.OU6,
        defaultOrMaker: $fixnum.Int64.ZERO)
    ..a<$core.int>(
        3, _omitFieldNames ? '' : 'minimumEdition', $pb.PbFieldType.O3)
    ..a<$core.int>(
        4, _omitFieldNames ? '' : 'maximumEdition', $pb.PbFieldType.O3)
    ..pc<CodeGeneratorResponse_File>(
        15, _omitFieldNames ? '' : 'file', $pb.PbFieldType.PM,
        subBuilder: CodeGeneratorResponse_File.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodeGeneratorResponse clone() =>
      CodeGeneratorResponse()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CodeGeneratorResponse copyWith(
          void Function(CodeGeneratorResponse) updates) =>
      super.copyWith((message) => updates(message as CodeGeneratorResponse))
          as CodeGeneratorResponse;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CodeGeneratorResponse create() => CodeGeneratorResponse._();
  @$core.override
  CodeGeneratorResponse createEmptyInstance() => create();
  static $pb.PbList<CodeGeneratorResponse> createRepeated() =>
      $pb.PbList<CodeGeneratorResponse>();
  @$core.pragma('dart2js:noInline')
  static CodeGeneratorResponse getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CodeGeneratorResponse>(create);
  static CodeGeneratorResponse? _defaultInstance;

  /// Error message.  If non-empty, code generation failed.  The plugin process
  /// should exit with status code zero even if it reports an error in this way.
  ///
  /// This should be used to indicate errors in .proto files which prevent the
  /// code generator from generating correct code.  Errors which indicate a
  /// problem in protoc itself -- such as the input CodeGeneratorRequest being
  /// unparseable -- should be reported by writing a message to stderr and
  /// exiting with a non-zero status code.
  @$pb.TagNumber(1)
  $core.String get error => $_getSZ(0);
  @$pb.TagNumber(1)
  set error($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasError() => $_has(0);
  @$pb.TagNumber(1)
  void clearError() => $_clearField(1);

  /// A bitmask of supported features that the code generator supports.
  /// This is a bitwise "or" of values from the Feature enum.
  @$pb.TagNumber(2)
  $fixnum.Int64 get supportedFeatures => $_getI64(1);
  @$pb.TagNumber(2)
  set supportedFeatures($fixnum.Int64 value) => $_setInt64(1, value);
  @$pb.TagNumber(2)
  $core.bool hasSupportedFeatures() => $_has(1);
  @$pb.TagNumber(2)
  void clearSupportedFeatures() => $_clearField(2);

  /// The minimum edition this plugin supports.  This will be treated as an
  /// Edition enum, but we want to allow unknown values.  It should be specified
  /// according the edition enum value, *not* the edition number.  Only takes
  /// effect for plugins that have FEATURE_SUPPORTS_EDITIONS set.
  @$pb.TagNumber(3)
  $core.int get minimumEdition => $_getIZ(2);
  @$pb.TagNumber(3)
  set minimumEdition($core.int v) {
    $_setSignedInt32(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasMinimumEdition() => $_has(2);
  @$pb.TagNumber(3)
  void clearMinimumEdition() => $_clearField(3);

  /// The maximum edition this plugin supports.  This will be treated as an
  /// Edition enum, but we want to allow unknown values.  It should be specified
  /// according the edition enum value, *not* the edition number.  Only takes
  /// effect for plugins that have FEATURE_SUPPORTS_EDITIONS set.
  @$pb.TagNumber(4)
  $core.int get maximumEdition => $_getIZ(3);
  @$pb.TagNumber(4)
  set maximumEdition($core.int v) {
    $_setSignedInt32(3, v);
  }

  @$pb.TagNumber(4)
  $core.bool hasMaximumEdition() => $_has(3);
  @$pb.TagNumber(4)
  void clearMaximumEdition() => $_clearField(4);

  @$pb.TagNumber(15)
  $pb.PbList<CodeGeneratorResponse_File> get file => $_getList(4);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
