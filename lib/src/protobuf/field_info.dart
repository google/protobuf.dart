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

  // Constructs the default value of a field.
  // TODO(skybrian): stop using this for repeated fields.
  final MakeDefaultFunc makeDefault;

  // Creates an empty message or group when decoding a message.
  // Not used for other types.
  // see GeneratedMessage._getEmptyMessage
  final CreateBuilderFunc subBuilder;

  // Looks up the enum value given its integer code.
  // (Not used for other types.)
  // see GeneratedMessage._getValueOfFunc
  final ValueOfFunc valueOf;

  // Verifies an item being added to a repeated field
  // (Not used for non-repeated fields.)
  final CheckFunc check;

  FieldInfo(this.name, this.tagNumber, int type,
            [dynamic defaultOrMaker,
            this.subBuilder,
            this.valueOf])
      : this.type = type,
        this.makeDefault = findMakeDefault(type, defaultOrMaker),
        this.check = null {
    assert(!_isGroupOrMessage(type) || subBuilder != null);
    assert(!_isEnum(type) || valueOf != null);
  }

  FieldInfo.repeated(this.name, this.tagNumber, int type,
                     CheckFunc check, this.subBuilder,
                     [this.valueOf])
    : this.type = type, this.check = check,
      this.makeDefault = (() => new PbList(check: check)) {
    assert(name != null);
    assert(tagNumber != null);
    assert(_isRepeated(type));
    assert(check != null);
    assert(!_isEnum(type) || valueOf != null);
  }

  static MakeDefaultFunc findMakeDefault(int type, dynamic defaultOrMaker) {
    if (defaultOrMaker == null) return FieldType._defaultForType(type);
    if (defaultOrMaker is MakeDefaultFunc) return defaultOrMaker;
    return () => defaultOrMaker;
  }

  String toString() => name;
}
