abstract class TestServiceBase extends $pb.GeneratedService {
  $async.Future<$0.SomeReply> aMethod(
    $pb.ServerContext ctx,
    $0.SomeRequest request,
  );
  $async.Future<$1.AnotherReply> anotherMethod(
    $pb.ServerContext ctx,
    $1.EmptyMessage request,
  );

  $pb.GeneratedMessage createRequest($core.String methodName) {
    switch (methodName) {
      case 'AMethod':
        return $0.SomeRequest();
      case 'AnotherMethod':
        return $1.EmptyMessage();
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $async.Future<$pb.GeneratedMessage> handleCall(
    $pb.ServerContext ctx,
    $core.String methodName,
    $pb.GeneratedMessage request,
  ) {
    switch (methodName) {
      case 'AMethod':
        return aMethod(ctx, request as $0.SomeRequest);
      case 'AnotherMethod':
        return anotherMethod(ctx, request as $1.EmptyMessage);
      default:
        throw $core.ArgumentError('Unknown method: $methodName');
    }
  }

  $core.Map<$core.String, $core.dynamic> get $json => TestServiceBase$json;
  $core.Map<$core.String, $core.Map<$core.String, $core.dynamic>>
  get $messageJson => TestServiceBase$messageJson;
}
