// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ExtensionGenerator {
  final FieldDescriptorProto _descriptor;
  final ProtobufContainer _parent;

  // populated by resolve()
  ProtobufField _field;
  String _extensionName;
  String _extendedClassName = "";

  ExtensionGenerator(this._descriptor, this._parent);

  void resolve(GenerationContext ctx) {
    _extensionName = extensionName(_descriptor);
    _field = new ProtobufField.extension(_descriptor, _parent, ctx);

    ProtobufContainer extendedType = ctx.getFieldType(_descriptor.extendee);
    // TODO(skybrian) When would this be null?
    if (extendedType != null) {
      _extendedClassName = extendedType.classname;
    }
  }

  String get package => _parent.package;

  /// The generator of the .pb.dart file where this extension will be defined.
  FileGenerator get fileGen => _parent.fileGen;

  String get name {
    if (_field == null) throw new StateError("resolve not called");
    String name = _extensionName;
    return _parent is MessageGenerator ? '${_parent.classname}.$name' : name;
  }

  bool get needsFixnumImport {
    if (_field == null) throw new StateError("resolve not called");
    return _field.needsFixnumImport;
  }

  /// Adds dependencies of [generate] to [imports].
  ///
  /// For each .pb.dart file that the generated code needs to import,
  /// add its generator.
  void addImportsTo(
      Set<FileGenerator> imports, Set<FileGenerator> enumImports) {
    if (_field == null) throw new StateError("resolve not called");
    var typeGen = _field.baseType.generator;
    if (typeGen != null) {
      // The type of this extension is defined in a different file,
      // so we need to import it.
      if (typeGen is EnumGenerator) {
        // Enums are always in a different file.
        enumImports.add(typeGen.fileGen);
      } else if (typeGen.fileGen != fileGen) {
        imports.add(typeGen.fileGen);
      }
    }
  }

  /// Adds dependencies of [generateConstants] to [imports].
  ///
  /// For each .pb.dart file that the generated code needs to import,
  /// add its generator.
  void addConstantImportsTo(Set<FileGenerator> imports) {
    if (_field == null) throw new StateError("resolve not called");
    // No dependencies - nothing to do.
  }

  void generate(IndentingWriter out) {
    if (_field == null) throw new StateError("resolve not called");

    String name = _extensionName;
    var type = _field.baseType;
    var dartType = type.getDartType(package);

    if (_field.isRepeated) {
      out.print('static final $_protobufImportPrefix.Extension $name = '
          'new $_protobufImportPrefix.Extension<$dartType>.repeated(\'$_extendedClassName\','
          ' \'$name\', ${_field.number}, ${_field.typeConstant}');
      if (type.isMessage || type.isGroup) {
        out.println(', $dartType.$checkItem, $dartType.create);');
      } else if (type.isEnum) {
        out.println(', $dartType.$checkItem, null, '
            '$dartType.valueOf, $dartType.values);');
      } else {
        out.println(
            ", $_protobufImportPrefix.getCheckFunction(${_field.typeConstant}));");
      }
      return;
    }

    out.print('static final $_protobufImportPrefix.Extension $name = '
        'new $_protobufImportPrefix.Extension<$dartType>(\'$_extendedClassName\', \'$name\', '
        '${_field.number}, ${_field.typeConstant}');

    String initializer = _field.generateDefaultFunction(package);

    if (type.isMessage || type.isGroup) {
      out.println(', $initializer, $dartType.create);');
    } else if (type.isEnum) {
      var dartEnum = type.getDartType(package);
      String enumParams = '(var v) => $dartEnum.valueOf(v), $dartEnum.values';
      out.println(", $initializer, null, $enumParams);");
    } else if (initializer != null) {
      out.println(", $initializer);");
    } else {
      out.println(");");
    }
  }
}
