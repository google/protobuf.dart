// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// Per-message type setup.
class BuilderInfo {
  final String messageName;
  final List<FieldInfo> byIndex = <FieldInfo>[];
  final Map<int, FieldInfo> fieldInfo = new Map<int, FieldInfo>();
  final Map<String, FieldInfo> byTagAsString = <String, FieldInfo>{};
  final Map<String, FieldInfo> byName = <String, FieldInfo>{};
  bool hasExtensions = false;
  bool hasRequiredFields = true;
  List<FieldInfo> _sortedByTag;

  BuilderInfo(this.messageName);

  void add<T>(
      int tagNumber,
      String name,
      int fieldType,
      dynamic defaultOrMaker,
      CreateBuilderFunc subBuilder,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues) {
    var index = byIndex.length;
    _addField(new FieldInfo<T>(name, tagNumber, index, fieldType,
        defaultOrMaker, subBuilder, valueOf, enumValues));
  }

  void addRepeated<T>(
      int tagNumber,
      String name,
      int fieldType,
      CheckFunc<T> check,
      CreateBuilderFunc subBuilder,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues) {
    var index = byIndex.length;
    _addField(new FieldInfo<T>.repeated(name, tagNumber, index, fieldType,
        check, subBuilder, valueOf, enumValues));
  }

  void _addField(FieldInfo fi) {
    byIndex.add(fi);
    assert(byIndex[fi.index] == fi);
    fieldInfo[fi.tagNumber] = fi;
    byTagAsString["${fi.tagNumber}"] = fi;
    byName[fi.name] = fi;
  }

  void a<T>(int tagNumber, String name, int fieldType,
      [dynamic defaultOrMaker,
      CreateBuilderFunc subBuilder,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues]) {
    add<T>(tagNumber, name, fieldType, defaultOrMaker, subBuilder, valueOf,
        enumValues);
  }

  /// Adds PbFieldType.OS String with no default value to reduce generated
  /// code size.
  void aOS(int tagNumber, String name) {
    add<String>(tagNumber, name, PbFieldType.OS, null, null, null, null);
  }

  /// Adds PbFieldType.PS String with no default value.
  void pPS(int tagNumber, String name) {
    addRepeated<String>(tagNumber, name, PbFieldType.PS,
        getCheckFunction(PbFieldType.PS), null, null, null);
  }

  /// Adds PbFieldType.QS String with no default value.
  void aQS(int tagNumber, String name) {
    add<String>(tagNumber, name, PbFieldType.QS, null, null, null, null);
  }

  /// Adds Int64 field with Int64.ZERO default.
  void aInt64(int tagNumber, String name) {
    add<Int64>(tagNumber, name, PbFieldType.O6, Int64.ZERO, null, null, null);
  }

  /// Adds a boolean with no default value.
  void aOB(int tagNumber, String name) {
    add<bool>(tagNumber, name, PbFieldType.OB, null, null, null, null);
  }

  // Enum.
  void e<T>(int tagNumber, String name, int fieldType, dynamic defaultOrMaker,
      ValueOfFunc valueOf, List<ProtobufEnum> enumValues) {
    add<T>(
        tagNumber, name, fieldType, defaultOrMaker, null, valueOf, enumValues);
  }

  // Repeated message.
  // TODO(skybrian): migrate to pp() and remove.
  void m<T>(int tagNumber, String name, CreateBuilderFunc subBuilder,
      MakeDefaultFunc makeDefault) {
    add<T>(tagNumber, name, PbFieldType._REPEATED_MESSAGE, makeDefault,
        subBuilder, null, null);
  }

  // Repeated, not a message, group, or enum.
  void p<T>(int tagNumber, String name, int fieldType) {
    assert(!_isGroupOrMessage(fieldType) && !_isEnum(fieldType));
    addRepeated<T>(tagNumber, name, fieldType, getCheckFunction(fieldType),
        null, null, null);
  }

  // Repeated message, group, or enum.
  void pp<T>(int tagNumber, String name, int fieldType, CheckFunc<T> check,
      [CreateBuilderFunc subBuilder,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues]) {
    assert(_isGroupOrMessage(fieldType) || _isEnum(fieldType));
    addRepeated<T>(
        tagNumber, name, fieldType, check, subBuilder, valueOf, enumValues);
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

  /// Returns the FieldInfo for each field in tag number order.
  List<FieldInfo> get sortedByTag => _sortedByTag ??= _computeSortedByTag();

  List<FieldInfo> _computeSortedByTag() {
    // TODO(skybrian): perhaps the code generator should insert the FieldInfos
    // in tag number order, to avoid sorting them?
    return new List<FieldInfo>.from(fieldInfo.values, growable: false)
      ..sort((FieldInfo a, FieldInfo b) => a.tagNumber.compareTo(b.tagNumber));
  }

  GeneratedMessage _makeEmptyMessage(
      int tagNumber, ExtensionRegistry extensionRegistry) {
    CreateBuilderFunc subBuilderFunc = subBuilder(tagNumber);
    if (subBuilderFunc == null && extensionRegistry != null) {
      subBuilderFunc =
          extensionRegistry.getExtension(messageName, tagNumber).subBuilder;
    }
    return subBuilderFunc();
  }

  _decodeEnum(int tagNumber, ExtensionRegistry registry, int rawValue) {
    ValueOfFunc f = valueOfFunc(tagNumber);
    if (f == null && registry != null) {
      f = registry.getExtension(messageName, tagNumber).valueOf;
    }
    return f(rawValue);
  }
}
