// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/// An object representing a protobuf message field.
class FieldInfo<T> {
  FrozenPbList<T> _emptyList;

  /// Name of this field as the `json_name` reported by protoc.
  ///
  /// This will typically be in camel case.
  final String name;

  /// The name of this field as written in the proto-definition.
  ///
  /// This will typically consist of words separated with underscores.
  final String protoName;

  final int tagNumber;
  final int index; // index of the field's value. Null for extensions.
  final int type;

  // Constructs the default value of a field.
  // (Only used for repeated fields where check is null.)
  final MakeDefaultFunc makeDefault;

  // Creates an empty message or group when decoding a message.
  // Not used for other types.
  // see GeneratedMessage._getEmptyMessage
  final CreateBuilderFunc subBuilder;

  // List of all enum enumValues.
  // (Not used for other types.)
  final List<ProtobufEnum> enumValues;

  // Looks up the enum value given its integer code.
  // (Not used for other types.)
  // see GeneratedMessage._getValueOfFunc
  final ValueOfFunc valueOf;

  // Verifies an item being added to a repeated field
  // (Not used for non-repeated fields.)
  final CheckFunc<T> check;

  FieldInfo(this.name, this.tagNumber, this.index, this.type,
      {dynamic defaultOrMaker,
      this.subBuilder,
      this.valueOf,
      this.enumValues,
      String protoName})
      : makeDefault = findMakeDefault(type, defaultOrMaker),
        check = null,
        protoName = protoName ?? _unCamelCase(name),
        assert(type != 0),
        assert(!_isGroupOrMessage(type) ||
            subBuilder != null ||
            _isMapField(type)),
        assert(!_isEnum(type) || valueOf != null);

  // Represents a field that has been removed by a program transformation.
  FieldInfo.dummy(this.index)
      : name = '<removed field>',
        protoName = '<removed field>',
        tagNumber = 0,
        type = 0,
        makeDefault = null,
        valueOf = null,
        check = null,
        enumValues = null,
        subBuilder = null;

  FieldInfo.repeated(this.name, this.tagNumber, this.index, this.type,
      this.check, this.subBuilder,
      {this.valueOf, this.enumValues, String protoName})
      : makeDefault = (() => PbList<T>(check: check)),
        protoName = protoName ?? _unCamelCase(name) {
    assert(name != null);
    assert(tagNumber != null);
    assert(_isRepeated(type));
    assert(check != null);
    assert(!_isEnum(type) || valueOf != null);
  }

  static MakeDefaultFunc findMakeDefault(int type, dynamic defaultOrMaker) {
    if (defaultOrMaker == null) return PbFieldType._defaultForType(type);
    if (defaultOrMaker is MakeDefaultFunc) return defaultOrMaker;
    return () => defaultOrMaker;
  }

  /// Returns `true` if this represents a dummy field standing in for a field
  /// that has been removed by a program transformation.
  bool get _isDummy => tagNumber == 0;

  bool get isRequired => _isRequired(type);
  bool get isRepeated => _isRepeated(type);
  bool get isGroupOrMessage => _isGroupOrMessage(type);
  bool get isEnum => _isEnum(type);
  bool get isMapField => _isMapField(type);

  /// Returns a read-only default value for a field.
  /// (Unlike getField, doesn't create a repeated field.)
  dynamic get readonlyDefault {
    if (isRepeated) {
      return _emptyList ??= FrozenPbList._([]);
    }
    return makeDefault();
  }

  /// Returns true if the field's value is okay to transmit.
  /// That is, it doesn't contain any required fields that aren't initialized.
  bool _hasRequiredValues(value) {
    if (value == null) return !isRequired; // missing is okay if optional
    if (!_isGroupOrMessage(type)) return true; // primitive and present

    if (!isRepeated) {
      // A required message: recurse.
      GeneratedMessage message = value;
      return message._fieldSet._hasRequiredValues();
    }

    List<GeneratedMessage> list = value;
    if (list.isEmpty) return true;

    // For message types that (recursively) contain no required fields,
    // short-circuit the loop.
    if (!list[0]._fieldSet._hasRequiredFields) return true;

    // Recurse on each item in the list.
    return list.every((GeneratedMessage m) => m._fieldSet._hasRequiredValues());
  }

  /// Appends the dotted path to each required field that's missing a value.
  void _appendInvalidFields(List<String> problems, value, String prefix) {
    if (value == null) {
      if (isRequired) problems.add('$prefix$name');
    } else if (!_isGroupOrMessage(type)) {
      // primitive and present
    } else if (!isRepeated) {
      // Required message/group: recurse.
      GeneratedMessage message = value;
      message._fieldSet._appendInvalidFields(problems, '$prefix$name.');
    } else {
      final list = value as List<GeneratedMessage>;
      if (list.isEmpty) return;

      // For message types that (recursively) contain no required fields,
      // short-circuit the loop.
      if (!list[0]._fieldSet._hasRequiredFields) return;

      // Recurse on each item in the list.
      var position = 0;
      for (var message in list) {
        message._fieldSet
            ._appendInvalidFields(problems, '$prefix$name[$position].');
        position++;
      }
    }
  }

  /// Creates a repeated field to be attached to the given message.
  ///
  /// Delegates actual list creation to the message, so that it can
  /// be overridden by a mixin.
  List<T> _createRepeatedField(GeneratedMessage m) {
    assert(isRepeated);
    return m.createRepeatedField<T>(tagNumber, this);
  }

  /// Same as above, but allow a tighter typed List to be created.
  List<S> _createRepeatedFieldWithType<S extends T>(GeneratedMessage m) {
    assert(isRepeated);
    return m.createRepeatedField<S>(tagNumber, this);
  }

  /// Convenience method to thread this FieldInfo's reified type parameter to
  /// _FieldSet._ensureRepeatedField.
  List<T> _ensureRepeatedField(_FieldSet fs) {
    return fs._ensureRepeatedField<T>(this);
  }

  @override
  String toString() => name;
}

final RegExp _upperCase = RegExp('[A-Z]');

String _unCamelCase(String name) {
  return name.replaceAllMapped(
      _upperCase, (match) => '_${match.group(0).toLowerCase()}');
}

class MapFieldInfo<K, V> extends FieldInfo<PbMap<K, V>> {
  final int keyFieldType;
  final int valueFieldType;

  /// Creates a new empty instance of the value type.
  ///
  /// `null` if the value type is not a Message type.
  final CreateBuilderFunc valueCreator;

  final BuilderInfo mapEntryBuilderInfo;

  MapFieldInfo(
      String name,
      int tagNumber,
      int index,
      int type,
      this.keyFieldType,
      this.valueFieldType,
      this.mapEntryBuilderInfo,
      this.valueCreator,
      {String protoName})
      : super(name, tagNumber, index, type,
            defaultOrMaker: () =>
                PbMap<K, V>(keyFieldType, valueFieldType, mapEntryBuilderInfo),
            protoName: protoName) {
    assert(name != null);
    assert(tagNumber != null);
    assert(_isMapField(type));
    assert(!_isEnum(type) || valueOf != null);
  }

  FieldInfo get valueFieldInfo =>
      mapEntryBuilderInfo.fieldInfo[PbMap._valueFieldNumber];

  Map<K, V> _ensureMapField(_FieldSet fs) {
    return fs._ensureMapField<K, V>(this);
  }

  Map<K, V> _createMapField(GeneratedMessage m) {
    assert(isMapField);
    return m.createMapField<K, V>(tagNumber, this);
  }
}
