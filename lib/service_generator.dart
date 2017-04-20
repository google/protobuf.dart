// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ServiceGenerator {
  final ServiceDescriptorProto _descriptor;

  /// The generator of the .pb.dart file that will contain this service.
  final FileGenerator fileGen;

  /// The message types needed directly by this service.
  ///
  /// The key is the fully qualified name.
  /// Populated by [resolve].
  final _deps = <String, MessageGenerator>{};

  /// The message types needed transitively by this service.
  ///
  /// The key is the fully qualified name.
  /// Populated by [resolve].
  final _transitiveDeps = <String, MessageGenerator>{};

  /// Maps each undefined type to a string describing its location.
  ///
  /// Populated by [resolve].
  final _undefinedDeps = <String, String>{};

  ServiceGenerator(this._descriptor, this.fileGen);

  String get classname {
    if (_descriptor.name.endsWith("Service")) {
      return _descriptor.name + "Base"; // avoid: ServiceServiceBase
    } else {
      return _descriptor.name + "ServiceBase";
    }
  }

  /// Finds all message types used by this service.
  ///
  /// Puts the types found in [_deps] and [_transitiveDeps].
  /// If a type name can't be resolved, puts it in [_undefinedDeps].
  /// Precondition: messages have been registered and resolved.
  void resolve(GenerationContext ctx) {
    for (var m in _methodDescriptors) {
      _addDependency(ctx, m.inputType, "input type of ${m.name}");
      _addDependency(ctx, m.outputType, "output type of ${m.name}");
    }
    _resolveMoreTypes(ctx);
  }

  /// Hook for a subclass to register any additional types it uses.
  void _resolveMoreTypes(GenerationContext ctx) {}

  /// Adds a dependency on the given message type.
  ///
  /// If the type name can't be resolved, adds it to [_undefinedDeps].
  /// If it can, recursively adds the types of its fields as well.
  void _addDependency(GenerationContext ctx, String fqname, String location) {
    if (_deps.containsKey(fqname)) return; // Already added.

    MessageGenerator mg = ctx.getFieldType(fqname);
    if (mg == null) {
      _undefinedDeps[fqname] = location;
      return;
    }
    _addDepsRecursively(mg, 0);
  }

  void _addDepsRecursively(MessageGenerator mg, int depth) {
    if (_transitiveDeps.containsKey(mg.fqname)) {
      // Already added, but perhaps at a different depth.
      if (depth == 0) _deps[mg.fqname] = mg;
      return;
    }
    mg.checkResolved();
    if (depth == 0) _deps[mg.fqname] = mg;
    _transitiveDeps[mg.fqname] = mg;
    for (var field in mg._fieldList) {
      if (field.baseType.isGroup || field.baseType.isMessage) {
        _addDepsRecursively(field.baseType.generator, depth + 1);
      }
    }
  }

  /// Adds dependencies of [generate] to [imports].
  ///
  /// For each .pb.dart file that the generated code needs to import,
  /// add its generator.
  void addImportsTo(Set<FileGenerator> imports) {
    for (var mg in _deps.values) {
      imports.add(mg.fileGen);
    }
  }

  /// Adds dependencies of [generateConstants] to [imports].
  ///
  /// For each .pbjson.dart file that the generated code needs to import,
  /// add its generator.
  void addConstantImportsTo(Set<FileGenerator> imports) {
    for (var mg in _transitiveDeps.values) {
      imports.add(mg.fileGen);
    }
  }

  /// Returns the Dart class name to use for a message type.
  ///
  /// Throws an exception if it can't be resolved.
  String _getDartClassName(String fqname) {
    var mg = _deps[fqname];
    if (mg == null) {
      var location = _undefinedDeps[fqname];
      throw 'FAILURE: Unknown type reference (${fqname}) for ${location}';
    }
    if (fileGen.package == mg.fileGen.package || mg.fileGen.package == "") {
      // It's either the same file, or another file with the same package.
      // (In the second case, we import it without using "as".)
      return mg.classname;
    }
    return mg.packageImportPrefix + "." + mg.classname;
  }

  List<MethodDescriptorProto> get _methodDescriptors => _descriptor.method;

  String _methodName(String name) =>
      name.substring(0, 1).toLowerCase() + name.substring(1);

  String get _parentClass => 'GeneratedService';

  void _generateStub(IndentingWriter out, MethodDescriptorProto m) {
    var methodName = _methodName(m.name);
    var inputClass = _getDartClassName(m.inputType);
    var outputClass = _getDartClassName(m.outputType);

    out.println('Future<$outputClass> $methodName('
        'ServerContext ctx, $inputClass request);');
  }

  void _generateStubs(IndentingWriter out) {
    for (MethodDescriptorProto m in _methodDescriptors) {
      _generateStub(out, m);
    }
    out.println();
  }

  void _generateRequestMethod(IndentingWriter out) {
    out.addBlock('GeneratedMessage createRequest(String method) {', '}', () {
      out.addBlock("switch (method) {", "}", () {
        for (MethodDescriptorProto m in _methodDescriptors) {
          var inputClass = _getDartClassName(m.inputType);
          out.println("case '${m.name}': return new $inputClass();");
        }
        out.println("default: "
            "throw new ArgumentError('Unknown method: \$method');");
      });
    });
    out.println();
  }

  void _generateDispatchMethod(out) {
    out.addBlock(
        'Future<GeneratedMessage> handleCall(ServerContext ctx, '
        'String method, GeneratedMessage request) {',
        '}', () {
      out.addBlock("switch (method) {", "}", () {
        for (MethodDescriptorProto m in _methodDescriptors) {
          var methodName = _methodName(m.name);
          out.println(
              "case '${m.name}': return this.$methodName(ctx, request);");
        }
        out.println("default: "
            "throw new ArgumentError('Unknown method: \$method');");
      });
    });
    out.println();
  }

  /// Hook for generating members added in subclasses.
  void _generateMoreClassMembers(IndentingWriter out) {}

  void generate(IndentingWriter out) {
    out.addBlock(
        'abstract class $classname extends '
        '$_parentClass {',
        '}', () {
      _generateStubs(out);
      _generateRequestMethod(out);
      _generateDispatchMethod(out);
      _generateMoreClassMembers(out);
      out.println("Map<String, dynamic> get \$json => $jsonConstant;");
      out.println("Map<String, Map<String, dynamic>> get \$messageJson =>"
          " $messageJsonConstant;");
    });
    out.println();
  }

  String get jsonConstant => "${_descriptor.name}\$json";
  String get messageJsonConstant => "${_descriptor.name}\$messageJson";

  /// Writes Dart constants for the service and message descriptors.
  ///
  /// The map includes an entry for every message type that might need
  /// to be read or written (assuming the type name resolved).
  void generateConstants(IndentingWriter out) {
    out.print("const $jsonConstant = ");
    writeJsonConst(out, _descriptor.writeToJsonMap());
    out.println(";");
    out.println();

    var typeConstants = <String, String>{};
    for (var key in _transitiveDeps.keys) {
      typeConstants[key] = _transitiveDeps[key].getJsonConstant(fileGen);
    }
    out.addBlock("const $messageJsonConstant = const {", "};", () {
      for (var key in typeConstants.keys) {
        var typeConst = typeConstants[key];
        out.println("'$key': $typeConst,");
      }
    });
    out.println();

    if (_undefinedDeps.isNotEmpty) {
      for (var name in _undefinedDeps.keys) {
        var location = _undefinedDeps[name];
        out.println("// can't resolve ($name) used by $location");
      }
      out.println();
    }
  }
}
