// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

/// A Dart function called on each item added to a repeated list
/// to check its type and range.
const checkItem = '\$checkItem';

class MessageGenerator extends ProtobufContainer {
  // List of Dart language reserved words in names which cannot be used in a
  // subclass of GeneratedMessage.
  static final List<String> reservedWords = [
    'assert',
    'break',
    'case',
    'catch',
    'class',
    'const',
    'continue',
    'default',
    'do',
    'else',
    'enum',
    'extends',
    'false',
    'final',
    'finally',
    'for',
    'if',
    'in',
    'is',
    'new',
    'null',
    'rethrow',
    'return',
    'super',
    'switch',
    'this',
    'throw',
    'true',
    'try',
    'var',
    'void',
    'while',
    'with'
  ];

  // List of names used in the generated class itself
  static final List<String> generatedNames = [
    'create',
    'createRepeated',
    'getDefault',
    checkItem
  ];

  // Returns the mixin for this message, or null if none.
  static PbMixin _getMixin(DescriptorProto desc, PbMixin defaultValue) {
    if (!desc.hasOptions()) return defaultValue;
    if (!desc.options.hasExtension(Dart_options.mixin)) return defaultValue;

    String name = desc.options.getExtension(Dart_options.mixin);
    if (name.isEmpty) return null; // don't use a mixin (override any default)
    var mixin = findMixin(name);
    if (mixin == null) {
      throw ("unknown mixin class: ${name}");
    }
    return mixin;
  }

  final String classname;
  final String fqname;
  final PbMixin mixin;

  final ProtobufContainer _parent;
  final DescriptorProto _descriptor;
  final List<EnumGenerator> _enumGenerators = <EnumGenerator>[];
  final List<MessageGenerator> _messageGenerators = <MessageGenerator>[];
  final List<ExtensionGenerator> _extensionGenerators = <ExtensionGenerator>[];

  // populated by resolve()
  List<ProtobufField> _fieldList;

  // Used during generation.
  final Set<String> _methodNames = new Set<String>();

  MessageGenerator(DescriptorProto descriptor, ProtobufContainer parent,
      PbMixin defaultMixin)
      : _descriptor = descriptor,
        _parent = parent,
        classname = (parent.classname == '')
            ? descriptor.name
            : '${parent.classname}_${descriptor.name}',
        fqname = (parent == null || parent.fqname == null)
            ? descriptor.name
            : (parent.fqname == '.'
                ? '.${descriptor.name}'
                : '${parent.fqname}.${descriptor.name}'),
        mixin = _getMixin(descriptor, defaultMixin) {
    for (EnumDescriptorProto e in _descriptor.enumType) {
      _enumGenerators.add(new EnumGenerator(e, this));
    }

    for (DescriptorProto n in _descriptor.nestedType) {
      _messageGenerators.add(new MessageGenerator(n, this, defaultMixin));
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
      throw new StateError("message not resolved: ${fqname}");
    }
  }

