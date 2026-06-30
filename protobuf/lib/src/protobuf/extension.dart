// Copyright (c) 2012, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of 'internal.dart';

/// An object representing an extension field.
class Extension<T> extends FieldInfo<T> {
  final String extendee;

  Extension(
    this.extendee,
    String name,
    int tagNumber,
    int fieldType, {
    super.defaultOrMaker,
    super.subBuilder,
    super.valueOf,
    super.enumValues,
    super.protoName,
  }) : super(name, tagNumber, null, fieldType);

  Extension.repeated(
    this.extendee,
    String name,
    int tagNumber,
    int fieldType, {
    required CheckFunc<T>? check,
    CreateBuilderFunc? subBuilder,
    super.valueOf,
    super.enumValues,
    super.protoName,
  }) : super.repeated(name, tagNumber, null, fieldType, check, subBuilder);

  @override
  int get hashCode => extendee.hashCode * 31 + tagNumber;

  @override
  bool operator ==(Object other) {
    if (other is! Extension) return false;

    final o = other;
    return extendee == o.extendee && tagNumber == o.tagNumber;
  }
}
