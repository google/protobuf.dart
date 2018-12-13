import '../out/protos/foo.pb.dart';
import 'package:test/test.dart';

main() {
  test('frozen behavior', () {
    Outer outer = Outer()
      ..inner = (Inner()..value = 'foo')
      ..freeze();
    expect(() => outer.inner = (Inner()..value = 'bar'),
        throwsA(TypeMatcher<UnsupportedError>()));
    expect(() => outer.inner..value = 'bar',
        throwsA(TypeMatcher<UnsupportedError>()));
    Outer outerBuilder = outer.toBuilder();
    // The builder is a shallow copy.
    expect(outerBuilder.inner, same(outer.inner));
    // The builder is only a shallow copy, the nested message is still frozen.
    expect(() => outerBuilder.inner.value = 'bar',
        throwsA(TypeMatcher<UnsupportedError>()));
    // The builder is mutable.
    outerBuilder.inner = (Inner()..value = 'zop');
    // The newly created `Inner` is mutable.
    outerBuilder.inner.value = 'bar';
  });
}
