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

  String get name {
    if (_field == null) throw new StateError("resolve not called");
    String name = _field.externalFieldName;
    return _parent is MessageGenerator ? '${_parent.classname}.$name' : name;
  }

  void generate(IndentingWriter out) {
    if (_field == null) throw new StateError("resolve not called");

    String baseType = _field.baseTypeForPackage(package);

    String name = _field.externalFieldName;
    String type = _field.shortTypeName;

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
      } else if (_field.hasInitialization) {
        var fieldInitialization = _field.initializationForPackage(package);
        initializer = ', ${fieldInitialization}';
      }
    }

    if (_field.enm) {
      if (initializer.isEmpty) {
        initializer = ', null';
      }
      if (builder.isEmpty) {
        builder = ', null';
      }
      var fieldType = _field.baseTypeForPackage(package);
      valueOf = ', (var v) => ${fieldType}.valueOf(v)';
    }

    out.println('static final Extension $name = '
      'new Extension(\'$_extendedClassName\', \'$name\', '
      '${_descriptor.number}, GeneratedMessage.$type'
      '${initializer}${builder}${valueOf}'
      ');');
  }
}
