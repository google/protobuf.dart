// This is a generated file - do not edit.
//
// Generated from shim.proto.

// @dart = 3.3

// ignore_for_file: annotate_overrides, camel_case_types, comment_references
// ignore_for_file: constant_identifier_names
// ignore_for_file: curly_braces_in_flow_control_structures
// ignore_for_file: deprecated_member_use_from_same_package, library_prefixes
// ignore_for_file: non_constant_identifier_names, prefer_relative_imports

import 'dart:async' as $async;
import 'dart:core' as $core;

import 'package:protobuf/protobuf.dart' as $pb;

import 'defining.pb.dart' as $0;

export 'package:protobuf/protobuf.dart' show GeneratedMessageGenericExtensions;

export 'defining.pb.dart';

class SApi {
  final $pb.RpcClient _client;

  SApi(this._client);

  $async.Future<$0.M> get($pb.ClientContext? ctx, $0.M request) =>
      _client.invoke<$0.M>(ctx, 'S', 'Get', request, $0.M());
}
