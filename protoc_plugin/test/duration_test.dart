// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:fixnum/fixnum.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/duration.pb.dart' as pb;

void main() {
  test('core duration -> proto duration', () {
    final coreDuration = Duration(
      days: 1,
      hours: 2,
      minutes: 3,
      seconds: 4,
      milliseconds: 5,
      microseconds: 6,
    );

    final protoDuration = pb.Duration.fromDart(coreDuration);

    expect(protoDuration.seconds, Int64(86400 + 3600 * 2 + 60 * 3 + 4));
    expect(protoDuration.nanos, 5006000);
  });

  test('core duration -> proto duration -> core duration', () {
    final coreDuration = Duration(
      days: 1,
      hours: 2,
      minutes: 3,
      seconds: 4,
      milliseconds: 5,
      microseconds: 6,
    );

    expect(pb.Duration.fromDart(coreDuration).toDart(), coreDuration);
  });

  test('proto duration -> core duration -> proto duration', () {
    final protoDuration = pb.Duration()
      ..seconds = Int64(987654321)
      ..nanos = 999999000;

    expect(pb.Duration.fromDart(protoDuration.toDart()), protoDuration);
  });
}
