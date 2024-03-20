import 'package:test/test.dart';
import '../out/protos/nullable/google/protobuf/unittest_proto3.pb.dart';

void main() {
  group('Optional fields should be nullable for', () {
    test('int32', () {
      final obj = TestAllTypes.create()
        ..singleInt32 = 1
        ..optionalSingleInt32 = 2;
      expect(obj.singleInt32, 1);
      expect(obj.optionalSingleInt32, 2);
      expect(obj.hasOptionalSingleInt32(), true);

      final obj2 = TestAllTypes.create()..singleInt32 = 1;
      expect(obj2.singleInt32, 1);
      expect(obj2.optionalSingleInt32, null);
      // should not generate linting errors
      expect(obj2.optionalSingleInt32 ?? 1, 1);
      expect(obj2.hasOptionalSingleInt32(), false);
    });
  });
}
