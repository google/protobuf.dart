// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

/**
 * An object representing a protobuf message field.
 */
class FieldInfo {
  final String name;
  final int tagNumber;
  final int type;
  final MakeDefaultFunc makeDefault;
  final CreateBuilderFunc subBuilder;
  final ValueOfFunc valueOf;

  FieldInfo(this.name, this.tagNumber, int type,
            [dynamic defaultOrMaker,
            this.subBuilder,
            this.valueOf])
      : this.type = type,
        this.makeDefault = findMakeDefault(type, defaultOrMaker);

  static MakeDefaultFunc findMakeDefault(int type, dynamic defaultOrMaker) {
    if (defaultOrMaker == null) return GeneratedMessage._defaultForType(type);
    if (defaultOrMaker is MakeDefaultFunc) return defaultOrMaker;
    return () => defaultOrMaker;
  }

  String toString() => name;
}
