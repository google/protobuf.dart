// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

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

  static List<T?> initByValueList<T extends ProtobufEnum>(List<T> byIndex) {
    if (byIndex.isEmpty) return [];
    final byValue = List<T?>.filled(byIndex.last.value + 1, null);
    for (final enumValue in byIndex) {
      byValue[enumValue.value] = enumValue;
    }
    return byValue;
  }

  static Map<int, T> initByValueMap<T extends ProtobufEnum>(List<T> byIndex) {
    final byValue = <int, T>{};
    for (final v in byIndex) {
      byValue[v.value] = v;
    }
    return byValue;
  }

  static List<T> initSparseList<T extends ProtobufEnum>(List<T> byIndex) =>
    byIndex.toList()..sort((e1, e2) => e1.value.compareTo(e2.value));

  static T? binarySearch<T extends ProtobufEnum>(
      List<T> sortedList, int value) {
    var min = 0;
    var max = sortedList.length;
    while (min < max) {
      final mid = min + ((max - min) >> 1);
      final element = sortedList[mid];
      final comp = element.value.compareTo(value);
      if (comp == 0) return element;
      if (comp < 0) {
        min = mid + 1;
      } else {
        max = mid;
      }
    }
    return null;
  }

  /// Returns this enum's [name] or the [value] if names are not represented.
  @override
  String toString() => name == '' ? value.toString() : name;
}
