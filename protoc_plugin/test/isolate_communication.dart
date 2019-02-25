// Copyright (c) 2019, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:isolate' as isolate;
import '../out/protos/foo.pb.dart';
import 'package:test/test.dart';

runInIsolate(isolate.SendPort sendPort) {
  sendPort.send(Outer()
    ..inner = (Inner()..value = 'pip')
    ..inners.add(Inner()..value = 'pop'));
}

main() async {
  test('Messages can be sent across isolates', () async {
    isolate.ReceivePort receivePort = isolate.ReceivePort();
    isolate.Isolate.spawn(runInIsolate, receivePort.sendPort);
    Outer received = await receivePort.first;
    expect(received.inner.value, 'pip');
    expect(received.inners.single.value, 'pop');
  }, onPlatform: {
    'js': Skip(
        'Dart compiled to javascript does not allow complex objects to be sent '
        'between isolates.')
  });
}
