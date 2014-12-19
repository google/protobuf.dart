// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/**
 * Per-message type setup.
 */
class BuilderInfo {
  final String messageName;
  final Map<int, FieldInfo> fieldInfo = new Map<int, FieldInfo>();
  final Map<String, FieldInfo> byName = <String, FieldInfo>{};
  bool hasExtensions = false;
  bool hasRequiredFields = true;

  BuilderInfo(this.messageName);

  void add(int tagNumber, String name, int fieldType,
           dynamic defaultOrMaker,
           CreateBuilderFunc subBuilder,
           ValueOfFunc valueOf) {
    fieldInfo[tagNumber] = byName[name] = new FieldInfo(
      name, tagNumber, fieldType, defaultOrMaker, subBuilder, valueOf);
  }

  void a(int tagNumber, String name, int fieldType,
         [dynamic defaultOrMaker,
          CreateBuilderFunc subBuilder,
          ValueOfFunc valueOf]) {
    add(tagNumber, name, fieldType,
        defaultOrMaker, subBuilder, valueOf);
  }

  // Enum.
  void e(int tagNumber, String name, int fieldType,
         dynamic defaultOrMaker, ValueOfFunc valueOf) {
    add(tagNumber, name, fieldType,
        defaultOrMaker, null, valueOf);
  }

  // Repeated message.
  // TODO(antonm): change the order of CreateBuilderFunc and MakeDefaultFunc.
  void m(int tagNumber, String name,
         CreateBuilderFunc subBuilder, MakeDefaultFunc makeDefault) {
    add(tagNumber, name, GeneratedMessage._REPEATED_MESSAGE,
        makeDefault, subBuilder, null);
  }

  // Repeated non-message.
  void p(int tagNumber, String name, int fieldType) {
    MakeDefaultFunc makeDefault;
    switch (fieldType & ~0x7) {
    case GeneratedMessage._BOOL_BIT:
      makeDefault = () => new PbList<bool>();
      break;
    case GeneratedMessage._BYTES_BIT:
      makeDefault = () => new PbList<List<int>>();
      break;
    case GeneratedMessage._STRING_BIT:
      makeDefault = () => new PbList<String>();
      break;
    case GeneratedMessage._FLOAT_BIT:
      makeDefault = () => new PbFloatList();
      break;
    case GeneratedMessage._DOUBLE_BIT:
      makeDefault = () => new PbList<double>();
      break;
    case GeneratedMessage._ENUM_BIT:
      makeDefault = () => new PbList<ProtobufEnum>();
      break;
    case GeneratedMessage._INT32_BIT:
    case GeneratedMessage._SINT32_BIT:
    case GeneratedMessage._SFIXED32_BIT:
      makeDefault = () => new PbSint32List();
      break;
    case GeneratedMessage._UINT32_BIT:
    case GeneratedMessage._FIXED32_BIT:
      makeDefault = () => new PbUint32List();
      break;
    case GeneratedMessage._INT64_BIT:
    case GeneratedMessage._SINT64_BIT:
    case GeneratedMessage._SFIXED64_BIT:
      makeDefault = () => new PbSint64List();
      break;
    case GeneratedMessage._UINT64_BIT:
    case GeneratedMessage._FIXED64_BIT:
      makeDefault = () => new PbUint64List();
      break;
    case GeneratedMessage._MESSAGE_BIT:
      throw new ArgumentError('use BuilderInfo.m() for repeated messages');
    default:
      throw new ArgumentError('unknown type ${fieldType}');
    }

    add(tagNumber, name, fieldType, makeDefault, null, null);
  }

  bool containsTagNumber(int tagNumber) => fieldInfo.containsKey(tagNumber);

  defaultValue(int tagNumber) {
    MakeDefaultFunc func = makeDefault(tagNumber);
    return func == null ? null : func();
  }

  // Returns the field name for a given tag number, for debugging purposes.
  String fieldName(int tagNumber) {
    FieldInfo i = fieldInfo[tagNumber];
    return i != null ? i.name : null;
  }

  int fieldType(int tagNumber) {
    FieldInfo i = fieldInfo[tagNumber];
    return i != null ? i.type : null;
  }

