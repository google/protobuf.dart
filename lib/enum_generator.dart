// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class EnumAlias {
  final EnumValueDescriptorProto value;
  final EnumValueDescriptorProto canonicalValue;
  EnumAlias(this.value, this.canonicalValue);
}

class EnumGenerator extends ProtobufContainer {
  final ProtobufContainer _parent;
  final String classname;
  final String fqname;
  final List<EnumValueDescriptorProto> _canonicalValues =
      <EnumValueDescriptorProto>[];
  final List<EnumAlias> _aliases = <EnumAlias>[];

  EnumGenerator(
      EnumDescriptorProto descriptor,
      ProtobufContainer parent)
    : _parent = parent,
      classname = (parent == null || parent is FileGenerator) ?
          descriptor.name : '${parent.classname}_${descriptor.name}',
      fqname = (parent == null || parent.fqname == null) ? descriptor.name :
          (parent.fqname == '.' ?
              '.${descriptor.name}' : '${parent.fqname}.${descriptor.name}') {
    for (EnumValueDescriptorProto value in descriptor.value) {
      EnumValueDescriptorProto canonicalValue =
          descriptor.value.firstWhere((v) => v.number == value.number);
      if (value == canonicalValue) {
        _canonicalValues.add(value);
      } else {
        _aliases.add(new EnumAlias(value, canonicalValue));
      }
    }
  }

  String get package => _parent.package;
  FileGenerator get fileGen => _parent.fileGen;

  /// Make this enum available as a field type.
  void register(GenerationContext ctx) {
    ctx.registerFieldType(fqname, this);
  }

  void generate(IndentingWriter out) {
    out.addBlock('class ${classname} extends ProtobufEnum {', '}\n', () {
      // -----------------------------------------------------------------
      // Define enum types.
      for (EnumValueDescriptorProto val in _canonicalValues) {
        out.println(
            'static const ${classname} ${val.name} = '
                "const ${classname}._(${val.number}, '${val.name}');");
      }
      if (!_aliases.isEmpty) {
        out.println();
        for (EnumAlias alias in _aliases) {
          out.println('static const ${classname} ${alias.value.name} ='
              ' ${alias.canonicalValue.name};');
        }
      }
      out.println();

      out.println(
        'static const List<${classname}> values ='
            ' const <${classname}> [');
      for (EnumValueDescriptorProto val in _canonicalValues) {
        out.println('  ${val.name},');
      }
      out.println('];');
      out.println();

      out.println('static final Map<int, ${classname}> _byValue ='
          ' ProtobufEnum.initByValue(values);');
      out.println('static ${classname} valueOf(int value) =>'
          ' _byValue[value];');
      out.println();

      out.println('const ${classname}._(int v, String n) '
          ': super(v, n);');
    });
  }
}
