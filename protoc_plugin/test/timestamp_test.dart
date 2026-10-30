// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/well_known_types/google/protobuf/timestamp.pb.dart';
import 'package:test/test.dart';

void main() {
  test('timestamp -> datetime -> timestamp', () {
    final timestamp =
        Timestamp()
          ..seconds = Int64(1550225928)
          ..nanos = 12345000;
    expect(Timestamp.fromDateTime(timestamp.toDateTime()), timestamp);
  });

  test('utc datetime -> timestamp -> datetime', () {
    final dateTime = DateTime.utc(2019, 02, 15, 10, 21, 25, 5, 5);
    final fromProto = Timestamp.fromDateTime(dateTime).toDateTime();

    expect(fromProto.isUtc, true, reason: '$fromProto is not a UTC time.');
    expect(fromProto, dateTime);
  });

  test('negative Timestamp', () {
    final secondBeforeEpoch =
        Timestamp()
          ..seconds = Int64(-1)
          ..nanos = 1000000;
    final dateTime = DateTime.fromMillisecondsSinceEpoch(-999, isUtc: true);

    expect(
      secondBeforeEpoch.toDateTime().millisecondsSinceEpoch,
      dateTime.millisecondsSinceEpoch,
    );
    expect(secondBeforeEpoch.toDateTime(), dateTime);
    expect(Timestamp.fromDateTime(dateTime).nanos, 1000000);
    expect(Timestamp.fromDateTime(dateTime).seconds, Int64(-1));

  });

  test('local datetime -> timestamp -> datetime', () {
    final dateTime = DateTime(2019, 02, 15, 10, 21, 25, 5, 5);
    final fromProto = Timestamp.fromDateTime(dateTime).toDateTime();

    expect(fromProto.isUtc, true, reason: '$fromProto is not a UTC time.');
    expect(fromProto, dateTime.toUtc());

    // Maximum valid DateTime is 100_000_000 days from epoch.
    // This is one microsecond before.
    final maximumDateTime = DateTime.utc(1970, 1, 1 + 100_000_000);
    expect(
      Timestamp.fromDateTime(maximumDateTime).toDateTime(),
      maximumDateTime,
    );

    final almostMaximumDateTime = maximumDateTime.subtract(
      const Duration(microseconds: 1),
    );
    expect(
      Timestamp.fromDateTime(almostMaximumDateTime).toDateTime(),
      almostMaximumDateTime,
    );

    final minimumDateTime = DateTime.utc(1970, 1, 1 - 100_000_000);
    expect(
      Timestamp.fromDateTime(minimumDateTime).toDateTime(),
      minimumDateTime,
    );

    final almostMinimumDateTime = minimumDateTime.add(
      const Duration(microseconds: 1),
    );
    expect(
      Timestamp.fromDateTime(almostMinimumDateTime).toDateTime(),
      almostMinimumDateTime,
    );

  });
}
