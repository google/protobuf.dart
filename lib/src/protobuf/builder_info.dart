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

  void addRepeated(int tagNumber, String name, int fieldType,
                   CheckFunc check,
                   CreateBuilderFunc subBuilder,
                   ValueOfFunc valueOf) {
    fieldInfo[tagNumber] = byName[name] = new FieldInfo.repeated(
        name, tagNumber, fieldType, check, subBuilder, valueOf);
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
  // TODO(skybrian): migrate to pp() and remove.
  void m(int tagNumber, String name,
         CreateBuilderFunc subBuilder, MakeDefaultFunc makeDefault) {
    add(tagNumber, name, FieldType._REPEATED_MESSAGE,
        makeDefault, subBuilder, null);
  }

  // Repeated, not a message, group, or enum.
  void p(int tagNumber, String name, int fieldType) {
    assert(!_isGroupOrMessage(fieldType) && !_isEnum(fieldType));
    addRepeated(tagNumber, name, fieldType,
        getCheckFunction(fieldType), null, null);
  }

  // Repeated message, group, or enum.
  void pp(int tagNumber, String name, int fieldType, CheckFunc check,
         [CreateBuilderFunc subBuilder, ValueOfFunc valueOf]) {
    assert(_isGroupOrMessage(fieldType) || _isEnum(fieldType));
    addRepeated(tagNumber, name, fieldType, check, subBuilder, valueOf);
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
    if (_isGroupOrMessage(fieldType)) {
      if (_isRequired(fieldType)) {
        GeneratedMessage message = fieldValues[tagNumber];
        // Required message/group must be present and initialized.
        if (message == null || !message.isInitialized()) {
          return false;
        }
      } else if (_isRepeated(fieldType)) {
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

    } else if (_isRequired(fieldType)) {
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
      if (_isGroupOrMessage(fieldType)) {
        if (_isRequired(fieldType)) {
          GeneratedMessage message = fieldValues[tagNumber];
          // Required message/group must be present.
          if (message == null) {
            invalidFields.add('${prefix}${field.name}');
          } else {
            message._findInvalidFields(
                invalidFields, '${prefix}${field.name}.');
          }
        } else if (_isRepeated(fieldType)) {
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

      } else if(_isRequired(fieldType)) {
        // Required 'primitive' must be present.
        if (fieldValues[tagNumber] == null) {
          invalidFields.add('${prefix}${field.name}');
        }
      }
    });
    return invalidFields;
  }
}
