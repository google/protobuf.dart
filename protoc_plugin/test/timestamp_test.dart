// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/timestamp.pb.dart';

void main() {
  test('timestamp -> datetime -> timestamp', () {
    Timestamp timestamp = Timestamp()
      ..seconds = Int64(1550225928)
      ..nanos = 12345000;
    expect(Timestamp.fromDateTime(timestamp.toDateTime()), timestamp);
  });

  test('utc datetime -> timestamp -> datetime', () {
    DateTime dateTime = DateTime.utc(2019, 02, 15, 10, 21, 25, 5, 5);
    DateTime fromProto = Timestamp.fromDateTime(dateTime).toDateTime();

    expect(fromProto.isUtc, true, reason: "$fromProto is not a UTC time.");
    expect(fromProto, dateTime);
  });

  test('local datetime -> timestamp -> datetime', () {
    DateTime dateTime = DateTime(2019, 02, 15, 10, 21, 25, 5, 5);
    DateTime fromProto = Timestamp.fromDateTime(dateTime).toDateTime();

    expect(fromProto.isUtc, true, reason: "$fromProto is not a UTC time.");
    expect(fromProto, dateTime.toUtc());
  });
}
