// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

const String SP = ' ';

class MessageGenerator implements ProtobufContainer {
  final String classname;
  final String fqname;
  final GenerationContext _context;
  final DescriptorProto _descriptor;
  final List<EnumGenerator> _enumGenerators = <EnumGenerator>[];
  final List<ProtobufField> _fieldList = <ProtobufField>[];
  final List<MessageGenerator> _messageGenerators = <MessageGenerator>[];
  final List<ExtensionGenerator> _extensionGenerators = <ExtensionGenerator>[];

  MessageGenerator(DescriptorProto descriptor, ProtobufContainer parent,
                   this._context)
      : _descriptor = descriptor,
        classname = (parent == null || parent.classname == '') ?
            descriptor.name : '${parent.classname}_${descriptor.name}',
        fqname = (parent == null || parent.fqname == null) ? descriptor.name :
            (parent.fqname == '.' ?
                '.${descriptor.name}' : '${parent.fqname}.${descriptor.name}') {
    _context.register(this);

    for (EnumDescriptorProto e in _descriptor.enumType) {
      _enumGenerators.add(new EnumGenerator(e, this, _context));
    }

    for (DescriptorProto n in _descriptor.nestedType) {
      _messageGenerators.add(new MessageGenerator(n, this, _context));
    }

    for (FieldDescriptorProto x in _descriptor.extension) {
      _extensionGenerators.add(new ExtensionGenerator(x, this, _context));
    }
  }

  void initializeFields() {
    _fieldList.clear();
    for (FieldDescriptorProto field in _descriptor.field) {
      _fieldList.add(new ProtobufField(field, _context));
    }
    for (MessageGenerator m in _messageGenerators) {
      m.initializeFields();
    }
  }

  void generate(IndentingWriter out) {
    for (EnumGenerator e in _enumGenerators) {
      e.generate(out);
    }

    for (MessageGenerator m in _messageGenerators) {
      m.generate(out);
    }

    out.addBlock('class ${classname} extends GeneratedMessage${SP}{',
        '}', ()
      {
      out.addBlock(
          'static final BuilderInfo _i = new BuilderInfo(\'${classname}\')',
          ';', () {
        for (ProtobufField field in _fieldList) {
          String type = field.shortTypeName;

          String makeDefault = null;
          if (field.hasInitialization) {
            makeDefault = '${field.initialization}';
          }
          String subBuilder = null;
          if (field.message || field.group) {
            subBuilder = '()${SP}=>${SP}new ${field.baseType}()';
          }
          String valueOf = null;
          if (field.enum) {
            valueOf = '(var v)${SP}=>${SP}${field.baseType}.valueOf(v)';
          }
          if ('PM' == type) {
            // Repeated message: default is an empty list
            out.println('..m(${field.number},${SP}'
                '\'${field.externalFieldName}\',${SP}$subBuilder,'
                '${SP}()${SP}=>${SP}new PbList<${field.baseType}>())');
          } else if (type[0] == 'P' && type != 'PG' && type != 'PE') {
            // Repeated, not a message or enum: default is an empty list,
            // subBuilder is null, valueOf is null.
            out.println('..p(${field.number},${SP}'
                '\'${field.externalFieldName}\',${SP}GeneratedMessage.$type)');
          } else if (type == 'OE' || type == 'QE') {
            out.println('..e(${field.number},${SP}'
                '\'${field.externalFieldName}\',${SP}GeneratedMessage.$type,'
                '${SP}$makeDefault,${SP}$valueOf)');
          } else {
            if (makeDefault == null && subBuilder == null && valueOf == null) {
              out.println('..a(${field.number},${SP}'
                  '\'${field.externalFieldName}\',${SP}GeneratedMessage.$type)');
            } else if (subBuilder == null && valueOf == null) {
              out.println('..a(${field.number},${SP}'
                  '\'${field.externalFieldName}\',${SP}GeneratedMessage.$type,'
                  '${SP}$makeDefault)');
            } else if (valueOf == null) {
              out.println('..a(${field.number},${SP}'
                  '\'${field.externalFieldName}\',${SP}GeneratedMessage.$type,'
                  '${SP}$makeDefault,${SP}$subBuilder)');
            } else {
              out.println('..a(${field.number},${SP}'
                  '\'${field.externalFieldName}\',${SP}GeneratedMessage.$type,'
                  '${SP}$makeDefault,${SP}$subBuilder,${SP}$valueOf)');
            }
          }
        }

        if (_descriptor.extensionRange.length > 0) {
          out.println('..hasExtensions${SP}=${SP}true');
        }
        if (!_hasRequiredFields(this, new Set())) {
          out.println('..hasRequiredFields${SP}=${SP}false');
        }
      });

      for (ExtensionGenerator x in _extensionGenerators) {
        x.generate(out);
      }

      out.println();

      out.println('${classname}()${SP}:${SP}super();');
      out.println('${classname}.fromBuffer(List<int> i,'
          '${SP}[ExtensionRegistry r = ExtensionRegistry.EMPTY])'
          '${SP}:${SP}super.fromBuffer(i,${SP}r);');
      out.println('${classname}.fromJson(String i,'
          '${SP}[ExtensionRegistry r = ExtensionRegistry.EMPTY])'
          '${SP}:${SP}super.fromJson(i,${SP}r);');
      out.println('${classname} clone()${SP}=>'
          '${SP}new ${classname}()..mergeFromMessage(this);');

      out.println('BuilderInfo get info_${SP}=>${SP}_i;');

      generateFieldsAccessorsMutators(out);
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
        ProtobufContainer messageType = _context[field.typeName];
        if (messageType != null && messageType is MessageGenerator) {
          if (_hasRequiredFields(messageType, alreadySeen)) {
            return true;
          }
        }
      }
    }
    return false;
  }

  void generateFieldsAccessorsMutators(IndentingWriter out) {
    for (ProtobufField field in _fieldList) {
      out.println();
      out.println('${field.typeString} get ${field.externalFieldName}'
          '${SP}=>${SP}getField(${field.number});');
      if (field.single) {
        out.println('void set ${field.externalFieldName}'
            '(${field.typeString} v)${SP}'
            '{${SP}setField(${field.number},${SP}v);${SP}}');
        out.println('bool has${field.titlecaseFieldName}()${SP}=>'
            '${SP}hasField(${field.number});');
        out.println('void clear${field.titlecaseFieldName}()${SP}=>'
            '${SP}clearField(${field.number});');
      }
    }
  }
}
