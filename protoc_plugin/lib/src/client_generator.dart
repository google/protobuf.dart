// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=2.11

part of '../protoc.dart';

class ClientApiGenerator {
  // The service that this Client API connects to.
  final ServiceGenerator service;
  final String className;
  final Set<String> usedMethodNames = {...reservedMemberNames};

  ClientApiGenerator(this.service, Set<String> usedNames)
      : className = disambiguateName(
            avoidInitialUnderscore(service._descriptor.name),
            usedNames,
            defaultSuffixes());

  // Subclasses can override this.
  String get _clientType => '$protobufImportPrefix.RpcClient';

  void generate(IndentingWriter out) {
    out.addBlock('class ${className}Api {', '}', () {
      out.println('$_clientType _client;');
      out.println('${className}Api(this._client);');
      out.println();

      for (var m in service.methods) {
        generateMethod(out, m);
      }
    });
    out.println();
  }

  // Subclasses can override this.
  void generateMethod(IndentingWriter out, _ServiceMethod m) {
    var inputType =
        service._getDartClassName(m.descriptor.inputType, forMainFile: true);
    var outputType =
        service._getDartClassName(m.descriptor.outputType, forMainFile: true);
    out.addBlock(
        '$asyncImportPrefix.Future<$outputType> ${m.dartName}('
            '$protobufImportPrefix.ClientContext? ctx, $inputType request) {',
        '}', () {
      out.println('var emptyResponse = $outputType();');
      out.println('return _client.invoke<$outputType>(ctx, \'$className\', '
          '\'${m.descriptor.name}\', request, emptyResponse);');
    });
  }
}
