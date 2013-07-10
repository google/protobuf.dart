// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

class ProtobufEnum {
  final int value;
  final String name;

  const ProtobufEnum(this.value, this.name);

  // Cannot type return type as Map<int, ProtobufEnum> as it will be
  // assigned to Map<int, subtype of ProtobufEnum>.
  static Map<int, dynamic> initByValue(List<ProtobufEnum> byIndex) {
    var byValue = new Map<int, dynamic>();
    for (ProtobufEnum v in byIndex) {
      byValue[v.value] = v;
    }
    return byValue;
  }

  int get hashCode => value;

  String toString() => name;
}
