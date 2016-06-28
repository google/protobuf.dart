///
//  Generated code. Do not modify.
///
library proto2_descriptor_pbenum;

import 'package:protobuf/protobuf.dart';

class FieldDescriptorProto_Type extends ProtobufEnum {
  static const FieldDescriptorProto_Type TYPE_DOUBLE = const FieldDescriptorProto_Type._(1, 'TYPE_DOUBLE');
  static const FieldDescriptorProto_Type TYPE_FLOAT = const FieldDescriptorProto_Type._(2, 'TYPE_FLOAT');
  static const FieldDescriptorProto_Type TYPE_INT64 = const FieldDescriptorProto_Type._(3, 'TYPE_INT64');
  static const FieldDescriptorProto_Type TYPE_UINT64 = const FieldDescriptorProto_Type._(4, 'TYPE_UINT64');
  static const FieldDescriptorProto_Type TYPE_INT32 = const FieldDescriptorProto_Type._(5, 'TYPE_INT32');
  static const FieldDescriptorProto_Type TYPE_FIXED64 = const FieldDescriptorProto_Type._(6, 'TYPE_FIXED64');
  static const FieldDescriptorProto_Type TYPE_FIXED32 = const FieldDescriptorProto_Type._(7, 'TYPE_FIXED32');
  static const FieldDescriptorProto_Type TYPE_BOOL = const FieldDescriptorProto_Type._(8, 'TYPE_BOOL');
  static const FieldDescriptorProto_Type TYPE_STRING = const FieldDescriptorProto_Type._(9, 'TYPE_STRING');
  static const FieldDescriptorProto_Type TYPE_GROUP = const FieldDescriptorProto_Type._(10, 'TYPE_GROUP');
  static const FieldDescriptorProto_Type TYPE_MESSAGE = const FieldDescriptorProto_Type._(11, 'TYPE_MESSAGE');
  static const FieldDescriptorProto_Type TYPE_BYTES = const FieldDescriptorProto_Type._(12, 'TYPE_BYTES');
  static const FieldDescriptorProto_Type TYPE_UINT32 = const FieldDescriptorProto_Type._(13, 'TYPE_UINT32');
  static const FieldDescriptorProto_Type TYPE_ENUM = const FieldDescriptorProto_Type._(14, 'TYPE_ENUM');
  static const FieldDescriptorProto_Type TYPE_SFIXED32 = const FieldDescriptorProto_Type._(15, 'TYPE_SFIXED32');
  static const FieldDescriptorProto_Type TYPE_SFIXED64 = const FieldDescriptorProto_Type._(16, 'TYPE_SFIXED64');
  static const FieldDescriptorProto_Type TYPE_SINT32 = const FieldDescriptorProto_Type._(17, 'TYPE_SINT32');
  static const FieldDescriptorProto_Type TYPE_SINT64 = const FieldDescriptorProto_Type._(18, 'TYPE_SINT64');

  static const List<FieldDescriptorProto_Type> values = const <FieldDescriptorProto_Type> [
    TYPE_DOUBLE,
    TYPE_FLOAT,
    TYPE_INT64,
    TYPE_UINT64,
    TYPE_INT32,
    TYPE_FIXED64,
    TYPE_FIXED32,
    TYPE_BOOL,
    TYPE_STRING,
    TYPE_GROUP,
    TYPE_MESSAGE,
    TYPE_BYTES,
    TYPE_UINT32,
    TYPE_ENUM,
    TYPE_SFIXED32,
    TYPE_SFIXED64,
    TYPE_SINT32,
    TYPE_SINT64,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static FieldDescriptorProto_Type valueOf(int value) => _byValue[value] as FieldDescriptorProto_Type;
  static void $checkItem(FieldDescriptorProto_Type v) {
    if (v is !FieldDescriptorProto_Type) checkItemFailed(v, 'FieldDescriptorProto_Type');
  }

  const FieldDescriptorProto_Type._(int v, String n) : super(v, n);
}

class FieldDescriptorProto_Label extends ProtobufEnum {
  static const FieldDescriptorProto_Label LABEL_OPTIONAL = const FieldDescriptorProto_Label._(1, 'LABEL_OPTIONAL');
  static const FieldDescriptorProto_Label LABEL_REQUIRED = const FieldDescriptorProto_Label._(2, 'LABEL_REQUIRED');
  static const FieldDescriptorProto_Label LABEL_REPEATED = const FieldDescriptorProto_Label._(3, 'LABEL_REPEATED');

  static const List<FieldDescriptorProto_Label> values = const <FieldDescriptorProto_Label> [
    LABEL_OPTIONAL,
    LABEL_REQUIRED,
    LABEL_REPEATED,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static FieldDescriptorProto_Label valueOf(int value) => _byValue[value] as FieldDescriptorProto_Label;
  static void $checkItem(FieldDescriptorProto_Label v) {
    if (v is !FieldDescriptorProto_Label) checkItemFailed(v, 'FieldDescriptorProto_Label');
  }

  const FieldDescriptorProto_Label._(int v, String n) : super(v, n);
}

class FileOptions_OptimizeMode extends ProtobufEnum {
  static const FileOptions_OptimizeMode SPEED = const FileOptions_OptimizeMode._(1, 'SPEED');
  static const FileOptions_OptimizeMode CODE_SIZE = const FileOptions_OptimizeMode._(2, 'CODE_SIZE');
  static const FileOptions_OptimizeMode LITE_RUNTIME = const FileOptions_OptimizeMode._(3, 'LITE_RUNTIME');

  static const List<FileOptions_OptimizeMode> values = const <FileOptions_OptimizeMode> [
    SPEED,
    CODE_SIZE,
    LITE_RUNTIME,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static FileOptions_OptimizeMode valueOf(int value) => _byValue[value] as FileOptions_OptimizeMode;
  static void $checkItem(FileOptions_OptimizeMode v) {
    if (v is !FileOptions_OptimizeMode) checkItemFailed(v, 'FileOptions_OptimizeMode');
  }

  const FileOptions_OptimizeMode._(int v, String n) : super(v, n);
}

class FieldOptions_CType extends ProtobufEnum {
  static const FieldOptions_CType STRING = const FieldOptions_CType._(0, 'STRING');

  static const List<FieldOptions_CType> values = const <FieldOptions_CType> [
    STRING,
  ];

  static final Map<int, dynamic> _byValue = ProtobufEnum.initByValue(values);
  static FieldOptions_CType valueOf(int value) => _byValue[value] as FieldOptions_CType;
  static void $checkItem(FieldOptions_CType v) {
    if (v is !FieldOptions_CType) checkItemFailed(v, 'FieldOptions_CType');
  }

  const FieldOptions_CType._(int v, String n) : super(v, n);
}

