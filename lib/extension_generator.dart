// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ExtensionGenerator extends ProtobufContainer {
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

  String get package => _parent.package;

  String get classname {
    String name = new ProtobufField(
        _descriptor, _parent, _context).externalFieldName;
    return _parent is MessageGenerator ? '${_parent.classname}.$name' : name;
  }

  void generate(IndentingWriter out) {
    ProtobufField field = new ProtobufField(_descriptor, _parent, _context);
    String baseType = field.baseTypeForPackage(package);

    String name = field.externalFieldName;
    String type = field.shortTypeName;

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
        initializer = ', () => new PbList<${baseType}>()';
        builder = ', () => new ${baseType}()';
      } else {
        initializer = ', () => new ${baseType}()';
        builder = ', () => new ${baseType}()';
      }
    } else {
      if (_descriptor.label == FieldDescriptorProto_Label.LABEL_REPEATED) {
        initializer = ', () => new PbList<${baseType}>()';
      } else if (field.hasInitialization) {
        var fieldInitialization = field.initializationForPackage(package);
        initializer = ', ${fieldInitialization}';
      }
    }

    if (field.enm) {
      if (initializer.isEmpty) {
        initializer = ', null';
      }
      if (builder.isEmpty) {
        builder = ', null';
      }
      var fieldType = field.baseTypeForPackage(package);
      valueOf = ', (var v) => ${fieldType}.valueOf(v)';
    }

    out.println('static final Extension $name = '
      'new Extension(\'$extendee\', \'$name\', '
      '${_descriptor.number}, GeneratedMessage.$type'
      '${initializer}${builder}${valueOf}'
      ');');
  }

  String get name => classname;
}
