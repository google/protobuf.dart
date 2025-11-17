// This is a generated file - do not edit.
//
// Generated from google/api/client.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

/// The organization for which the client libraries are being published.
/// Affects the url where generated docs are published, etc.
class ClientLibraryOrganization extends $pb.ProtobufEnum {
  /// Not useful.
  static const ClientLibraryOrganization
      CLIENT_LIBRARY_ORGANIZATION_UNSPECIFIED = ClientLibraryOrganization._(
          0, _omitEnumNames ? '' : 'CLIENT_LIBRARY_ORGANIZATION_UNSPECIFIED');

  /// Google Cloud Platform Org.
  static const ClientLibraryOrganization CLOUD =
      ClientLibraryOrganization._(1, _omitEnumNames ? '' : 'CLOUD');

  /// Ads (Advertising) Org.
  static const ClientLibraryOrganization ADS =
      ClientLibraryOrganization._(2, _omitEnumNames ? '' : 'ADS');

  /// Photos Org.
  static const ClientLibraryOrganization PHOTOS =
      ClientLibraryOrganization._(3, _omitEnumNames ? '' : 'PHOTOS');

  /// Street View Org.
  static const ClientLibraryOrganization STREET_VIEW =
      ClientLibraryOrganization._(4, _omitEnumNames ? '' : 'STREET_VIEW');

  /// Shopping Org.
  static const ClientLibraryOrganization SHOPPING =
      ClientLibraryOrganization._(5, _omitEnumNames ? '' : 'SHOPPING');

  /// Geo Org.
  static const ClientLibraryOrganization GEO =
      ClientLibraryOrganization._(6, _omitEnumNames ? '' : 'GEO');

  /// Generative AI - https://developers.generativeai.google
  static const ClientLibraryOrganization GENERATIVE_AI =
      ClientLibraryOrganization._(7, _omitEnumNames ? '' : 'GENERATIVE_AI');

  static const $core.List<ClientLibraryOrganization> values =
      <ClientLibraryOrganization>[
    CLIENT_LIBRARY_ORGANIZATION_UNSPECIFIED,
    CLOUD,
    ADS,
    PHOTOS,
    STREET_VIEW,
    SHOPPING,
    GEO,
    GENERATIVE_AI,
  ];

  static final $core.List<ClientLibraryOrganization?> _byValue =
      $pb.ProtobufEnum.$_initByValueList(values, 7);
  static ClientLibraryOrganization? valueOf($core.int value) =>
      value < 0 || value >= _byValue.length ? null : _byValue[value];

  const ClientLibraryOrganization._(super.value, super.name);
}

/// To where should client libraries be published?
class ClientLibraryDestination extends $pb.ProtobufEnum {
  /// Client libraries will neither be generated nor published to package
  /// managers.
  static const ClientLibraryDestination CLIENT_LIBRARY_DESTINATION_UNSPECIFIED =
      ClientLibraryDestination._(
          0, _omitEnumNames ? '' : 'CLIENT_LIBRARY_DESTINATION_UNSPECIFIED');

  /// Generate the client library in a repo under github.com/googleapis,
  /// but don't publish it to package managers.
  static const ClientLibraryDestination GITHUB =
      ClientLibraryDestination._(10, _omitEnumNames ? '' : 'GITHUB');

  /// Publish the library to package managers like nuget.org and npmjs.com.
  static const ClientLibraryDestination PACKAGE_MANAGER =
      ClientLibraryDestination._(20, _omitEnumNames ? '' : 'PACKAGE_MANAGER');

  static const $core.List<ClientLibraryDestination> values =
      <ClientLibraryDestination>[
    CLIENT_LIBRARY_DESTINATION_UNSPECIFIED,
    GITHUB,
    PACKAGE_MANAGER,
  ];

  static final $core.Map<$core.int, ClientLibraryDestination> _byValue =
      $pb.ProtobufEnum.initByValue(values);
  static ClientLibraryDestination? valueOf($core.int value) => _byValue[value];

  const ClientLibraryDestination._(super.value, super.name);
}

const $core.bool _omitEnumNames =
    $core.bool.fromEnvironment('protobuf.omit_enum_names');
