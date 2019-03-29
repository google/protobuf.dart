import 'package:test/test.dart';

import '../out/protos/mixins.pb.dart' as pb;
import 'package:protoc_plugin/testing/mixins.dart';

void main() {
  group('Proto with Mixin1', () {
    pb.Mixin1PB proto;

    setUp(() {
      proto = pb.Mixin1PB();
    });

    test('is a Mixin1', () {
      expect(proto is Mixin1, isTrue);
      expect(proto is Mixin2, isFalse);
    });

    test('implements interface defined by mixins', () {
      proto.interfaceString = 'test';
      expect(proto.hasInterfaceString(), isTrue);
      expect(proto.interfaceString, equals('test'));
    });
  });

  group('Proto with Mixin2', () {
    pb.Mixin2PB proto;

    setUp(() {
      proto = pb.Mixin2PB();
    });

    test('overrides has method', () {
      expect(proto.hasOverriddenHasMethod(), isFalse);
      proto.overriddenHasMethod = 'test';

      expect(proto.hasOverriddenHasMethod(), isTrue);
    });
  });

  group('Proto without mixins', () {
    pb.NoMixinPB proto;

    setUp(() {
      proto = pb.NoMixinPB();
    });

    test('is neither Mixin1 nor Mixin2', () {
      expect(proto is Mixin1, isFalse);
      expect(proto is Mixin2, isFalse);
    });
  });

  group('Proto with Mixin3', () {
    pb.Mixin3PB proto;

    setUp(() {
      proto = pb.Mixin3PB();
    });

    test('is both Mixin1 (from parent) and Mixin3', () {
      expect(proto is Mixin1, isTrue);
      expect(proto is Mixin2, isFalse);
      expect(proto is Mixin3, isTrue);
    });
  });
}
