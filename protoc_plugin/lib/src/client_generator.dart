// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../protoc.dart';

class ClientApiGenerator {
  // The service that this Client API connects to.
  final ServiceGenerator service;
  final String className;
  final Set<String> usedMethodNames = {...reservedMemberNames};

  /// Tag of `FileDescriptorProto.service`.
  static const _fileDescriptorServiceTag = 6;

  /// Tag of `ServiceDescriptorProto.method`.
  static const _serviceDescriptorMethodTag = 2;

  /// Index of the service in `FileDescriptorProto.service` repeated field.
  final int _repeatedFieldIndex;

  List<int> get _serviceDescriptorPath => [
        ...service.fileGen.fieldPath,
        _fileDescriptorServiceTag,
        _repeatedFieldIndex
      ];

  List<int> _methodDescriptorPath(int methodRepeatedFieldIndex) => [
        ..._serviceDescriptorPath,
        _serviceDescriptorMethodTag,
        methodRepeatedFieldIndex
      ];

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
      out.println('$_clientType _client;');
      out.println('${className}Api(this._client);');
      out.println();

      for (var i = 0; i < service._descriptor.method.length; i++) {
        generateMethod(out, service._descriptor.method[i], i);
      }
    });
    out.println();
  }

  // Subclasses can override this.
  void generateMethod(IndentingWriter out, MethodDescriptorProto m,
      int methodRepeatedFieldIndex) {
    final methodName = disambiguateName(
        avoidInitialUnderscore(service._methodName(m.name)),
        usedMethodNames,
        defaultSuffixes());
    final inputType = service._getDartClassName(m.inputType, forMainFile: true);
    final outputType =
        service._getDartClassName(m.outputType, forMainFile: true);
    final commentBlock = service.fileGen
        .commentBlock(_methodDescriptorPath(methodRepeatedFieldIndex));
    if (commentBlock != null) {
      out.println(commentBlock);
    }
    if (m.options.deprecated) {
      out.println(
          '@$coreImportPrefix.Deprecated(\'This method is deprecated\')');
    }
    out.addBlock(
        '$asyncImportPrefix.Future<$outputType> $methodName('
            '$protobufImportPrefix.ClientContext? ctx, $inputType request) =>',
        ';', () {
      out.println('_client.invoke<$outputType>(ctx, \'$className\', '
          '\'${m.name}\', request, $outputType())');
    });
  }
}
