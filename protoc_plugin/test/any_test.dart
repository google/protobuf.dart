// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/google/protobuf/any.pb.dart';
import '../out/protos/service.pb.dart';
import '../out/protos/toplevel.pb.dart' as toplevel;
import '../out/protos/using_any.pb.dart';

void main() {
  test('pack -> unpack', () {
    final any = Any.pack(SearchRequest()..query = 'hest');
    expect(any.typeUrl, 'type.googleapis.com/service.SearchRequest');
    final any1 = Any.pack(SearchRequest()..query = 'hest1',
        typeUrlPrefix: 'example.com');
    expect(any1.typeUrl, 'example.com/service.SearchRequest');
    expect(any1.canUnpackInto(SearchRequest.getDefault()), true);
    expect(any1.canUnpackInto(SearchResponse.getDefault()), false);
    final searchRequest = any.unpackInto(SearchRequest());
    expect(searchRequest.query, 'hest');
    final searchRequest1 = any1.unpackInto(SearchRequest());
    expect(searchRequest1.query, 'hest1');
    expect(() {
      any.unpackInto(SearchResponse());
    }, throwsA(const TypeMatcher<InvalidProtocolBufferException>()));
  });

  test('any inside any', () {
    final any = Any.pack(Any.pack(SearchRequest()..query = 'hest'));
    expect(any.typeUrl, 'type.googleapis.com/google.protobuf.Any');
    expect(any.canUnpackInto(Any.getDefault()), true);
    expect(any.canUnpackInto(SearchRequest.getDefault()), false);
    expect(
        any.unpackInto(Any()).canUnpackInto(SearchRequest.getDefault()), true);
    expect(any.unpackInto(Any()).unpackInto(SearchRequest()).query, 'hest');
  });

  test('toplevel', () {
    final any = Any.pack(toplevel.T()
      ..a = 127
      ..b = 'hest');
    expect(any.typeUrl, 'type.googleapis.com/toplevel.T');
    final t2 = any.unpackInto(toplevel.T());
    expect(t2.a, 127);
    expect(t2.b, 'hest');
  });

  test('nested message', () {
    final any = Any.pack(Container_Nested()..int32Value = 127);
    expect(
        any.typeUrl, 'type.googleapis.com/protobuf_unittest.Container.Nested');
    final t2 = any.unpackInto(Container_Nested());
    expect(t2.int32Value, 127);
  });

  test('using any', () {
    final any = Any.pack(SearchRequest()..query = 'hest');
    final any1 = Any.pack(SearchRequest()..query = 'hest1');
    final any2 = Any.pack(SearchRequest()..query = 'hest2');
    final testAny = TestAny()
      ..anyValue = any
      ..repeatedAnyValue.addAll(<Any>[any1, any2]);
    final testAnyFromBuffer = TestAny.fromBuffer(testAny.writeToBuffer());
    expect(
        testAnyFromBuffer.anyValue.unpackInto(SearchRequest()).query, 'hest');
    expect(
        testAnyFromBuffer.repeatedAnyValue[0].unpackInto(SearchRequest()).query,
        'hest1');
    expect(
        testAnyFromBuffer.repeatedAnyValue[1].unpackInto(SearchRequest()).query,
        'hest2');
  });
}
