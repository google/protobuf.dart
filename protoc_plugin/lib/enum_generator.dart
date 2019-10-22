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
  final List<int> _originalCanonicalIndices = <int>[];
  final List<EnumAlias> _aliases = <EnumAlias>[];

  /// Maps the name of an enum value to the Dart name we will use for it.
  final Map<String, String> dartNames = <String, String>{};
  final List<int> _originalAliasIndices = <int>[];
  List<int> _fieldPath;
  final List<int> _fieldPathSegment;

  /// See [[ProtobufContainer]
  List<int> get fieldPath =>
      _fieldPath ??= List.from(_parent.fieldPath)..addAll(_fieldPathSegment);

  EnumGenerator._(EnumDescriptorProto descriptor, ProtobufContainer parent,
      Set<String> usedClassNames, int repeatedFieldIndex, int fieldIdTag)
      : assert(parent != null),
        _parent = parent,
        _fieldPathSegment = [fieldIdTag, repeatedFieldIndex],
        classname = messageOrEnumClassName(descriptor.name, usedClassNames,
            parent: parent?.classname ?? ''),
        fullName = parent.fullName == ''
            ? descriptor.name
            : '${parent.fullName}.${descriptor.name}',
        _descriptor = descriptor {
    final usedNames = Set<String>()..addAll(reservedEnumNames);
    for (var i = 0; i < descriptor.value.length; i++) {
      EnumValueDescriptorProto value = descriptor.value[i];
      EnumValueDescriptorProto canonicalValue =
          descriptor.value.firstWhere((v) => v.number == value.number);
      if (value == canonicalValue) {
        _canonicalValues.add(value);
        _originalCanonicalIndices.add(i);
      } else {
        _aliases.add(EnumAlias(value, canonicalValue));
        _originalAliasIndices.add(i);
      }
      dartNames[value.name] = disambiguateName(
          avoidInitialUnderscore(value.name), usedNames, enumSuffixes());
    }
  }

  static const _topLevelFieldTag = 5;
  static const _nestedFieldTag = 4;

  EnumGenerator.topLevel(
      EnumDescriptorProto descriptor,
      ProtobufContainer parent,
      Set<String> usedClassNames,
      int repeatedFieldIndex)
      : this._(descriptor, parent, usedClassNames, repeatedFieldIndex,
            _topLevelFieldTag);

  EnumGenerator.nested(EnumDescriptorProto descriptor, ProtobufContainer parent,
      Set<String> usedClassNames, int repeatedFieldIndex)
      : this._(descriptor, parent, usedClassNames, repeatedFieldIndex,
            _nestedFieldTag);

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

  static const int _enumValueTag = 2;

  void generate(IndentingWriter out) {
    out.addAnnotatedBlock(
        'class ${classname} extends $_protobufImportPrefix.ProtobufEnum {',
        '}\n', [
      NamedLocation(
          name: classname, fieldPathSegment: fieldPath, start: 'class '.length)
    ], () {
      // -----------------------------------------------------------------
      // Define enum types.
      for (var i = 0; i < _canonicalValues.length; i++) {
        EnumValueDescriptorProto val = _canonicalValues[i];
        final name = dartNames[val.name];
        out.printlnAnnotated(
            'static const ${classname} $name = '
            "${classname}._(${val.number}, ${singleQuote(val.name)});",
            [
              NamedLocation(
                  name: name,
                  fieldPathSegment: List.from(fieldPath)
                    ..addAll([_enumValueTag, _originalCanonicalIndices[i]]),
                  start: 'static const ${classname} '.length)
            ]);
      }
      if (_aliases.isNotEmpty) {
        out.println();
        for (var i = 0; i < _aliases.length; i++) {
          EnumAlias alias = _aliases[i];
          final name = dartNames[alias.value.name];
          out.printlnAnnotated(
              'static const ${classname} $name ='
              ' ${dartNames[alias.canonicalValue.name]};',
              [
                NamedLocation(
                    name: name,
                    fieldPathSegment: List.from(fieldPath)
                      ..addAll([_enumValueTag, _originalAliasIndices[i]]),
                    start: 'static const ${classname} '.length)
              ]);
        }
      }
      out.println();

      out.println('static const $_coreImportPrefix.List<${classname}> values ='
          ' <${classname}> [');
      for (EnumValueDescriptorProto val in _canonicalValues) {
        final name = dartNames[val.name];
        out.println('  $name,');
      }
      out.println('];');
      out.println();

      out.println(
          'static final $_coreImportPrefix.Map<$_coreImportPrefix.int, $classname> _byValue ='
          ' $_protobufImportPrefix.ProtobufEnum.initByValue(values);');
      out.println('static ${classname} valueOf($_coreImportPrefix.int value) =>'
          ' _byValue[value];');
      out.println();

      out.println(
          'const ${classname}._($_coreImportPrefix.int v, $_coreImportPrefix.String n) '
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
