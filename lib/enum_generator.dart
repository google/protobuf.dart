// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class EnumAlias {
  final EnumValueDescriptorProto value;
  final EnumValueDescriptorProto canonicalValue;
  EnumAlias(this.value, this.canonicalValue);
}

class EnumGenerator implements ProtobufContainer {
  final String classname;
  final String fqname;
  final List<EnumValueDescriptorProto> _canonicalValues =
      <EnumValueDescriptorProto>[];
  final List<EnumAlias> _aliases = <EnumAlias>[];

  EnumGenerator(
      EnumDescriptorProto descriptor,
      ProtobufContainer parent,
      GenerationContext context)
    : classname = (parent == null || parent is FileGenerator) ?
          descriptor.name : '${parent.classname}_${descriptor.name}',
      fqname = parent == null ?
          descriptor.name : '${parent.fqname}.${descriptor.name}' {
    for (EnumValueDescriptorProto value in descriptor.value) {
      EnumValueDescriptorProto canonicalValue =
          descriptor.value.firstWhere((v) => v.number == value.number);
      if (value == canonicalValue) {
        _canonicalValues.add(value);
      } else {
        _aliases.add(new EnumAlias(value, canonicalValue));
      }
    }
    context.register(this);
  }

  void generate(IndentingWriter out) {
    out.addBlock('class ${classname} extends ProtobufEnum {', '}\n', () {
      // -----------------------------------------------------------------
      // Define enum types.
      for (EnumValueDescriptorProto val in _canonicalValues) {
        out.println(
            'static const ${classname} ${val.name}${SP}=${SP}'
                "const ${classname}._(${val.number},${SP}'${val.name}');");
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
        'static const List<${classname}> values${SP}='
            '${SP}const${SP}<${classname}>${SP}[');
      for (EnumValueDescriptorProto val in _canonicalValues) {
        out.println('${SP}${SP}${val.name},');
      }
      out.println('];');
      out.println();

      out.println('static final Map<int, ${classname}> _byValue${SP}='
          '${SP}ProtobufEnum.initByValue(values);');
      out.println('static ${classname} valueOf(int value)${SP}=>'
          '${SP}_byValue[value];');
      out.println();

      out.println('const ${classname}._(int v,${SP}String n)${SP}'
          ':${SP}super(v,${SP}n);');
    });
  }
}
