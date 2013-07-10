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
  int readInt32() => _readRawVarint64().getInt32(0, Endianness.LITTLE_ENDIAN);
  ByteData readInt64() => _readRawVarint64();
  int readUint32() => _readRawVarint32();
  ByteData readUint64() => _readRawVarint64();
  int readSint32() => _decodeZigZag32(readUint32());
  ByteData readSint64() => _decodeZigZag64(readUint64());
  int readFixed32() => _readByteData(4).getUint32(0, Endianness.LITTLE_ENDIAN);
  ByteData readFixed64() => readSfixed64();
  int readSfixed32() => _readByteData(4).getInt32(0, Endianness.LITTLE_ENDIAN);
  ByteData readSfixed64() => _readByteData(8);
  bool readBool() => _readRawVarint32() != 0;
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

  static int _decodeZigZag32(int value) {
    if ((value & 0x1) == 1) value = -value;
    return value >> 1;
  }

  static ByteData _decodeZigZag64(ByteData value) {
    int lo = value.getUint32(0, Endianness.LITTLE_ENDIAN);
    int hi = value.getUint32(4, Endianness.LITTLE_ENDIAN);
    int newHi = hi >> 1;
    int newLo = (lo >> 1) | ((hi & 0x1) << 31);
    if ((lo & 0x1) == 1) {
      newHi ^= 0xffffffff;
      newLo ^= 0xffffffff;
    }
    return new ByteData(8)
        ..setUint32(0, newLo, Endianness.LITTLE_ENDIAN)
        ..setUint32(4, newHi, Endianness.LITTLE_ENDIAN);
  }

  int _readRawVarintByte() {
    _checkLimit(1);
    return _buffer[_bufferPos - 1];
  }

  int _readRawVarint32() {
    int result = 0;
    for (int i = 0; i < 5; i++) {
      int byte = _readRawVarintByte();
      result |= (byte & 0x7f) << (i * 7);
      if ((byte & 0x80) == 0) return result;
    }
    throw new InvalidProtocolBufferException.malformedVarint();
  }

  ByteData _readRawVarint64() {
    final result = new ByteData(8);

    setPart(index, value) =>
        result..setUint32(index, value, Endianness.LITTLE_ENDIAN);

    int lo = 0;

    // Read low 28 bits.
    for (int i = 0; i < 4; i++) {
      int byte = _readRawVarintByte();
      lo |= (byte & 0x7f) << (i * 7);
      if ((byte & 0x80) == 0) return setPart(0, lo);
    }

    // Read middle 7 bits: 4 low belong to low part above,
    // 3 remaining belong to hi.
    int byte = _readRawVarintByte();
    setPart(0, lo | (byte & 0xf) << 28);
    int hi = (byte >> 4) & 0x7;
    if ((byte & 0x80) == 0) return setPart(4, hi);

    // Read remaining bits of hi.
    for (int i = 0; i < 5; i++) {
      int byte = _readRawVarintByte();
      hi |= (byte & 0x7f) << ((i * 7) + 3);
      if ((byte & 0x80) == 0) return setPart(4, hi);
    }
    throw new InvalidProtocolBufferException.malformedVarint();
  }

  ByteData _readByteData(int sizeInBytes) {
    _checkLimit(sizeInBytes);
    return new ByteData.view(
        _buffer.buffer, _bufferPos - sizeInBytes, sizeInBytes);
  }
}
