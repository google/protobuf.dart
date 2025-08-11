// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'package:collection/collection.dart';

import 'gen/google/api/http.pb.dart';

class PathTemplate {
  final List<PathSegment> segments;
  final String? verb;

  PathTemplate({required this.segments, this.verb});

  factory PathTemplate.parse(String path) {
    // Path template syntax:
    //
    //     Template = "/" Segments [ Verb ] ;
    //     Segments = Segment { "/" Segment } ;
    //     Segment  = "*" | "**" | LITERAL | Variable ;
    //     Variable = "{" FieldPath [ "=" Segments ] "}" ;
    //     FieldPath = IDENT { "." IDENT } ;
    //     Verb     = ":" LITERAL ;

    String? verb;

    // Look for a trailing ":<verb>".
    if (path.contains(':')) {
      final index = path.indexOf(':');
      verb = path.substring(index + 1);
      path = path.substring(0, index);
    }

    // parse into variable and literal segments
    final segments =
        _findSegments(path).map((str) {
          return str.startsWith('{')
              ? PathVariablePathSegment(
                PathVariable.parse(str.substring(1, str.length - 1)),
              )
              : LiteralPathSegment(str);
        }).toList();

    return PathTemplate(segments: segments, verb: verb);
  }

  static List<PathTemplate> parseRules(List<HttpRule> rules) {
    // get put post delete patch

    final result = <PathTemplate>[];

    for (final rule in rules) {
      String? template;

      if (rule.hasGet()) {
        template = rule.get;
      } else if (rule.hasPut()) {
        template = rule.put;
      } else if (rule.hasPost()) {
        template = rule.post;
      } else if (rule.hasDelete()) {
        template = rule.delete;
      } else if (rule.hasPatch()) {
        template = rule.patch;
      }

      if (template != null) {
        result.add(PathTemplate.parse(template));
      }
    }

    return result;
  }

  @override
  String toString() => '${segments.join('/')}${verb == null ? '' : ':$verb'}';
}

/// Either a [LiteralPathSegment] or a [PathVariablePathSegment].
abstract class PathSegment {}

final class LiteralPathSegment extends PathSegment {
  final String literal;

  LiteralPathSegment(this.literal);

  @override
  bool operator ==(Object other) {
    return other is LiteralPathSegment && other.literal == literal;
  }

  @override
  int get hashCode => literal.hashCode;

  @override
  String toString() => literal;
}

final class PathVariablePathSegment extends PathSegment {
  final PathVariable variable;

  PathVariablePathSegment(this.variable);

  @override
  bool operator ==(Object other) {
    return other is PathVariablePathSegment && other.variable == variable;
  }

  @override
  int get hashCode => variable.hashCode;

  @override
  String toString() => '{$variable}';
}

class PathVariable {
  final List<String> fieldPath;
  final List<String> segments;

  PathVariable({required this.fieldPath, required this.segments});

  factory PathVariable.parse(String str) {
    // name=projects/*/databases/*/documents/*/**
    final index = str.indexOf('=');

    if (index == -1) {
      // parse path variable shorthand
      return PathVariable(fieldPath: [str], segments: ['*']);
    } else {
      final field = str.substring(0, index);
      final segments = str.substring(index + 1);

      return PathVariable(
        fieldPath: field.split('.'),
        segments: segments.split('/'),
      );
    }
  }

  @override
  bool operator ==(Object other) {
    return other is PathVariable &&
        ListEquality().equals(other.fieldPath, fieldPath) &&
        ListEquality().equals(other.segments, segments);
  }

  @override
  int get hashCode => Object.hashAll(fieldPath) ^ Object.hashAll(segments);

  @override
  String toString() => '${fieldPath.join('.')}=${segments.join('/')}';
}

/// Return a sequence of either path variables or segments.
List<String> _findSegments(String str) {
  // /v1/{parent=projects/*/databases/*/documents/*/**}/{collection_id}
  //   =>
  // v1, {parent=projects/*/databases/*/documents/*/**}, {collection_id}

  final result = <String>[];

  while (str.isNotEmpty) {
    var index = str.indexOf('{');

    if (index == 0) {
      // extract the path variable
      final end = str.indexOf('}');
      result.add(str.substring(0, end + 1));
      str = str.substring(end + 1);
    } else if (index == -1) {
      // extract the sequence of segments
      result.addAll(str.split('/').where((segment) => segment.isNotEmpty));
      str = '';
    } else {
      // extract the sequence of segments
      final segments = str.substring(0, index);
      result.addAll(segments.split('/').where((segment) => segment.isNotEmpty));
      str = str.substring(index);
    }
  }

  return result;
}
