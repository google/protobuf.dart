import '../out/protos/foo.pb.dart';
import 'package:test/test.dart';

main() {
  group('frozen and tobuilder', () {
    Outer original = Outer()
      ..inner = (Inner()..value = 'foo')
      ..inners.add(Inner()..value = 'repeatedInner')
      ..setExtension(FooExt.inner, Inner()..value = 'extension')
      ..getExtension(FooExt.inners).add(Inner()..value = 'repeatedExtension')
      ..freeze();
    test('can read extensions', () {
      expect(original.getExtension(FooExt.inner).value, 'extension');
      expect(
          original.getExtension(FooExt.inners)[0].value, 'repeatedExtension');
    }, skip: 'https://github.com/dart-lang/protobuf/issues/171');

    test('frozen message cannot be modified', () {
      expect(() => original.inner = (Inner()..value = 'bar'),
          throwsA(TypeMatcher<UnsupportedError>()));
      expect(() => original.inner..value = 'bar',
          throwsA(TypeMatcher<UnsupportedError>()));
    });

    test('extensions cannot be modified', () {
      expect(() => original.setExtension(FooExt.inner, Inner()..value = 'bar'),
          throwsA(TypeMatcher<UnsupportedError>()));
      expect(
          () =>
              original.getExtension(FooExt.inners).add(Inner()..value = 'bar'),
          throwsA(TypeMatcher<UnsupportedError>()));
    });

    Outer builder = original.toBuilder();
    test('builder is a shallow copy', () {
      expect(builder.inner, same(original.inner));
    });
    test('builder extensions are also copied shallowly', () {
      expect(builder.getExtension(FooExt.inner),
          same(original.getExtension(FooExt.inner)));
    }, skip: 'https://github.com/dart-lang/protobuf/issues/171');

    test('repeated fields are cloned', () {
      expect(builder.inners, isNot(same(original.inners)));
      expect(builder.inners[0], same(original.inners[0]));
    });

    test('repeated extensions are cloned', () {
      expect(builder.getExtension(FooExt.inners),
          isNot(same(original.getExtension(FooExt.inners))));
      expect(builder.getExtension(FooExt.inners)[0],
          same(original.getExtension(FooExt.inners)[0]));
    }, skip: 'https://github.com/dart-lang/protobuf/issues/171');

    test(
        'the builder is only a shallow copy, the nested message is still frozen.',
        () {
      expect(() => builder.inner.value = 'bar',
          throwsA(TypeMatcher<UnsupportedError>()));
    });
    test('the builder is mutable', () {
      builder.inner = (Inner()..value = 'zop');
      expect(builder.inner.value, 'zop');
      builder.inners.add(Inner()..value = 'bob');
      expect(builder.inners.length, 2);
      builder.setExtension(FooExt.inner, Inner()..value = 'nob');
      expect(builder.getExtension(FooExt.inner).value, 'nob');
      builder.getExtension(FooExt.inners).add(Inner()..value = 'rob');
      expect(builder.getExtension(FooExt.inners).length, 2);
    });
    test('newly created `Inner` is mutable', () {
      builder.inner.value = 'bar';
      expect(builder.inner.value, 'bar');
    });
  });

  group('map properties behave correctly', () {
    OuterWithMap original;
    OuterWithMap outerBuilder;
    setUp(() {
      original = OuterWithMap()
        ..innerMap[1] = (Inner()..value = 'mapInner')
        ..freeze();
      outerBuilder = original.toBuilder();
    });
    test('map fields are cloned', () {
      expect(outerBuilder.innerMap, isNot(same(original.innerMap)));
      expect(outerBuilder.innerMap[1], same(original.innerMap[1]));
    });
    test('the builder is mutable', () {
      outerBuilder.innerMap[1] = (Inner()..value = 'mob');
      expect(outerBuilder.innerMap[1].value, 'mop');
    });
  }, skip: 'https://github.com/dart-lang/protobuf/issues/165');
}
