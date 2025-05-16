//
//  Generated code. Do not modify.
//  source: client.proto
//
// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_final_fields
// ignore_for_file: unnecessary_import, unnecessary_this, unused_import

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'client.pbenum.dart';

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'client.pbenum.dart';

/// Required information for every language.
class CommonLanguageSettings extends $pb.GeneratedMessage {
  factory CommonLanguageSettings({
    @$core.Deprecated('This field is deprecated.')
    $core.String? referenceDocsUri,
    $core.Iterable<ClientLibraryDestination>? destinations,
    SelectiveGapicGeneration? selectiveGapicGeneration,
  }) {
    final $result = create();
    if (referenceDocsUri != null) {
      // ignore: deprecated_member_use_from_same_package
      $result.referenceDocsUri = referenceDocsUri;
    }
    if (destinations != null) {
      $result.destinations.addAll(destinations);
    }
    if (selectiveGapicGeneration != null) {
      $result.selectiveGapicGeneration = selectiveGapicGeneration;
    }
    return $result;
  }
  CommonLanguageSettings._() : super();
  factory CommonLanguageSettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CommonLanguageSettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CommonLanguageSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'referenceDocsUri')
    ..pc<ClientLibraryDestination>(
        2, _omitFieldNames ? '' : 'destinations', $pb.PbFieldType.KE,
        valueOf: ClientLibraryDestination.valueOf,
        enumValues: ClientLibraryDestination.values,
        defaultEnumValue:
            ClientLibraryDestination.CLIENT_LIBRARY_DESTINATION_UNSPECIFIED)
    ..aOM<SelectiveGapicGeneration>(
        3, _omitFieldNames ? '' : 'selectiveGapicGeneration',
        subBuilder: SelectiveGapicGeneration.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonLanguageSettings clone() =>
      CommonLanguageSettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CommonLanguageSettings copyWith(
          void Function(CommonLanguageSettings) updates) =>
      super.copyWith((message) => updates(message as CommonLanguageSettings))
          as CommonLanguageSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CommonLanguageSettings create() => CommonLanguageSettings._();
  CommonLanguageSettings createEmptyInstance() => create();
  static $pb.PbList<CommonLanguageSettings> createRepeated() =>
      $pb.PbList<CommonLanguageSettings>();
  @$core.pragma('dart2js:noInline')
  static CommonLanguageSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CommonLanguageSettings>(create);
  static CommonLanguageSettings? _defaultInstance;

  /// Link to automatically generated reference documentation.  Example:
  /// https://cloud.google.com/nodejs/docs/reference/asset/latest
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(1)
  $core.String get referenceDocsUri => $_getSZ(0);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(1)
  set referenceDocsUri($core.String v) {
    $_setString(0, v);
  }

  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(1)
  $core.bool hasReferenceDocsUri() => $_has(0);
  @$core.Deprecated('This field is deprecated.')
  @$pb.TagNumber(1)
  void clearReferenceDocsUri() => $_clearField(1);

  /// The destination where API teams want this client library to be published.
  @$pb.TagNumber(2)
  $pb.PbList<ClientLibraryDestination> get destinations => $_getList(1);

  /// Configuration for which RPCs should be generated in the GAPIC client.
  @$pb.TagNumber(3)
  SelectiveGapicGeneration get selectiveGapicGeneration => $_getN(2);
  @$pb.TagNumber(3)
  set selectiveGapicGeneration(SelectiveGapicGeneration v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasSelectiveGapicGeneration() => $_has(2);
  @$pb.TagNumber(3)
  void clearSelectiveGapicGeneration() => $_clearField(3);
  @$pb.TagNumber(3)
  SelectiveGapicGeneration ensureSelectiveGapicGeneration() => $_ensure(2);
}

/// This message configures the settings for publishing [Google Cloud Client
/// libraries](https://cloud.google.com/apis/docs/cloud-client-libraries)
/// generated from the service config.
class Publishing extends $pb.GeneratedMessage {
  factory Publishing({
    $core.String? newIssueUri,
    $core.String? documentationUri,
    $core.String? apiShortName,
    $core.String? githubLabel,
    $core.Iterable<$core.String>? codeownerGithubTeams,
    $core.String? docTagPrefix,
    ClientLibraryOrganization? organization,
    $core.String? protoReferenceDocumentationUri,
    $core.String? restReferenceDocumentationUri,
  }) {
    final $result = create();
    if (newIssueUri != null) {
      $result.newIssueUri = newIssueUri;
    }
    if (documentationUri != null) {
      $result.documentationUri = documentationUri;
    }
    if (apiShortName != null) {
      $result.apiShortName = apiShortName;
    }
    if (githubLabel != null) {
      $result.githubLabel = githubLabel;
    }
    if (codeownerGithubTeams != null) {
      $result.codeownerGithubTeams.addAll(codeownerGithubTeams);
    }
    if (docTagPrefix != null) {
      $result.docTagPrefix = docTagPrefix;
    }
    if (organization != null) {
      $result.organization = organization;
    }
    if (protoReferenceDocumentationUri != null) {
      $result.protoReferenceDocumentationUri = protoReferenceDocumentationUri;
    }
    if (restReferenceDocumentationUri != null) {
      $result.restReferenceDocumentationUri = restReferenceDocumentationUri;
    }
    return $result;
  }
  Publishing._() : super();
  factory Publishing.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory Publishing.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'Publishing',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOS(101, _omitFieldNames ? '' : 'newIssueUri')
    ..aOS(102, _omitFieldNames ? '' : 'documentationUri')
    ..aOS(103, _omitFieldNames ? '' : 'apiShortName')
    ..aOS(104, _omitFieldNames ? '' : 'githubLabel')
    ..pPS(105, _omitFieldNames ? '' : 'codeownerGithubTeams')
    ..aOS(106, _omitFieldNames ? '' : 'docTagPrefix')
    ..e<ClientLibraryOrganization>(
        107, _omitFieldNames ? '' : 'organization', $pb.PbFieldType.OE,
        defaultOrMaker:
            ClientLibraryOrganization.CLIENT_LIBRARY_ORGANIZATION_UNSPECIFIED,
        valueOf: ClientLibraryOrganization.valueOf,
        enumValues: ClientLibraryOrganization.values)
    ..aOS(110, _omitFieldNames ? '' : 'protoReferenceDocumentationUri')
    ..aOS(111, _omitFieldNames ? '' : 'restReferenceDocumentationUri')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Publishing clone() => Publishing()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  Publishing copyWith(void Function(Publishing) updates) =>
      super.copyWith((message) => updates(message as Publishing)) as Publishing;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static Publishing create() => Publishing._();
  Publishing createEmptyInstance() => create();
  static $pb.PbList<Publishing> createRepeated() => $pb.PbList<Publishing>();
  @$core.pragma('dart2js:noInline')
  static Publishing getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<Publishing>(create);
  static Publishing? _defaultInstance;

  /// Link to a *public* URI where users can report issues.  Example:
  /// https://issuetracker.google.com/issues/new?component=190865&template=1161103
  @$pb.TagNumber(101)
  $core.String get newIssueUri => $_getSZ(0);
  @$pb.TagNumber(101)
  set newIssueUri($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(101)
  $core.bool hasNewIssueUri() => $_has(0);
  @$pb.TagNumber(101)
  void clearNewIssueUri() => $_clearField(101);

  /// Link to product home page.  Example:
  /// https://cloud.google.com/asset-inventory/docs/overview
  @$pb.TagNumber(102)
  $core.String get documentationUri => $_getSZ(1);
  @$pb.TagNumber(102)
  set documentationUri($core.String v) {
    $_setString(1, v);
  }

  @$pb.TagNumber(102)
  $core.bool hasDocumentationUri() => $_has(1);
  @$pb.TagNumber(102)
  void clearDocumentationUri() => $_clearField(102);

  /// Used as a tracking tag when collecting data about the APIs developer
  /// relations artifacts like docs, packages delivered to package managers,
  /// etc.  Example: "speech".
  @$pb.TagNumber(103)
  $core.String get apiShortName => $_getSZ(2);
  @$pb.TagNumber(103)
  set apiShortName($core.String v) {
    $_setString(2, v);
  }

  @$pb.TagNumber(103)
  $core.bool hasApiShortName() => $_has(2);
  @$pb.TagNumber(103)
  void clearApiShortName() => $_clearField(103);

  /// GitHub label to apply to issues and pull requests opened for this API.
  @$pb.TagNumber(104)
  $core.String get githubLabel => $_getSZ(3);
  @$pb.TagNumber(104)
  set githubLabel($core.String v) {
    $_setString(3, v);
  }

  @$pb.TagNumber(104)
  $core.bool hasGithubLabel() => $_has(3);
  @$pb.TagNumber(104)
  void clearGithubLabel() => $_clearField(104);

  /// GitHub teams to be added to CODEOWNERS in the directory in GitHub
  /// containing source code for the client libraries for this API.
  @$pb.TagNumber(105)
  $pb.PbList<$core.String> get codeownerGithubTeams => $_getList(4);

  /// A prefix used in sample code when demarking regions to be included in
  /// documentation.
  @$pb.TagNumber(106)
  $core.String get docTagPrefix => $_getSZ(5);
  @$pb.TagNumber(106)
  set docTagPrefix($core.String v) {
    $_setString(5, v);
  }

  @$pb.TagNumber(106)
  $core.bool hasDocTagPrefix() => $_has(5);
  @$pb.TagNumber(106)
  void clearDocTagPrefix() => $_clearField(106);

  /// For whom the client library is being published.
  @$pb.TagNumber(107)
  ClientLibraryOrganization get organization => $_getN(6);
  @$pb.TagNumber(107)
  set organization(ClientLibraryOrganization v) {
    $_setField(107, v);
  }

  @$pb.TagNumber(107)
  $core.bool hasOrganization() => $_has(6);
  @$pb.TagNumber(107)
  void clearOrganization() => $_clearField(107);

  /// Optional link to proto reference documentation.  Example:
  /// https://cloud.google.com/pubsub/lite/docs/reference/rpc
  @$pb.TagNumber(110)
  $core.String get protoReferenceDocumentationUri => $_getSZ(7);
  @$pb.TagNumber(110)
  set protoReferenceDocumentationUri($core.String v) {
    $_setString(7, v);
  }

  @$pb.TagNumber(110)
  $core.bool hasProtoReferenceDocumentationUri() => $_has(7);
  @$pb.TagNumber(110)
  void clearProtoReferenceDocumentationUri() => $_clearField(110);

  /// Optional link to REST reference documentation.  Example:
  /// https://cloud.google.com/pubsub/lite/docs/reference/rest
  @$pb.TagNumber(111)
  $core.String get restReferenceDocumentationUri => $_getSZ(8);
  @$pb.TagNumber(111)
  set restReferenceDocumentationUri($core.String v) {
    $_setString(8, v);
  }

  @$pb.TagNumber(111)
  $core.bool hasRestReferenceDocumentationUri() => $_has(8);
  @$pb.TagNumber(111)
  void clearRestReferenceDocumentationUri() => $_clearField(111);
}

/// Settings for Java client libraries.
class JavaSettings extends $pb.GeneratedMessage {
  factory JavaSettings({
    $core.String? libraryPackage,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        serviceClassNames,
    CommonLanguageSettings? common,
  }) {
    final $result = create();
    if (libraryPackage != null) {
      $result.libraryPackage = libraryPackage;
    }
    if (serviceClassNames != null) {
      $result.serviceClassNames.addEntries(serviceClassNames);
    }
    if (common != null) {
      $result.common = common;
    }
    return $result;
  }
  JavaSettings._() : super();
  factory JavaSettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory JavaSettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'JavaSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOS(1, _omitFieldNames ? '' : 'libraryPackage')
    ..m<$core.String, $core.String>(
        2, _omitFieldNames ? '' : 'serviceClassNames',
        entryClassName: 'JavaSettings.ServiceClassNamesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('google.api'))
    ..aOM<CommonLanguageSettings>(3, _omitFieldNames ? '' : 'common',
        subBuilder: CommonLanguageSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JavaSettings clone() => JavaSettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  JavaSettings copyWith(void Function(JavaSettings) updates) =>
      super.copyWith((message) => updates(message as JavaSettings))
          as JavaSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static JavaSettings create() => JavaSettings._();
  JavaSettings createEmptyInstance() => create();
  static $pb.PbList<JavaSettings> createRepeated() =>
      $pb.PbList<JavaSettings>();
  @$core.pragma('dart2js:noInline')
  static JavaSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<JavaSettings>(create);
  static JavaSettings? _defaultInstance;

  /// The package name to use in Java. Clobbers the java_package option
  /// set in the protobuf. This should be used **only** by APIs
  /// who have already set the language_settings.java.package_name" field
  /// in gapic.yaml. API teams should use the protobuf java_package option
  /// where possible.
  ///
  /// Example of a YAML configuration::
  ///
  ///  publishing:
  ///    java_settings:
  ///      library_package: com.google.cloud.pubsub.v1
  @$pb.TagNumber(1)
  $core.String get libraryPackage => $_getSZ(0);
  @$pb.TagNumber(1)
  set libraryPackage($core.String v) {
    $_setString(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasLibraryPackage() => $_has(0);
  @$pb.TagNumber(1)
  void clearLibraryPackage() => $_clearField(1);

  /// Configure the Java class name to use instead of the service's for its
  /// corresponding generated GAPIC client. Keys are fully-qualified
  /// service names as they appear in the protobuf (including the full
  /// the language_settings.java.interface_names" field in gapic.yaml. API
  /// teams should otherwise use the service name as it appears in the
  /// protobuf.
  ///
  /// Example of a YAML configuration::
  ///
  ///  publishing:
  ///    java_settings:
  ///      service_class_names:
  ///        - google.pubsub.v1.Publisher: TopicAdmin
  ///        - google.pubsub.v1.Subscriber: SubscriptionAdmin
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get serviceClassNames => $_getMap(1);

  /// Some settings.
  @$pb.TagNumber(3)
  CommonLanguageSettings get common => $_getN(2);
  @$pb.TagNumber(3)
  set common(CommonLanguageSettings v) {
    $_setField(3, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasCommon() => $_has(2);
  @$pb.TagNumber(3)
  void clearCommon() => $_clearField(3);
  @$pb.TagNumber(3)
  CommonLanguageSettings ensureCommon() => $_ensure(2);
}

/// Settings for C++ client libraries.
class CppSettings extends $pb.GeneratedMessage {
  factory CppSettings({
    CommonLanguageSettings? common,
  }) {
    final $result = create();
    if (common != null) {
      $result.common = common;
    }
    return $result;
  }
  CppSettings._() : super();
  factory CppSettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory CppSettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'CppSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOM<CommonLanguageSettings>(1, _omitFieldNames ? '' : 'common',
        subBuilder: CommonLanguageSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CppSettings clone() => CppSettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  CppSettings copyWith(void Function(CppSettings) updates) =>
      super.copyWith((message) => updates(message as CppSettings))
          as CppSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static CppSettings create() => CppSettings._();
  CppSettings createEmptyInstance() => create();
  static $pb.PbList<CppSettings> createRepeated() => $pb.PbList<CppSettings>();
  @$core.pragma('dart2js:noInline')
  static CppSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<CppSettings>(create);
  static CppSettings? _defaultInstance;

  /// Some settings.
  @$pb.TagNumber(1)
  CommonLanguageSettings get common => $_getN(0);
  @$pb.TagNumber(1)
  set common(CommonLanguageSettings v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCommon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommon() => $_clearField(1);
  @$pb.TagNumber(1)
  CommonLanguageSettings ensureCommon() => $_ensure(0);
}

/// Settings for Php client libraries.
class PhpSettings extends $pb.GeneratedMessage {
  factory PhpSettings({
    CommonLanguageSettings? common,
  }) {
    final $result = create();
    if (common != null) {
      $result.common = common;
    }
    return $result;
  }
  PhpSettings._() : super();
  factory PhpSettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PhpSettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PhpSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOM<CommonLanguageSettings>(1, _omitFieldNames ? '' : 'common',
        subBuilder: CommonLanguageSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhpSettings clone() => PhpSettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PhpSettings copyWith(void Function(PhpSettings) updates) =>
      super.copyWith((message) => updates(message as PhpSettings))
          as PhpSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PhpSettings create() => PhpSettings._();
  PhpSettings createEmptyInstance() => create();
  static $pb.PbList<PhpSettings> createRepeated() => $pb.PbList<PhpSettings>();
  @$core.pragma('dart2js:noInline')
  static PhpSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PhpSettings>(create);
  static PhpSettings? _defaultInstance;

  /// Some settings.
  @$pb.TagNumber(1)
  CommonLanguageSettings get common => $_getN(0);
  @$pb.TagNumber(1)
  set common(CommonLanguageSettings v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCommon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommon() => $_clearField(1);
  @$pb.TagNumber(1)
  CommonLanguageSettings ensureCommon() => $_ensure(0);
}

/// Experimental features to be included during client library generation.
/// These fields will be deprecated once the feature graduates and is enabled
/// by default.
class PythonSettings_ExperimentalFeatures extends $pb.GeneratedMessage {
  factory PythonSettings_ExperimentalFeatures({
    $core.bool? restAsyncIoEnabled,
    $core.bool? protobufPythonicTypesEnabled,
    $core.bool? unversionedPackageDisabled,
  }) {
    final $result = create();
    if (restAsyncIoEnabled != null) {
      $result.restAsyncIoEnabled = restAsyncIoEnabled;
    }
    if (protobufPythonicTypesEnabled != null) {
      $result.protobufPythonicTypesEnabled = protobufPythonicTypesEnabled;
    }
    if (unversionedPackageDisabled != null) {
      $result.unversionedPackageDisabled = unversionedPackageDisabled;
    }
    return $result;
  }
  PythonSettings_ExperimentalFeatures._() : super();
  factory PythonSettings_ExperimentalFeatures.fromBuffer(
          $core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PythonSettings_ExperimentalFeatures.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PythonSettings.ExperimentalFeatures',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOB(1, _omitFieldNames ? '' : 'restAsyncIoEnabled')
    ..aOB(2, _omitFieldNames ? '' : 'protobufPythonicTypesEnabled')
    ..aOB(3, _omitFieldNames ? '' : 'unversionedPackageDisabled')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PythonSettings_ExperimentalFeatures clone() =>
      PythonSettings_ExperimentalFeatures()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PythonSettings_ExperimentalFeatures copyWith(
          void Function(PythonSettings_ExperimentalFeatures) updates) =>
      super.copyWith((message) =>
              updates(message as PythonSettings_ExperimentalFeatures))
          as PythonSettings_ExperimentalFeatures;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PythonSettings_ExperimentalFeatures create() =>
      PythonSettings_ExperimentalFeatures._();
  PythonSettings_ExperimentalFeatures createEmptyInstance() => create();
  static $pb.PbList<PythonSettings_ExperimentalFeatures> createRepeated() =>
      $pb.PbList<PythonSettings_ExperimentalFeatures>();
  @$core.pragma('dart2js:noInline')
  static PythonSettings_ExperimentalFeatures getDefault() =>
      _defaultInstance ??= $pb.GeneratedMessage.$_defaultFor<
          PythonSettings_ExperimentalFeatures>(create);
  static PythonSettings_ExperimentalFeatures? _defaultInstance;

  /// Enables generation of asynchronous REST clients if `rest` transport is
  /// enabled. By default, asynchronous REST clients will not be generated.
  /// This feature will be enabled by default 1 month after launching the
  /// feature in preview packages.
  @$pb.TagNumber(1)
  $core.bool get restAsyncIoEnabled => $_getBF(0);
  @$pb.TagNumber(1)
  set restAsyncIoEnabled($core.bool v) {
    $_setBool(0, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasRestAsyncIoEnabled() => $_has(0);
  @$pb.TagNumber(1)
  void clearRestAsyncIoEnabled() => $_clearField(1);

  /// Enables generation of protobuf code using new types that are more
  /// Pythonic which are included in `protobuf>=5.29.x`. This feature will be
  /// enabled by default 1 month after launching the feature in preview
  /// packages.
  @$pb.TagNumber(2)
  $core.bool get protobufPythonicTypesEnabled => $_getBF(1);
  @$pb.TagNumber(2)
  set protobufPythonicTypesEnabled($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasProtobufPythonicTypesEnabled() => $_has(1);
  @$pb.TagNumber(2)
  void clearProtobufPythonicTypesEnabled() => $_clearField(2);

  /// Disables generation of an unversioned Python package for this client
  /// library. This means that the module names will need to be versioned in
  /// import statements. For example `import google.cloud.library_v2` instead
  /// of `import google.cloud.library`.
  @$pb.TagNumber(3)
  $core.bool get unversionedPackageDisabled => $_getBF(2);
  @$pb.TagNumber(3)
  set unversionedPackageDisabled($core.bool v) {
    $_setBool(2, v);
  }

  @$pb.TagNumber(3)
  $core.bool hasUnversionedPackageDisabled() => $_has(2);
  @$pb.TagNumber(3)
  void clearUnversionedPackageDisabled() => $_clearField(3);
}

/// Settings for Python client libraries.
class PythonSettings extends $pb.GeneratedMessage {
  factory PythonSettings({
    CommonLanguageSettings? common,
    PythonSettings_ExperimentalFeatures? experimentalFeatures,
  }) {
    final $result = create();
    if (common != null) {
      $result.common = common;
    }
    if (experimentalFeatures != null) {
      $result.experimentalFeatures = experimentalFeatures;
    }
    return $result;
  }
  PythonSettings._() : super();
  factory PythonSettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory PythonSettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'PythonSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOM<CommonLanguageSettings>(1, _omitFieldNames ? '' : 'common',
        subBuilder: CommonLanguageSettings.create)
    ..aOM<PythonSettings_ExperimentalFeatures>(
        2, _omitFieldNames ? '' : 'experimentalFeatures',
        subBuilder: PythonSettings_ExperimentalFeatures.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PythonSettings clone() => PythonSettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  PythonSettings copyWith(void Function(PythonSettings) updates) =>
      super.copyWith((message) => updates(message as PythonSettings))
          as PythonSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static PythonSettings create() => PythonSettings._();
  PythonSettings createEmptyInstance() => create();
  static $pb.PbList<PythonSettings> createRepeated() =>
      $pb.PbList<PythonSettings>();
  @$core.pragma('dart2js:noInline')
  static PythonSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<PythonSettings>(create);
  static PythonSettings? _defaultInstance;

  /// Some settings.
  @$pb.TagNumber(1)
  CommonLanguageSettings get common => $_getN(0);
  @$pb.TagNumber(1)
  set common(CommonLanguageSettings v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCommon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommon() => $_clearField(1);
  @$pb.TagNumber(1)
  CommonLanguageSettings ensureCommon() => $_ensure(0);

  /// Experimental features to be included during client library generation.
  @$pb.TagNumber(2)
  PythonSettings_ExperimentalFeatures get experimentalFeatures => $_getN(1);
  @$pb.TagNumber(2)
  set experimentalFeatures(PythonSettings_ExperimentalFeatures v) {
    $_setField(2, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasExperimentalFeatures() => $_has(1);
  @$pb.TagNumber(2)
  void clearExperimentalFeatures() => $_clearField(2);
  @$pb.TagNumber(2)
  PythonSettings_ExperimentalFeatures ensureExperimentalFeatures() =>
      $_ensure(1);
}

/// Settings for Node client libraries.
class NodeSettings extends $pb.GeneratedMessage {
  factory NodeSettings({
    CommonLanguageSettings? common,
  }) {
    final $result = create();
    if (common != null) {
      $result.common = common;
    }
    return $result;
  }
  NodeSettings._() : super();
  factory NodeSettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory NodeSettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'NodeSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOM<CommonLanguageSettings>(1, _omitFieldNames ? '' : 'common',
        subBuilder: CommonLanguageSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodeSettings clone() => NodeSettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  NodeSettings copyWith(void Function(NodeSettings) updates) =>
      super.copyWith((message) => updates(message as NodeSettings))
          as NodeSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static NodeSettings create() => NodeSettings._();
  NodeSettings createEmptyInstance() => create();
  static $pb.PbList<NodeSettings> createRepeated() =>
      $pb.PbList<NodeSettings>();
  @$core.pragma('dart2js:noInline')
  static NodeSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<NodeSettings>(create);
  static NodeSettings? _defaultInstance;

  /// Some settings.
  @$pb.TagNumber(1)
  CommonLanguageSettings get common => $_getN(0);
  @$pb.TagNumber(1)
  set common(CommonLanguageSettings v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCommon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommon() => $_clearField(1);
  @$pb.TagNumber(1)
  CommonLanguageSettings ensureCommon() => $_ensure(0);
}

/// Settings for Dotnet client libraries.
class DotnetSettings extends $pb.GeneratedMessage {
  factory DotnetSettings({
    CommonLanguageSettings? common,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? renamedServices,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>?
        renamedResources,
    $core.Iterable<$core.String>? ignoredResources,
    $core.Iterable<$core.String>? forcedNamespaceAliases,
    $core.Iterable<$core.String>? handwrittenSignatures,
  }) {
    final $result = create();
    if (common != null) {
      $result.common = common;
    }
    if (renamedServices != null) {
      $result.renamedServices.addEntries(renamedServices);
    }
    if (renamedResources != null) {
      $result.renamedResources.addEntries(renamedResources);
    }
    if (ignoredResources != null) {
      $result.ignoredResources.addAll(ignoredResources);
    }
    if (forcedNamespaceAliases != null) {
      $result.forcedNamespaceAliases.addAll(forcedNamespaceAliases);
    }
    if (handwrittenSignatures != null) {
      $result.handwrittenSignatures.addAll(handwrittenSignatures);
    }
    return $result;
  }
  DotnetSettings._() : super();
  factory DotnetSettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory DotnetSettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'DotnetSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOM<CommonLanguageSettings>(1, _omitFieldNames ? '' : 'common',
        subBuilder: CommonLanguageSettings.create)
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'renamedServices',
        entryClassName: 'DotnetSettings.RenamedServicesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('google.api'))
    ..m<$core.String, $core.String>(
        3, _omitFieldNames ? '' : 'renamedResources',
        entryClassName: 'DotnetSettings.RenamedResourcesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('google.api'))
    ..pPS(4, _omitFieldNames ? '' : 'ignoredResources')
    ..pPS(5, _omitFieldNames ? '' : 'forcedNamespaceAliases')
    ..pPS(6, _omitFieldNames ? '' : 'handwrittenSignatures')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DotnetSettings clone() => DotnetSettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  DotnetSettings copyWith(void Function(DotnetSettings) updates) =>
      super.copyWith((message) => updates(message as DotnetSettings))
          as DotnetSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static DotnetSettings create() => DotnetSettings._();
  DotnetSettings createEmptyInstance() => create();
  static $pb.PbList<DotnetSettings> createRepeated() =>
      $pb.PbList<DotnetSettings>();
  @$core.pragma('dart2js:noInline')
  static DotnetSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<DotnetSettings>(create);
  static DotnetSettings? _defaultInstance;

  /// Some settings.
  @$pb.TagNumber(1)
  CommonLanguageSettings get common => $_getN(0);
  @$pb.TagNumber(1)
  set common(CommonLanguageSettings v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCommon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommon() => $_clearField(1);
  @$pb.TagNumber(1)
  CommonLanguageSettings ensureCommon() => $_ensure(0);

  /// Map from original service names to renamed versions.
  /// This is used when the default generated types
  /// would cause a naming conflict. (Neither name is
  /// fully-qualified.)
  /// Example: Subscriber to SubscriberServiceApi.
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get renamedServices => $_getMap(1);

  /// Map from full resource types to the effective short name
  /// for the resource. This is used when otherwise resource
  /// named from different services would cause naming collisions.
  /// Example entry:
  /// "datalabeling.googleapis.com/Dataset": "DataLabelingDataset"
  @$pb.TagNumber(3)
  $pb.PbMap<$core.String, $core.String> get renamedResources => $_getMap(2);

  /// List of full resource types to ignore during generation.
  /// This is typically used for API-specific Location resources,
  /// which should be handled by the generator as if they were actually
  /// the common Location resources.
  /// Example entry: "documentai.googleapis.com/Location"
  @$pb.TagNumber(4)
  $pb.PbList<$core.String> get ignoredResources => $_getList(3);

  /// Namespaces which must be aliased in snippets due to
  /// a known (but non-generator-predictable) naming collision
  @$pb.TagNumber(5)
  $pb.PbList<$core.String> get forcedNamespaceAliases => $_getList(4);

  /// Method signatures (in the form "service.method(signature)")
  /// which are provided separately, so shouldn't be generated.
  /// Snippets *calling* these methods are still generated, however.
  @$pb.TagNumber(6)
  $pb.PbList<$core.String> get handwrittenSignatures => $_getList(5);
}

/// Settings for Ruby client libraries.
class RubySettings extends $pb.GeneratedMessage {
  factory RubySettings({
    CommonLanguageSettings? common,
  }) {
    final $result = create();
    if (common != null) {
      $result.common = common;
    }
    return $result;
  }
  RubySettings._() : super();
  factory RubySettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory RubySettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'RubySettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOM<CommonLanguageSettings>(1, _omitFieldNames ? '' : 'common',
        subBuilder: CommonLanguageSettings.create)
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RubySettings clone() => RubySettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  RubySettings copyWith(void Function(RubySettings) updates) =>
      super.copyWith((message) => updates(message as RubySettings))
          as RubySettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static RubySettings create() => RubySettings._();
  RubySettings createEmptyInstance() => create();
  static $pb.PbList<RubySettings> createRepeated() =>
      $pb.PbList<RubySettings>();
  @$core.pragma('dart2js:noInline')
  static RubySettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<RubySettings>(create);
  static RubySettings? _defaultInstance;

  /// Some settings.
  @$pb.TagNumber(1)
  CommonLanguageSettings get common => $_getN(0);
  @$pb.TagNumber(1)
  set common(CommonLanguageSettings v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCommon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommon() => $_clearField(1);
  @$pb.TagNumber(1)
  CommonLanguageSettings ensureCommon() => $_ensure(0);
}

/// Settings for Go client libraries.
class GoSettings extends $pb.GeneratedMessage {
  factory GoSettings({
    CommonLanguageSettings? common,
    $core.Iterable<$core.MapEntry<$core.String, $core.String>>? renamedServices,
  }) {
    final $result = create();
    if (common != null) {
      $result.common = common;
    }
    if (renamedServices != null) {
      $result.renamedServices.addEntries(renamedServices);
    }
    return $result;
  }
  GoSettings._() : super();
  factory GoSettings.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory GoSettings.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'GoSettings',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..aOM<CommonLanguageSettings>(1, _omitFieldNames ? '' : 'common',
        subBuilder: CommonLanguageSettings.create)
    ..m<$core.String, $core.String>(2, _omitFieldNames ? '' : 'renamedServices',
        entryClassName: 'GoSettings.RenamedServicesEntry',
        keyFieldType: $pb.PbFieldType.OS,
        valueFieldType: $pb.PbFieldType.OS,
        packageName: const $pb.PackageName('google.api'))
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoSettings clone() => GoSettings()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  GoSettings copyWith(void Function(GoSettings) updates) =>
      super.copyWith((message) => updates(message as GoSettings)) as GoSettings;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static GoSettings create() => GoSettings._();
  GoSettings createEmptyInstance() => create();
  static $pb.PbList<GoSettings> createRepeated() => $pb.PbList<GoSettings>();
  @$core.pragma('dart2js:noInline')
  static GoSettings getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<GoSettings>(create);
  static GoSettings? _defaultInstance;

  /// Some settings.
  @$pb.TagNumber(1)
  CommonLanguageSettings get common => $_getN(0);
  @$pb.TagNumber(1)
  set common(CommonLanguageSettings v) {
    $_setField(1, v);
  }

  @$pb.TagNumber(1)
  $core.bool hasCommon() => $_has(0);
  @$pb.TagNumber(1)
  void clearCommon() => $_clearField(1);
  @$pb.TagNumber(1)
  CommonLanguageSettings ensureCommon() => $_ensure(0);

  /// Map of service names to renamed services. Keys are the package relative
  /// service names and values are the name to be used for the service client
  /// and call options.
  ///
  /// publishing:
  ///   go_settings:
  ///     renamed_services:
  ///       Publisher: TopicAdmin
  @$pb.TagNumber(2)
  $pb.PbMap<$core.String, $core.String> get renamedServices => $_getMap(1);
}

/// This message is used to configure the generation of a subset of the RPCs in
/// a service for client libraries.
class SelectiveGapicGeneration extends $pb.GeneratedMessage {
  factory SelectiveGapicGeneration({
    $core.Iterable<$core.String>? methods,
    $core.bool? generateOmittedAsInternal,
  }) {
    final $result = create();
    if (methods != null) {
      $result.methods.addAll(methods);
    }
    if (generateOmittedAsInternal != null) {
      $result.generateOmittedAsInternal = generateOmittedAsInternal;
    }
    return $result;
  }
  SelectiveGapicGeneration._() : super();
  factory SelectiveGapicGeneration.fromBuffer($core.List<$core.int> i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromBuffer(i, r);
  factory SelectiveGapicGeneration.fromJson($core.String i,
          [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) =>
      create()..mergeFromJson(i, r);

  static final $pb.BuilderInfo _i = $pb.BuilderInfo(
      _omitMessageNames ? '' : 'SelectiveGapicGeneration',
      package: const $pb.PackageName(_omitMessageNames ? '' : 'google.api'),
      createEmptyInstance: create)
    ..pPS(1, _omitFieldNames ? '' : 'methods')
    ..aOB(2, _omitFieldNames ? '' : 'generateOmittedAsInternal')
    ..hasRequiredFields = false;

  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectiveGapicGeneration clone() =>
      SelectiveGapicGeneration()..mergeFromMessage(this);
  @$core.Deprecated('See https://github.com/google/protobuf.dart/issues/998.')
  SelectiveGapicGeneration copyWith(
          void Function(SelectiveGapicGeneration) updates) =>
      super.copyWith((message) => updates(message as SelectiveGapicGeneration))
          as SelectiveGapicGeneration;

  $pb.BuilderInfo get info_ => _i;

  @$core.pragma('dart2js:noInline')
  static SelectiveGapicGeneration create() => SelectiveGapicGeneration._();
  SelectiveGapicGeneration createEmptyInstance() => create();
  static $pb.PbList<SelectiveGapicGeneration> createRepeated() =>
      $pb.PbList<SelectiveGapicGeneration>();
  @$core.pragma('dart2js:noInline')
  static SelectiveGapicGeneration getDefault() => _defaultInstance ??=
      $pb.GeneratedMessage.$_defaultFor<SelectiveGapicGeneration>(create);
  static SelectiveGapicGeneration? _defaultInstance;

  /// An allowlist of the fully qualified names of RPCs that should be included
  /// on public client surfaces.
  @$pb.TagNumber(1)
  $pb.PbList<$core.String> get methods => $_getList(0);

  /// Setting this to true indicates to the client generators that methods
  /// that would be excluded from the generation should instead be generated
  /// in a way that indicates these methods should not be consumed by
  /// end users. How this is expressed is up to individual language
  /// implementations to decide. Some examples may be: added annotations,
  /// obfuscated identifiers, or other language idiomatic patterns.
  @$pb.TagNumber(2)
  $core.bool get generateOmittedAsInternal => $_getBF(1);
  @$pb.TagNumber(2)
  set generateOmittedAsInternal($core.bool v) {
    $_setBool(1, v);
  }

  @$pb.TagNumber(2)
  $core.bool hasGenerateOmittedAsInternal() => $_has(1);
  @$pb.TagNumber(2)
  void clearGenerateOmittedAsInternal() => $_clearField(2);
}

class Client {
  static final methodSignature = $pb.Extension<$core.String>.repeated(
      _omitMessageNames ? '' : 'google.protobuf.MethodOptions',
      _omitFieldNames ? '' : 'methodSignature',
      1051,
      $pb.PbFieldType.PS,
      check: $pb.getCheckFunction($pb.PbFieldType.PS));
  static final defaultHost = $pb.Extension<$core.String>(
      _omitMessageNames ? '' : 'google.protobuf.ServiceOptions',
      _omitFieldNames ? '' : 'defaultHost',
      1049,
      $pb.PbFieldType.OS);
  static final oauthScopes = $pb.Extension<$core.String>(
      _omitMessageNames ? '' : 'google.protobuf.ServiceOptions',
      _omitFieldNames ? '' : 'oauthScopes',
      1050,
      $pb.PbFieldType.OS);
  static final apiVersion = $pb.Extension<$core.String>(
      _omitMessageNames ? '' : 'google.protobuf.ServiceOptions',
      _omitFieldNames ? '' : 'apiVersion',
      525000001,
      $pb.PbFieldType.OS);
  static void registerAllExtensions($pb.ExtensionRegistry registry) {
    registry.add(methodSignature);
    registry.add(defaultHost);
    registry.add(oauthScopes);
    registry.add(apiVersion);
  }
}

const _omitFieldNames = $core.bool.fromEnvironment('protobuf.omit_field_names');
const _omitMessageNames =
    $core.bool.fromEnvironment('protobuf.omit_message_names');
