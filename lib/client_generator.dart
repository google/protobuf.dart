// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ClientApiGenerator {
  final ServiceDescriptorProto _descriptor;

  ClientApiGenerator(this._descriptor);

  String get classname => _descriptor.name;

  String _shortType(String typename) {
    return typename.substring(typename.lastIndexOf('.') + 1);
  }

  String _methodName(String name) =>
      name.substring(0, 1).toLowerCase() + name.substring(1);

  String get _clientType => 'RpcClient';

  void generate(IndentingWriter out) {
    out.addBlock('class ${classname}Api {', '}', () {
      out.println('$_clientType _client;');
      out.println('${classname}Api(this._client);');
      out.println();

      for (MethodDescriptorProto m in _descriptor.method) {
        generateMethod(out, m);
      }
    });
    out.println();
  }

  void generateMethod(IndentingWriter out, MethodDescriptorProto m) {
    out.addBlock('Future<${_shortType(m.outputType)}> ${_methodName(m.name)}('
        'ClientContext ctx, ${_shortType(m.inputType)} request) {', '}', () {
      out.println('var emptyResponse = new ${_shortType(m.outputType)}();');
      out.println('return _client.invoke(ctx, \'${_descriptor.name}\', '
          '\'${m.name}\', request, emptyResponse);');
    });
  }
}
