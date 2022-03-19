// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// Per-message type setup.
class BuilderInfo {
  /// The fully qualified name of this message.
  final String qualifiedMessageName;
  final List<FieldInfo> byIndex = <FieldInfo>[];
  final Map<int, FieldInfo> fieldInfo = <int, FieldInfo>{};
  final Map<String, FieldInfo> byTagAsString = <String, FieldInfo>{};
  final Map<String, FieldInfo> byName = <String, FieldInfo>{};
  // Maps a tag number to the corresponding oneof index (if any).
  final Map<int, int> oneofs = <int, int>{};
  bool hasExtensions = false;
  bool hasRequiredFields = true;
  List<FieldInfo>? _sortedByTag;

  // For well-known types.
  final Object? Function(GeneratedMessage message, TypeRegistry typeRegistry)?
      toProto3Json;
  final Function(GeneratedMessage targetMessage, Object json,
      TypeRegistry typeRegistry, JsonParsingContext context)? fromProto3Json;
  final CreateBuilderFunc? createEmptyInstance;

  BuilderInfo(String? messageName,
      {PackageName package = const PackageName(''),
      this.createEmptyInstance,
      this.toProto3Json,
      this.fromProto3Json})
      : qualifiedMessageName = '${package.prefix}$messageName';

  void add<T>(
      int tagNumber,
      String name,
      int? fieldType,
      dynamic defaultOrMaker,
      CreateBuilderFunc? subBuilder,
      ValueOfFunc? valueOf,
      List<ProtobufEnum>? enumValues,
      {String? protoName}) {
    var index = byIndex.length;
    final fieldInfo = (tagNumber == 0)
        ? FieldInfo.dummy(index)
        : FieldInfo<T>(name, tagNumber, index, fieldType!,
            defaultOrMaker: defaultOrMaker,
            subBuilder: subBuilder,
            valueOf: valueOf,
            enumValues: enumValues,
            protoName: protoName);
    _addField(fieldInfo);
  }

  void addMapField<K, V>(
      int tagNumber,
      String name,
      int? keyFieldType,
      int? valueFieldType,
      BuilderInfo mapEntryBuilderInfo,
      CreateBuilderFunc? valueCreator,
      {ProtobufEnum? defaultEnumValue,
      String? protoName}) {
    var index = byIndex.length;
    _addField(MapFieldInfo<K, V>(name, tagNumber, index, PbFieldType.M,
        keyFieldType, valueFieldType, mapEntryBuilderInfo, valueCreator,
        defaultEnumValue: defaultEnumValue, protoName: protoName));
  }

  void addRepeated<T>(
      int tagNumber,
      String name,
      int fieldType,
      CheckFunc<T> check,
      CreateBuilderFunc? subBuilder,
      ValueOfFunc? valueOf,
      List<ProtobufEnum>? enumValues,
      {ProtobufEnum? defaultEnumValue,
      String? protoName}) {
    var index = byIndex.length;
    _addField(FieldInfo<T>.repeated(
        name, tagNumber, index, fieldType, check, subBuilder,
        valueOf: valueOf,
        enumValues: enumValues,
        defaultEnumValue: defaultEnumValue,
        protoName: protoName));
  }

  void _addField(FieldInfo fi) {
    byIndex.add(fi);
    assert(byIndex[fi.index!] == fi);
    // Fields with tag number 0 are considered dummy fields added to avoid
    // index calculations add up. They should not be reflected in the following
    // maps.
    if (!fi._isDummy) {
      fieldInfo[fi.tagNumber] = fi;
      byTagAsString['${fi.tagNumber}'] = fi;
      byName[fi.name] = fi;
    }
  }

  void a<T>(int tagNumber, String name, int fieldType,
      {dynamic defaultOrMaker,
      CreateBuilderFunc? subBuilder,
      ValueOfFunc? valueOf,
      List<ProtobufEnum>? enumValues,
      String? protoName}) {
    add<T>(tagNumber, name, fieldType, defaultOrMaker, subBuilder, valueOf,
        enumValues,
        protoName: protoName);
  }

  /// Adds PbFieldType.OS String with no default value to reduce generated
  /// code size.
  void aOS(int tagNumber, String name, {String? protoName}) {
    add<String>(tagNumber, name, PbFieldType.OS, null, null, null, null,
        protoName: protoName);
  }

  /// Adds PbFieldType.PS String with no default value.
  void pPS(int tagNumber, String name, {String? protoName}) {
    addRepeated<String>(tagNumber, name, PbFieldType.PS,
        getCheckFunction(PbFieldType.PS), null, null, null,
        protoName: protoName);
  }

  /// Adds PbFieldType.QS String with no default value.
  void aQS(int tagNumber, String name, {String? protoName}) {
    add<String>(tagNumber, name, PbFieldType.QS, null, null, null, null,
        protoName: protoName);
  }

  /// Adds Int64 field with Int64.ZERO default.
  void aInt64(int tagNumber, String name, {String? protoName}) {
    add<Int64>(tagNumber, name, PbFieldType.O6, Int64.ZERO, null, null, null,
        protoName: protoName);
  }

  /// Adds a boolean with no default value.
  void aOB(int tagNumber, String name, {String? protoName}) {
    add<bool>(tagNumber, name, PbFieldType.OB, null, null, null, null,
        protoName: protoName);
  }

