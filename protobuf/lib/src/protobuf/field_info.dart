// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'internal.dart';

/// An object representing a protobuf message field.
class FieldInfo<T> {
  /// Cached read-only empty list for this field type. For non-repeated fields
  /// this is always `null`. Otherwise it starts as `null` and gets initialized
  /// in `readonlyDefault`.
  PbList<T>? _emptyList;

  /// Name of this field as the `json_name` reported by protoc.
  ///
  /// Example:
  ///
  /// ```proto
  /// message Msg {
  ///   int32 foo_name = 1 [json_name = "barName"];
  /// }
  /// ```
  ///
  /// Here `name` of the field is `barName`. When `json_name` is not specified
  /// in the proto definition, this is the camelCase version of the field name.
  /// In the example above, without the `json_name` field option, `name` would
  /// be `"fooName"`.
  final String name;

  /// Name of this field as written in the proto definition.
  ///
  /// Example:
  ///
  /// ```proto
  /// message SearchRequest {
  ///   ...
  ///   int32 result_per_page = 3;
  /// }
  /// ```
  ///
  /// `protoName` for the `result_per_page` field above is `"result_per_page"`.
  /// The name typically consist of words separated with underscores.
  String get protoName {
    return _protoName ??= _unCamelCase(name);
  }

  String? _protoName;

  /// Field number as specified in the proto definition.
  ///
  /// Example:
  ///
  /// ```proto
  /// message SearchRequest {
  ///   ...
  ///   int32 result_per_page = 3;
  /// }
  /// ```
  ///
  /// `tagNumber` of `result_per_page` field is 3.
  final int tagNumber;

  /// Index of the field in [FieldSet._values] list of this field's message.
  ///
  /// The value is `null` for extension fields.
  final int? index;

  /// Type of this field. See [PbFieldType].
  final int type;

  /// Constructs the default value of a field.
  ///
  /// For repeated fields, only used when the [check] property is `null`.
  final MakeDefaultFunc? makeDefault;

  /// Creates an empty message or group when decoding a message.
  ///
  /// Only available in fields with message type.
  final CreateBuilderFunc? subBuilder;

  /// List of all enum values.
  ///
  /// Only available in enum fields.
  final List<ProtobufEnum>? enumValues;

  /// Default enum value.
  ///
  /// Only available in enum fields.
  final ProtobufEnum? defaultEnumValue;

  /// Mapping from enum integer values to enum values.
  ///
  /// Only available in enum fields.
  final ValueOfFunc? valueOf;

  /// Function to verify items when adding to a repeated field.
  ///
  /// Only available in repeated fields.
  final CheckFunc<T>? check;

  FieldInfo(
    this.name,
    this.tagNumber,
    this.index,
    this.type, {
    dynamic defaultOrMaker,
    this.subBuilder,
    this.valueOf,
    this.enumValues,
    this.defaultEnumValue,
    String? protoName,
  }) : makeDefault = findMakeDefault(type, defaultOrMaker),
       check = null,
       _protoName = protoName,
       assert(type != 0),
       assert(
         !PbFieldType.isGroupOrMessage(type) ||
             subBuilder != null ||
             PbFieldType.isMapField(type),
       ),
       assert(!PbFieldType.isEnum(type) || valueOf != null);

  // Represents a field that has been removed by a program transformation.
  FieldInfo.dummy(this.index)
    : name = '<removed field>',
      _protoName = '<removed field>',
      tagNumber = 0,
      type = 0,
      makeDefault = null,
      valueOf = null,
      check = null,
      enumValues = null,
      defaultEnumValue = null,
      subBuilder = null;

  FieldInfo.repeated(
    this.name,
    this.tagNumber,
    this.index,
    this.type,
    CheckFunc<T> this.check,
    this.subBuilder, {
    this.valueOf,
    this.enumValues,
    this.defaultEnumValue,
    String? protoName,
  }) : makeDefault = (() => PbList<T>(check: check)),
       _protoName = protoName,
       assert(PbFieldType.isRepeated(type)),
       assert(!PbFieldType.isEnum(type) || valueOf != null);

  static MakeDefaultFunc? findMakeDefault(int type, dynamic defaultOrMaker) {
    if (defaultOrMaker == null) return PbFieldType.defaultForType(type);
    if (defaultOrMaker is MakeDefaultFunc) return defaultOrMaker;
    return () => defaultOrMaker;
  }

  /// Whether this represents a dummy field standing in for a field that has
  /// been removed by a program transformation.
  bool get _isDummy => tagNumber == 0;

  bool get isRequired => PbFieldType.isRequired(type);
  bool get isRepeated => PbFieldType.isRepeated(type);
  bool get isGroupOrMessage => PbFieldType.isGroupOrMessage(type);
  bool get isEnum => PbFieldType.isEnum(type);
  bool get isMapField => PbFieldType.isMapField(type);

