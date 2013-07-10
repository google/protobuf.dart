// Copyright (c) 2011, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

class CodedBufferReader {
  static const int DEFAULT_RECURSION_LIMIT = 64;
  static const int DEFAULT_SIZE_LIMIT = 64 << 20;

  final Uint8List _buffer;
  int _bufferPos = 0;
  int _currentLimit = -1;
  int _lastTag = 0;
  int _recursionDepth = 0;
  final int _recursionLimit;
  final int _sizeLimit;

  CodedBufferReader(
      List<int> buffer,
      {int recursionLimit: DEFAULT_RECURSION_LIMIT,
      int sizeLimit: DEFAULT_SIZE_LIMIT}) :
      _buffer = new Uint8List(buffer.length)..setRange(0, buffer.length, buffer),
      _recursionLimit = recursionLimit,
      _sizeLimit = min(sizeLimit, buffer.length);

  void checkLastTagWas(int value) {
    if (_lastTag != value) {
      throw new InvalidProtocolBufferException.invalidEndTag();
    }
  }

  bool isAtEnd() =>
      (_currentLimit != -1 && _bufferPos >= _currentLimit)
          || _bufferPos >= _buffer.length;

  void _withLimit(int byteLimit, callback) {
    if (byteLimit < 0) {
      throw new ArgumentError(
          'CodedBufferReader encountered an embedded string or message'
          ' which claimed to have negative size.');
    }
    byteLimit += _bufferPos;
    int oldLimit = _currentLimit;
    if ((oldLimit != -1 && byteLimit > oldLimit) || byteLimit > _sizeLimit) {
      throw new InvalidProtocolBufferException.truncatedMessage();
    }
    _currentLimit = byteLimit;
    callback();
    _currentLimit = oldLimit;
  }

  int _checkLimit(int increment) {
    _bufferPos += increment;
    if ((_currentLimit != -1 && _bufferPos > _currentLimit) ||
        _bufferPos > _sizeLimit) {
      throw new InvalidProtocolBufferException.truncatedMessage();
    }
  }

  void readGroup(int fieldNumber, GeneratedMessage message,
                 ExtensionRegistry extensionRegistry) {
    if (_recursionDepth >= _recursionLimit) {
      throw new InvalidProtocolBufferException.recursionLimitExceeded();
    }
    ++_recursionDepth;
    message.mergeFromCodedBufferReader(this);
    checkLastTagWas(makeTag(fieldNumber, WIRETYPE_END_GROUP));
    --_recursionDepth;
  }

  UnknownFieldSet readUnknownFieldSetGroup(int fieldNumber) {
    if (_recursionDepth >= _recursionLimit) {
      throw new InvalidProtocolBufferException.recursionLimitExceeded();
    }
    ++_recursionDepth;
    UnknownFieldSet unknownFieldSet = new UnknownFieldSet();
    unknownFieldSet.mergeFromCodedBufferReader(this);
    checkLastTagWas(makeTag(fieldNumber, WIRETYPE_END_GROUP));
    --_recursionDepth;
    return unknownFieldSet;
  }

  void readMessage(GeneratedMessage message,
                   ExtensionRegistry extensionRegistry) {
    int length = readInt32();
    if (_recursionDepth >= _recursionLimit) {
      throw new InvalidProtocolBufferException.recursionLimitExceeded();
    }
    _withLimit(length, () {
        ++_recursionDepth;
        message.mergeFromCodedBufferReader(this);
        checkLastTagWas(0);
        --_recursionDepth;
    });
  }

  int readEnum() => readInt32();
  int readInt32() => _unsigned32ToSigned(_readRawVarint());
  int readInt64() => _unsigned64ToSigned(_readRawVarint());
  int readUint32() => _readRawVarint();
  int readUint64() => _readRawVarint();
  int readSint32() => _decodeZigZag(readUint32());
  int readSint64() => _decodeZigZag(readUint64());
  int readFixed32() => _readByteData(4).getUint32(0, Endianness.LITTLE_ENDIAN);
  int readFixed64() => _readByteData(8).getUint64(0, Endianness.LITTLE_ENDIAN);
  int readSfixed32() => _readByteData(4).getInt32(0, Endianness.LITTLE_ENDIAN);
  int readSfixed64() => _readByteData(8).getInt64(0, Endianness.LITTLE_ENDIAN);
  bool readBool() => _readRawVarint() != 0;
  List<int> readBytes() {
    int length = readInt32();
    _checkLimit(length);
    return new Uint8List.view(_buffer.buffer, _bufferPos - length, length);
  }
  String readString() => decodeUtf8(readBytes());
  double readFloat() =>
      _readByteData(4).getFloat32(0, Endianness.LITTLE_ENDIAN);
  double readDouble() =>
      _readByteData(8).getFloat64(0, Endianness.LITTLE_ENDIAN);

  int readTag() {
    if (isAtEnd()) {
      _lastTag = 0;
      return 0;
    }

    _lastTag = readInt32();
    if (getTagFieldNumber(_lastTag) == 0) {
      throw new InvalidProtocolBufferException.invalidTag();
    }
    return _lastTag;
  }

  static int _unsigned32ToSigned(int x) =>
      (new ByteData(4)..setUint32(0, x, Endianness.LITTLE_ENDIAN))
      .getInt32(0, Endianness.LITTLE_ENDIAN);

  static int _unsigned64ToSigned(int x) =>
      (new ByteData(8)..setUint64(0, x, Endianness.LITTLE_ENDIAN))
      .getInt64(0, Endianness.LITTLE_ENDIAN);

  static int _decodeZigZag(int value) {
    return (value & 0x01) == 0 ? value ~/ 2 : -((value + 1) ~/2);
  }

  // TODO(antonm): there is a bug actually: if we expect 32bit value, there
  // should be at most 5 bytes ahead, fix it.
  int _readRawVarint() {
    const int MAX_SHIFT = 7 * 10;
    int result = 0;
    int shift = 0;
    while (true) {
      _checkLimit(1);
      int byte = _buffer[_bufferPos - 1];
      result |= (byte & 0x7f) << shift;
      shift += 7;

      if ((byte & 0x80) == 0) return result;
      if (shift == MAX_SHIFT) {
        throw new InvalidProtocolBufferException.malformedVarint();
      }
    }
  }

  ByteData _readByteData(int sizeInBytes) {
    _checkLimit(sizeInBytes);
    return new ByteData.view(
        _buffer.buffer, _bufferPos - sizeInBytes, sizeInBytes);
  }
}
