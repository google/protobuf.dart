// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

const int TAG_TYPE_BITS = 3;
const int TAG_TYPE_MASK = (1 << TAG_TYPE_BITS) - 1;

const int WIRETYPE_VARINT = 0;
const int WIRETYPE_FIXED64 = 1;
const int WIRETYPE_LENGTH_DELIMITED = 2;
const int WIRETYPE_START_GROUP = 3;
const int WIRETYPE_END_GROUP = 4;
const int WIRETYPE_FIXED32 = 5;

int getTagFieldNumber(int tag) => (tag & 0x7fffffff) >> TAG_TYPE_BITS;

int getTagWireType(int tag) => tag & TAG_TYPE_MASK;

int makeTag(int fieldNumber, int tag) => (fieldNumber << TAG_TYPE_BITS) | tag;
