// Copyright (c) 2016, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf/meta.dart';
import 'package:protoc_plugin/src/dart_options.pb.dart';
import 'package:protoc_plugin/src/descriptor.pb.dart';

/// A Dart function called on each item added to a repeated list
/// to check its type and range.
const checkItem = '\$checkItem';

/// The Dart member names in a GeneratedMessage subclass for one protobuf field.
class MemberNames {
  /// The descriptor of the field these member names apply to.
  final FieldDescriptorProto descriptor;

  /// The index of this field in MessageGenerator.fieldList.
  /// The same index will be stored in FieldInfo.index.
  final int index;

  /// Identifier for generated getters/setters.
  final String fieldName;

  /// Identifier for the generated hasX() method, without braces.
  ///
  /// `null` for repeated fields.
  final String hasMethodName;

  /// Identifier for the generated clearX() method, without braces.
  ///
  /// `null` for repeated fields.
  final String clearMethodName;

  MemberNames(this.descriptor, this.index, this.fieldName, this.hasMethodName,
      this.clearMethodName);

  MemberNames.forRepeatedField(this.descriptor, this.index, this.fieldName)
      : hasMethodName = null,
        clearMethodName = null;
}

/// Chooses the Dart name of an extension.
String extensionName(FieldDescriptorProto descriptor) {
  var existingNames = new Set<String>()
    ..addAll(_dartReservedWords)
    ..addAll(GeneratedMessage_reservedNames)
    ..addAll(_generatedNames);
  return _unusedMemberNames(descriptor, null, existingNames).fieldName;
}

/// Chooses the name of the Dart class holding top-level extensions.
String extensionClassName(FileDescriptorProto descriptor) {
  var taken = new Set<String>();
  for (var messageType in descriptor.messageType) {
    taken.add(messageClassName(messageType));
  }

  String s = _fileNameWithoutExtension(descriptor).replaceAll('-', '_');
  String candidate = '${s[0].toUpperCase()}${s.substring(1)}';

  if (!taken.contains(candidate)) {
    return candidate;
  }

  // Found a conflict; try again.
  candidate = "${candidate}Ext";
  if (!taken.contains(candidate)) {
    return candidate;
  }

  // Next, try numbers.
  int suffix = 2;
  while (taken.contains("$candidate$suffix")) {
    suffix++;
  }
  return "$candidate$suffix";
}

String _fileNameWithoutExtension(FileDescriptorProto descriptor) {
  Uri path = new Uri.file(descriptor.name);
  String fileName = path.pathSegments.last;
  int dot = fileName.lastIndexOf(".");
  return dot == -1 ? fileName : fileName.substring(0, dot);
}

// Exception thrown when a field has an invalid 'dart_name' option.
class DartNameOptionException implements Exception {
  final String message;
  DartNameOptionException(this.message);
  String toString() => "$message";
}

/// Chooses the name of the Dart class to generate for a protobuf message.
///
/// For a nested message, [parent] should be provided
/// with the name of the Dart class for the immediate parent.
String messageClassName(DescriptorProto descriptor, {String parent: ''}) {
  var name = descriptor.name;
  if (parent != '') {
    name = '${parent}_${descriptor.name}';
  }
  if (name == 'Function') {
    name = 'Function_'; // Avoid reserved word.
  } else if (name.startsWith('Function_')) {
    // Avoid any further name conflicts due to 'Function' rename (unlikely).
    name = name + '_';
  }
  return name;
}

/// Chooses the GeneratedMessage member names for each field.
///
/// Additional names to avoid can be supplied using [reserved].
/// (This should only be used for mixins.)
///
/// Returns a map from the field name in the .proto file to its
/// corresponding MemberNames.
///
/// Throws [DartNameOptionException] if a field has this option and
/// it's set to an invalid name.
Map<String, MemberNames> messageFieldNames(DescriptorProto descriptor,
    {Iterable<String> reserved: const []}) {
  var sorted = new List<FieldDescriptorProto>.from(descriptor.field)
    ..sort((FieldDescriptorProto a, FieldDescriptorProto b) {
      if (a.number < b.number) return -1;
      if (a.number > b.number) return 1;
      throw "multiple fields defined for tag ${a.number} in ${descriptor.name}";
    });

  // Choose indexes first, based on their position in the sorted list.
  var indexes = <String, int>{};
  for (var field in sorted) {
    var index = indexes.length;
    indexes[field.name] = index;
  }

  var existingNames = new Set<String>()
    ..addAll(_dartReservedWords)
    ..addAll(GeneratedMessage_reservedNames)
    ..addAll(_generatedNames)
    ..addAll(reserved);

  var memberNames = <String, MemberNames>{};

  void takeNames(MemberNames chosen) {
    memberNames[chosen.descriptor.name] = chosen;

    existingNames.add(chosen.fieldName);
    if (chosen.hasMethodName != null) {
      existingNames.add(chosen.hasMethodName);
    }
    if (chosen.clearMethodName != null) {
      existingNames.add(chosen.clearMethodName);
    }
  }

  // Handle fields with a dart_name option.
  // They have higher priority than automatically chosen names.
  // Explicitly setting a name that's already taken is a build error.
  for (var field in sorted) {
    if (_nameOption(field).isNotEmpty) {
      takeNames(_memberNamesFromOption(
          descriptor, field, indexes[field.name], existingNames));
    }
  }

  // Then do other fields.
  // They are automatically renamed until we find something unused.
  for (var field in sorted) {
    if (_nameOption(field).isEmpty) {
      var index = indexes[field.name];
      takeNames(_unusedMemberNames(field, index, existingNames));
    }
  }

  // Return a map with entries in sorted order.
  var result = <String, MemberNames>{};
  for (var field in sorted) {
    result[field.name] = memberNames[field.name];
  }
  return result;
}

