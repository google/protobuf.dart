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

  /// The Dart expression to use for this type when in a different file.
  String get prefixed => generator == null
      ? unprefixed
      : generator.fileImportPrefix + "." + unprefixed;

  /// Returns the name to use in generated code for this Dart type.
  ///
  /// Doesn't include the List type for repeated fields.
  /// [protoFileUri] represents the current proto file where we are generating
  /// code. The Dart class might be imported from a different proto file.
  String getDartType(FileGenerator fileGen) =>
      (fileGen.protoFileUri == generator?.fileGen?.protoFileUri)
          ? unprefixed
          : prefixed;

  String getRepeatedDartType(FileGenerator fileGen) =>
      "$_coreImportPrefix.List<${getDartType(fileGen)}>";

  factory BaseType(FieldDescriptorProto field, GenerationContext ctx) {
    String constSuffix;

    switch (field.type) {
      case FieldDescriptorProto_Type.TYPE_BOOL:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_BOOL, "B",
            "$_coreImportPrefix.bool", r"$_setBool", null);
      case FieldDescriptorProto_Type.TYPE_FLOAT:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_FLOAT, "F",
            "$_coreImportPrefix.double", r"$_setFloat", null);
      case FieldDescriptorProto_Type.TYPE_DOUBLE:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_DOUBLE, "D",
            "$_coreImportPrefix.double", r"$_setDouble", null);
      case FieldDescriptorProto_Type.TYPE_INT32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_INT32, "3",
            "$_coreImportPrefix.int", r"$_setSignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_UINT32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_UINT32, "U3",
            "$_coreImportPrefix.int", r"$_setUnsignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_SINT32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_SINT32, "S3",
            "$_coreImportPrefix.int", r"$_setSignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_FIXED32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_FIXED32, "F3",
            "$_coreImportPrefix.int", r"$_setUnsignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_SFIXED32,
            "SF3", "$_coreImportPrefix.int", r"$_setSignedInt32", null);
      case FieldDescriptorProto_Type.TYPE_INT64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_INT64, "6",
            "$_fixnumImportPrefix.Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_UINT64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_UINT64, "U6",
            "$_fixnumImportPrefix.Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_SINT64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_SINT64, "S6",
            "$_fixnumImportPrefix.Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_FIXED64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_FIXED64, "F6",
            "$_fixnumImportPrefix.Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_SFIXED64:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_SFIXED64,
            "SF6", "$_fixnumImportPrefix.Int64", r"$_setInt64", null);
      case FieldDescriptorProto_Type.TYPE_STRING:
        return const BaseType._raw(FieldDescriptorProto_Type.TYPE_STRING, "S",
            "$_coreImportPrefix.String", r"$_setString", null);
      case FieldDescriptorProto_Type.TYPE_BYTES:
        return const BaseType._raw(
            FieldDescriptorProto_Type.TYPE_BYTES,
            "Y",
            "$_coreImportPrefix.List<$_coreImportPrefix.int>",
            r"$_setBytes",
            null);

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
        throw ArgumentError("unimplemented type: ${field.type.name}");
    }

    ProtobufContainer generator = ctx.getFieldType(field.typeName);
    if (generator == null) {
      throw 'FAILURE: Unknown type reference ${field.typeName}';
    }

    return BaseType._raw(
        field.type, constSuffix, generator.classname, null, generator);
  }
}