  MakeDefaultFunc makeDefault(int tagNumber) {
    FieldInfo i = fieldInfo[tagNumber];
    return i != null ? i.makeDefault : null;
  }

  bool isInitialized(Map<int, dynamic> fieldValues) {
    return fieldInfo.keys.every(
        (tagNumber) => _isFieldInitialized(fieldValues, tagNumber));
  }

  CreateBuilderFunc subBuilder(int tagNumber) {
    FieldInfo i = fieldInfo[tagNumber];
    return i != null ? i.subBuilder : null;
  }

  int tagNumber(String fieldName) {
    FieldInfo i = byName[fieldName];
    return i != null ? i.tagNumber : null;
  }

  ValueOfFunc valueOfFunc(int tagNumber) {
    FieldInfo i = fieldInfo[tagNumber];
    return i != null ? i.valueOf : null;
  }

  bool _isFieldInitialized(Map<int, dynamic> fieldValues, int tagNumber,
                           [int fieldType = null]) {
    if (fieldType == null) {
      fieldType = fieldInfo[tagNumber].type;
    }
    if ((fieldType &
        (GeneratedMessage._MESSAGE_BIT | GeneratedMessage._GROUP_BIT)) != 0) {
      if ((fieldType & GeneratedMessage._REQUIRED_BIT) != 0) {
        GeneratedMessage message = fieldValues[tagNumber];
        // Required message/group must be present and initialized.
        if (message == null || !message.isInitialized()) {
          return false;
        }
      } else if ((fieldType & GeneratedMessage._REPEATED_BIT) != 0) {
        if (fieldValues.containsKey(tagNumber)) {
          // Repeated message/group must have all its members initialized.
          List list = fieldValues[tagNumber];
          // For message types that (recursively) contain no required fields,
          // short-circuit the loop.
          if (!list.isEmpty && list[0].hasRequiredFields()) {
            if (!list.every((message) => message.isInitialized())) {
              return false;
            }
          }
        }
      } else {
        GeneratedMessage message = fieldValues[tagNumber];
        // Optional message/group must be initialized if it is present.
        if (message != null && !message.isInitialized()) {
          return false;
        }
      }

    } else if ((fieldType & GeneratedMessage._REQUIRED_BIT) != 0) {
      // Required 'primitive' must be present.
      if (fieldValues[tagNumber] == null) {
        return false;
      }
    }
    return true;
  }

  List<String> _findInvalidFields(Map<int, dynamic> fieldValues,
      List<String> invalidFields, [String prefix = '']) {
    fieldInfo.forEach((int tagNumber, FieldInfo field) {
      int fieldType = field.type;
      if ((fieldType &
          (GeneratedMessage._MESSAGE_BIT | GeneratedMessage._GROUP_BIT)) != 0) {
        if ((fieldType & GeneratedMessage._REQUIRED_BIT) != 0) {
          GeneratedMessage message = fieldValues[tagNumber];
          // Required message/group must be present.
          if (message == null) {
            invalidFields.add('${prefix}${field.name}');
          } else {
            message._findInvalidFields(
                invalidFields, '${prefix}${field.name}.');
          }
        } else if ((fieldType & GeneratedMessage._REPEATED_BIT) != 0) {
          if (fieldValues.containsKey(tagNumber)) {
            // Repeated message/group must have all its members initialized.
            List list = fieldValues[tagNumber];
            // For messages that (recursively) contain no required fields,
            // short-circuit the loop.
            if (!list.isEmpty && list[0].hasRequiredFields()) {
              int position = 0;
              for (GeneratedMessage message in list) {
                if (message.hasRequiredFields()) {
                  message._findInvalidFields(
                      invalidFields, '${prefix}${field.name}[${position}].');
                }
                position++;
              }
            }
          }
        } else {
          GeneratedMessage message = fieldValues[tagNumber];
          // Required message/group must be present.
          if (message != null) {
            message._findInvalidFields(invalidFields, '${prefix}${field.name}.');
          }
        }

      } else if((fieldType & GeneratedMessage._REQUIRED_BIT) != 0) {
        // Required 'primitive' must be present.
        if (fieldValues[tagNumber] == null) {
          invalidFields.add('${prefix}${field.name}');
        }
      }
    });
    return invalidFields;
  }
}
