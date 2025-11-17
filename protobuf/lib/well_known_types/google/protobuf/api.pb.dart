// This is a generated file - do not edit.
//
// Generated from google/protobuf/api.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;
import 'package:protobuf/well_known_types/google/protobuf/source_context.pb.dart'
    as $1;
import 'package:protobuf/well_known_types/google/protobuf/type.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

/// Api is a light-weight descriptor for an API Interface.
///
/// Interfaces are also described as "protocol buffer services" in some contexts,
/// such as by the "service" keyword in a .proto file, but they are different
/// from API Services, which represent a concrete implementation of an interface
/// as opposed to simply a description of methods and bindings. They are also
/// sometimes simply referred to as "APIs" in other contexts, such as the name of
/// this message itself. See https://cloud.google.com/apis/design/glossary for
/// detailed terminology.
///
/// New usages of this message as an alternative to ServiceDescriptorProto are
/// strongly discouraged. This message does not reliability preserve all
/// information necessary to model the schema and preserve semantics. Instead
/// make use of FileDescriptorSet which preserves the necessary information.
class Api extends $pb.GeneratedMessage {
  factory Api({
    $core.String? name,
    $core.Iterable<Method>? methods,
    $core.Iterable<$0.Option>? options,
    $core.String? version,
    $1.SourceContext? sourceContext,
    $core.Iterable<Mixin>? mixins,
    $0.Syntax? syntax,
    $core.String? edition,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (methods != null) result.methods.addAll(methods);
    if (options != null) result.options.addAll(options);
    if (version != null) result.version = version;
    if (sourceContext != null) result.sourceContext = sourceContext;
    if (mixins != null) result.mixins.addAll(mixins);
    if (syntax != null) result.syntax = syntax;
    if (edition != null) result.edition = edition;
    return result;
  }

  Api._();

  factory Api.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Api.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Api',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'google.protobuf'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..pPM<Method>(2, _omitFieldNames ? '' : 'methods',
        subBuilder: Method.create)
    ..pPM<$0.Option>(3, _omitFieldNames ? '' : 'options',
        subBuilder: $0.Option.create)
    ..aOS(4, _omitFieldNames ? '' : 'version')
    ..aOM<$1.SourceContext>(5, _omitFieldNames ? '' : 'sourceContext',
        subBuilder: $1.SourceContext.create)
    ..pPM<Mixin>(6, _omitFieldNames ? '' : 'mixins', subBuilder: Mixin.create)
    ..aE<$0.Syntax>(7, _omitFieldNames ? '' : 'syntax',
        enumValues: $0.Syntax.values)
    ..aOS(8, _omitFieldNames ? '' : 'edition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Api clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Api copyWith(void Function(Api) updates) =>
      super.copyWith((message) => updates(message as Api)) as Api;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Api create() => Api._();
  @$core.override
  Api createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Api getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Api>(create);
  static Api? _defaultInstance;

  /// The fully qualified name of this interface, including package name
  /// followed by the interface's simple name.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// The methods of this interface, in unspecified order.
  @$pb.TagNumber(2)
  $pb.PbList<Method> get methods => $_getList(1);

  /// Any metadata attached to the interface.
  @$pb.TagNumber(3)
  $pb.PbList<$0.Option> get options => $_getList(2);

  /// A version string for this interface. If specified, must have the form
  /// `major-version.minor-version`, as in `1.10`. If the minor version is
  /// omitted, it defaults to zero. If the entire version field is empty, the
  /// major version is derived from the package name, as outlined below. If the
  /// field is not empty, the version in the package name will be verified to be
  /// consistent with what is provided here.
  ///
  /// The versioning schema uses [semantic
  /// versioning](http://semver.org) where the major version number
  /// indicates a breaking change and the minor version an additive,
  /// non-breaking change. Both version numbers are signals to users
  /// what to expect from different versions, and should be carefully
  /// chosen based on the product plan.
  ///
  /// The major version is also reflected in the package name of the
  /// interface, which must end in `v<major-version>`, as in
  /// `google.feature.v1`. For major versions 0 and 1, the suffix can
  /// be omitted. Zero major versions must only be used for
  /// experimental, non-GA interfaces.
  @$pb.TagNumber(4)
  $core.String get version => $_getSZ(3);
  @$pb.TagNumber(4)
  set version($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasVersion() => $_has(3);
  @$pb.TagNumber(4)
  void clearVersion() => $_clearField(4);

  /// Source context for the protocol buffer service represented by this
  /// message.
  @$pb.TagNumber(5)
  $1.SourceContext get sourceContext => $_getN(4);
  @$pb.TagNumber(5)
  set sourceContext($1.SourceContext value) => $_setField(5, value);
  @$pb.TagNumber(5)
  $core.bool hasSourceContext() => $_has(4);
  @$pb.TagNumber(5)
  void clearSourceContext() => $_clearField(5);
  @$pb.TagNumber(5)
  $1.SourceContext ensureSourceContext() => $_ensure(4);

  /// Included interfaces. See [Mixin][].
  @$pb.TagNumber(6)
  $pb.PbList<Mixin> get mixins => $_getList(5);

  /// The source syntax of the service.
  @$pb.TagNumber(7)
  $0.Syntax get syntax => $_getN(6);
  @$pb.TagNumber(7)
  set syntax($0.Syntax value) => $_setField(7, value);
  @$pb.TagNumber(7)
  $core.bool hasSyntax() => $_has(6);
  @$pb.TagNumber(7)
  void clearSyntax() => $_clearField(7);

  /// The source edition string, only valid when syntax is SYNTAX_EDITIONS.
  @$pb.TagNumber(8)
  $core.String get edition => $_getSZ(7);
  @$pb.TagNumber(8)
  set edition($core.String value) => $_setString(7, value);
  @$pb.TagNumber(8)
  $core.bool hasEdition() => $_has(7);
  @$pb.TagNumber(8)
  void clearEdition() => $_clearField(8);
}

/// Method represents a method of an API interface.
///
/// New usages of this message as an alternative to MethodDescriptorProto are
/// strongly discouraged. This message does not reliability preserve all
/// information necessary to model the schema and preserve semantics. Instead
/// make use of FileDescriptorSet which preserves the necessary information.
class Method extends $pb.GeneratedMessage {
  factory Method({
    $core.String? name,
    $core.String? requestTypeUrl,
    $core.bool? requestStreaming,
    $core.String? responseTypeUrl,
    $core.bool? responseStreaming,
    $core.Iterable<$0.Option>? options,
    @$core.Deprecated('This field is deprecated.') $0.Syntax? syntax,
    @$core.Deprecated('This field is deprecated.') $core.String? edition,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (requestTypeUrl != null) result.requestTypeUrl = requestTypeUrl;
    if (requestStreaming != null) result.requestStreaming = requestStreaming;
    if (responseTypeUrl != null) result.responseTypeUrl = responseTypeUrl;
    if (responseStreaming != null) result.responseStreaming = responseStreaming;
    if (options != null) result.options.addAll(options);
    if (syntax != null) result.syntax = syntax;
    if (edition != null) result.edition = edition;
    return result;
  }

  Method._();

  factory Method.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Method.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Method',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'google.protobuf'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'requestTypeUrl')
    ..aOB(3, _omitFieldNames ? '' : 'requestStreaming')
    ..aOS(4, _omitFieldNames ? '' : 'responseTypeUrl')
    ..aOB(5, _omitFieldNames ? '' : 'responseStreaming')
    ..pPM<$0.Option>(6, _omitFieldNames ? '' : 'options',
        subBuilder: $0.Option.create)
    ..aE<$0.Syntax>(7, _omitFieldNames ? '' : 'syntax',
        enumValues: $0.Syntax.values)
    ..aOS(8, _omitFieldNames ? '' : 'edition')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Method clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Method copyWith(void Function(Method) updates) =>
      super.copyWith((message) => updates(message as Method)) as Method;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Method create() => Method._();
  @$core.override
  Method createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Method getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Method>(create);
  static Method? _defaultInstance;

  /// The simple name of this method.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// A URL of the input message type.
  @$pb.TagNumber(2)
  $core.String get requestTypeUrl => $_getSZ(1);
  @$pb.TagNumber(2)
  set requestTypeUrl($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRequestTypeUrl() => $_has(1);
  @$pb.TagNumber(2)
  void clearRequestTypeUrl() => $_clearField(2);

  /// If true, the request is streamed.
  @$pb.TagNumber(3)
  $core.bool get requestStreaming => $_getBF(2);
  @$pb.TagNumber(3)
  set requestStreaming($core.bool value) => $_setBool(2, value);
  @$pb.TagNumber(3)
  $core.bool hasRequestStreaming() => $_has(2);
  @$pb.TagNumber(3)
  void clearRequestStreaming() => $_clearField(3);

  /// The URL of the output message type.
  @$pb.TagNumber(4)
  $core.String get responseTypeUrl => $_getSZ(3);
  @$pb.TagNumber(4)
  set responseTypeUrl($core.String value) => $_setString(3, value);
  @$pb.TagNumber(4)
  $core.bool hasResponseTypeUrl() => $_has(3);
  @$pb.TagNumber(4)
  void clearResponseTypeUrl() => $_clearField(4);

  /// If true, the response is streamed.
  @$pb.TagNumber(5)
  $core.bool get responseStreaming => $_getBF(4);
  @$pb.TagNumber(5)
  set responseStreaming($core.bool value) => $_setBool(4, value);
  @$pb.TagNumber(5)
  $core.bool hasResponseStreaming() => $_has(4);
  @$pb.TagNumber(5)
  void clearResponseStreaming() => $_clearField(5);

  /// Any metadata attached to the method.
  @$pb.TagNumber(6)
  $pb.PbList<$0.Option> get options => $_getList(5);

  /// The source syntax of this method.
  ///
  /// This field should be ignored, instead the syntax should be inherited from
  /// Api. This is similar to Field and EnumValue.
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(7)
  $0.Syntax get syntax => $_getN(6);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(7)
  set syntax($0.Syntax value) => $_setField(7, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(7)
  $core.bool hasSyntax() => $_has(6);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(7)
  void clearSyntax() => $_clearField(7);

  /// The source edition string, only valid when syntax is SYNTAX_EDITIONS.
  ///
  /// This field should be ignored, instead the edition should be inherited from
  /// Api. This is similar to Field and EnumValue.
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(8)
  $core.String get edition => $_getSZ(7);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(8)
  set edition($core.String value) => $_setString(7, value);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(8)
  $core.bool hasEdition() => $_has(7);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(8)
  void clearEdition() => $_clearField(8);
}

/// Declares an API Interface to be included in this interface. The including
/// interface must redeclare all the methods from the included interface, but
/// documentation and options are inherited as follows:
///
/// - If after comment and whitespace stripping, the documentation
///   string of the redeclared method is empty, it will be inherited
///   from the original method.
///
/// - Each annotation belonging to the service config (http,
///   visibility) which is not set in the redeclared method will be
///   inherited.
///
/// - If an http annotation is inherited, the path pattern will be
///   modified as follows. Any version prefix will be replaced by the
///   version of the including interface plus the [root][] path if
///   specified.
///
/// Example of a simple mixin:
///
///     package google.acl.v1;
///     service AccessControl {
///       // Get the underlying ACL object.
///       rpc GetAcl(GetAclRequest) returns (Acl) {
///         option (google.api.http).get = "/v1/{resource=**}:getAcl";
///       }
///     }
///
///     package google.storage.v2;
///     service Storage {
///       rpc GetAcl(GetAclRequest) returns (Acl);
///
///       // Get a data record.
///       rpc GetData(GetDataRequest) returns (Data) {
///         option (google.api.http).get = "/v2/{resource=**}";
///       }
///     }
///
/// Example of a mixin configuration:
///
///     apis:
///     - name: google.storage.v2.Storage
///       mixins:
///       - name: google.acl.v1.AccessControl
///
/// The mixin construct implies that all methods in `AccessControl` are
/// also declared with same name and request/response types in
/// `Storage`. A documentation generator or annotation processor will
/// see the effective `Storage.GetAcl` method after inheriting
/// documentation and annotations as follows:
///
///     service Storage {
///       // Get the underlying ACL object.
///       rpc GetAcl(GetAclRequest) returns (Acl) {
///         option (google.api.http).get = "/v2/{resource=**}:getAcl";
///       }
///       ...
///     }
///
/// Note how the version in the path pattern changed from `v1` to `v2`.
///
/// If the `root` field in the mixin is specified, it should be a
/// relative path under which inherited HTTP paths are placed. Example:
///
///     apis:
///     - name: google.storage.v2.Storage
///       mixins:
///       - name: google.acl.v1.AccessControl
///         root: acls
///
/// This implies the following inherited HTTP annotation:
///
///     service Storage {
///       // Get the underlying ACL object.
///       rpc GetAcl(GetAclRequest) returns (Acl) {
///         option (google.api.http).get = "/v2/acls/{resource=**}:getAcl";
///       }
///       ...
///     }
class Mixin extends $pb.GeneratedMessage {
  factory Mixin({
    $core.String? name,
    $core.String? root,
  }) {
    final result = create();
    if (name != null) result.name = name;
    if (root != null) result.root = root;
    return result;
  }

  Mixin._();

  factory Mixin.fromBuffer($core.List<$core.int> data,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(data, registry);
  factory Mixin.fromJson($core.String json,
          [$pb.ExtensionRegistry registry = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(json, registry);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Mixin',
      package:
          const $pb.PackageName(_omitMessageNames ? '' : 'google.protobuf'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'name')
    ..aOS(2, _omitFieldNames ? '' : 'root')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Mixin clone() => deepCopy();
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Mixin copyWith(void Function(Mixin) updates) =>
      super.copyWith((message) => updates(message as Mixin)) as Mixin;

  @$core.override
  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Mixin create() => Mixin._();
  @$core.override
  Mixin createEmptyInstance() => create();
  @$core.pragma('dart2js:noInline')
  static Mixin getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<Mixin>(create);
  static Mixin? _defaultInstance;

  /// The fully qualified name of the interface which is included.
  @$pb.TagNumber(1)
  $core.String get name => $_getSZ(0);
  @$pb.TagNumber(1)
  set name($core.String value) => $_setString(0, value);
  @$pb.TagNumber(1)
  $core.bool hasName() => $_has(0);
  @$pb.TagNumber(1)
  void clearName() => $_clearField(1);

  /// If non-empty specifies a path under which inherited HTTP paths
  /// are rooted.
  @$pb.TagNumber(2)
  $core.String get root => $_getSZ(1);
  @$pb.TagNumber(2)
  set root($core.String value) => $_setString(1, value);
  @$pb.TagNumber(2)
  $core.bool hasRoot() => $_has(1);
  @$pb.TagNumber(2)
  void clearRoot() => $_clearField(2);
}

const $core.bool _omitFieldNames =
    $core.bool.fromEnvironment('protobuf.omit_field_names');
const $core.bool _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