  /// Returns a read-only default value for a field. Unlike
  /// [GeneratedMessage.getField], doesn't create a repeated field.
  dynamic get readonlyDefault {
    if (isRepeated) {
      return _emptyList ??= PbList.unmodifiable();
    }
    return makeDefault!();
  }

  /// Returns true if the field's value is okay to transmit.
  /// That is, it doesn't contain any required fields that aren't initialized.
  bool _hasRequiredValues(dynamic value) {
    if (value == null) return !isRequired; // missing is okay if optional
    if (!PbFieldType.isGroupOrMessage(type)) {
      return true; // primitive and present
    }

    if (!isRepeated) {
      // A required message: recurse.
      final GeneratedMessage message = value;
      return message._fieldSet._hasRequiredValues();
    }

    final List<GeneratedMessage> list = value;
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
    } else if (!PbFieldType.isGroupOrMessage(type)) {
      // primitive and present
    } else if (!isRepeated) {
      // Required message/group: recurse.
      final GeneratedMessage message = value;
      message._fieldSet._appendInvalidFields(problems, '$prefix$name.');
    } else {
      final List<GeneratedMessage> list = value;
      if (list.isEmpty) return;

      // For message types that (recursively) contain no required fields,
      // short-circuit the loop.
      if (!list[0]._fieldSet._hasRequiredFields) return;

      // Recurse on each item in the list.
      var position = 0;
      for (final message in list) {
        message._fieldSet._appendInvalidFields(
          problems,
          '$prefix$name[$position].',
        );
        position++;
      }
    }
  }

  /// Creates a repeated field.
  PbList<T> _createRepeatedField() {
    assert(isRepeated);
    return PbList<T>(check: check!);
  }

  /// Same as above, but allow a tighter typed [PbList] to be created.
  PbList<S> _createRepeatedFieldWithType<S extends T>() {
    assert(isRepeated);
    return PbList<S>(check: check!);
  }

  /// Convenience method to thread this FieldInfo's reified type parameter to
  /// `FieldSet._ensureRepeatedField`.
  PbList<T> _ensureRepeatedField(BuilderInfo meta, FieldSet fs) {
    return fs._ensureRepeatedField<T>(meta, this);
  }

  @override
  String toString() => name;
}

extension FieldInfoInternalExtension<T> on FieldInfo<T> {
  List<T> ensureRepeatedField(BuilderInfo meta, FieldSet fs) =>
      _ensureRepeatedField(meta, fs);
}

final RegExp _upperCase = RegExp('[A-Z]');

String _unCamelCase(String name) {
  return name.replaceAllMapped(
    _upperCase,
    (match) => '_${match.group(0)!.toLowerCase()}',
  );
}

/// A [FieldInfo] subclass for protobuf `map` fields.
class MapFieldInfo<K, V> extends FieldInfo<PbMap<K, V>?> {
  /// Key type of the map. Per proto2 and proto3 specs, this needs to be an
  /// integer type or `string`, and the type cannot be `repeated`.
  ///
  /// The `int` value is interpreted the same way as [FieldInfo.type].
  final int keyFieldType;

  /// Value type of the map. Per proto2 and proto3 specs, this can be any type
  /// other than `map`, and the type cannot be `repeated`.
  ///
  /// The `int` value is interpreted the same way as [FieldInfo.type].
  final int valueFieldType;

  /// Creates a new empty instance of the value type.
  ///
  /// `null` if the value type is not a Message type.
  final CreateBuilderFunc? valueCreator;

  final BuilderInfo mapEntryBuilderInfo;

  MapFieldInfo(
    String name,
    int tagNumber,
    int index,
    int type,
    this.keyFieldType,
    this.valueFieldType,
    this.mapEntryBuilderInfo,
    this.valueCreator, {
    ProtobufEnum? defaultEnumValue,
    String? protoName,
  }) : assert(PbFieldType.isMapField(type)),
       super(
         name,
         tagNumber,
         index,
         type,
         defaultOrMaker: () => PbMap<K, V>(keyFieldType, valueFieldType),
         defaultEnumValue: defaultEnumValue,
         protoName: protoName,
       ) {
    assert(!PbFieldType.isEnum(type) || valueOf != null);
  }

  FieldInfo get valueFieldInfo =>
      mapEntryBuilderInfo.fieldInfo[PbMap._valueFieldNumber]!;

  PbMap<K, V> _ensureMapField(BuilderInfo meta, FieldSet fs) {
    return fs._ensureMapField<K, V>(meta, this);
  }

  PbMap<K, V> _createMapField() {
    assert(isMapField);
    return PbMap<K, V>(keyFieldType, valueFieldType);
  }
}

extension MapFieldInfoInternalExtension<K, V> on MapFieldInfo<K, V> {
  Map<K, V> ensureMapField(BuilderInfo meta, FieldSet fs) =>
      _ensureMapField(meta, fs);
}
