// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

/// Represents the base type of a particular field in a proto definition.
/// (Doesn't include List<> for repeated fields.)
class BaseType {
  final FieldDescriptorProto_Type descriptor;

  /// The name of the Dart type when in the same package.
  final String unprefixed;

  /// The suffix of the constant for this type in PbFieldType.
  /// (For example, 'B' for boolean or '3' for int32.)
  final String typeConstantSuffix;

  // Method name of the setter method for this type.
  final String setter;

  // The generator corresponding to this type.
  // (Null for primitive types.)
  final ProtobufContainer generator;

  const BaseType._raw(this.descriptor, this.typeConstantSuffix, this.unprefixed,
      this.setter, this.generator);

  bool get isGroup => descriptor == FieldDescriptorProto_Type.TYPE_GROUP;
  bool get isMessage => descriptor == FieldDescriptorProto_Type.TYPE_MESSAGE;
  bool get isEnum => descriptor == FieldDescriptorProto_Type.TYPE_ENUM;
  bool get isString => descriptor == FieldDescriptorProto_Type.TYPE_STRING;
  bool get isBytes => descriptor == FieldDescriptorProto_Type.TYPE_BYTES;
  bool get isPackable => (generator == null && !isString && !isBytes) || isEnum;

  /// The package where this type is declared.
  /// (Always the empty string for primitive types.)
  String get package => generator == null ? "" : generator.package;

  /// The Dart expression to use for this type when in a different package.
  String get prefixed {
    if (generator == null || generator.packageImportPrefix.isEmpty) {
      return unprefixed;
    }
    return generator.packageImportPrefix + "." + unprefixed;
  }

  /// Returns the name to use in generated code for this Dart type.
  ///
  /// Doesn't include the List type for repeated fields.
  /// [package] is the current package where we are generating code.
  /// The Dart class might be imported from a different package.
  String getDartType(String package) =>
      (package == this.package) ? unprefixed : prefixed;

  String getRepeatedDartType(String package) => "List<${getDartType(package)}>";

  factory BaseType(FieldDescriptorProto field, GenerationContext ctx) {
    String constSuffix;

    switch (field.type) {
      case FieldDescriptorProto_Type.TYPE_BOOL:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_BOOL, "B",
            "bool", r"$_setBool", null);
      case FieldDescriptorProto_Type.TYPE_FLOAT:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_FLOAT, "F",
            "double", r"$_setFloat", null);
      case FieldDescriptorProto_Type.TYPE_DOUBLE:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_DOUBLE, "D",
            "double", r"$_setDouble", null);
      case FieldDescriptorProto_Type.TYPE_INT32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_INT32, "3",
            "int", r"$_setSignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_UINT32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_UINT32, "U3",
            "int", r"$_setUnsignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_SINT32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_SINT32, "S3",
            "int", r"$_setSignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_FIXED32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_FIXED32, "F3",
            "int", r"$_setUnsignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_SFIXED32,
            "SF3", "int", r"$_setSignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_INT64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_INT64, "6",
            "Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_UINT64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_UINT64, "U6",
            "Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_SINT64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_SINT64, "S6",
            "Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_FIXED64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_FIXED64, "F6",
            "Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_SFIXED64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_SFIXED64,
            "SF6", "Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_STRING:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_STRING, "S",
            "String", r"$_setString", null);
      case FieldDescriptorProto_Type.TYPE_BYTES:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_BYTES, "Y",
            "List<int>", r"$_setBytes", null);

      case FieldDescriptorProto_Type.TYPE_GROUP:
        constSuffix = "G";
        break;
      case FieldDescriptorProto_Type.TYPE_MESSAGE:
        constSuffix = "M";
        break;
      case FieldDescriptorProto_Type.TYPE_ENUM:
        constSuffix = "E";
        break;

      default:
        throw new ArgumentError("unimplemented type: ${field.type.name}");
    }

    ProtobufContainer generator = ctx.getFieldType(field.typeName);
    if (generator == null) {
      throw 'FAILURE: Unknown type reference ${field.typeName}';
    }

    return new BaseType._raw(
        field.type, constSuffix, generator.classname, null, generator);
  }
}
