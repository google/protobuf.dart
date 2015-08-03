// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class MessageGenerator extends ProtobufContainer {
  // List of Dart language reserved words in names which cannot be used in a
  // subclass of GeneratedMessage.
  static final List<String> reservedWords =
      ['assert', 'break', 'case', 'catch', 'class', 'const', 'continue',
       'default', 'do', 'else', 'enum', 'extends', 'false', 'final',
       'finally', 'for', 'if', 'in', 'is', 'new', 'null', 'rethrow', 'return',
       'super', 'switch', 'this', 'throw', 'true', 'try', 'var', 'void',
       'while', 'with'];

  // List of names used in the generated class itself
  static final List<String> generatedNames =
      ['create', 'createRepeated', 'getDefault'];

  // Returns the mixin for this message, or null if none.
  static PbMixin _getMixin(DescriptorProto desc, PbMixin defaultValue) {
    if (!desc.hasOptions()) return defaultValue;
    if (!desc.options.hasExtension(Dart_options.mixin)) return defaultValue;

    String name = desc.options.getExtension(Dart_options.mixin);
    if (name.isEmpty) return null; // don't use a mixin (override any default)
    var mixin = findMixin(name);
    if (mixin == null) {
      throw("unknown mixin class: ${name}");
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

  MessageGenerator(
      DescriptorProto descriptor, ProtobufContainer parent, PbMixin defaultMixin)
      : _descriptor = descriptor,
        _parent = parent,
        classname = (parent.classname == '') ?
            descriptor.name : '${parent.classname}_${descriptor.name}',
        fqname = (parent == null || parent.fqname == null) ? descriptor.name :
            (parent.fqname == '.' ?
                '.${descriptor.name}' : '${parent.fqname}.${descriptor.name}'),
        mixin = _getMixin(descriptor, defaultMixin) {

    for (EnumDescriptorProto e in _descriptor.enumType) {
      _enumGenerators.add(new EnumGenerator(e, this));
    }

    for (DescriptorProto n in _descriptor.nestedType) {
      _messageGenerators.add(
          new MessageGenerator(n, this, defaultMixin));
    }

    for (FieldDescriptorProto x in _descriptor.extension) {
      _extensionGenerators.add(new ExtensionGenerator(x, this));
    }
  }

  String get package => _parent.package;

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
    for (var m  in _messageGenerators) {
      m.register(ctx);
    }
    for (var e in _enumGenerators) {
      e.register(ctx);
    }
  }

  // Creates fields and resolves extension targets.
  void resolve(GenerationContext ctx) {
    if (_fieldList != null) throw new StateError("message already resolved");

    _fieldList = <ProtobufField>[];
    for (FieldDescriptorProto field in _descriptor.field) {
      _fieldList.add(new ProtobufField(field, this, ctx));
    }

    for (var m in _messageGenerators) {
      m.resolve(ctx);
    }
    for (var x in _extensionGenerators) {
      x.resolve(ctx);
    }
  }

  void generate(IndentingWriter out) {
    if (_fieldList == null) throw new StateError("message not resolved");

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

    out.addBlock('class ${classname} extends GeneratedMessage${mixinClause} {',
        '}', ()
      {
      out.addBlock(
          'static final BuilderInfo _i = new BuilderInfo(\'${classname}\')',
          ';', () {
        for (ProtobufField field in _fieldList) {
          String type = field.shortTypeName;
          String fieldType = field.baseTypeForPackage(package);

          String makeDefault = null;
          if (field.hasInitialization) {
            makeDefault = field.initializationForPackage(package);
          }
          String subBuilder = null;
          String subBuilderRepeated = null;
          if (field.message || field.group) {
            subBuilder = '${fieldType}.create';
            subBuilderRepeated = '${fieldType}.createRepeated';
          }
          String valueOf = null;
          if (field.enm) {
            valueOf = '(var v) => ${fieldType}.valueOf(v)';
          }
          if ('PM' == type) {
            // Repeated message: default is an empty list
            out.println('..m(${field.number}, '
                '\'${field.externalFieldName}\', $subBuilder,'
                ' $subBuilderRepeated)');
          } else if (type[0] == 'P' && type != 'PG' && type != 'PE') {
            // Repeated, not a message or enum: default is an empty list,
            // subBuilder is null, valueOf is null.
            out.println('..p(${field.number}, '
                '\'${field.externalFieldName}\', GeneratedMessage.$type)');
          } else if (type == 'OE' || type == 'QE') {
            out.println('..e(${field.number}, '
                '\'${field.externalFieldName}\', GeneratedMessage.$type,'
                ' $makeDefault, $valueOf)');
          } else {
            if (makeDefault == null && subBuilder == null && valueOf == null) {
              out.println('..a(${field.number}, '
                  '\'${field.externalFieldName}\', GeneratedMessage.$type)');
            } else if (subBuilder == null && valueOf == null) {
              out.println('..a(${field.number}, '
                  '\'${field.externalFieldName}\', GeneratedMessage.$type,'
                  ' $makeDefault)');
            } else if (valueOf == null) {
              out.println('..a(${field.number}, '
                  '\'${field.externalFieldName}\', GeneratedMessage.$type,'
                  ' $makeDefault, $subBuilder)');
            } else {
              out.println('..a(${field.number}, '
                  '\'${field.externalFieldName}\', GeneratedMessage.$type,'
                  ' $makeDefault, $subBuilder, $valueOf)');
            }
          }
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
      out.addBlock('static ${classname} getDefault() {',
          '}', () {
        out.println('if (_defaultInstance == null) _defaultInstance = new _Readonly${classname}();');
        out.println('return _defaultInstance;');
      });
      out.println('static ${classname} _defaultInstance;');
      generateFieldsAccessorsMutators(out);
    });
    out.println();

    out.println('class _Readonly${classname} extends ${classname} with ReadonlyMessageMixin {}');
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
      if (field.required) {
        return true;
      }
      if (field.message) {
        MessageGenerator messageType = field.typeGenerator;
        if (_hasRequiredFields(messageType, alreadySeen)) {
          return true;
        }
      }
    }
    return false;
  }

  void generateFieldsAccessorsMutators(IndentingWriter out) {
    for (ProtobufField field in _fieldList) {
      out.println();
      String identifier = field.externalFieldName;
      String hasIdentifier = "has" + field.titlecaseFieldName;
      String clearIdentifier = "clear" + field.titlecaseFieldName;
      if (field.single) {
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
      var fieldTypeString = field.typeStringForPackage(package);
      out.println('${fieldTypeString} get ${identifier}'
          ' => getField(${field.number});');
      if (field.single) {
        out.println('void set ${identifier}'
            '(${fieldTypeString} v) '
            '{ setField(${field.number}, v); }');
        out.println('bool $hasIdentifier() =>'
            ' hasField(${field.number});');
        out.println('void $clearIdentifier() =>'
            ' clearField(${field.number});');
      }
    }
  }
}
