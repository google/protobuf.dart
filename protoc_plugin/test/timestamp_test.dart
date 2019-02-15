// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/timestamp.pb.dart';

void main() {
  test('timestamp -> datetime -> timestamp', () {
    Timestamp timestamp = new Timestamp()
      ..seconds = new Int64(1550225928)
      ..nanos = 12345000;
    expect(Timestamp.fromDateTime(timestamp.toDateTime()), timestamp);
  });

  test('datetime -> timestamp -> datetime', () {
    DateTime dateTime = new DateTime.utc(2019, 02, 15, 10, 21, 25, 5, 5);
    DateTime fromProto = Timestamp.fromDateTime(dateTime).toDateTime();

    /// The time zone information is lost, so cannot use equality on these dates.s
    expect(fromProto.isAtSameMomentAs(dateTime), true,
        reason: "$fromProto is not at the same moment as $dateTime");
  });
}
