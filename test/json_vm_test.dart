// VM-specific smoke tests for the GeneratedMessage JSON API.
//
// These tests will be skipped on js, as the dart2js platform
// does not support 64-bit ints.
@TestOn('!js')

library json_vm_test;

import 'package:fixnum/fixnum.dart' show Int64;
import 'package:test/test.dart';

import 'mock_util.dart' show MockMessage, mockInfo;

class T extends MockMessage {
  get info_ => _info;
  static final _info = mockInfo("T", () => new T());
}

main() {
  test('testInt64JsonEncoding', () {
    final value = new Int64(1234567890123456789);
    final t = new T()..int64 = value;
    final encoded = t.writeToJsonMap();
    expect(encoded["5"], "$value");
    final decoded = new T()..mergeFromJsonMap(encoded);
    expect(decoded.int64, value);
  });
}
