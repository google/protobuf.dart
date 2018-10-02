// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class MessageGenerator extends ProtobufContainer {
  /// Returns the mixin for this message, or null if none.
  ///
  /// First searches [declaredMixins], then internal mixins declared by
  /// [findMixin].
  static PbMixin _getMixin(DescriptorProto desc, FileDescriptorProto file,
      Map<String, PbMixin> declaredMixins, PbMixin defaultMixin) {
    if (!desc.hasOptions() || !desc.options.hasExtension(Dart_options.mixin)) {
      return defaultMixin;
    }

    String name = desc.options.getExtension(Dart_options.mixin);
    if (name.isEmpty) return null; // don't use any mixins (override default)
    var mixin = declaredMixins[name] ?? findMixin(name);
    if (mixin == null) {
      throw '${desc.name} in ${file.name}: mixin "$name" not found';
    }
    return mixin;
  }

  /// The name of the Dart class to generate.
  final String classname;

  /// The fully-qualified name of the message (without any leading '.').
  final String fullName;

  /// The part of the fully qualified name that comes after the package prefix.
  ///
  /// For nested messages this will include the names of the parents.
  ///
  /// For example:
  /// ```
  /// package foo;
  ///
  /// message Container {
  ///   message Nested {
  ///     int32 int32_value = 1;
  ///   }
  /// }
  /// ```
  /// The nested message will have a `fullName` of 'foo.Container.Nested', and a
  /// `messageName` of 'Container.Nested'.
  String get messageName =>
      fullName.substring(package.length == 0 ? 0 : package.length + 1);

  final PbMixin mixin;

  final ProtobufContainer _parent;
  final DescriptorProto _descriptor;
  final List<EnumGenerator> _enumGenerators = <EnumGenerator>[];
  final List<MessageGenerator> _messageGenerators = <MessageGenerator>[];
  final List<ExtensionGenerator> _extensionGenerators = <ExtensionGenerator>[];

  // populated by resolve()
  List<ProtobufField> _fieldList;

  MessageGenerator(DescriptorProto descriptor, ProtobufContainer parent,
      Map<String, PbMixin> declaredMixins, PbMixin defaultMixin)
      : _descriptor = descriptor,
        _parent = parent,
        classname = messageOrEnumClassName(descriptor.name,
            parent: parent?.classname ?? ''),
        assert(parent != null),
        fullName = parent.fullName == ''
            ? descriptor.name
            : '${parent.fullName}.${descriptor.name}',
        mixin = _getMixin(descriptor, parent.fileGen.descriptor, declaredMixins,
            defaultMixin) {
    for (EnumDescriptorProto e in _descriptor.enumType) {
      _enumGenerators.add(new EnumGenerator(e, this));
    }

    for (DescriptorProto n in _descriptor.nestedType) {
      _messageGenerators
          .add(new MessageGenerator(n, this, declaredMixins, defaultMixin));
    }

    for (FieldDescriptorProto x in _descriptor.extension) {
      _extensionGenerators.add(new ExtensionGenerator(x, this));
    }
  }

  String get package => _parent.package;

  /// The generator of the .pb.dart file that will declare this type.
  FileGenerator get fileGen => _parent.fileGen;

  /// Throws an exception if [resolve] hasn't been called yet.
  void checkResolved() {
    if (_fieldList == null) {
      throw new StateError("message not resolved: ${fullName}");
    }
  }

  /// Returns a const expression that evaluates to the JSON for this message.
  /// [usage] represents the .pb.dart file where the expression will be used.
  String getJsonConstant(FileGenerator usage) {
    var name = "$classname\$json";
    if (usage.protoFileUri == fileGen.protoFileUri) {
      return name;
    }
    return "$fileImportPrefix.$name";
  }

  /// Adds all mixins used in this message and any submessages.
  void addMixinsTo(Set<PbMixin> output) {
    if (mixin != null) {
      output.addAll(mixin.findMixinsToApply());
    }
    for (var m in _messageGenerators) {
      m.addMixinsTo(output);
    }
  }

  // Registers message and enum types that can be used elsewhere.
  void register(GenerationContext ctx) {
    ctx.registerFieldType(this);
    for (var m in _messageGenerators) {
      m.register(ctx);
    }
    for (var e in _enumGenerators) {
      e.register(ctx);
    }
  }

  // Creates fields and resolves extension targets.
  void resolve(GenerationContext ctx) {
    if (_fieldList != null) throw new StateError("message already resolved");

    var reserved = mixin?.findReservedNames() ?? const <String>[];
    var fields = messageFieldNames(_descriptor, reserved: reserved);

    _fieldList = <ProtobufField>[];
    for (MemberNames names in fields.values) {
      _fieldList.add(new ProtobufField.message(names, this, ctx));
    }

    for (var m in _messageGenerators) {
      m.resolve(ctx);
    }
    for (var x in _extensionGenerators) {
      x.resolve(ctx);
    }
  }

  bool get needsFixnumImport {
    if (_fieldList == null) throw new StateError("message not resolved");
    for (var field in _fieldList) {
      if (field.needsFixnumImport) return true;
    }
    for (var m in _messageGenerators) {
      if (m.needsFixnumImport) return true;
    }
    for (var x in _extensionGenerators) {
      if (x.needsFixnumImport) return true;
    }
    return false;
  }

  /// Adds dependencies of [generate] to [imports].
  ///
  /// For each .pb.dart file that the generated code needs to import,
  /// add its generator.
  void addImportsTo(
      Set<FileGenerator> imports, Set<FileGenerator> enumImports) {
    if (_fieldList == null) throw new StateError("message not resolved");
    for (var field in _fieldList) {
      var typeGen = field.baseType.generator;
      if (typeGen is EnumGenerator) {
        enumImports.add(typeGen.fileGen);
      } else if (typeGen != null) {
        imports.add(typeGen.fileGen);
      }
    }
    for (var m in _messageGenerators) {
      m.addImportsTo(imports, enumImports);
    }
    for (var x in _extensionGenerators) {
      x.addImportsTo(imports, enumImports);
    }
  }

  // Returns the number of enums in this message and all nested messages.
  int get enumCount {
    var count = _enumGenerators.length;
    for (var m in _messageGenerators) {
      count += m.enumCount;
    }
    return count;
  }

  /// Adds dependencies of [generateConstants] to [imports].
  ///
  /// For each .pbjson.dart file that the generated code needs to import,
  /// add its generator.
  void addConstantImportsTo(Set<FileGenerator> imports) {
    if (_fieldList == null) throw new StateError("message not resolved");
    for (var m in _messageGenerators) {
      m.addConstantImportsTo(imports);
    }
    for (var x in _extensionGenerators) {
      x.addConstantImportsTo(imports);
    }
  }

  void generate(IndentingWriter out) {
    checkResolved();

    for (MessageGenerator m in _messageGenerators) {
      m.generate(out);
    }

    var mixinClause = '';
    if (mixin != null) {
      var mixinNames = mixin.findMixinsToApply().map((m) => m.name);
      mixinClause = ' with ${mixinNames.join(", ")}';
    }

    String packageClause = package == ''
        ? ''
        : ', package: const $_protobufImportPrefix.PackageName(\'$package\')';
    out.addBlock(
        'class ${classname} extends $_protobufImportPrefix.GeneratedMessage${mixinClause} {',
        '}', () {
      out.addBlock(
          'static final $_protobufImportPrefix.BuilderInfo _i = '
          'new $_protobufImportPrefix.BuilderInfo(\'${messageName}\'$packageClause)',
          ';', () {
        for (ProtobufField field in _fieldList) {
          var dartFieldName = field.memberNames.fieldName;
          out.println(field.generateBuilderInfoCall(fileGen, dartFieldName));
        }

        if (_descriptor.extensionRange.length > 0) {
          out.println('..hasExtensions = true');
        }
        if (!_hasRequiredFields(this, new Set())) {
          out.println('..hasRequiredFields = false');
        }
      });

      for (ExtensionGenerator x in _extensionGenerators) {
        x.generate(out);
      }

      out.println();

      out.println('${classname}() : super();');
      out.println('${classname}.fromBuffer(List<int> i,'
          ' [$_protobufImportPrefix.ExtensionRegistry r = $_protobufImportPrefix.ExtensionRegistry.EMPTY])'
          ' : super.fromBuffer(i, r);');
      out.println('${classname}.fromJson(String i,'
          ' [$_protobufImportPrefix.ExtensionRegistry r = $_protobufImportPrefix.ExtensionRegistry.EMPTY])'
          ' : super.fromJson(i, r);');
      out.println('${classname} clone() =>'
          ' new ${classname}()..mergeFromMessage(this);');
      out.println('$classname copyWith(void Function($classname) updates) =>'
          ' super.copyWith((message) => updates(message as $classname));');

      out.println('$_protobufImportPrefix.BuilderInfo get info_ => _i;');

      // Factory functions which can be used as default value closures.
      out.println('static ${classname} create() =>'
          ' new ${classname}();');
      out.println(
          'static $_protobufImportPrefix.PbList<${classname}> createRepeated() =>'
          ' new $_protobufImportPrefix.PbList<${classname}>();');
      out.println(
          'static ${classname} getDefault() => _defaultInstance ??= create()..freeze();');
      out.println('static ${classname} _defaultInstance;');
      out.addBlock('static void $checkItem($classname v) {', '}', () {
        out.println('if (v is! $classname)'
            " $_protobufImportPrefix.checkItemFailed(v, _i.qualifiedMessageName);");
      });
      generateFieldsAccessorsMutators(out);
      if (fullName == 'google.protobuf.Any') {
        generateAnyMethods(out);
      }
    });
    out.println();
  }

  // Returns true if the message type has any required fields.  If it doesn't,
  // we can optimize out calls to its isInitialized()/_findInvalidFields()
  // methods.
  //
  // already_seen is used to avoid checking the same type multiple times
  // (and also to protect against unbounded recursion).
  bool _hasRequiredFields(MessageGenerator type, Set alreadySeen) {
    if (type._fieldList == null) throw new StateError("message not resolved");

    if (alreadySeen.contains(type.fullName)) {
      // The type is already in cache.  This means that either:
      // a. The type has no required fields.
      // b. We are in the midst of checking if the type has required fields,
      //    somewhere up the stack.  In this case, we know that if the type
      //    has any required fields, they'll be found when we return to it,
      //    and the whole call to HasRequiredFields() will return true.
      //    Therefore, we don't have to check if this type has required fields
      //    here.
      return false;
    }
    alreadySeen.add(type.fullName);
    // If the type has extensions, an extension with message type could contain
    // required fields, so we have to be conservative and assume such an
    // extension exists.
    if (type._descriptor.extensionRange.length > 0) {
      return true;
    }

    for (ProtobufField field in type._fieldList) {
      if (field.isRequired) {
        return true;
      }
      if (field.baseType.isMessage) {
        MessageGenerator child = field.baseType.generator;
        if (_hasRequiredFields(child, alreadySeen)) {
          return true;
        }
      }
    }
    return false;
  }

  /// Generates methods for the Any message class for packing and unpacking
  /// values.
  void generateAnyMethods(IndentingWriter out) {
    out.println('''
  /// Unpacks the message in [value] into [instance].
  ///
  /// Throws a [InvalidProtocolBufferException] if [typeUrl] does not correspond
  /// to the type of [instance].
  ///
  /// A typical usage would be `any.unpackInto(new Message())`.
  ///
  /// Returns [instance].
  T unpackInto<T extends $_protobufImportPrefix.GeneratedMessage>(T instance,
      {$_protobufImportPrefix.ExtensionRegistry extensionRegistry = $_protobufImportPrefix.ExtensionRegistry.EMPTY}) {
    $_protobufImportPrefix.unpackIntoHelper(value, instance, typeUrl,
        extensionRegistry: extensionRegistry);
    return instance;
  }

  /// Returns `true` if the encoded message matches the type of [instance].
  ///
  /// Can be used with a default instance:
  /// `any.canUnpackInto(Message.getDefault())`
  bool canUnpackInto($_protobufImportPrefix.GeneratedMessage instance) {
    return $_protobufImportPrefix.canUnpackIntoHelper(instance, typeUrl);
  }

  /// Creates a new [Any] encoding [message].
  ///
  /// The [typeUrl] will be [typeUrlPrefix]/`fullName` where `fullName` is
  /// the fully qualified name of the type of [message].
  static Any pack($_protobufImportPrefix.GeneratedMessage message,
      {String typeUrlPrefix = 'type.googleapis.com'}) {
    return new Any()
      ..value = message.writeToBuffer()
      ..typeUrl = '\${typeUrlPrefix}/\${message.info_.qualifiedMessageName}';
  }''');
  }

  void generateFieldsAccessorsMutators(IndentingWriter out) {
    for (ProtobufField field in _fieldList) {
      out.println();
      generateFieldAccessorsMutators(field, out);
    }
  }

  void generateFieldAccessorsMutators(
      ProtobufField field, IndentingWriter out) {
    var fieldTypeString = field.getDartType(fileGen);
    var defaultExpr = field.getDefaultExpr();
    var names = field.memberNames;

    _emitOverrideIf(field.overridesGetter, out);
    var getterExpr = _getterExpression(
        fieldTypeString, field.index, defaultExpr, field.isRepeated);
    out.println('${fieldTypeString} get ${names.fieldName} => ${getterExpr};');

    if (field.isRepeated) {
      if (field.overridesSetter) {
        throw 'Field ${field.fullName} cannot override a setter for '
            '${names.fieldName} because it is repeated.';
      }
      if (field.overridesHasMethod) {
        throw 'Field ${field.fullName} cannot override '
            '${names.hasMethodName}() because it is repeated.';
      }
      if (field.overridesClearMethod) {
        throw 'Field ${field.fullName} cannot override '
            '${names.clearMethodName}() because it is repeated.';
      }
    } else {
      var fastSetter = field.baseType.setter;
      _emitOverrideIf(field.overridesSetter, out);
      if (fastSetter != null) {
        out.println('set ${names.fieldName}'
            '($fieldTypeString v) { '
            '$fastSetter(${field.index}, v);'
            ' }');
      } else {
        out.println('set ${names.fieldName}'
            '($fieldTypeString v) { '
            'setField(${field.number}, v);'
            ' }');
      }
      _emitOverrideIf(field.overridesHasMethod, out);
      out.println('bool ${names.hasMethodName}() =>'
          ' \$_has(${field.index});');
      _emitOverrideIf(field.overridesClearMethod, out);
      out.println('void ${names.clearMethodName}() =>'
          ' clearField(${field.number});');
    }
  }

  String _getterExpression(
      String fieldType, int index, String defaultExpr, bool isRepeated) {
    if (fieldType == 'String') {
      return '\$_getS($index, $defaultExpr)';
    }
    if (fieldType == 'Int64' && defaultExpr == 'null') {
      return '\$_getI64($index)';
    }
    if (defaultExpr == 'null') {
      return isRepeated ? '\$_getList($index)' : '\$_getN($index)';
    }
    return '\$_get($index, $defaultExpr)';
  }

  void _emitOverrideIf(bool condition, IndentingWriter out) {
    if (condition) {
      out.println('@override');
    }
  }

  void generateEnums(IndentingWriter out) {
    for (EnumGenerator e in _enumGenerators) {
      e.generate(out);
    }

    for (MessageGenerator m in _messageGenerators) {
      m.generateEnums(out);
    }
  }

  /// Writes a Dart constant containing the JSON for the ProtoDescriptor.
  /// Also writes a separate constant for each nested message,
  /// to avoid duplication.
  void generateConstants(IndentingWriter out) {
    const nestedTypeTag = 3;
    const enumTypeTag = 4;
    assert(_descriptor.info_.fieldInfo[nestedTypeTag].name == "nestedType");
    assert(_descriptor.info_.fieldInfo[enumTypeTag].name == "enumType");

    var name = getJsonConstant(fileGen);
    var json = _descriptor.writeToJsonMap();
    var nestedTypeNames =
        _messageGenerators.map((m) => m.getJsonConstant(fileGen)).toList();
    var nestedEnumNames =
        _enumGenerators.map((e) => e.getJsonConstant(fileGen)).toList();

    out.addBlock("const $name = const {", "};", () {
      for (var key in json.keys) {
        out.print("'$key': ");
        if (key == "$nestedTypeTag") {
          // refer to message constants by name instead of repeating each value
          out.println("const [${nestedTypeNames.join(", ")}],");
          continue;
        } else if (key == "$enumTypeTag") {
          // refer to enum constants by name
          out.println("const [${nestedEnumNames.join(", ")}],");
          continue;
        }
        writeJsonConst(out, json[key]);
        out.println(",");
      }
    });
    out.println();

    for (var m in _messageGenerators) {
      m.generateConstants(out);
    }

    for (var e in _enumGenerators) {
      e.generateConstants(out);
    }
  }
}
