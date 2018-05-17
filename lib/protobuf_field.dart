// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ProtobufField {
  static final RegExp HEX_LITERAL_REGEX =
      new RegExp(r'^0x[0-9a-f]+$', multiLine: false, caseSensitive: false);
  static final RegExp INTEGER_LITERAL_REGEX = new RegExp(r'^[+-]?[0-9]+$');
  static final RegExp DECIMAL_LITERAL_REGEX_A = new RegExp(
      r'^[+-]?([0-9]*)\.[0-9]+(e[+-]?[0-9]+)?$',
      multiLine: false,
      caseSensitive: false);
  static final RegExp DECIMAL_LITERAL_REGEX_B = new RegExp(
      r'^[+-]?[0-9]+e[+-]?[0-9]+$',
      multiLine: false,
      caseSensitive: false);

  final FieldDescriptorProto descriptor;

  /// Dart names within a GeneratedMessage or `null` for an extension.
  final MemberNames memberNames;

  final String fqname;
  final BaseType baseType;

  ProtobufField.message(
      MemberNames names, ProtobufContainer parent, GenerationContext ctx)
      : this._(names.descriptor, names, parent, ctx);

  ProtobufField.extension(FieldDescriptorProto descriptor,
      ProtobufContainer parent, GenerationContext ctx)
      : this._(descriptor, null, parent, ctx);

  ProtobufField._(FieldDescriptorProto descriptor, MemberNames dartNames,
      ProtobufContainer parent, GenerationContext ctx)
      : this.descriptor = descriptor,
        this.memberNames = dartNames,
        fqname = '${parent.fqname}.${descriptor.name}',
        baseType = new BaseType(descriptor, ctx);

  /// The index of this field in MessageGenerator.fieldList.
  ///
  /// `null` for an extension.
  int get index => memberNames?.index;

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
  bool get needsFixnumImport => baseType.unprefixed == "Int64";

  /// Returns the expression to use for the Dart type.
  ///
  /// This will be a List for repeated types.
  /// [package] is the package where we are generating code.
  String getDartType(String package) {
    if (isRepeated) return baseType.getRepeatedDartType(package);
    return baseType.getDartType(package);
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
    return "PbFieldType." + prefix + baseType.typeConstantSuffix;
  }

  /// Returns Dart code adding this field to a BuilderInfo object.
  /// The call will start with ".." and a method name.
  /// [package] is the package where the code will be evaluated.
  String generateBuilderInfoCall(String package, String dartFieldName) {
    String quotedName = "'$dartFieldName'";
    String type = baseType.getDartType(package);

    if (isRepeated) {
      if (baseType.isMessage || baseType.isGroup) {
        return '..pp<$type>($number, $quotedName, $typeConstant,'
            ' $type.$checkItem, $type.create)';
      } else if (baseType.isEnum) {
        return '..pp<$type>($number, $quotedName, $typeConstant,'
            ' $type.$checkItem, null, $type.valueOf, $type.values)';
      } else if (typeConstant == 'PbFieldType.PS') {
        return '..pPS($number, $quotedName)';
      } else {
        return '..p<$type>($number, $quotedName, $typeConstant)';
      }
    }

    String makeDefault = generateDefaultFunction(package);
    if (baseType.isEnum) {
      String enumParams = '$type.valueOf, $type.values';
      return '..e<$type>('
          '$number, $quotedName, $typeConstant, $makeDefault, $enumParams)';
    }

    String prefix = '..a<$type>($number, $quotedName, $typeConstant';
    if (makeDefault == null) {
      switch (type) {
        case 'String':
          if (typeConstant == 'PbFieldType.OS') {
            return '..aOS($number, $quotedName)';
          } else if (typeConstant == 'PbFieldType.QS') {
            return '..aQS($number, $quotedName)';
          }
          break;
        case 'bool':
          if (typeConstant == 'PbFieldType.OB') {
            return '..aOB($number, $quotedName)';
          }
          break;
        default:
          break;
      }
      return prefix + ')';
    }

    if (makeDefault == 'Int64.ZERO' &&
        type == 'Int64' &&
        typeConstant == 'PbFieldType.O6') {
      return '..aInt64($number, $quotedName)';
    }

    if (baseType.isMessage || baseType.isGroup) {
      return prefix + ', $makeDefault, $type.create)';
    }

    return prefix + ', $makeDefault)';
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
  /// [package] is the package where the expression will be evaluated.
  /// Returns null if this field doesn't have an initializer.
  String generateDefaultFunction(String package) {
    if (isRepeated) {
      return '() => new PbList()';
    }

    bool samePackage = package == baseType.package;

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
          return 'double.infinity';
        } else if (descriptor.defaultValue == '-inf') {
          return 'double.negativeInfinity';
        } else if (descriptor.defaultValue == 'nan') {
          return 'double.nan';
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
        if (value == '0') return 'Int64.ZERO';
        return "parseLongInt('$value')";
      case FieldDescriptorProto_Type.TYPE_STRING:
        return _getDefaultAsStringExpr(null);
      case FieldDescriptorProto_Type.TYPE_BYTES:
        if (!descriptor.hasDefaultValue() || descriptor.defaultValue.isEmpty) {
          return null;
        }
        String byteList = descriptor.defaultValue.codeUnits
            .map((b) => '0x${b.toRadixString(16)}')
            .join(',');
        return '() => <int>[$byteList]';
      case FieldDescriptorProto_Type.TYPE_GROUP:
      case FieldDescriptorProto_Type.TYPE_MESSAGE:
        if (samePackage) return '${baseType.unprefixed}.getDefault';
        return "${baseType.prefixed}.getDefault";
      case FieldDescriptorProto_Type.TYPE_ENUM:
        var className = samePackage ? baseType.unprefixed : baseType.prefixed;
        EnumGenerator gen = baseType.generator;
        if (descriptor.hasDefaultValue() && !descriptor.defaultValue.isEmpty) {
          return '$className.${descriptor.defaultValue}';
        } else if (!gen._canonicalValues.isEmpty) {
          return '$className.${gen._canonicalValues[0].name}';
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
      " found in field $fqname";

  _typeNotImplemented(String methodName) => "dart-protoc-plugin:"
      " $methodName not implemented for type (${descriptor.type})"
      " found in field $fqname";
}
