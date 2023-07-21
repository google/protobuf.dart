import 'package:protoc_plugin/src/shared.dart';
import 'package:test/test.dart';

void main() {
  group('toDartComment', () {
    test('empty', () {
      expect(toDartComment(''), null);
    });

    test('indent', () {
      expect(
        toDartComment('''
 A line is nice
 
 with one indent - trailing whitespace removed
 
 
'''),
        '''
/// A line is nice
///
/// with one indent - trailing whitespace removed''',
      );
    });
  });
}
