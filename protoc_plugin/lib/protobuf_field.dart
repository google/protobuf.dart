// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ProtobufField {
  static final RegExp HEX_LITERAL_REGEX =
      RegExp(r'^0x[0-9a-f]+$', multiLine: false, caseSensitive: false);
  static final RegExp INTEGER_LITERAL_REGEX = RegExp(r'^[+-]?[0-9]+$');
  static final RegExp DECIMAL_LITERAL_REGEX_A = RegExp(
      r'^[+-]?([0-9]*)\.[0-9]+(e[+-]?[0-9]+)?$',
      multiLine: false,
      caseSensitive: false);
  static final RegExp DECIMAL_LITERAL_REGEX_B = RegExp(
      r'^[+-]?[0-9]+e[+-]?[0-9]+$',
      multiLine: false,
      caseSensitive: false);

  final FieldDescriptorProto descriptor;

  /// Dart names within a GeneratedMessage or `null` for an extension.
  final FieldNames memberNames;

  final String fullName;
  final BaseType baseType;

  ProtobufField.message(
      FieldNames names, ProtobufContainer parent, GenerationContext ctx)
      : this._(names.descriptor, names, parent, ctx);

  ProtobufField.extension(FieldDescriptorProto descriptor,
      ProtobufContainer parent, GenerationContext ctx)
      : this._(descriptor, null, parent, ctx);

  ProtobufField._(FieldDescriptorProto descriptor, FieldNames dartNames,
      ProtobufContainer parent, GenerationContext ctx)
      : this.descriptor = descriptor,
        this.memberNames = dartNames,
        fullName = '${parent.fullName}.${descriptor.name}',
        baseType = BaseType(descriptor, ctx);

  /// The index of this field in MessageGenerator.fieldList.
  ///
  /// `null` for an extension.
  int get index => memberNames?.index;

  String get quotedProtoName =>
      (_unCamelCase(descriptor.jsonName) == descriptor.name)
          ? null
          : "'${descriptor.name}'";

  /// The position of this field as it appeared in the original DescriptorProto.
  int get sourcePosition => memberNames.sourcePosition;

  /// True if the field is to be encoded with [deprecated = true] encoding.
  bool get isDeprecated => descriptor.options?.deprecated;

  bool get isRequired =>
      descriptor.label == FieldDescriptorProto_Label.LABEL_REQUIRED;

  bool get isRepeated =>
      descriptor.label == FieldDescriptorProto_Label.LABEL_REPEATED;

  /// True if the field is to be encoded with [packed=true] encoding.
  bool get isPacked =>
      isRepeated && descriptor.options != null && descriptor.options.packed;

  /// Whether the field has the `overrideGetter` annotation set to true.
  bool get overridesGetter => _hasBooleanOption(Dart_options.overrideGetter);

  /// Whether the field has the `overrideSetter` annotation set to true.
  bool get overridesSetter => _hasBooleanOption(Dart_options.overrideSetter);

  /// Whether the field has the `overrideHasMethod` annotation set to true.
  bool get overridesHasMethod =>
      _hasBooleanOption(Dart_options.overrideHasMethod);

  /// Whether the field has the `overrideClearMethod` annotation set to true.
  bool get overridesClearMethod =>
      _hasBooleanOption(Dart_options.overrideClearMethod);

  /// True if this field uses the Int64 from the fixnum package.
  bool get needsFixnumImport =>
      baseType.unprefixed == "$_fixnumImportPrefix.Int64";

  /// True if this field is a map field definition:
  /// `map<key_type, value_type> map_field = N`.
  bool get isMapField {
    if (!isRepeated || !baseType.isMessage) return false;
    MessageGenerator generator = baseType.generator;
    return generator._descriptor.options.hasMapEntry();
  }

  /// Returns the expression to use for the Dart type.
  ///
  /// This will be a List for repeated types.
  /// [fileGen] represents the .proto file where we are generating code.
  String getDartType(FileGenerator fileGen) {
    if (isMapField) {
      MessageGenerator d = baseType.generator;
      String keyType = d._fieldList[0].baseType.getDartType(fileGen);
      String valueType = d._fieldList[1].baseType.getDartType(fileGen);
      return '$_coreImportPrefix.Map<$keyType, $valueType>';
    }
    if (isRepeated) return baseType.getRepeatedDartType(fileGen);
    return baseType.getDartType(fileGen);
  }

  /// Returns the tag number of the underlying proto field.
  int get number => descriptor.number;

  /// Returns the constant in PbFieldType corresponding to this type.
  String get typeConstant {
    String prefix = 'O';
    if (isRequired) {
      prefix = 'Q';
    } else if (isPacked) {
      prefix = 'K';
    } else if (isRepeated) {
      prefix = 'P';
    }
    return "$_protobufImportPrefix.PbFieldType." +
        prefix +
        baseType.typeConstantSuffix;
  }

  static String _formatArguments(
      List<String> positionals, Map<String, String> named) {
    final args = positionals.toList();
    while (args.last == null) {
      args.removeLast();
    }
    for (int i = 0; i < args.length; i++) {
      if (args[i] == null) {
        args[i] = 'null';
      }
    }
    named.forEach((key, value) {
      if (value != null) {
        args.add('$key: $value');
      }
    });
    return '${args.join(', ')}';
  }

  /// Returns Dart code adding this field to a BuilderInfo object.
  /// The call will start with ".." and a method name.
  /// [fileGen] represents the .proto file where the code will be evaluated.
  String generateBuilderInfoCall(FileGenerator fileGen, String package) {
    assert(descriptor.hasJsonName());
    // JSON names should be serialized as-is, but '$' can cause Dart to try to
    // perform string interpolation on non-existent variables.
    String quotedName = "'${descriptor.jsonName.replaceAll(r'$', r'\$')}'";

    String type = baseType.getDartType(fileGen);

    String invocation;

    List<String> args = <String>[];
    Map<String, String> named = {'protoName': quotedProtoName};
    args.add('$number');
    args.add(quotedName);

    if (isMapField) {
      MessageGenerator generator = baseType.generator;
      ProtobufField key = generator._fieldList[0];
      ProtobufField value = generator._fieldList[1];
      String keyType = key.baseType.getDartType(fileGen);
      String valueType = value.baseType.getDartType(fileGen);

      invocation = 'm<$keyType, $valueType>';

      named['entryClassName'] = "'${generator.messageName}'";
      named['keyFieldType'] = key.typeConstant;
      named['valueFieldType'] = value.typeConstant;
      if (value.baseType.isMessage || value.baseType.isGroup) {
        named['valueCreator'] = '$valueType.create';
      }
      if (value.baseType.isEnum) {
        named['valueOf'] = '$valueType.valueOf';
        named['enumValues'] = '$valueType.values';
      }
      if (package != '') {
        named['packageName'] =
            'const $_protobufImportPrefix.PackageName(\'$package\')';
      }
    } else if (isRepeated) {
      if (typeConstant == '$_protobufImportPrefix.PbFieldType.PS') {
        invocation = 'pPS';
      } else {
        args.add(typeConstant);
        if (baseType.isMessage || baseType.isGroup || baseType.isEnum) {
          invocation = 'pc<$type>';
        } else {
          invocation = 'p<$type>';
        }

        if (baseType.isMessage || baseType.isGroup) {
          named['subBuilder'] = '$type.create';
        } else if (baseType.isEnum) {
          named['valueOf'] = '$type.valueOf';
          named['enumValues'] = '$type.values';
        }
      }
    } else {
      // Singular field.
      String makeDefault = generateDefaultFunction(fileGen);

      if (baseType.isEnum) {
        args.add(typeConstant);
        named['defaultOrMaker'] = makeDefault;
        named['valueOf'] = '$type.valueOf';
        named['enumValues'] = '$type.values';
        invocation = 'e<$type>';
      } else if (makeDefault == null) {
        switch (type) {
          case '$_coreImportPrefix.String':
            if (typeConstant == '$_protobufImportPrefix.PbFieldType.OS') {
              invocation = 'aOS';
            } else if (typeConstant ==
                '$_protobufImportPrefix.PbFieldType.QS') {
              invocation = 'aQS';
            } else {
              invocation = 'a<$type>';
              args.add(typeConstant);
            }
            break;
          case '$_coreImportPrefix.bool':
            if (typeConstant == '$_protobufImportPrefix.PbFieldType.OB') {
              invocation = 'aOB';
            } else {
              invocation = 'a<$type>';
              args.add(typeConstant);
            }
            break;
          default:
            invocation = 'a<$type>';
            args.add(typeConstant);
            break;
        }
      } else {
        if (makeDefault == '$_fixnumImportPrefix.Int64.ZERO' &&
            type == '$_fixnumImportPrefix.Int64' &&
            typeConstant == '$_protobufImportPrefix.PbFieldType.O6') {
          invocation = 'aInt64';
        } else {
          if (baseType.isMessage || baseType.isGroup) {
            named['subBuilder'] = '$type.create';
          }
          if (baseType.isMessage) {
            invocation = isRequired ? 'aQM<$type>' : 'aOM<$type>';
          } else {
            invocation = 'a<$type>';
            named['defaultOrMaker'] = makeDefault;
            args.add(typeConstant);
          }
        }
      }
    }
    assert(invocation != null);
    return '..$invocation(${_formatArguments(args, named)})';
  }

  /// Returns a Dart expression that evaluates to this field's default value.
  ///
  /// Returns "null" if unavailable, in which case FieldSet._getDefault()
  /// should be called instead.
  String getDefaultExpr() {
    if (isRepeated) return "null";
    switch (descriptor.type) {
      case FieldDescriptorProto_Type.TYPE_BOOL:
        return _getDefaultAsBoolExpr("false");
      case FieldDescriptorProto_Type.TYPE_INT32:
      case FieldDescriptorProto_Type.TYPE_UINT32:
      case FieldDescriptorProto_Type.TYPE_SINT32:
      case FieldDescriptorProto_Type.TYPE_FIXED32:
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        return _getDefaultAsInt32Expr("0");
      case FieldDescriptorProto_Type.TYPE_STRING:
        return _getDefaultAsStringExpr("''");
      default:
        return "null";
    }
  }

  /// Returns a function expression that returns the field's default value.
  ///
  /// [fileGen] represents the .proto file where the expression will be
  /// evaluated.
  String generateDefaultFunction(FileGenerator fileGen) {
    assert(!isRepeated);
    switch (descriptor.type) {
      case FieldDescriptorProto_Type.TYPE_BOOL:
        return _getDefaultAsBoolExpr(null);
      case FieldDescriptorProto_Type.TYPE_FLOAT:
      case FieldDescriptorProto_Type.TYPE_DOUBLE:
        if (!descriptor.hasDefaultValue()) {
          return null;
        } else if ('0.0' == descriptor.defaultValue ||
            '0' == descriptor.defaultValue) {
          return null;
        } else if (descriptor.defaultValue == 'inf') {
          return '$_coreImportPrefix.double.infinity';
        } else if (descriptor.defaultValue == '-inf') {
          return '$_coreImportPrefix.double.negativeInfinity';
        } else if (descriptor.defaultValue == 'nan') {
          return '$_coreImportPrefix.double.nan';
        } else if (HEX_LITERAL_REGEX.hasMatch(descriptor.defaultValue)) {
          return '(${descriptor.defaultValue}).toDouble()';
        } else if (INTEGER_LITERAL_REGEX.hasMatch(descriptor.defaultValue)) {
          return '${descriptor.defaultValue}.0';
        } else if (DECIMAL_LITERAL_REGEX_A.hasMatch(descriptor.defaultValue) ||
            DECIMAL_LITERAL_REGEX_B.hasMatch(descriptor.defaultValue)) {
          return '${descriptor.defaultValue}';
        }
        throw _invalidDefaultValue;
      case FieldDescriptorProto_Type.TYPE_INT32:
      case FieldDescriptorProto_Type.TYPE_UINT32:
      case FieldDescriptorProto_Type.TYPE_SINT32:
      case FieldDescriptorProto_Type.TYPE_FIXED32:
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        return _getDefaultAsInt32Expr(null);
      case FieldDescriptorProto_Type.TYPE_INT64:
      case FieldDescriptorProto_Type.TYPE_UINT64:
      case FieldDescriptorProto_Type.TYPE_SINT64:
      case FieldDescriptorProto_Type.TYPE_FIXED64:
      case FieldDescriptorProto_Type.TYPE_SFIXED64:
        var value = '0';
        if (descriptor.hasDefaultValue()) value = descriptor.defaultValue;
        if (value == '0') return '$_fixnumImportPrefix.Int64.ZERO';
        return "$_protobufImportPrefix.parseLongInt('$value')";
      case FieldDescriptorProto_Type.TYPE_STRING:
        return _getDefaultAsStringExpr(null);
      case FieldDescriptorProto_Type.TYPE_BYTES:
        if (!descriptor.hasDefaultValue() || descriptor.defaultValue.isEmpty) {
          return null;
        }
        String byteList = descriptor.defaultValue.codeUnits
            .map((b) => '0x${b.toRadixString(16)}')
            .join(',');
        return '() => <$_coreImportPrefix.int>[$byteList]';
      case FieldDescriptorProto_Type.TYPE_GROUP:
      case FieldDescriptorProto_Type.TYPE_MESSAGE:
        return '${baseType.getDartType(fileGen)}.getDefault';
      case FieldDescriptorProto_Type.TYPE_ENUM:
        var className = baseType.getDartType(fileGen);
        EnumGenerator gen = baseType.generator;
        if (descriptor.hasDefaultValue() &&
            descriptor.defaultValue.isNotEmpty) {
          return '$className.${descriptor.defaultValue}';
        } else if (gen._canonicalValues.isNotEmpty) {
          return '$className.${gen.dartNames[gen._canonicalValues[0].name]}';
        }
        return null;
      default:
        throw _typeNotImplemented("generatedDefaultFunction");
    }
  }

  String _getDefaultAsBoolExpr(String noDefault) {
    if (descriptor.hasDefaultValue() && 'false' != descriptor.defaultValue) {
      return '${descriptor.defaultValue}';
    }
    return noDefault;
  }

  String _getDefaultAsStringExpr(String noDefault) {
    if (!descriptor.hasDefaultValue() || descriptor.defaultValue.isEmpty) {
      return noDefault;
    }
    // TODO(skybrian): fix dubious escaping.
    String value = descriptor.defaultValue.replaceAll(r'$', r'\$');
    return '\'$value\'';
  }

  String _getDefaultAsInt32Expr(String noDefault) {
    if (descriptor.hasDefaultValue() && '0' != descriptor.defaultValue) {
      return '${descriptor.defaultValue}';
    }
    return noDefault;
  }

  bool _hasBooleanOption(Extension extension) =>
      descriptor?.options?.getExtension(extension) ?? false;

  get _invalidDefaultValue => "dart-protoc-plugin:"
      " invalid default value (${descriptor.defaultValue})"
      " found in field $fullName";

  _typeNotImplemented(String methodName) => "dart-protoc-plugin:"
      " $methodName not implemented for type (${descriptor.type})"
      " found in field $fullName";

  static final RegExp _upperCase = RegExp('[A-Z]');

  static String _unCamelCase(String name) {
    return name.replaceAllMapped(
        _upperCase, (match) => '_${match.group(0).toLowerCase()}');
  }
}
