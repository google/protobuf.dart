// This is a generated file - do not edit.
//
// Generated from testpkg.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, unused_import

import 'dart:convert' as $convert;
import 'dart:core' as $core;
import 'dart:typed_data' as $typed_data;

import 'foobar.pbjson.dart' as $1;

@$core.Deprecated('Use someRequestDescriptor instead')
const SomeRequest$json = {
  '1': 'SomeRequest',
};

/// Descriptor for `SomeRequest`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List someRequestDescriptor =
    $convert.base64Decode('CgtTb21lUmVxdWVzdA==');

@$core.Deprecated('Use someReplyDescriptor instead')
const SomeReply$json = {
  '1': 'SomeReply',
};

/// Descriptor for `SomeReply`. Decode as a `google.protobuf.DescriptorProto`.
final $typed_data.Uint8List someReplyDescriptor =
    $convert.base64Decode('CglTb21lUmVwbHk=');

const $core.Map<$core.String, $core.dynamic> TestServiceBase$json = {
  '1': 'Test',
  '2': [
    {'1': 'AMethod', '2': '.testpkg.SomeRequest', '3': '.testpkg.SomeReply'},
    {
      '1': 'AnotherMethod',
      '2': '.foo.bar.EmptyMessage',
      '3': '.foo.bar.AnotherReply'
    },
  ],
};

@$core.Deprecated('Use testServiceDescriptor instead')
const $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
    TestServiceBase$messageJson = {
  '.testpkg.SomeRequest': SomeRequest$json,
  '.testpkg.SomeReply': SomeReply$json,
  '.foo.bar.EmptyMessage': $1.EmptyMessage$json,
  '.foo.bar.AnotherReply': $1.AnotherReply$json,
};

/// Descriptor for `Test`. Decode as a `google.protobuf.ServiceDescriptorProto`.
final $typed_data.Uint8List testServiceDescriptor = $convert.base64Decode(
    'CgRUZXN0EjMKB0FNZXRob2QSFC50ZXN0cGtnLlNvbWVSZXF1ZXN0GhIudGVzdHBrZy5Tb21lUm'
    'VwbHkSPQoNQW5vdGhlck1ldGhvZBIVLmZvby5iYXIuRW1wdHlNZXNzYWdlGhUuZm9vLmJhci5B'
    'bm90aGVyUmVwbHk=');
