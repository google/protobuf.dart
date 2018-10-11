// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ClientApiGenerator {
  // The service that this Client API connects to.
  final ServiceGenerator service;

  ClientApiGenerator(this.service);

  // Subclasses can override this.
  String get _clientType => '$_protobufImportPrefix.RpcClient';

  void generate(IndentingWriter out) {
    var className = service._descriptor.name;
    out.addBlock('class ${className}Api {', '}', () {
      out.println('$_clientType _client;');
      out.println('${className}Api(this._client);');
      out.println();

      for (MethodDescriptorProto m in service._descriptor.method) {
        generateMethod(out, m);
      }
    });
    out.println();
  }

  // Subclasses can override this.
  void generateMethod(IndentingWriter out, MethodDescriptorProto m) {
    var methodName = service._methodName(m.name);
    var inputType = service._getDartClassName(m.inputType);
    var outputType = service._getDartClassName(m.outputType);
    out.addBlock(
        '\$async.Future<$outputType> $methodName('
        '$_protobufImportPrefix.ClientContext ctx, $inputType request) {',
        '}', () {
      out.println('var emptyResponse = new $outputType();');
      out.println(
          'return _client.invoke<$outputType>(ctx, \'${service._descriptor.name}\', '
          '\'${m.name}\', request, emptyResponse);');
    });
  }
}
