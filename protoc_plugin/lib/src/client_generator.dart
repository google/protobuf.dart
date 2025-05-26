// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../protoc.dart';

class ClientApiGenerator {
  // The service that this Client API connects to.
  final ServiceGenerator service;
  final String className;
  final Set<String> usedMethodNames = {...reservedMemberNames};

  /// Tag of `ServiceDescriptorProto.method`.
  static const serviceDescriptorMethodTag = 2;

  /// Tag of `FileDescriptorProto.service`.
  static const fileDescriptorServiceTag = 6;

  /// Index of the service in `FileDescriptorProto.service` repeated field.
  final int _repeatedFieldIndex;

  late final List<int> _serviceDescriptorPath = [
    ...service.fileGen.fieldPath,
    fileDescriptorServiceTag,
    _repeatedFieldIndex
  ];

  List<int> _methodDescriptorPath(int methodIndex) {
    return [
      ..._serviceDescriptorPath,
      serviceDescriptorMethodTag,
      methodIndex,
    ];
  }

  ClientApiGenerator(
      this.service, Set<String> usedNames, this._repeatedFieldIndex)
      : className = disambiguateName(
            avoidInitialUnderscore(service._descriptor.name),
            usedNames,
            defaultSuffixes());

  // Subclasses can override this.
  String get _clientType => '$protobufImportPrefix.RpcClient';

  void generate(IndentingWriter out) {
    final commentBlock = service.fileGen.commentBlock(_serviceDescriptorPath);
    if (commentBlock != null) {
      out.println(commentBlock);
    }
    if (service._descriptor.options.deprecated) {
      out.println(
          '@$coreImportPrefix.Deprecated(\'This service is deprecated\')');
    }
    out.addBlock('class ${className}Api {', '}', () {
      out.println('final $_clientType _client;');
      out.println();
      out.println('${className}Api(this._client);');
      out.println();

      for (var i = 0; i < service._descriptor.method.length; i++) {
        generateMethod(out, service._descriptor.method[i], i);
      }
    });
    out.println();
  }

  // Subclasses can override this.
  void generateMethod(
      IndentingWriter out, MethodDescriptorProto method, int methodIndex) {
    final methodName = disambiguateName(
        avoidInitialUnderscore(service._methodName(method.name)),
        usedMethodNames,
        defaultSuffixes());
    final inputType =
        service._getDartClassName(method.inputType, forMainFile: true);
    final outputType =
        service._getDartClassName(method.outputType, forMainFile: true);
    final commentBlock =
        service.fileGen.commentBlock(_methodDescriptorPath(methodIndex));
    if (commentBlock != null) {
      out.println(commentBlock);
    }
    if (method.options.deprecated) {
      out.println(
          '@$coreImportPrefix.Deprecated(\'This method is deprecated\')');
    }
    out.addBlock(
        '$asyncImportPrefix.Future<$outputType> $methodName('
            '$protobufImportPrefix.ClientContext? ctx, $inputType request) =>',
        ';', () {
      out.println('_client.invoke<$outputType>(ctx, \'$className\', '
          '\'${method.name}\', request, $outputType())');
    });
  }
}
