// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

@TestOn('vm')
library;

import 'dart:isolate' show Isolate;

import 'package:analyzer/dart/analysis/analysis_context_collection.dart';
import 'package:analyzer/dart/analysis/results.dart';
import 'package:analyzer/dart/analysis/session.dart';
import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';
import 'package:path/path.dart' as p;
import 'package:protobuf/meta.dart'
    show GeneratedMessage_reservedNames, ProtobufEnum_reservedNames;
import 'package:protoc_plugin/mixins.dart' show findMixin;
import 'package:test/test.dart';

void main() {
  late final AnalysisSession session;

  setUpAll(() {
    final packageEntryUri =
        Isolate.resolvePackageUriSync(
          Uri.parse('package:protoc_plugin/mixins.dart'),
        )!;
    final packageRoot = p.dirname(p.dirname(packageEntryUri.toFilePath()));
    final collection = AnalysisContextCollection(includedPaths: [packageRoot]);
    addTearDown(collection.dispose);
    session = collection.contextFor(packageRoot).currentSession;
  });

  test('GeneratedMessage reserved names are up to date', () async {
    final actual = Set<String>.from(GeneratedMessage_reservedNames);
    final expected = await _findMemberNames(
      session,
      'package:protobuf/src/protobuf/internal.dart',
      'GeneratedMessage',
    );

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });

  test('ProtobufEnum reserved names are up to date', () async {
    final actual = Set<String>.from(ProtobufEnum_reservedNames);
    final expected = await _findMemberNames(
      session,
      'package:protobuf/src/protobuf/internal.dart',
      'ProtobufEnum',
    );

    expect(actual.toList()..sort(), equals(expected.toList()..sort()));
  });

  test('PbMapMixin reserved names are up to date', () async {
    final meta = findMixin('PbMapMixin')!;
    final actual = Set<String>.from(meta.findReservedNames());

    final expected = await _findMemberNames(
      session,
      meta.importFrom,
      'PbMapMixin',
    );
    expected
      ..addAll(await _findMemberNames(session, 'dart:collection', 'MapMixin'))
      ..removeAll(GeneratedMessage_reservedNames);

    // `MapMixin.retype` was removed in Dart 2, but remains reserved in
    // `PbMapMixin` for backwards compatibility (#636).
    expect(
      actual.difference({'retype'}).toList()..sort(),
      equals(expected.toList()..sort()),
    );
  });

  test('throws StateError when target declaration is missing', () async {
    await expectLater(
      _findMemberNames(
        session,
        'package:protobuf/src/protobuf/internal.dart',
        'ReadonlyMessageMixin',
      ),
      throwsA(isA<StateError>()),
    );
  });
}

/// Returns the names of public constructors, explicit accessors, and
/// non-static methods of [typeName] in [libraryUri] and its superclasses.
Future<Set<String>> _findMemberNames(
  AnalysisSession session,
  String libraryUri,
  String typeName,
) async {
  final libraryResult = await session.getLibraryByUri(libraryUri);
  if (libraryResult is! LibraryElementResult) {
    throw StateError('Failed to resolve library $libraryUri: $libraryResult');
  }

  final library = libraryResult.element;
  final aliasedType = library.getTypeAlias(typeName)?.aliasedType;
  final target =
      library.getClass(typeName) ??
      library.getMixin(typeName) ??
      (aliasedType is InterfaceType ? aliasedType.element : null);
  if (target == null) {
    throw StateError(
      'No class, mixin, or interface typedef "$typeName" found in $libraryUri.',
    );
  }

  final result = <String>{};
  for (
    InterfaceElement? current = target;
    current != null;
    current = current.supertype?.element
  ) {
    result.addAll(
      _declaredMemberNames(
        current,
        aliasName: identical(current, target) ? typeName : null,
      ),
    );
  }
  return result;
}

Iterable<String> _declaredMemberNames(
  InterfaceElement element, {
  String? aliasName,
}) sync* {
  final interfaceName = aliasName ?? element.name;
  if (element is MixinElement && !element.isPrivate && interfaceName != null) {
    yield interfaceName;
  }

  for (final constructor in element.constructors) {
    if (constructor.isPrivate) continue;
    final name = constructor.name == 'new' ? interfaceName : constructor.name;
    if (name != null) yield name;
  }

  for (final executable in [
    ...element.methods,
    ...element.getters,
    ...element.setters,
  ]) {
    if (executable.isPrivate || executable.isStatic) continue;
    final name = switch (executable) {
      MethodElement(isOriginDeclaration: true, :final name) ||
      PropertyAccessorElement(isOriginDeclaration: true, :final name) => name,
      _ => null,
    };
    if (name != null) yield name;
  }
}
