// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// Per-message type setup.
class BuilderInfo {
  /// The fully qualified name of this message.
  final String qualifiedMessageName;
  final List<FieldInfo> byIndex = <FieldInfo>[];
  final Map<int, FieldInfo> fieldInfo = Map<int, FieldInfo>();
  final Map<String, FieldInfo> byTagAsString = <String, FieldInfo>{};
  final Map<String, FieldInfo> byName = <String, FieldInfo>{};
  // Maps a tag number to the corresponding oneof index (if any).
  final Map<int, int> oneofs = <int, int>{};
  bool hasExtensions = false;
  bool hasRequiredFields = true;
  List<FieldInfo> _sortedByTag;

  BuilderInfo(String messageName, {PackageName package = const PackageName('')})
      : qualifiedMessageName = "${package.prefix}$messageName";

  void add<T>(
      int tagNumber,
      String name,
      int fieldType,
      dynamic defaultOrMaker,
      CreateBuilderFunc subBuilder,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues) {
    var index = byIndex.length;
    _addField(FieldInfo<T>(name, tagNumber, index, fieldType, defaultOrMaker,
        subBuilder, valueOf, enumValues));
  }

  void addMapField<K, V>(int tagNumber, String name, int keyFieldType,
      int valueFieldType, BuilderInfo mapEntryBuilderInfo) {
    var index = byIndex.length;
    _addField(MapFieldInfo<K, V>.map(name, tagNumber, index, PbFieldType.M,
        keyFieldType, valueFieldType, mapEntryBuilderInfo));
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
    _addField(FieldInfo<T>.repeated(name, tagNumber, index, fieldType, check,
        subBuilder, valueOf, enumValues));
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

  // Repeated, not a message, group, or enum.
  void p<T>(int tagNumber, String name, int fieldType) {
    assert(!_isGroupOrMessage(fieldType) && !_isEnum(fieldType));
    addRepeated<T>(tagNumber, name, fieldType, getCheckFunction(fieldType),
        null, null, null);
  }

  // Repeated message, group, or enum.
  void pc<T>(int tagNumber, String name, int fieldType,
      [CreateBuilderFunc subBuilder,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues]) {
    assert(_isGroupOrMessage(fieldType) || _isEnum(fieldType));
    addRepeated<T>(tagNumber, name, fieldType, _checkNotNull, subBuilder,
        valueOf, enumValues);
  }

  @Deprecated('Use [pc] instead. The given [check] function is ignored.'
      'This function will be removed in the next major version.')
  void pp<T>(int tagNumber, String name, int fieldType, CheckFunc<T> check,
      [CreateBuilderFunc subBuilder,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues]) {
    assert(_isGroupOrMessage(fieldType) || _isEnum(fieldType));
    addRepeated<T>(tagNumber, name, fieldType, _checkNotNull, subBuilder,
        valueOf, enumValues);
  }

  // oneof declarations.
  void oo(int oneofIndex, List<int> tags) {
    tags.forEach((int tag) => oneofs[tag] = oneofIndex);
  }

  // Map field.
  void m<K, V>(int tagNumber, String name, String entryClassName,
      int keyFieldType, int valueFieldType,
      [CreateBuilderFunc valueCreator,
      ValueOfFunc valueOf,
      List<ProtobufEnum> enumValues,
      PackageName packageName = const PackageName('')]) {
    BuilderInfo mapEntryBuilderInfo = BuilderInfo(entryClassName,
        package: packageName)
      ..add(PbMap._keyFieldNumber, 'key', keyFieldType, null, null, null, null)
      ..add(PbMap._valueFieldNumber, 'value', valueFieldType, null,
          valueCreator, valueOf, enumValues);

    addMapField<K, V>(
        tagNumber, name, keyFieldType, valueFieldType, mapEntryBuilderInfo);
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

  /// The FieldInfo for each field in tag number order.
  List<FieldInfo> get sortedByTag => _sortedByTag ??= _computeSortedByTag();

  /// The message name. Also see [qualifiedMessageName].
  String get messageName {
    final lastDot = qualifiedMessageName.lastIndexOf('.');
    return lastDot == -1
        ? qualifiedMessageName
        : qualifiedMessageName.substring(lastDot + 1);
  }

  List<FieldInfo> _computeSortedByTag() {
    // TODO(skybrian): perhaps the code generator should insert the FieldInfos
    // in tag number order, to avoid sorting them?
    return List<FieldInfo>.from(fieldInfo.values, growable: false)
      ..sort((FieldInfo a, FieldInfo b) => a.tagNumber.compareTo(b.tagNumber));
  }

  GeneratedMessage _makeEmptyMessage(
      int tagNumber, ExtensionRegistry extensionRegistry) {
    CreateBuilderFunc subBuilderFunc = subBuilder(tagNumber);
    if (subBuilderFunc == null && extensionRegistry != null) {
      subBuilderFunc = extensionRegistry
          .getExtension(qualifiedMessageName, tagNumber)
          .subBuilder;
    }
    return subBuilderFunc();
  }

  _decodeEnum(int tagNumber, ExtensionRegistry registry, int rawValue) {
    ValueOfFunc f = valueOfFunc(tagNumber);
    if (f == null && registry != null) {
      f = registry.getExtension(qualifiedMessageName, tagNumber).valueOf;
    }
    return f(rawValue);
  }
}
