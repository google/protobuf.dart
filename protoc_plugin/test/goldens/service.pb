///
//  Generated code. Do not modify.
//  source: test
///
// ignore_for_file: camel_case_types,non_constant_identifier_names,library_prefixes,unused_import

import 'dart:async' as $async;
// ignore: UNUSED_SHOWN_NAME
import 'dart:core' as $core show int, bool, double, String, List, Map, override, Deprecated;

import 'package:protobuf/protobuf.dart' as $pb;

class Empty extends $pb.GeneratedMessage {
  static final $pb.BuilderInfo _i = $pb.BuilderInfo('Empty')
    ..hasRequiredFields = false
  ;

  Empty() : super();
  Empty.fromBuffer($core.List<$core.int> i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromBuffer(i, r);
  Empty.fromJson($core.String i, [$pb.ExtensionRegistry r = $pb.ExtensionRegistry.EMPTY]) : super.fromJson(i, r);
  Empty clone() => Empty()..mergeFromMessage(this);
  Empty copyWith(void Function(Empty) updates) => super.copyWith((message) => updates(message as Empty));
  $pb.BuilderInfo get info_ => _i;
  static Empty create() => Empty();
  Empty createEmptyInstance() => create();
  static $pb.PbList<Empty> createRepeated() => $pb.PbList<Empty>();
  static Empty getDefault() => _defaultInstance ??= create()..freeze();
  static Empty _defaultInstance;
}

class TestApi {
  $pb.RpcClient _client;
  TestApi(this._client);

  $async.Future<Empty> ping($pb.ClientContext ctx, Empty request) {
    var emptyResponse = Empty();
    return _client.invoke<Empty>(ctx, 'Test', 'Ping', request, emptyResponse);
  }
}

