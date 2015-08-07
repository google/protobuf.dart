// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ExtensionGenerator {
  final FieldDescriptorProto _descriptor;
  final ProtobufContainer _parent;

  // populated by resolve()
  ProtobufField _field;
  String _extendedClassName = "";

  ExtensionGenerator(this._descriptor, this._parent);

  void resolve(GenerationContext ctx) {
    _field = new ProtobufField(_descriptor, _parent, ctx);

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
    String name = _field.dartFieldName;
    return _parent is MessageGenerator ? '${_parent.classname}.$name' : name;
  }

  bool get needsFixnumImport {
    if (_field == null) throw new StateError("resolve not called");
    return _field.needsFixnumImport;
  }

  /// Adds any imports needed by the Dart code defining this extension.
  void addImportsTo(Set<FileGenerator> imports) {
    if (_field == null) throw new StateError("resolve not called");
    var typeGen = _field.baseType.generator;
    if (typeGen != null && typeGen.fileGen != fileGen) {
      // The type of this extension is defined in a different file,
      // so we need to import it.
      imports.add(typeGen.fileGen);
    }
  }

  void generate(IndentingWriter out) {
    if (_field == null) throw new StateError("resolve not called");

    String name = _field.dartFieldName;
    out.print('static final Extension $name = '
        'new Extension(\'$_extendedClassName\', \'$name\', '
        '${_field.number}, ${_field.typeConstant}');

    String initializer = _field.generateDefaultFunction(package);
    if (_field.isRepeated) {
      // TODO(skybrian) why do we do this only for extensions?
      var dartType = _field.baseType.getDartType(package);
      initializer = '() => new PbList<${dartType}>()';
    }

    var type = _field.baseType;
    if (type.isMessage || type.isGroup) {
      var dartClass = type.getDartType(package);
      out.println(', $initializer, $dartClass.create);');
    } else if (type.isEnum) {
      var dartEnum = type.getDartType(package);
      String valueOf = '(var v) => $dartEnum.valueOf(v)';
      out.println(", $initializer, null, $valueOf);");
    } else if (initializer != null) {
      out.println(", $initializer);");
    } else {
      out.println(");");
    }
  }
}
