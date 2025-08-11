// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:protoc_plugin/src/gen/google/api/http.pb.dart';
import 'package:protoc_plugin/src/grpc_annotations.dart';
import 'package:test/test.dart';

void main() {
  group('PathVariable', () {
    test('parse', () {
      final result = PathVariable.parse(
        'name=projects/*/databases/*/documents/*/**',
      );
      expect(result.fieldPath, ['name']);
      expect(result.segments, [
        'projects',
        '*',
        'databases',
        '*',
        'documents',
        '*',
        '**',
      ]);
    });

    test('parse compound field', () {
      final result = PathVariable.parse('foo.bar=projects/*/databases');
      expect(result.fieldPath, ['foo', 'bar']);
      expect(result.segments, ['projects', '*', 'databases']);
    });

    test('shorthand', () {
      // {foo} is shorthand for {foo=*}

      final result = PathVariable.parse('foo');
      expect(result.fieldPath, ['foo']);
      expect(result.segments, ['*']);
    });
  });

  group('PathTemplate', () {
    test('simple', () {
      final actual = PathTemplate.parse(
        '/v1/{name=projects/*/databases/*/documents/*/**}',
      );

      expect(actual.segments[0], LiteralPathSegment('v1'));
      expect(
        actual.segments[1],
        PathVariablePathSegment(
          PathVariable(
            fieldPath: ['name'],
            segments: 'projects/*/databases/*/documents/*/**'.split('/'),
          ),
        ),
      );
    });

    test('two path variables', () {
      final actual = PathTemplate.parse(
        '/v1/{parent=projects/*/databases/*/documents/*/**}/{collection_id}',
      );

      expect(actual.segments[0], LiteralPathSegment('v1'));
      expect(
        actual.segments[1],
        PathVariablePathSegment(
          PathVariable(
            fieldPath: ['parent'],
            segments: 'projects/*/databases/*/documents/*/**'.split('/'),
          ),
        ),
      );
      expect(
        actual.segments[2],
        PathVariablePathSegment(
          PathVariable(fieldPath: ['collection_id'], segments: ['*']),
        ),
      );
    });

    test('multiple literals', () {
      final actual = PathTemplate.parse(
        '/foo/bar/{name=projects/*/databases}/baz',
      );

      expect(actual.segments[0], LiteralPathSegment('foo'));
      expect(actual.segments[1], LiteralPathSegment('bar'));
      expect(
        actual.segments[2],
        PathVariablePathSegment(
          PathVariable(
            fieldPath: ['name'],
            segments: 'projects/*/databases'.split('/'),
          ),
        ),
      );
      expect(actual.segments[3], LiteralPathSegment('baz'));
    });

    test('has a verb', () {
      final actual = PathTemplate.parse(
        '/v1/{database=projects/*/databases/*}/documents:batchGet',
      );

      expect(actual.verb, 'batchGet');
      expect(actual.segments[0], LiteralPathSegment('v1'));
      expect(
        actual.segments[1],
        PathVariablePathSegment(
          PathVariable(
            fieldPath: ['database'],
            segments: 'projects/*/databases/*'.split('/'),
          ),
        ),
      );
      expect(actual.segments[2], LiteralPathSegment('documents'));
    });

    test('parseRules', () {
      // option (google.api.http).post = "{parent=projects/*}/topics";

      final rule = HttpRule(post: '{parent=projects/*}/topics');
      final actual = PathTemplate.parseRules([rule]);

      expect(actual, hasLength(1));
      final template = actual[0];
      expect(
        template.segments[0],
        PathVariablePathSegment(
          PathVariable(fieldPath: ['parent'], segments: ['projects', '*']),
        ),
      );
      expect(template.segments[1], LiteralPathSegment('topics'));
    });

    test('parseRules with additionalBindings', () {
      // option (google.api.http) = {
      //   get: "/v1/{parent=projects/*/databases/*/documents/*/**}/{collection_id}"
      //   additional_bindings {
      //     get: "/v1/{parent=projects/*/databases/*/documents}/{collection_id}"
      //   }
      // };

      final rule = HttpRule(
        get: '/v1/{parent=projects/*/databases/*/documents/*/**}',
        additionalBindings: [
          HttpRule(get: '/v1/{parent=projects/*/databases/*/documents}'),
        ],
      );
      final actual = PathTemplate.parseRules([
        rule,
        ...rule.additionalBindings,
      ]);

      expect(actual, hasLength(2));

      var template = actual[0];
      expect(template.segments[0], LiteralPathSegment('v1'));
      expect(
        template.segments[1],
        PathVariablePathSegment(
          PathVariable(
            fieldPath: ['parent'],
            segments: 'projects/*/databases/*/documents/*/**'.split('/'),
          ),
        ),
      );

      template = actual[1];
      expect(template.segments[0], LiteralPathSegment('v1'));
      expect(
        template.segments[1],
        PathVariablePathSegment(
          PathVariable(
            fieldPath: ['parent'],
            segments: 'projects/*/databases/*/documents'.split('/'),
          ),
        ),
      );
    });
  });
}
