// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// ignore_for_file: non_constant_identifier_names

part of '../../protobuf.dart';

/// A base class for all proto enum types.
///
/// All proto `enum` classes inherit from [ProtobufEnum]. For example, given
/// the following enum defined in a proto file:
///
///     message MyMessage {
///       enum Color {
///         RED = 0;
///         GREEN = 1;
///         BLUE = 2;
///       };
///       // ...
///     }
///
/// the generated Dart file will include a `MyMessage_Color` class that extends
/// `ProtobufEnum`. It will also include a `const MyMessage_Color` for each of
/// the three values defined. Here are some examples:
///
/// ```
/// MyMessage_Color.RED  // => a MyMessage_Color instance
/// MyMessage_Color.GREEN.value  // => 1
/// MyMessage_Color.GREEN.name   // => "GREEN"
/// ```
class ProtobufEnum {
  /// This enum's integer value, as specified in the .proto file.
  final int value;

  /// This enum's name, as specified in the .proto file.
  final String name;

  /// Creates a new constant [ProtobufEnum] using [value] and [name].
  const ProtobufEnum(this.value, this.name);

  /// This function is for generated code.
  ///
  /// Creates a Map for all of the [ProtobufEnum]s in [enumValues], mapping each
  /// [ProtobufEnum]'s [value] to the [ProtobufEnum].
  ///
  /// @nodoc
  static Map<int, T> initByValue<T extends ProtobufEnum>(List<T> enumValues) {
    final byValue = <int, T>{};
    for (final v in enumValues) {
      byValue[v.value] = v;
    }
    return byValue;
  }

  /// This function is for generated code.
  ///
  /// @nodoc
  static List<T?> $_initByValueList<T extends ProtobufEnum>(List<T> enumValues) {
    if (enumValues.isEmpty) return [];

    var maxValue = enumValues[0].value;
    for (var i = 0; i < enumValues.length; i += 1) {
      final value = enumValues[i].value;
      if (value > maxValue) {
        maxValue = value;
      }
    }

    final byValue = List<T?>.filled(maxValue + 1, null);
    for (final enumValue in enumValues) {
      byValue[enumValue.value] = enumValue;
    }
    return byValue;
  }

  /// Returns this enum's [name] or the [value] if names are not represented.
  @override
  String toString() => name == '' ? value.toString() : name;
}
