// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ServiceGenerator extends ProtobufContainer {
  final String classname;
  final String fqname;

  final ProtobufContainer _parent;
  final GenerationContext _context;
  final ServiceDescriptorProto _descriptor;
  final List<MethodDescriptorProto> _methodDescriptors;

  ServiceGenerator(ServiceDescriptorProto descriptor, ProtobufContainer parent,
      this._context)
      : _descriptor = descriptor,
        _parent = parent,
        classname = descriptor.name,
        fqname = _qualifiedName(descriptor, parent),
        _methodDescriptors = descriptor.method {
    _context.register(this);
  }

  static String  _qualifiedName(ServiceDescriptorProto descriptor,
      ProtobufContainer parent) {
    if (parent == null || parent.fqname == null) {
      return descriptor.name;
    } else if (parent.fqname == '.') {
      return '.${descriptor.name}';
    } else {
      return '${parent.fqname}.${descriptor.name}';
    }
  }

  static String _serviceClassName(descriptor) {
    if (descriptor.name.endsWith("Service")) {
      return descriptor.name + "Base"; // avoid: ServiceServiceBase
    } else {
      return descriptor.name + "ServiceBase";
    }
  }

  String get package => _parent.package;

  String _shortType(String typename) {
    return typename.substring(typename.lastIndexOf('.') + 1);
  }

  String _methodName(String name) =>
      name.substring(0,1).toLowerCase() + name.substring(1);

  void generate(IndentingWriter out) {
    out.addBlock(
        'abstract class ${_serviceClassName(_descriptor)} extends '
        'GeneratedService {',
        '}', () {
      for (MethodDescriptorProto m in _methodDescriptors) {
        var methodName = _methodName(m.name);
        out.println('Future<${_shortType(m.outputType)}> $methodName('
            'ServerContext ctx, ${_shortType(m.inputType)} request);');
      }
      out.println();

      out.addBlock(
          'GeneratedMessage createRequest(String method) {', '}', () {
        out.addBlock("switch (method) {", "}", () {
          for (MethodDescriptorProto m in _methodDescriptors) {
            out.println(
              "case '${m.name}': return new ${_shortType(m.inputType)}();");
          }
          out.println("default: "
            "throw new ArgumentError('Unknown method: \$method');");
        });
      });
      out.println();

      out.addBlock(
          'Future<GeneratedMessage> handleCall(ServerContext ctx, '
          'String method, GeneratedMessage request) async {', '}', () {
        out.addBlock("switch (method) {", "}", () {
          for (MethodDescriptorProto m in _methodDescriptors) {
            var methodName = _methodName(m.name);
            out.println(
              "case '${m.name}': return await $methodName(ctx, request);");
          }
          out.println("default: "
            "throw new ArgumentError('Unknown method: \$method');");
        });
      });
    });
    out.println();
  }
}
