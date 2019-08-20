// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ExtensionGenerator {
  final FieldDescriptorProto _descriptor;
  final ProtobufContainer _parent;

  // populated by resolve()
  ProtobufField _field;
  final String _extensionName;
  String _extendedFullName = "";
  List<int> _fieldPath;
  final List<int> _fieldPathSegment;

  /// See [[ProtobufContainer]
  List<int> get fieldPath =>
      _fieldPath ??= List.from(_parent.fieldPath)..addAll(_fieldPathSegment);

  ExtensionGenerator._(this._descriptor, this._parent, Set<String> usedNames,
      int repeatedFieldIndex, int fieldIdTag)
      : _extensionName = extensionName(_descriptor, usedNames),
        _fieldPathSegment = [fieldIdTag, repeatedFieldIndex];

  static const _topLevelFieldTag = 7;
  static const _nestedFieldTag = 6;

  ExtensionGenerator.topLevel(FieldDescriptorProto descriptor,
      ProtobufContainer parent, Set<String> usedNames, int repeatedFieldIndex)
      : this._(descriptor, parent, usedNames, repeatedFieldIndex,
            _topLevelFieldTag);
  ExtensionGenerator.nested(FieldDescriptorProto descriptor,
      ProtobufContainer parent, Set<String> usedNames, int repeatedFieldIndex)
      : this._(
            descriptor, parent, usedNames, repeatedFieldIndex, _nestedFieldTag);

  void resolve(GenerationContext ctx) {
    _field = ProtobufField.extension(_descriptor, _parent, ctx);

    ProtobufContainer extendedType = ctx.getFieldType(_descriptor.extendee);
    // TODO(skybrian) When would this be null?
    if (extendedType != null) {
      _extendedFullName = extendedType.fullName;
    }
  }

  String get package => _parent.package;

  /// The generator of the .pb.dart file where this extension will be defined.
  FileGenerator get fileGen => _parent.fileGen;

  String get name {
    if (_field == null) throw StateError("resolve not called");
    String name = _extensionName;
    return _parent is MessageGenerator ? '${_parent.classname}.$name' : name;
  }

  bool get needsFixnumImport {
    if (_field == null) throw StateError("resolve not called");
    return _field.needsFixnumImport;
  }

  /// Adds dependencies of [generate] to [imports].
  ///
  /// For each .pb.dart file that the generated code needs to import,
  /// add its generator.
  void addImportsTo(
      Set<FileGenerator> imports, Set<FileGenerator> enumImports) {
    if (_field == null) throw StateError("resolve not called");
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
    if (_field == null) throw StateError("resolve not called");
    // No dependencies - nothing to do.
  }

  void generate(IndentingWriter out) {
    if (_field == null) throw StateError("resolve not called");

    String name = _extensionName;
    var type = _field.baseType;
    var dartType = type.getDartType(fileGen);
    String invocation;
    List<String> positionals = <String>[];
    positionals.add("'$_extendedFullName'");
    positionals.add("'${_descriptor.jsonName}'");
    positionals.add('${_field.number}');
    positionals.add(_field.typeConstant);

    Map<String, String> named = <String, String>{};
    named['protoName'] = _field.quotedProtoName;
    if (_field.isRepeated) {
      invocation = '$_protobufImportPrefix.Extension<$dartType>.repeated';
      named['check'] =
          '$_protobufImportPrefix.getCheckFunction(${_field.typeConstant})';
      if (type.isMessage || type.isGroup) {
        named['subBuilder'] = '$dartType.create';
      } else if (type.isEnum) {
        named['valueOf'] = '$dartType.valueOf';
        named['enumValues'] = '$dartType.values';
      }
    } else {
      invocation = '$_protobufImportPrefix.Extension<$dartType>';
      named['defaultOrMaker'] = _field.generateDefaultFunction(fileGen);
      if (type.isMessage || type.isGroup) {
        named['subBuilder'] = '$dartType.create';
      } else if (type.isEnum) {
        var dartEnum = type.getDartType(fileGen);
        named['valueOf'] = '$dartEnum.valueOf';
        named['enumValues'] = '$dartEnum.values';
      }
    }
    assert(invocation != null);
    out.printAnnotated(
        'static final $_protobufImportPrefix.Extension $name = '
        '$invocation(${ProtobufField._formatArguments(positionals, named)});\n',
        [
          NamedLocation(
              name: name,
              fieldPathSegment: List.from(fieldPath),
              start: 'static final $_protobufImportPrefix.Extension '.length)
        ]);
  }
}
