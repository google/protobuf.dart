// This is a generated file - do not edit.
//
// Generated from shim.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports
// ignore_for_file: unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'defining.pbjson.dart' as $0;

export 'defining.pbjson.dart';

const $core.Map<$core.String, $core.dynamic> SServiceBase$json = {
  '1': 'S',
  '2': [
    {'1': 'Get', '2': '.d.M', '3': '.d.M'},
  ],
};

@$core.Deprecated('Use sServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    SServiceBase$messageJson = {
  '.d.M': $0.M$json,
};

/// Descriptor for `S`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List sServiceDescriptor =
    $convert.base64Decode('CgFTEhEKA0dldBIELmQuTRoELmQuTQ==');