  /// Returns a const expression that evaluates to the JSON for this message.
  /// [usage] represents the .pb.dart file where the expression will be used.
  String getJsonConstant(FileGenerator usage) {
    var name = "$classname\$json";
    if (usage.package == fileGen.package || packageImportPrefix.isEmpty) {
      return name;
    }
    return "$packageImportPrefix.$name";
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
    ctx.registerFieldType(fqname, this);
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

    var sorted = new List<FieldDescriptorProto>.from(_descriptor.field)
      ..sort((FieldDescriptorProto a, FieldDescriptorProto b) {
        if (a.number < b.number) return -1;
        if (a.number > b.number) return 1;
        throw "multiple fields defined for tag ${a.number} in $fqname";
      });

    _fieldList = <ProtobufField>[];
    for (FieldDescriptorProto field in sorted) {
      int index = _fieldList.length;
      _fieldList.add(new ProtobufField(field, index, this, ctx));
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

  /// Adds generators of the .pb.dart files that this type needs to import.
  void addImportsTo(Set<FileGenerator> imports) {
    if (_fieldList == null) throw new StateError("message not resolved");
    for (var field in _fieldList) {
      var typeGen = field.baseType.generator;
      if (typeGen != null && typeGen.fileGen != fileGen) {
        // The field's type is defined in a different .pb.dart file.
        // Therefore we need to import it.
        imports.add(typeGen.fileGen);
      }
    }
    for (var m in _messageGenerators) {
      m.addImportsTo(imports);
    }
    for (var x in _extensionGenerators) {
      x.addImportsTo(imports);
    }
  }

  void generate(IndentingWriter out) {
    checkResolved();

    _methodNames.clear();
    _methodNames.addAll(reservedWords);
    _methodNames.addAll(GeneratedMessage_reservedNames);
    _methodNames.addAll(generatedNames);

    if (mixin != null) {
      _methodNames.addAll(mixin.findReservedNames());
    }

    for (EnumGenerator e in _enumGenerators) {
      e.generate(out);
    }

    for (MessageGenerator m in _messageGenerators) {
      m.generate(out);
    }

    var mixinClause = '';
    if (mixin != null) {
      var mixinNames = mixin.findMixinsToApply().map((m) => m.name);
      mixinClause = ' with ${mixinNames.join(", ")}';
    }

    out.addBlock(
        'class ${classname} extends GeneratedMessage${mixinClause} {', '}', () {
      out.addBlock(
          'static final BuilderInfo _i = new BuilderInfo(\'${classname}\')',
          ';', () {
        for (ProtobufField field in _fieldList) {
          out.println(field.generateBuilderInfoCall(package));
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
          ' [ExtensionRegistry r = ExtensionRegistry.EMPTY])'
          ' : super.fromBuffer(i, r);');
      out.println('${classname}.fromJson(String i,'
          ' [ExtensionRegistry r = ExtensionRegistry.EMPTY])'
          ' : super.fromJson(i, r);');
      out.println('${classname} clone() =>'
          ' new ${classname}()..mergeFromMessage(this);');

      out.println('BuilderInfo get info_ => _i;');

      // Factory functions which can be used as default value closures.
      out.println('static ${classname} create() =>'
          ' new ${classname}();');
      out.println('static PbList<${classname}> createRepeated() =>'
          ' new PbList<${classname}>();');
      out.addBlock('static ${classname} getDefault() {', '}', () {
        out.println(
            'if (_defaultInstance == null) _defaultInstance = new _Readonly${classname}();');
        out.println('return _defaultInstance;');
      });
      out.println('static ${classname} _defaultInstance;');
      out.addBlock('static void $checkItem($classname v) {', '}', () {
        out.println('if (v is !$classname)'
            " checkItemFailed(v, '$classname');");
      });
      generateFieldsAccessorsMutators(out);
    });
    out.println();

    out.println(
        'class _Readonly${classname} extends ${classname} with ReadonlyMessageMixin {}');
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

    if (alreadySeen.contains(type.fqname)) {
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
    alreadySeen.add(type.fqname);
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

  void generateFieldsAccessorsMutators(IndentingWriter out) {
    for (ProtobufField field in _fieldList) {
      out.println();

      // Choose non-conflicting names.
      String identifier = field.dartFieldName;
      String hasIdentifier = field.hasMethodName;
      String clearIdentifier = field.clearMethodName;
      if (!field.isRepeated) {
        while (_methodNames.contains(identifier) ||
            _methodNames.contains(hasIdentifier) ||
            _methodNames.contains(clearIdentifier)) {
          identifier += '_' + field.number.toString();
          hasIdentifier += '_' + field.number.toString();
          clearIdentifier += '_' + field.number.toString();
        }
        _methodNames.add(identifier);
        _methodNames.add(hasIdentifier);
        _methodNames.add(clearIdentifier);
      } else {
        while (_methodNames.contains(identifier)) {
          identifier += '_' + field.number.toString();
        }
        _methodNames.add(identifier);
      }

      var fieldTypeString = field.getDartType(package);
      var defaultExpr = field.getDefaultExpr();
      out.println('${fieldTypeString} get ${identifier}'
          ' => \$_get('
          '${field.index}, ${field.number}, $defaultExpr);');
      if (!field.isRepeated) {
        var fastSetter = field.baseType.setter;
        if (fastSetter != null) {
          out.println('void set $identifier'
              '($fieldTypeString v) { '
              '$fastSetter(${field.index}, ${field.number}, v);'
              ' }');
        } else {
          out.println('void set $identifier'
              '($fieldTypeString v) { '
              'setField(${field.number}, v);'
              ' }');
        }
        out.println('bool $hasIdentifier() =>'
            ' \$_has(${field.index}, ${field.number});');
        out.println('void $clearIdentifier() =>'
            ' clearField(${field.number});');
      }
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