  // Enum.
  void e<T>(int tagNumber, String name, int fieldType,
      {dynamic defaultOrMaker,
      ValueOfFunc? valueOf,
      List<ProtobufEnum>? enumValues,
      String? protoName}) {
    add<T>(
        tagNumber, name, fieldType, defaultOrMaker, null, valueOf, enumValues,
        protoName: protoName);
  }

  // Repeated, not a message, group, or enum.
  void p<T>(int tagNumber, String name, int fieldType, {String? protoName}) {
    assert(!_isGroupOrMessage(fieldType) && !_isEnum(fieldType));
    addRepeated<T>(tagNumber, name, fieldType, getCheckFunction(fieldType),
        null, null, null,
        protoName: protoName);
  }

  // Repeated message, group, or enum.
  void pc<T>(int tagNumber, String name, int fieldType,
      {CreateBuilderFunc? subBuilder,
      ValueOfFunc? valueOf,
      List<ProtobufEnum>? enumValues,
      ProtobufEnum? defaultEnumValue,
      String? protoName}) {
    assert(_isGroupOrMessage(fieldType) || _isEnum(fieldType));
    addRepeated<T>(tagNumber, name, fieldType, _checkNotNull, subBuilder,
        valueOf, enumValues,
        defaultEnumValue: defaultEnumValue, protoName: protoName);
  }

  void aOM<T extends GeneratedMessage>(int tagNumber, String name,
      {T Function()? subBuilder, String? protoName}) {
    add<T>(
        tagNumber,
        name,
        PbFieldType.OM,
        GeneratedMessage._defaultMakerFor<T>(subBuilder),
        subBuilder,
        null,
        null,
        protoName: protoName);
  }

  void aQM<T extends GeneratedMessage>(int tagNumber, String name,
      {T Function()? subBuilder, String? protoName}) {
    add<T>(
        tagNumber,
        name,
        PbFieldType.QM,
        GeneratedMessage._defaultMakerFor<T>(subBuilder),
        subBuilder,
        null,
        null,
        protoName: protoName);
  }

  // oneof declarations.
  void oo(int oneofIndex, List<int> tags) {
    for (var tag in tags) {
      oneofs[tag] = oneofIndex;
    }
  }

  // Map field.
  void m<K, V>(int tagNumber, String name,
      {String? entryClassName,
      int? keyFieldType,
      int? valueFieldType,
      CreateBuilderFunc? valueCreator,
      ValueOfFunc? valueOf,
      List<ProtobufEnum>? enumValues,
      ProtobufEnum? defaultEnumValue,
      PackageName packageName = const PackageName(''),
      String? protoName}) {
    var mapEntryBuilderInfo = BuilderInfo(entryClassName, package: packageName)
      ..add(PbMap._keyFieldNumber, 'key', keyFieldType, null, null, null, null)
      ..add(PbMap._valueFieldNumber, 'value', valueFieldType, null,
          valueCreator, valueOf, enumValues);

    addMapField<K, V>(tagNumber, name, keyFieldType, valueFieldType,
        mapEntryBuilderInfo, valueCreator,
        defaultEnumValue: defaultEnumValue, protoName: protoName);
  }

  bool containsTagNumber(int tagNumber) => fieldInfo.containsKey(tagNumber);

  dynamic defaultValue(int tagNumber) {
    var func = makeDefault(tagNumber);
    return func == null ? null : func();
  }

  // Returns the field name for a given tag number, for debugging purposes.
  String? fieldName(int tagNumber) {
    var i = fieldInfo[tagNumber];
    return i?.name;
  }

  int? fieldType(int tagNumber) {
    var i = fieldInfo[tagNumber];
    return i?.type;
  }

  MakeDefaultFunc? makeDefault(int tagNumber) {
    var i = fieldInfo[tagNumber];
    return i?.makeDefault;
  }

  CreateBuilderFunc? subBuilder(int tagNumber) {
    var i = fieldInfo[tagNumber];
    return i?.subBuilder;
  }

  int? tagNumber(String fieldName) {
    var i = byName[fieldName];
    return i?.tagNumber;
  }

  ValueOfFunc? valueOfFunc(int tagNumber) {
    var i = fieldInfo[tagNumber];
    return i?.valueOf;
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
      int tagNumber, ExtensionRegistry? extensionRegistry) {
    var subBuilderFunc = subBuilder(tagNumber);
    if (subBuilderFunc == null && extensionRegistry != null) {
      subBuilderFunc = extensionRegistry
          .getExtension(qualifiedMessageName, tagNumber)!
          .subBuilder;
    }
    return subBuilderFunc!();
  }

  ProtobufEnum? _decodeEnum(
      int tagNumber, ExtensionRegistry? registry, int rawValue) {
    var f = valueOfFunc(tagNumber);
    if (f == null && registry != null) {
      f = registry.getExtension(qualifiedMessageName, tagNumber)!.valueOf;
    }
    return f!(rawValue);
  }
}

/// Annotation for marking accessors that belong together.
class TagNumber {
  final int tagNumber;

  /// Annotation for marking accessors that belong together.
  ///
  /// Allows tooling to associate related accessors.
  /// [tagNumber] is the protobuf tagnumber associated with the annotated
  /// accessor.
  const TagNumber(this.tagNumber);
}
