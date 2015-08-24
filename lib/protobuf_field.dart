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
      multiLine: false, caseSensitive: false);
  static final RegExp DECIMAL_LITERAL_REGEX_B = new RegExp(
      r'^[+-]?[0-9]+e[+-]?[0-9]+$', multiLine: false, caseSensitive: false);

  final FieldDescriptorProto _field;
  final String fqname;
  final BaseType baseType;
  final GenerationOptions _genOptions;

  ProtobufField(FieldDescriptorProto field, ProtobufContainer parent,
      GenerationContext ctx)
      : _field = field,
        fqname = '${parent.fqname}.${field.name}',
        baseType = new BaseType(field, ctx),
        _genOptions = ctx.options;

  int get number => _field.number;

  bool get isRequired =>
      _field.label == FieldDescriptorProto_Label.LABEL_REQUIRED;

  bool get isRepeated =>
      _field.label == FieldDescriptorProto_Label.LABEL_REPEATED;

  /// True if the field is to be encoded with [packed=true] encoding.
  bool get isPacked =>
      isRepeated && _field.options != null && _field.options.packed;

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

  /// The name to use by default for the Dart getter and setter.
  /// (A suffix will be added if there is a conflict.)
  String get dartFieldName {
    String name = _fieldMethodSuffix;
    return '${name[0].toLowerCase()}${name.substring(1)}';
  }

  String get hasMethodName => 'has$_fieldMethodSuffix';
  String get clearMethodName => 'clear$_fieldMethodSuffix';

  /// The suffix to use for this field in Dart method names.
  /// (It should be camelcase and begin with an uppercase letter.)
  String get _fieldMethodSuffix {
    String underscoresToCamelCase(String s) {
      cap(s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
      return s.split('_').map(cap).join('');
    }

    // For groups, use capitalization of 'typeName' rather than 'name'.
    if (baseType.isGroup) {
      String name = _field.typeName;
      int index = name.lastIndexOf('.');
      if (index != -1) {
        name = name.substring(index + 1);
      }
      return underscoresToCamelCase(name);
    }
    var name = _genOptions.fieldNameOverrides[fqname];
    return name != null ? name : underscoresToCamelCase(_field.name);
  }

  /// Returns Dart code adding this field to a BuilderInfo object.
  /// The call will start with ".." and a method name.
  /// [package] is the package where the code will be evaluated.
  String generateBuilderInfoCall(String package) {
    String quotedName = "'$dartFieldName'";
    String type = baseType.getDartType(package);

    if (isRepeated) {
      if (baseType.isMessage || baseType.isGroup) {
        return '..pp($number, $quotedName, $typeConstant,'
          ' $type.$checkItem, $type.create)';
      } else if (baseType.isEnum) {
        return '..pp($number, $quotedName, $typeConstant,'
          ' $type.$checkItem, null, $type.valueOf)';
      } else {
        return '..p($number, $quotedName, $typeConstant)';
      }
    }

    String makeDefault = generateDefaultFunction(package);
    if (baseType.isEnum) {
      String valueOf = '$type.valueOf';
      return '..e($number, $quotedName, $typeConstant, $makeDefault, $valueOf)';
    }

    String prefix = '..a($number, $quotedName, $typeConstant';
    if (makeDefault == null) return prefix + ')';

    if (baseType.isMessage || baseType.isGroup) {
      return prefix + ', $makeDefault, $type.create)';
    }

    return prefix + ', $makeDefault)';
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

    switch (_field.type) {
      case FieldDescriptorProto_Type.TYPE_BOOL:
        if (_field.hasDefaultValue() && 'false' != _field.defaultValue) {
          return '${_field.defaultValue}';
        }
        return null;
      case FieldDescriptorProto_Type.TYPE_FLOAT:
      case FieldDescriptorProto_Type.TYPE_DOUBLE:
        if (!_field.hasDefaultValue()) {
          return null;
        } else if ('0.0' == _field.defaultValue || '0' == _field.defaultValue) {
          return null;
        } else if (_field.defaultValue == 'inf') {
          return 'double.INFINITY';
        } else if (_field.defaultValue == '-inf') {
          return 'double.NEGATIVE_INFINITY';
        } else if (_field.defaultValue == 'nan') {
          return 'double.NAN';
        } else if (HEX_LITERAL_REGEX.hasMatch(_field.defaultValue)) {
          return '(${_field.defaultValue}).toDouble()';
        } else if (INTEGER_LITERAL_REGEX.hasMatch(_field.defaultValue)) {
          return '${_field.defaultValue}.0';
        } else if (DECIMAL_LITERAL_REGEX_A.hasMatch(_field.defaultValue) ||
            DECIMAL_LITERAL_REGEX_B.hasMatch(_field.defaultValue)) {
          return '${_field.defaultValue}';
        }
        throw _invalidDefaultValue;
      case FieldDescriptorProto_Type.TYPE_INT32:
      case FieldDescriptorProto_Type.TYPE_UINT32:
      case FieldDescriptorProto_Type.TYPE_SINT32:
      case FieldDescriptorProto_Type.TYPE_FIXED32:
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        if (_field.hasDefaultValue() && '0' != _field.defaultValue) {
          return '${_field.defaultValue}';
        }
        return null;
      case FieldDescriptorProto_Type.TYPE_INT64:
      case FieldDescriptorProto_Type.TYPE_UINT64:
      case FieldDescriptorProto_Type.TYPE_SINT64:
      case FieldDescriptorProto_Type.TYPE_FIXED64:
      case FieldDescriptorProto_Type.TYPE_SFIXED64:
        var value = '0';
        if (_field.hasDefaultValue()) value = _field.defaultValue;
        if (value == '0') return 'Int64.ZERO';
        return "parseLongInt('$value')";
      case FieldDescriptorProto_Type.TYPE_STRING:
        if (!_field.hasDefaultValue() || _field.defaultValue.isEmpty) {
          return null;
        }
        String value = _field.defaultValue.replaceAll(r'$', r'\$');
        return '\'$value\'';
      case FieldDescriptorProto_Type.TYPE_BYTES:
        if (!_field.hasDefaultValue() || _field.defaultValue.isEmpty) {
          return null;
        }
        String byteList = _field.defaultValue.codeUnits
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
        if (_field.hasDefaultValue() && !_field.defaultValue.isEmpty) {
          return '$className.${_field.defaultValue}';
        } else if (!gen._canonicalValues.isEmpty) {
          return '$className.${gen._canonicalValues[0].name}';
        }
        return null;
      default:
        throw _typeNotImplemented("generatedDefaultFunction");
    }
  }

  get _invalidDefaultValue => "dart-protoc-plugin:"
      " invalid default value (${_field.defaultValue})"
      " found in field $fqname";

  _typeNotImplemented(String methodName) => "dart-protoc-plugin:"
      " $methodName not implemented for type (${_field.type})"
      " found in field $fqname";
}
