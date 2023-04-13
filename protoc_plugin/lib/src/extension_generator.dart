// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../protoc.dart';

class ExtensionGenerator {
  final FieldDescriptorProto _descriptor;
  final ProtobufContainer _parent;

  // populated by resolve()
  late ProtobufField _field;
  bool _resolved = false;
  final String _extensionName;
  String _extendedFullName = '';
  final List<int> _fieldPathSegment;

  /// See [ProtobufContainer]
  late final List<int> fieldPath = List.from(_parent.fieldPath!)
    ..addAll(_fieldPathSegment);

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
    _resolved = true;

    final extendedType = ctx.getFieldType(_descriptor.extendee);
    // TODO(skybrian) When would this be null?
    if (extendedType != null) {
      _extendedFullName = extendedType.fullName;
    }
  }

  String get package => _parent.package;

  /// The generator of the .pb.dart file where this extension will be defined.
  FileGenerator? get fileGen => _parent.fileGen;

  String get name {
    if (!_resolved) throw StateError('resolve not called');
    final name = _extensionName;
    return _parent is MessageGenerator ? '${_parent.classname}.$name' : name;
  }

  bool get needsFixnumImport {
    if (!_resolved) throw StateError('resolve not called');
    return _field.needsFixnumImport;
  }

  /// Adds dependencies of [generate] to [imports].
  ///
  /// For each .pb.dart file that the generated code needs to import,
  /// add its generator.
  void addImportsTo(
      Set<FileGenerator> imports, Set<FileGenerator> enumImports) {
    if (!_resolved) throw StateError('resolve not called');
    final typeGen = _field.baseType.generator;
    if (typeGen is EnumGenerator) {
      // Enums are always in a different file.
      enumImports.add(typeGen.fileGen!);
    } else if (typeGen != null && typeGen.fileGen != fileGen) {
      imports.add(typeGen.fileGen!);
    }
  }

  /// For each .pb.dart file that the generated code needs to import,
  /// add its generator.
  void addConstantImportsTo(Set<FileGenerator> imports) {
    if (!_resolved) throw StateError('resolve not called');
    // No dependencies - nothing to do.
  }

  void generate(IndentingWriter out) {
    if (!_resolved) throw StateError('resolve not called');

    final name = _extensionName;
    final type = _field.baseType;
    final dartType = type.getDartType(fileGen!);

    final omitFieldNames = ConditionalConstDefinition('omit_field_names');
    out.addSuffix(
        omitFieldNames.constFieldName, omitFieldNames.constDefinition);
    final conditionalName = omitFieldNames.createTernary(_extensionName);
    final omitMessageNames = ConditionalConstDefinition('omit_message_names');
    out.addSuffix(
        omitMessageNames.constFieldName, omitMessageNames.constDefinition);
    final conditionalExtendedName =
        omitMessageNames.createTernary(_extendedFullName);

    String invocation;
    final positionals = <String>[];
    positionals.add(conditionalExtendedName);
    positionals.add(conditionalName);
    positionals.add('${_field.number}');
    positionals.add(_field.typeConstant);

    final named = <String, String?>{};
    named['protoName'] = _field.quotedProtoName;
    if (_field.isRepeated) {
      invocation = '$protobufImportPrefix.Extension<$dartType>.repeated';
      named['check'] =
          '$protobufImportPrefix.getCheckFunction(${_field.typeConstant})';
      if (type.isMessage || type.isGroup) {
        named['subBuilder'] = '$dartType.create';
      } else if (type.isEnum) {
        named['valueOf'] = '$dartType.valueOf';
        named['enumValues'] = '$dartType.values';
      }
    } else {
      invocation = '$protobufImportPrefix.Extension<$dartType>';
      named['defaultOrMaker'] = _field.generateDefaultFunction();
      if (type.isMessage || type.isGroup) {
        named['subBuilder'] = '$dartType.create';
      } else if (type.isEnum) {
        final dartEnum = type.getDartType(fileGen!);
        named['valueOf'] = '$dartEnum.valueOf';
        named['enumValues'] = '$dartEnum.values';
      }
    }
    final fieldDefinition = 'static final ';
    out.printAnnotated(
        '$fieldDefinition$name = '
        '$invocation(${ProtobufField._formatArguments(positionals, named)});\n',
        [
          NamedLocation(
              name: name,
              fieldPathSegment: List.from(fieldPath),
              start: fieldDefinition.length)
        ]);
  }
}
