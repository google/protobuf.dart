// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class ProtobufField {
  static final RegExp HEX_LITERAL_REGEX =
      new RegExp(r'^0x[0-9a-f]+$', multiLine: false, caseSensitive: false);
  static final RegExp INTEGER_LITERAL_REGEX = new RegExp(r'^[+-]?[0-9]+$');
  static final RegExp DECIMAL_LITERAL_REGEX_A =
      new RegExp(r'^[+-]?([0-9]*)\.[0-9]+(e[+-]?[0-9]+)?$', 
                 multiLine: false, caseSensitive: false);
  static final RegExp DECIMAL_LITERAL_REGEX_B =
      new RegExp(r'^[+-]?[0-9]+e[+-]?[0-9]+$', multiLine: false, 
                 caseSensitive: false);

  final FieldDescriptorProto _field;
  final ProtobufContainer parent;
  final GenerationContext context;
  final String fqname;
  final String baseType;
  final String typeString;
  final String codedStreamType;
  final bool repeats;
  final String initialization;
  final bool required;
  // True if the field is to be encoded with [packed=true] encoding.
  final bool packed;
  // True if the fields's type can handle [packed=true] encoding.
  final bool packable;

  bool get single => !repeats;

  bool get group => type == FieldDescriptorProto_Type.TYPE_GROUP;
  bool get message => type == FieldDescriptorProto_Type.TYPE_MESSAGE;
  bool get enum => type == FieldDescriptorProto_Type.TYPE_ENUM;
  bool get primitive => !group && !message;

  bool get hasInitialization => initialization != null;

  bool get optional => !required; // includes repeated

  // Delegate methods.
  String get name => _field.name;
  int get number => _field.number;
  FieldDescriptorProto_Label get label => _field.label;
  FieldDescriptorProto_Type get type => _field.type;
  FieldOptions get options => _field.options;
  String get typeName => _field.typeName;

  String get shortTypeName {
    String prefix;
    if (required) {
      prefix = 'Q';
    } else if (packed) {
      prefix = 'K';
    } else if (repeats) {
      prefix = 'P';
    } else if (optional) {
      prefix = 'O';
    } else {
      throw '$this';
    }
    switch (codedStreamType.toUpperCase()) {
      case 'BOOL': return '${prefix}B';
      case 'BYTES': return '${prefix}Y';
      case 'STRING': return '${prefix}S';
      case 'FLOAT': return '${prefix}F';
      case 'DOUBLE': return '${prefix}D';
      case 'ENUM': return '${prefix}E';
      case 'GROUP': return '${prefix}G';
      case 'INT32': return '${prefix}3';
      case 'INT64': return '${prefix}6';
      case 'UINT32': return '${prefix}U3';
      case 'UINT64': return '${prefix}U6';
      case 'SINT32': return '${prefix}S3';
      case 'SINT64': return '${prefix}S6';
      case 'FIXED32': return '${prefix}F3';
      case 'FIXED64': return '${prefix}F6';
      case 'SFIXED32': return '${prefix}SF3';
      case 'SFIXED64': return '${prefix}SF6';
      case 'MESSAGE': return '${prefix}M';
    }
    throw 'Unknown type';
  }

  ProtobufField._(
      field, parent, this.context, this.baseType, this.typeString,
      this.codedStreamType, this.repeats, this.initialization, this.required,
      this.packed, this.packable) :
          this._field = field,
          this.parent = parent,
          fqname = '${parent.fqname}.${field.name}';


  factory ProtobufField(FieldDescriptorProto field,
                        MessageGenerator parent,
                        GenerationContext context) {
    bool required = field.label == FieldDescriptorProto_Label.LABEL_REQUIRED;
    bool repeats = field.label == FieldDescriptorProto_Label.LABEL_REPEATED;
    bool packed = false;

    var write;
    if (repeats) {
      packed = field.options == null ? false : field.options.packed;
      write = (String typeString) => 'List<$typeString>';
    } else {
      write = (String typeString) => typeString;
    }

    String baseType;
    String typeString;
    bool packable = false;
    String codedStreamType;
    String initialization;
    switch (field.type) {
      case FieldDescriptorProto_Type.TYPE_BOOL:
        baseType = 'bool';
        typeString = write('bool');
        packable = true;
        codedStreamType = 'Bool';
        if (!repeats) {
          if (field.hasDefaultValue() && 'false' != field.defaultValue) {
            initialization = '()${SP}=>${SP}${field.defaultValue}';
          }
        }
        break;
      case FieldDescriptorProto_Type.TYPE_FLOAT:
      case FieldDescriptorProto_Type.TYPE_DOUBLE:
        baseType = 'double';
        typeString = write('double');
        packable = true;
        codedStreamType =
            (field.type == FieldDescriptorProto_Type.TYPE_FLOAT) ?
                'Float' : 'Double';
        if (!repeats) {
          if (field.hasDefaultValue() &&
              ('0.0' != field.defaultValue || '0' != field.defaultValue)) {
            switch (true) {
              case field.defaultValue == 'inf':
                initialization = '()${SP}=>${SP}double.INFINITY';
                break;
              case field.defaultValue == '-inf':
                initialization = '()${SP}=>${SP}double.NEGATIVE_INFINITY';
                break;
              case field.defaultValue == 'nan':
                initialization = '()${SP}=>${SP}double.NAN';
                break;
              case HEX_LITERAL_REGEX.hasMatch(field.defaultValue):
                initialization = '()${SP}=>${SP}(${field.defaultValue})'
                    '.toDouble()';
                break;
              case INTEGER_LITERAL_REGEX.hasMatch(field.defaultValue):
                initialization = '()${SP}=>${SP}${field.defaultValue}.0';
                break;
              case DECIMAL_LITERAL_REGEX_A.hasMatch(field.defaultValue):
              case DECIMAL_LITERAL_REGEX_B.hasMatch(field.defaultValue):
                initialization = '()${SP}=>${SP}${field.defaultValue}';
                break;
              default:
                throw new InvalidDefaultValue.double(
                    field.name, field.defaultValue);
            }
          }
        }
        break;
      case FieldDescriptorProto_Type.TYPE_INT32:
      case FieldDescriptorProto_Type.TYPE_UINT32:
      case FieldDescriptorProto_Type.TYPE_SINT32:
      case FieldDescriptorProto_Type.TYPE_FIXED32:
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        baseType = 'int';
        typeString = write('int');
        packable = true;
        switch (field.type) {
          case FieldDescriptorProto_Type.TYPE_INT32:
            codedStreamType = 'Int32';
            break;
          case FieldDescriptorProto_Type.TYPE_UINT32:
            codedStreamType = 'Uint32';
            break;
          case FieldDescriptorProto_Type.TYPE_SINT32:
            codedStreamType = 'Sint32';
            break;
          case FieldDescriptorProto_Type.TYPE_FIXED32:
            codedStreamType = 'Fixed32';
            break;
          case FieldDescriptorProto_Type.TYPE_SFIXED32:
            codedStreamType = 'Sfixed32';
            break;
        }
        if (!repeats) {
          if (field.hasDefaultValue() && '0' != field.defaultValue) {
            initialization = '()${SP}=>${SP}${field.defaultValue}';
          }
        }
        break;
      case FieldDescriptorProto_Type.TYPE_INT64:
      case FieldDescriptorProto_Type.TYPE_UINT64:
      case FieldDescriptorProto_Type.TYPE_SINT64:
      case FieldDescriptorProto_Type.TYPE_FIXED64:
      case FieldDescriptorProto_Type.TYPE_SFIXED64:
        baseType = 'ByteData';
        typeString = write('ByteData');
        packable = true;
        switch (field.type) {
          case FieldDescriptorProto_Type.TYPE_INT64:
            codedStreamType = 'Int64';
            break;
          case FieldDescriptorProto_Type.TYPE_UINT64:
            codedStreamType = 'Uint64';
            break;
          case FieldDescriptorProto_Type.TYPE_SINT64:
            codedStreamType = 'Sint64';
            break;
          case FieldDescriptorProto_Type.TYPE_FIXED64:
            codedStreamType = 'Fixed64';
            break;
          case FieldDescriptorProto_Type.TYPE_SFIXED64:
            codedStreamType = 'Sfixed64';
            break;
        }
        if (!repeats) {
          final defaultValue = field.hasDefaultValue() ?
              field.defaultValue : '0';
          initialization = '()${SP}=>${SP}makeLongInt($defaultValue)';
        }
        break;
      case FieldDescriptorProto_Type.TYPE_STRING:
        baseType = 'String';
        typeString = write('String');
        codedStreamType = 'String';
        if (!repeats) {
          if (field.hasDefaultValue() && !field.defaultValue.isEmpty) {
            String defaultValue = field.defaultValue.replaceAll(r'$', r'\$');
            initialization = '()${SP}=>${SP}\'$defaultValue\'';
          }
        }
        break;
      case FieldDescriptorProto_Type.TYPE_BYTES:
        baseType = 'List<int>';
        typeString = write('List<int>');
        codedStreamType = 'Bytes';
        if (!repeats) {
          if (field.hasDefaultValue() && !field.defaultValue.isEmpty) {
            String byteList = field.defaultValue.codeUnits
                .map((b) => '0x${b.toRadixString(16)}')
                .join(',');
            initialization = '()${SP}=>${SP}<int>[$byteList]';
          }
        }
        break;
      case FieldDescriptorProto_Type.TYPE_GROUP:
        ProtobufContainer groupType = context[field.typeName];
        if (groupType != null) {
          baseType = groupType.classname;
          typeString = write(groupType.classname);
          codedStreamType = 'Group';
        } else {
          throw 'FAILURE: Unknown group type reference ${field.typeName}';
        }
        initialization = '()${SP}=>${SP}new ${baseType}()';
        break;
      case FieldDescriptorProto_Type.TYPE_MESSAGE:
        ProtobufContainer messageType = context[field.typeName];
        if (messageType != null) {
          baseType = messageType.classname;
          typeString = write(messageType.classname);
          codedStreamType = 'Message';
        } else {
          throw 'FAILURE: Unknown message type reference ${field.typeName}';
        }
        initialization = '()${SP}=>${SP}new ${baseType}()';
        break;
      case FieldDescriptorProto_Type.TYPE_ENUM:
        EnumGenerator enumType = context[field.typeName];
        if (enumType != null) {
          baseType = enumType.classname;
          typeString = write(enumType.classname);
          codedStreamType = 'Enum';
          packable = true;
          if (!repeats) {
            if (field.hasDefaultValue() && !field.defaultValue.isEmpty) {
              initialization =
                  '()${SP}=>${SP}${enumType.classname}.${field.defaultValue}';
            } else if (!enumType._canonicalValues.isEmpty) {
              initialization =
                  '()${SP}=>${SP}${enumType.classname}.'
                  '${enumType._canonicalValues[0].name}';
            }
          }
        } else {
          throw 'FAILURE: Unknown enum type reference ${field.typeName}';
        }
        break;
      default:
        throw 'Unknown type ${field.type.name}';
      // No default -- should be an error.
    }

    if (repeats) {
      initialization = '()${SP}=>${SP}new PbList()';
    }

    return new ProtobufField._(
        field, parent, context, baseType, typeString, codedStreamType, repeats,
        initialization, required, packed, packable);
  }

  // camelCase field name.
  String get externalFieldName {
    String name = titlecaseFieldName;
    return '${name[0].toLowerCase()}${name.substring(1)}';
  }

  // TitleCase field name.
  String get titlecaseFieldName {
    String underscoresToCamelCase(String s) {
      cap(s) => s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';
      return s.split('_').map(cap).join('');
    }

    // For groups, use capitalization of 'typeName' rather than 'name'.
    if (codedStreamType == 'Group') {
      String name = _field.typeName;
      int index = name.lastIndexOf('.');
      if (index != -1) {
        name = name.substring(index + 1);
      }
      return underscoresToCamelCase(name);
    }
    var name = context.options.fieldNameOption(fqname);
    return (name != null) ? name : underscoresToCamelCase(_field.name);
  }

  int get wireType {
    switch (_field.type) {
      case FieldDescriptorProto_Type.TYPE_INT32:
      case FieldDescriptorProto_Type.TYPE_INT64:
      case FieldDescriptorProto_Type.TYPE_UINT32:
      case FieldDescriptorProto_Type.TYPE_UINT64:
      case FieldDescriptorProto_Type.TYPE_SINT32:
      case FieldDescriptorProto_Type.TYPE_SINT64:
      case FieldDescriptorProto_Type.TYPE_BOOL:
      case FieldDescriptorProto_Type.TYPE_ENUM:
        return 0; // Varint
      case FieldDescriptorProto_Type.TYPE_DOUBLE:
      case FieldDescriptorProto_Type.TYPE_FIXED64:
      case FieldDescriptorProto_Type.TYPE_SFIXED64:
        return 1; // 64-bit
      case FieldDescriptorProto_Type.TYPE_STRING:
      case FieldDescriptorProto_Type.TYPE_BYTES:
      case FieldDescriptorProto_Type.TYPE_MESSAGE:
        return 2; // Length-delimited
      case FieldDescriptorProto_Type.TYPE_GROUP:
        return 3; // Start group
      case FieldDescriptorProto_Type.TYPE_FLOAT:
      case FieldDescriptorProto_Type.TYPE_FIXED32:
      case FieldDescriptorProto_Type.TYPE_SFIXED32:
        return 5; // 32-bit
    }
  }
}