/// Chooses the member names for a field that has the 'dart_name' option.
///
/// If the explicitly-set Dart name is already taken, throw an exception.
/// (Fails the build.)
MemberNames _memberNamesFromOption(DescriptorProto message,
    FieldDescriptorProto field, int index, Set<String> existingNames) {
  // TODO(skybrian): provide more context in errors (filename).
  var where = "${message.name}.${field.name}";

  void checkAvailable(String name) {
    if (existingNames.contains(name)) {
      throw new DartNameOptionException(
          "$where: dart_name option is invalid: '$name' is already used");
    }
  }

  var name = _nameOption(field);
  if (name.isEmpty) {
    throw new ArgumentError("field doesn't have dart_name option");
  }
  if (!_isDartFieldName(name)) {
    throw new DartNameOptionException("$where: dart_name option is invalid: "
        "'$name' is not a valid Dart field name");
  }
  checkAvailable(name);

  if (_isRepeated(field)) {
    return new MemberNames.forRepeatedField(field, index, name);
  }

  String hasMethod = "has${_capitalize(name)}";
  checkAvailable(hasMethod);

  String clearMethod = "clear${_capitalize(name)}";
  checkAvailable(clearMethod);

  return new MemberNames(field, index, name, hasMethod, clearMethod);
}

MemberNames _unusedMemberNames(
    FieldDescriptorProto field, int index, Set<String> existingNames) {
  var suffix = '_' + field.number.toString();

  if (_isRepeated(field)) {
    var name = _defaultFieldName(field);
    while (existingNames.contains(name)) {
      name += suffix;
    }
    return new MemberNames.forRepeatedField(field, index, name);
  }

  String name = _defaultFieldName(field);
  String hasMethod = _defaultHasMethodName(field);
  String clearMethod = _defaultClearMethodName(field);

  while (existingNames.contains(name) ||
      existingNames.contains(hasMethod) ||
      existingNames.contains(clearMethod)) {
    name += suffix;
    hasMethod += suffix;
    clearMethod += suffix;
  }
  return new MemberNames(field, index, name, hasMethod, clearMethod);
}

/// The name to use by default for the Dart getter and setter.
/// (A suffix will be added if there is a conflict.)
String _defaultFieldName(FieldDescriptorProto field) {
  String name = _fieldMethodSuffix(field);
  return '${name[0].toLowerCase()}${name.substring(1)}';
}

String _defaultHasMethodName(FieldDescriptorProto field) =>
    'has${_fieldMethodSuffix(field)}';

String _defaultClearMethodName(FieldDescriptorProto field) =>
    'clear${_fieldMethodSuffix(field)}';

/// The suffix to use for this field in Dart method names.
/// (It should be camelcase and begin with an uppercase letter.)
String _fieldMethodSuffix(FieldDescriptorProto field) {
  var name = _nameOption(field);
  if (name.isNotEmpty) return _capitalize(name);

  if (field.type != FieldDescriptorProto_Type.TYPE_GROUP) {
    return _underscoresToCamelCase(field.name);
  }

  // For groups, use capitalization of 'typeName' rather than 'name'.
  name = field.typeName;
  int index = name.lastIndexOf('.');
  if (index != -1) {
    name = name.substring(index + 1);
  }
  return _underscoresToCamelCase(name);
}

String _underscoresToCamelCase(s) => s.split('_').map(_capitalize).join('');

String _capitalize(s) =>
    s.isEmpty ? s : '${s[0].toUpperCase()}${s.substring(1)}';

bool _isRepeated(FieldDescriptorProto field) =>
    field.label == FieldDescriptorProto_Label.LABEL_REPEATED;

String _nameOption(FieldDescriptorProto field) =>
    field.options.getExtension(Dart_options.dartName);

bool _isDartFieldName(name) => name.startsWith(_dartFieldNameExpr);

final _dartFieldNameExpr = new RegExp(r'^[a-z]\w+$');

// List of Dart language reserved words in names which cannot be used in a
// subclass of GeneratedMessage.
const List<String> _dartReservedWords = const [
  'assert',
  'break',
  'case',
  'catch',
  'class',
  'const',
  'continue',
  'default',
  'do',
  'else',
  'enum',
  'extends',
  'false',
  'final',
  'finally',
  'for',
  'if',
  'in',
  'is',
  'new',
  'null',
  'rethrow',
  'return',
  'super',
  'switch',
  'this',
  'throw',
  'true',
  'try',
  'var',
  'void',
  'while',
  'with'
];

// List of names used in the generated class itself.
const List<String> _generatedNames = const [
  'create',
  'createRepeated',
  'getDefault',
  checkItem
];
