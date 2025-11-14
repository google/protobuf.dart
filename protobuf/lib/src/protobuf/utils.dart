// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

// @dart=3.10

import 'package:fixnum/fixnum.dart' show Int64;

import 'internal.dart';
import 'json_parsing_context.dart';

// TODO(antonm): reconsider later if PbList should take care of equality.
bool deepEquals(Object? lhs, Object? rhs) {
  // Some GeneratedMessages implement Map, so test this first.
  if (lhs is GeneratedMessage) return lhs == rhs;
  if (rhs is GeneratedMessage) return false;
  if ((lhs is List) && (rhs is List)) return areListsEqual(lhs, rhs);
  if ((lhs is Map) && (rhs is Map)) return areMapsEqual(lhs, rhs);
  return lhs == rhs;
}

bool areListsEqual(List<Object?> lhs, List<Object?> rhs) {
  if (lhs.length != rhs.length) return false;
  for (var i = 0; i < lhs.length; i++) {
    if (!deepEquals(lhs[i], rhs[i])) return false;
  }
  return true;
}

bool areMapsEqual(Map<Object?, Object?> lhs, Map<Object?, Object?> rhs) {
  if (lhs.length != rhs.length) return false;
  return lhs.keys.every((key) => deepEquals(lhs[key], rhs[key]));
}

List<T> sorted<T>(Iterable<T> list) => List.from(list)..sort();

/// Escapes slash, double quotes, and newlines in [s] with \ as needed
/// for a TextFormat string.
///
/// This is a copy of the official Java implementation: https://github.com/protocolbuffers/protobuf/blob/main/java/core/src/main/java/com/google/protobuf/TextFormat.java#L632
String escapeString(String s) {
  return s
      .replaceAll('\\', '\\\\')
      .replaceAll('"', '\\"')
      .replaceAll('\n', '\\n');
}

/// Appends the characters of [bytes] to [out] while escaping them as needed
/// for a TextFormat string.
///
/// See TextFormat spec in https://protobuf.dev/reference/protobuf/textformat-spec/
/// This is a copy of the official Java implementation: https://github.com/protocolbuffers/protobuf/blob/main/java/core/src/main/java/com/google/protobuf/TextFormatEscaper.java#L40
void escapeBytes(List<int> bytes, StringSink out) {
  for (final byte in bytes) {
    // Only ASCII characters between 0x20 (space) and 0x7e (tilde) are
    // printable.  Other byte values must be escaped.
    switch (byte) {
      case 0x07:
        out.write(r'\a');
      case 0x08:
        out.write(r'\b');
      case 0x0c:
        out.write(r'\f');
      case 0x0a:
        out.write(r'\n');
      case 0x0d:
        out.write(r'\r');
      case 0x09:
        out.write(r'\t');
      case 0x0b:
        out.write(r'\v');
      default:
        if (byte >= 0x20 && byte < 0x7f) {
          if (byte == 0x22 /* " */ || byte == 0x5c /* \ */ ) {
            out.write(r'\');
          }
          out.writeCharCode(byte);
        } else {
          out.write(r'\');
          out.write(((byte >> 6) & 3).toString());
          out.write(((byte >> 3) & 7).toString());
          out.write((byte & 7).toString());
        }
    }
  }
}

class HashUtils {
  // Jenkins hash functions copied from
  // https://github.com/google/quiver-dart/blob/master/lib/src/core/hash.dart.

  static int combine(int hash, int value) {
    hash = 0x1fffffff & (hash + value);
    hash = 0x1fffffff & (hash + ((0x0007ffff & hash) << 10));
    return hash ^ (hash >> 6);
  }

  static int _finish(int hash) {
    hash = 0x1fffffff & (hash + ((0x03ffffff & hash) << 3));
    hash = hash ^ (hash >> 11);
    return 0x1fffffff & (hash + ((0x00003fff & hash) << 15));
  }

  /// Generates a hash code for multiple [objects].
  static int hashObjects(Iterable objects) =>
      _finish(objects.fold(0, (h, i) => combine(h, i.hashCode)));

  /// Generates a hash code for two objects.
  static int hash2(dynamic a, dynamic b) =>
      _finish(combine(combine(0, a.hashCode), b.hashCode));
}

class Proto3ParseUtils {
  static int tryParse32Bit(String s, JsonParsingContext context) {
    return int.tryParse(s) ??
        (throw context.parseException('expected integer', s));
  }

  static int check32BitSigned(int n, JsonParsingContext context) {
    if (n < -2147483648 || n > 2147483647) {
      throw context.parseException('expected 32 bit signed integer', n);
    }
    return n;
  }

  static int check32BitUnsigned(int n, JsonParsingContext context) {
    if (n < 0 || n > 0xFFFFFFFF) {
      throw context.parseException('expected 32 bit unsigned integer', n);
    }
    return n;
  }

  static Int64 tryParse64Bit(
    Object? json,
    String s,
    JsonParsingContext context,
  ) {
    try {
      return Int64.parseInt(s);
    } on FormatException {
      throw context.parseException('expected integer', json);
    }
  }
}
