import 'package:protobuf/protobuf.dart';
import 'package:test/test.dart';

import '../out/protos/message_set.pb.dart';

void main() {
  test('Simple message set field', () {
    final encoded = [
      0xda,
      0x07,
      0x0e,
      0x0b,
      0x10,
      0xc8,
      0xa6,
      0x6b,
      0x1a,
      0x06,
      0x08,
      0x7b,
      0x12,
      0x02,
      0x68,
      0x69,
      0x0c
    ];
    final registry = ExtensionRegistry()..add(TestMessage.messageSetExtension);
    final msg = TestMessage.fromBuffer(encoded, registry);
    final extensionValue = msg.info
        .getExtension(TestMessage.messageSetExtension) as ExtensionMessage;
    expect(extensionValue.a, 123);
    expect(extensionValue.b, 'hi');
  });
}
