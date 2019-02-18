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
  final String fullName;
  final EnumDescriptorProto _descriptor;
  final List<EnumValueDescriptorProto> _canonicalValues =
      <EnumValueDescriptorProto>[];
  final List<EnumAlias> _aliases = <EnumAlias>[];

  /// Maps the name of an enum value to the Dart name we will use for it.
  final Map<String, String> dartNames = <String, String>{};

  EnumGenerator(EnumDescriptorProto descriptor, ProtobufContainer parent,
      Set<String> usedClassNames)
      : assert(parent != null),
        _parent = parent,
        classname = messageOrEnumClassName(descriptor.name, usedClassNames,
            parent: parent?.classname ?? ''),
        fullName = parent.fullName == ''
            ? descriptor.name
            : '${parent.fullName}.${descriptor.name}',
        _descriptor = descriptor {
    final usedNames = reservedEnumNames;
    for (EnumValueDescriptorProto value in descriptor.value) {
      EnumValueDescriptorProto canonicalValue =
          descriptor.value.firstWhere((v) => v.number == value.number);
      if (value == canonicalValue) {
        _canonicalValues.add(value);
      } else {
        _aliases.add(new EnumAlias(value, canonicalValue));
      }
      dartNames[value.name] = disambiguateName(
          avoidInitialUnderscore(value.name), usedNames, enumSuffixes());
    }
  }

  String get package => _parent.package;
  FileGenerator get fileGen => _parent.fileGen;

  /// Make this enum available as a field type.
  void register(GenerationContext ctx) {
    ctx.registerFieldType(this);
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

  void generate(IndentingWriter out) {
    out.addBlock(
        'class ${classname} extends $_protobufImportPrefix.ProtobufEnum {',
        '}\n', () {
      // -----------------------------------------------------------------
      // Define enum types.
      for (EnumValueDescriptorProto val in _canonicalValues) {
        final name = dartNames[val.name];
        out.println('static const ${classname} $name = '
            "const ${classname}._(${val.number}, ${singleQuote(name)});");
      }
      if (_aliases.isNotEmpty) {
        out.println();
        for (EnumAlias alias in _aliases) {
          final name = dartNames[alias.value.name];
          out.println('static const ${classname} $name ='
              ' ${dartNames[alias.canonicalValue.name]};');
        }
      }
      out.println();

      out.println('static const List<${classname}> values ='
          ' const <${classname}> [');
      for (EnumValueDescriptorProto val in _canonicalValues) {
        final name = dartNames[val.name];
        out.println('  $name,');
      }
      out.println('];');
      out.println();

      out.println('static final Map<int, $classname> _byValue ='
          ' $_protobufImportPrefix.ProtobufEnum.initByValue(values);');
      out.println('static ${classname} valueOf(int value) =>'
          ' _byValue[value];');
      out.println();

      out.println('const ${classname}._(int v, String n) '
          ': super(v, n);');
    });
  }

  /// Writes a Dart constant containing the JSON for the EnumProtoDescriptor.
  void generateConstants(IndentingWriter out) {
    var name = getJsonConstant(fileGen);
    var json = _descriptor.writeToJsonMap();

    out.print("const $name = ");
    writeJsonConst(out, json);
    out.println(";");
    out.println();
  }
}
