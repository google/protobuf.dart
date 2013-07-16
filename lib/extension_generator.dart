// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ExtensionGenerator implements ProtobufContainer {
  final String fqname;
  final FieldDescriptorProto _descriptor;
  final ProtobufContainer _parent;
  final GenerationContext _context;

  ExtensionGenerator(
      FieldDescriptorProto descriptor,
      ProtobufContainer parent,
      GenerationContext context)
          : this._descriptor = descriptor,
            this._parent = parent,
            this._context = context,
            fqname = parent.fqname == '.' ?
                '.${descriptor.name}' :
                '${parent.fqname}.${descriptor.name}';

  String get classname {
    String name = new ProtobufField(_descriptor, _context).externalFieldName;
    return _parent is MessageGenerator ? '${_parent.classname}.$name' : name;
  }

  void generate(IndentingWriter out) {
    ProtobufField field = new ProtobufField(_descriptor, _context);
    String baseType = field.baseType;

    String name = field.externalFieldName;
    String type = field.shortTypeName;

    String typeName = '';
    ProtobufContainer typeNameContainer = _context[_descriptor.typeName];
    if (typeNameContainer != null) {
      typeName = typeNameContainer.classname;
    }

    String extendee = '';
    ProtobufContainer extendeeContainer = _context[_descriptor.extendee];
    if (extendeeContainer != null) {
      extendee = extendeeContainer.classname;
    }


    String initializer = '';
    String builder = '';
    String valueOf = '';

    if (_descriptor.type == FieldDescriptorProto_Type.TYPE_MESSAGE ||
        _descriptor.type == FieldDescriptorProto_Type.TYPE_GROUP) {
      if (_descriptor.label ==
          FieldDescriptorProto_Label.LABEL_REPEATED) {
        initializer = ',${SP}()${SP}=>${SP}new PbList<${typeName}>()';
        builder = ',${SP}()${SP}=>${SP}new ${typeName}()';
      } else {
        initializer = ',${SP}()${SP}=>${SP}new ${typeName}()';
        builder = ',${SP}()${SP}=>${SP}new ${typeName}()';
      }
    } else {
      if (_descriptor.label == FieldDescriptorProto_Label.LABEL_REPEATED) {
        initializer = ',${SP}()${SP}=>${SP}new PbList<${baseType}>()';
      } else if (field.hasInitialization) {
        initializer = ',${SP}${field.initialization}';
      }
    }

    if (field.enum) {
      if (initializer.isEmpty) {
        initializer = ',${SP}null';
      }
      if (builder.isEmpty) {
        builder = ',${SP}null';
      }
      valueOf = ',${SP}(var v)${SP}=>${SP}${field.baseType}.valueOf(v)';
    }

    out.println('static final Extension $name${SP}=${SP}'
      'new Extension(\'$extendee\',${SP}\'$name\',${SP}'
      '${_descriptor.number},${SP}GeneratedMessage.$type'
      '${initializer}${builder}${valueOf}'
      ');');
  }

  String get name => classname;
}
