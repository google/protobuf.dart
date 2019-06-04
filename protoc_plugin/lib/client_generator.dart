// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ClientApiGenerator {
  // The service that this Client API connects to.
  final ServiceGenerator service;
  final String className;
  final Set<String> usedMethodNames = Set<String>()
    ..addAll(reservedMemberNames);

  ClientApiGenerator(this.service, Set<String> usedNames)
      : className = disambiguateName(
            avoidInitialUnderscore(service._descriptor.name),
            usedNames,
            defaultSuffixes());

  // Subclasses can override this.
  String get _clientType => '$_protobufImportPrefix.RpcClient';

  void generate(IndentingWriter out) {
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
    var methodName = disambiguateName(
        avoidInitialUnderscore(service._methodName(m.name)),
        usedMethodNames,
        defaultSuffixes());
    var inputType = service._getDartClassName(m.inputType, forMainFile: true);
    var outputType = service._getDartClassName(m.outputType, forMainFile: true);
    out.addBlock(
        '$_asyncImportPrefix.Future<$outputType> $methodName('
            '$_protobufImportPrefix.ClientContext ctx, $inputType request) {',
        '}', () {
      out.println('var emptyResponse = $outputType();');
      out.println('return _client.invoke<$outputType>(ctx, \'${className}\', '
          '\'${m.name}\', request, emptyResponse);');
    });
  }
}
