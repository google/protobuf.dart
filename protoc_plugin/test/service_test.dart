import 'package:protobuf/protobuf.dart';
import 'package:protoc_plugin/src/generated/descriptor.pb.dart'
    show DescriptorProto, ServiceDescriptorProto;
import 'package:test/test.dart';

import '../out/protos/service.pbserver.dart' as pb;
import '../out/protos/service2.pb.dart' as pb2;
import '../out/protos/service3.pb.dart' as pb3;

class SearchService extends pb.SearchServiceBase {
  @override
  Future<pb.SearchResponse> search(
      ServerContext ctx, pb.SearchRequest request) async {
    final out = pb.SearchResponse();
    if (request.query == 'hello' || request.query == 'world') {
      out.result.add('hello, world!');
    }
    return out;
  }

  @override
  Future<pb2.SearchResponse> search2(
      ServerContext ctx, pb2.SearchRequest request) async {
    final out = pb2.SearchResponse();
    if (request.query == '2') {
      final result = pb3.SearchResult()
        ..url = 'http://example.com/'
        ..snippet = 'hello world (2)!';
      out.results.add(result);
    }
    return out;
  }
}

class FakeJsonServer {
  final GeneratedService searchService;
  FakeJsonServer(this.searchService);

  Future<String> messageHandler(
      String serviceName, String methodName, String requestJson) async {
    if (serviceName == 'SearchService') {
      final request = searchService.createRequest(methodName);
      request.mergeFromJson(requestJson);
      final ctx = ServerContext();
      final reply = await searchService.handleCall(ctx, methodName, request);
      return reply.writeToJson();
    } else {
      throw 'unknown service: $serviceName';
    }
  }
}

class FakeJsonClient implements RpcClient {
  final FakeJsonServer server;

  FakeJsonClient(this.server);

  @override
  Future<T> invoke<T extends GeneratedMessage>(
      ClientContext? ctx,
      String serviceName,
      String methodName,
      GeneratedMessage request,
      T response) async {
    final requestJson = request.writeToJson();
    final replyJson =
        await server.messageHandler(serviceName, methodName, requestJson);
    response.mergeFromJson(replyJson);
    return response;
  }
}

void main() {
  final service = SearchService();
  final server = FakeJsonServer(service);
  final api = pb.SearchServiceApi(FakeJsonClient(server));

  test('end to end RPC using JSON', () async {
    final request = pb.SearchRequest()..query = 'hello';
    final reply = await api.search(ClientContext(), request);
    expect(reply.result, ['hello, world!']);
  });

  test('end to end RPC using message from a different package', () async {
    final request = pb2.SearchRequest()..query = '2';
    final reply = await api.search2(ClientContext(), request);
    expect(reply.results.length, 1);
    expect(reply.results[0].url, 'http://example.com/');
    expect(reply.results[0].snippet, 'hello world (2)!');
  });

  test('can read service descriptor from JSON', () {
    final descriptor = ServiceDescriptorProto()
      ..mergeFromJsonMap(service.$json);
    expect(descriptor.name, 'SearchService');
    final methodNames = descriptor.method.map((m) => m.name).toList();
    expect(methodNames, ['Search', 'Search2']);
  });

  test('can read message descriptors from JSON', () {
    final map = service.$messageJson;
    expect(map.keys, [
      '.service.SearchRequest',
      '.service.SearchResponse',
      '.service2.SearchRequest',
      '.service2.SearchResponse',
      '.service3.SearchResult',
    ]);

    String readMessageName(fqname) {
      final json = map[fqname]!;
      final descriptor = DescriptorProto()..mergeFromJsonMap(json);
      return descriptor.name;
    }

    expect(readMessageName('.service.SearchRequest'), 'SearchRequest');
    expect(readMessageName('.service2.SearchRequest'), 'SearchRequest');
    expect(readMessageName('.service3.SearchResult'), 'SearchResult');
  });
}
