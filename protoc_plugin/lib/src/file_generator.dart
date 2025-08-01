// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of '../protoc.dart';

final RegExp _dartIdentifier = RegExp(r'^\w+$');

const String _asyncImportUrl = 'dart:async';

const String _convertImportPrefix = r'$convert';
const String _convertImportUrl = 'dart:convert';

const String _coreImportUrl = 'dart:core';
const String _grpcImportUrl = 'package:grpc/service_api.dart';
const String _protobufImportUrl = 'package:protobuf/protobuf.dart';

const String _typedDataImportPrefix = r'$typed_data';
const String _typedDataImportUrl = 'dart:typed_data';

enum ProtoSyntax { proto2, proto3 }

/// Generates the Dart output files for one .proto input file.
///
/// Outputs include .pb.dart, pbenum.dart, and .pbjson.dart.
class FileGenerator extends ProtobufContainer {
  /// Reads and the declared mixins in the file, keyed by name.
  ///
  /// Performs some basic validation on declared mixins, e.g. whether names
  /// are valid dart identifiers and whether there are cycles in the `parent`
  /// hierarchy.
  /// Does not check for existence of import files or classes.
  static Map<String, PbMixin> _getDeclaredMixins(FileDescriptorProto desc) {
    String mixinError(String error) =>
        'Option "mixins" in ${desc.name}: $error';

    if (!desc.hasOptions() ||
        !desc.options.hasExtension(Dart_options.imports)) {
      return <String, PbMixin>{};
    }
    final dartMixins = <String, DartMixin>{};
    final importedMixins =
        desc.options.getExtension(Dart_options.imports) as Imports;
    for (final mixin in importedMixins.mixins) {
      if (dartMixins.containsKey(mixin.name)) {
        throw mixinError('Duplicate mixin name: "${mixin.name}"');
      }
      if (!mixin.name.startsWith(_dartIdentifier)) {
        throw mixinError(
          '"${mixin.name}" is not a valid dart class identifier',
        );
      }
      if (mixin.hasParent() && !mixin.parent.startsWith(_dartIdentifier)) {
        throw mixinError(
          'Mixin parent "${mixin.parent}" of "${mixin.name}" is '
          'not a valid dart class identifier',
        );
      }
      dartMixins[mixin.name] = mixin;
    }

    // Detect cycles and unknown parents.
    for (final mixin in dartMixins.values) {
      if (!mixin.hasParent()) continue;
      var currentMixin = mixin;
      final parentChain = <String>[];
      while (currentMixin.hasParent()) {
        final parentName = currentMixin.parent;

        final declaredMixin = dartMixins.containsKey(parentName);
        final internalMixin = !declaredMixin && findMixin(parentName) != null;

        if (internalMixin) break; // No further validation of parent chain.

        if (!declaredMixin) {
          throw mixinError(
            'Unknown mixin parent "${mixin.parent}" of '
            '"${currentMixin.name}"',
          );
        }

        if (parentChain.contains(parentName)) {
          final cycle = '${parentChain.join('->')}->$parentName';
          throw mixinError('Cycle in parent chain: $cycle');
        }
        parentChain.add(parentName);
        currentMixin = dartMixins[parentName]!;
      }
    }

    // Turn DartMixins into PbMixins.
    final pbMixins = <String, PbMixin>{};
    PbMixin? resolveMixin(String name) {
      if (pbMixins.containsKey(name)) return pbMixins[name];
      if (dartMixins.containsKey(name)) {
        final dartMixin = dartMixins[name]!;
        final pbMixin = PbMixin(
          dartMixin.name,
          importFrom: dartMixin.importFrom,
          parent: resolveMixin(dartMixin.parent),
        );
        pbMixins[name] = pbMixin;
        return pbMixin;
      }
      return findMixin(name);
    }

    for (final mixin in dartMixins.values) {
      resolveMixin(mixin.name);
    }
    return pbMixins;
  }

  final FileDescriptorProto descriptor;
  final GenerationOptions options;

  // The relative path used to import the .proto file, as a URI.
  final Uri protoFileUri;

  final enumGenerators = <EnumGenerator>[];
  final messageGenerators = <MessageGenerator>[];
  final extensionGenerators = <ExtensionGenerator>[];
  final clientApiGenerators = <ClientApiGenerator>[];
  final serviceGenerators = <ServiceGenerator>[];
  final grpcGenerators = <GrpcServiceGenerator>[];

  /// Used to avoid collisions after names have been mangled to match the Dart
  /// style.
  final Set<String> usedTopLevelNames =
      <String>{}..addAll(forbiddenTopLevelNames);

  /// Used to avoid collisions in the service file after names have been mangled
  /// to match the dart style.
  final Set<String> usedTopLevelServiceNames =
      <String>{}..addAll(forbiddenTopLevelNames);

  final Set<String> usedExtensionNames =
      <String>{}..addAll(forbiddenExtensionNames);

  /// Whether cross-references have been resolved.
  bool _linked = false;

  final ProtoSyntax syntax;

  FileGenerator(this.descriptor, this.options)
    : protoFileUri = Uri.file(descriptor.name),
      syntax =
          descriptor.syntax == 'proto3'
              ? ProtoSyntax.proto3
              : ProtoSyntax.proto2 {
    if (protoFileUri.isAbsolute) {
      // protoc should never generate an import with an absolute path.
      throw 'FAILURE: Import with absolute path is not supported';
    }

    final declaredMixins = _getDeclaredMixins(descriptor);
    final defaultMixinName =
        descriptor.options.getExtension(Dart_options.defaultMixin) as String? ??
        '';
    final defaultMixin =
        declaredMixins[defaultMixinName] ?? findMixin(defaultMixinName);
    if (defaultMixin == null && defaultMixinName.isNotEmpty) {
      throw 'Option default_mixin on file ${descriptor.name}: Unknown mixin '
          '$defaultMixinName';
    }

    // Load and register all enum and message types.
    for (var i = 0; i < descriptor.enumType.length; i++) {
      enumGenerators.add(
        EnumGenerator.topLevel(
          descriptor.enumType[i],
          this,
          usedTopLevelNames,
          i,
        ),
      );
    }
    for (var i = 0; i < descriptor.messageType.length; i++) {
      messageGenerators.add(
        MessageGenerator.topLevel(
          descriptor.messageType[i],
          this,
          declaredMixins,
          defaultMixin,
          usedTopLevelNames,
          i,
        ),
      );
    }
    for (var i = 0; i < descriptor.extension.length; i++) {
      extensionGenerators.add(
        ExtensionGenerator.topLevel(
          descriptor.extension[i],
          this,
          usedExtensionNames,
          i,
        ),
      );
    }
    for (var i = 0; i < descriptor.service.length; i++) {
      final service = descriptor.service[i];
      if (options.useGrpc) {
        grpcGenerators.add(GrpcServiceGenerator(service, this, i));
      } else {
        final serviceGen = ServiceGenerator(
          service,
          this,
          usedTopLevelServiceNames,
        );
        serviceGenerators.add(serviceGen);
        clientApiGenerators.add(
          ClientApiGenerator(serviceGen, usedTopLevelNames, i),
        );
      }
    }
  }

  /// Creates the fields in each message.
  /// Resolves field types and extension targets using the supplied context.
  void resolve(GenerationContext ctx) {
    if (_linked) throw StateError('cross references already resolved');

    for (final m in messageGenerators) {
      m.resolve(ctx);
    }
    for (final x in extensionGenerators) {
      x.resolve(ctx);
    }

    _linked = true;
  }

  @override
  String get package => descriptor.package;

  @override
  String get classname => '';

  @override
  String get fullName => descriptor.package;

  @override
  FileGenerator get fileGen => this;

  @override
  ProtobufContainer? get parent => null;

  @override
  List<int> get fieldPath => [];

  /// Generates all the Dart files for this .proto file.
  List<CodeGeneratorResponse_File> generateFiles(OutputConfiguration config) {
    if (!_linked) throw StateError('not linked');

    CodeGeneratorResponse_File makeFile(String extension, String content) {
      final protoUrl = Uri.file(descriptor.name);
      final dartUrl = config.outputPathFor(protoUrl, extension);
      return CodeGeneratorResponse_File()
        ..name = dartUrl.path
        ..content = content;
    }

    final mainWriter = generateMainFile(config);
    final enumWriter = generateEnumFile(config);

    final generateMetadata = options.generateMetadata;

    final files = [
      makeFile('.pb.dart', mainWriter.emitSource(format: !generateMetadata)),
      makeFile(
        '.pbenum.dart',
        enumWriter.emitSource(format: !generateMetadata),
      ),
      // TODO(devoncarew): Consider not emitting empty json files.
      makeFile('.pbjson.dart', generateJsonFile(config)),
    ];

    if (generateMetadata) {
      files.addAll([
        makeFile(
          '.pb.dart.meta',
          mainWriter.sourceLocationInfo.writeToJson().toString(),
        ),
        makeFile(
          '.pbenum.dart.meta',
          enumWriter.sourceLocationInfo.writeToJson().toString(),
        ),
      ]);
    }
    if (options.useGrpc) {
      if (grpcGenerators.isNotEmpty) {
        files.add(makeFile('.pbgrpc.dart', generateGrpcFile(config)));
      }
    } else {
      if (serviceGenerators.isNotEmpty) {
        files.add(makeFile('.pbserver.dart', generateServerFile(config)));
      }
    }

    return files;
  }

  /// Creates an IndentingWriter with metadata generation enabled or disabled.
  IndentingWriter makeWriter() {
    return IndentingWriter(
      fileName: descriptor.name,
      generateMetadata: options.generateMetadata,
    );
  }

  /// Returns the contents of the .pb.dart file for this .proto file.
  IndentingWriter generateMainFile([
    OutputConfiguration config = const DefaultOutputConfiguration(),
  ]) {
    if (!_linked) throw StateError('not linked');

    final out = makeWriter();
    writeMainHeader(out, config);

    // Generate code.
    for (final m in messageGenerators) {
      m.generate(out);
    }

    // Generate code for extensions defined at top-level using a class name
    // derived from the file name.
    if (extensionGenerators.isNotEmpty) {
      // TODO(antonm): do not generate a class.
      final className = extensionClassName(descriptor, usedTopLevelNames);
      out.addBlock('class $className {', '}\n', () {
        for (final x in extensionGenerators) {
          x.generate(out);
        }
        out.println(
          'static void registerAllExtensions('
          '$protobufImportPrefix.ExtensionRegistry registry) {',
        );
        for (final x in extensionGenerators) {
          out.println('  registry.add(${x.name});');
        }
        out.println('}');
      });
    }

    for (final c in clientApiGenerators) {
      c.generate(out);
    }
    return out;
  }

  /// Writes the header and imports for the .pb.dart file.
  void writeMainHeader(
    IndentingWriter out, [
    OutputConfiguration config = const DefaultOutputConfiguration(),
  ]) {
    final importWriter = ImportWriter();

    // We only add the dart:async import if there are generic client API
    // generators for services in the FileDescriptorProto.
    if (clientApiGenerators.isNotEmpty) {
      importWriter.addImport(_asyncImportUrl, prefix: asyncImportPrefix);
    }

    importWriter.addImport(_coreImportUrl, prefix: coreImportPrefix);

    if (_needsFixnumImport) {
      importWriter.addImport(
        'package:fixnum/fixnum.dart',
        prefix: fixnumImportPrefix,
      );
    }

    if (_needsProtobufImport) {
      importWriter.addImport(_protobufImportUrl, prefix: protobufImportPrefix);
    }

    for (final libraryUri in findMixinImports()) {
      importWriter.addImport(libraryUri, prefix: mixinImportPrefix);
    }

    // Import the .pb.dart files we depend on.
    final imports = Set<FileGenerator>.identity();
    final enumImports = Set<FileGenerator>.identity();
    _findProtosToImport(imports, enumImports);

    for (final target in imports) {
      _addImport(importWriter, config, target, '.pb.dart');
    }

    for (final target in enumImports) {
      // If we're already adding the main file (.pb.dart) as an import, we don't
      // need to add the enums file, as that's exported from the main file.
      if (!imports.contains(target)) {
        _addImport(importWriter, config, target, '.pbenum.dart');
      }
    }

    importWriter.addExport(
      _protobufImportUrl,
      members: ['GeneratedMessageGenericExtensions'],
    );

    for (final publicDependency in descriptor.publicDependency) {
      _addExport(
        importWriter,
        config,
        Uri.file(descriptor.dependency[publicDependency]),
        '.pb.dart',
      );
    }

    // Export enums in main file for backward compatibility.
    if (hasEnums) {
      final url = config.resolveImport(
        protoFileUri,
        protoFileUri,
        '.pbenum.dart',
      );
      importWriter.addExport(url.toString());
    }

    // The well-known-types mixins create src/ refs into package:protobuf; we
    // should likely refactor this so they're regular (non-src/) references.
    //
    // For now, we surpress the analysis warning.
    _writeHeading(
      out,
      extraIgnores: {if (importWriter.hasSrcImport) 'implementation_imports'},
    );

    out.println(importWriter.emit());
  }

  bool get _needsFixnumImport {
    for (final m in messageGenerators) {
      if (m.needsFixnumImport) return true;
    }
    for (final x in extensionGenerators) {
      if (x.needsFixnumImport) return true;
    }
    return false;
  }

  bool get _needsProtobufImport =>
      messageGenerators.isNotEmpty ||
      extensionGenerators.isNotEmpty ||
      clientApiGenerators.isNotEmpty;

  /// Returns the generator for each .pb.dart file we need to import.
  void _findProtosToImport(
    Set<FileGenerator> imports,
    Set<FileGenerator> enumImports,
  ) {
    for (final m in messageGenerators) {
      m.addImportsTo(imports, enumImports);
    }
    for (final x in extensionGenerators) {
      x.addImportsTo(imports, enumImports);
    }
    // Add imports needed for client-side services.
    for (final x in serviceGenerators) {
      x.addImportsTo(imports);
    }
    // Don't need to import self. (But we may need to import the enums.)
    imports.remove(this);
  }

  /// Returns a sorted list of imports needed to support all mixins.
  List<String> findMixinImports() {
    final mixins = <PbMixin>{};
    for (final m in messageGenerators) {
      m.addMixinsTo(mixins);
    }

    return mixins
      .map((mixin) => mixin.importFrom)
      .toSet()
      .toList(growable: false)..sort();
  }

  /// Returns the contents of the .pbenum.dart file for this .proto file.
  IndentingWriter generateEnumFile([
    OutputConfiguration config = const DefaultOutputConfiguration(),
  ]) {
    if (!_linked) throw StateError('not linked');

    final out = makeWriter();
    _writeHeading(out);

    final importWriter = ImportWriter();

    if (hasEnums) {
      // Make sure any other symbols in dart:core don't cause name conflicts
      // with enums that have the same name.
      importWriter.addImport(_coreImportUrl, prefix: coreImportPrefix);
      importWriter.addImport(_protobufImportUrl, prefix: protobufImportPrefix);
    }

    for (final publicDependency in descriptor.publicDependency) {
      _addExport(
        importWriter,
        config,
        Uri.file(descriptor.dependency[publicDependency]),
        '.pbenum.dart',
      );
    }

    if (importWriter.hasImports) {
      out.println(importWriter.emit());
    }

    for (final e in enumGenerators) {
      e.generate(out);
    }

    for (final m in messageGenerators) {
      m.generateEnums(out);
    }

    return out;
  }

  /// Returns the number of enum types generated in the .pbenum.dart file.
  int get enumCount {
    var count = enumGenerators.length;
    for (final m in messageGenerators) {
      count += m.enumCount;
    }
    return count;
  }

  /// Returns whether this proto file defines any enums (either top level or
  /// nested within messages).
  bool get hasEnums => enumCount > 0;

  /// Returns the contents of the .pbserver.dart file for this .proto file.
  String generateServerFile([
    OutputConfiguration config = const DefaultOutputConfiguration(),
  ]) {
    if (!_linked) throw StateError('not linked');

    final out = makeWriter();
    _writeHeading(
      out,
      extraIgnores: {'deprecated_member_use_from_same_package'},
    );

    final importWriter = ImportWriter();

    if (serviceGenerators.isNotEmpty) {
      importWriter.addImport(_asyncImportUrl, prefix: asyncImportPrefix);
      importWriter.addImport(_coreImportUrl, prefix: coreImportPrefix);
      importWriter.addImport(_protobufImportUrl, prefix: protobufImportPrefix);
    }

    // Import .pb.dart files needed for requests and responses.
    final imports = <FileGenerator>{};
    for (final x in serviceGenerators) {
      x.addImportsTo(imports);
    }
    for (final target in imports) {
      _addImport(importWriter, config, target, '.pb.dart');
    }

    // Import .pbjson.dart file needed for $json and $messageJson.
    if (serviceGenerators.isNotEmpty) {
      _addImport(importWriter, config, this, '.pbjson.dart');
    }

    final url = config.resolveImport(protoFileUri, protoFileUri, '.pb.dart');
    importWriter.addExport(url.toString());

    if (importWriter.hasImports) {
      out.println(importWriter.emit());
    }

    for (final s in serviceGenerators) {
      s.generate(out);
    }

    return out.emitSource(format: true);
  }

  /// Returns the contents of the .pbgrpc.dart file for this .proto file.
  String generateGrpcFile([
    OutputConfiguration config = const DefaultOutputConfiguration(),
  ]) {
    if (!_linked) throw StateError('not linked');

    final out = makeWriter();
    _writeHeading(out);

    final importWriter = ImportWriter();

    importWriter.addImport(_asyncImportUrl, prefix: asyncImportPrefix);
    importWriter.addImport(_coreImportUrl, prefix: coreImportPrefix);
    importWriter.addImport(_grpcImportUrl, prefix: grpcImportPrefix);
    importWriter.addImport(_protobufImportUrl, prefix: protobufImportPrefix);

    // Import .pb.dart files needed for requests and responses.
    final imports = <FileGenerator>{};
    for (final generator in grpcGenerators) {
      generator.addImportsTo(imports);
    }
    for (final target in imports) {
      _addImport(importWriter, config, target, '.pb.dart');
    }

    final url = config.resolveImport(protoFileUri, protoFileUri, '.pb.dart');
    importWriter.addExport(url.toString());

    out.println(importWriter.emit());

    for (final generator in grpcGenerators) {
      generator.generate(out);
    }

    return out.emitSource(format: true);
  }

  void writeBinaryDescriptor(
    IndentingWriter out,
    String identifierName,
    String name,
    GeneratedMessage descriptor,
  ) {
    final base64 = base64Encode(descriptor.writeToBuffer());
    out.println(
      '/// Descriptor for `$name`. Decode as a '
      '`${descriptor.info_.qualifiedMessageName}`.',
    );

    const indent = '    ';

    final base64Lines = _splitString(
      base64,
      74,
    ).map((s) => "'$s'").join('\n$indent');
    out.println(
      'final $_typedDataImportPrefix.Uint8List '
      '$identifierName = '
      '$_convertImportPrefix.base64Decode(\n$indent$base64Lines);',
    );
  }

  /// Return the given [str], split into separate segments, where no segment is
  /// longer than [segmentLength].
  static List<String> _splitString(String str, int segmentLength) {
    final result = <String>[];
    while (str.length >= segmentLength) {
      result.add(str.substring(0, segmentLength));
      str = str.substring(segmentLength);
    }
    if (str.isNotEmpty) result.add(str);
    return result;
  }

  /// Returns the contents of the .pbjson.dart file for this .proto file.
  String generateJsonFile([
    OutputConfiguration config = const DefaultOutputConfiguration(),
  ]) {
    if (!_linked) throw StateError('not linked');

    final out = makeWriter();
    _writeHeading(out, extraIgnores: {'unused_import'});

    final importWriter = ImportWriter();
    importWriter.addImport(_convertImportUrl, prefix: _convertImportPrefix);
    importWriter.addImport(_coreImportUrl, prefix: coreImportPrefix);
    importWriter.addImport(_typedDataImportUrl, prefix: _typedDataImportPrefix);

    // Import the .pbjson.dart files we depend on.
    final imports = _findJsonProtosToImport();
    for (final target in imports) {
      _addImport(importWriter, config, target, '.pbjson.dart');
    }

    out.println(importWriter.emit());

    for (final e in enumGenerators) {
      e.generateConstants(out);
      writeBinaryDescriptor(
        out,
        e.binaryDescriptorName,
        e._descriptor.name,
        e._descriptor,
      );
      out.println('');
    }
    for (final m in messageGenerators) {
      m.generateConstants(out);
      writeBinaryDescriptor(
        out,
        m.binaryDescriptorName,
        m._descriptor.name,
        m._descriptor,
      );
      out.println('');
    }
    for (final s in serviceGenerators) {
      s.generateConstants(out);
      writeBinaryDescriptor(
        out,
        s.binaryDescriptorName,
        s._descriptor.name,
        s._descriptor,
      );
      out.println('');
    }

    return out.emitSource(format: true);
  }

  /// Returns the generator for each .pbjson.dart file the generated
  /// .pbjson.dart needs to import.
  Set<FileGenerator> _findJsonProtosToImport() {
    final imports = Set<FileGenerator>.identity();
    for (final m in messageGenerators) {
      m.addConstantImportsTo(imports);
    }
    for (final x in extensionGenerators) {
      x.addConstantImportsTo(imports);
    }
    for (final x in serviceGenerators) {
      x.addConstantImportsTo(imports);
    }
    imports.remove(this); // Don't need to import self.
    return imports;
  }

  /// Writes the header at the top of the dart file.
  void _writeHeading(
    IndentingWriter out, {
    Set<String> extraIgnores = const <String>{},
  }) {
    final ignores = ({..._fileIgnores, ...extraIgnores}).toList()..sort();

    // Group the ignores into lines not longer than 80 chars.
    final ignorelines = <String>[];

    if (ignores.isNotEmpty) {
      ignorelines.add('// ignore_for_file: ${ignores.first}');

      for (final ignore in ignores.skip(1)) {
        if (ignorelines.last.length + ignore.length + ', '.length > 80) {
          ignorelines.add('// ignore_for_file: $ignore');
        } else {
          ignorelines.add('${ignorelines.removeLast()}, $ignore');
        }
      }
    }

    out.println('''
// This is a generated file - do not edit.
//
// Generated from ${descriptor.name}.

// @dart = 3.3
''');
    ignorelines.forEach(out.println);
    out.println('');
  }

  /// Writes an import of a .dart file corresponding to a .proto file.
  /// (Possibly the same .proto file.)
  void _addImport(
    ImportWriter importWriter,
    OutputConfiguration config,
    FileGenerator target,
    String ext,
  ) {
    final url = config.resolveImport(target.protoFileUri, protoFileUri, ext);
    final import = url.toString();

    // .pb.dart files should always be prefixed -- the protoFileUri check will
    // evaluate to true not just for the main .pb.dart file based off the proto
    // file, but also for the .pbserver.dart, .pbgrpc.dart files.
    if (ext == '.pb.dart' || protoFileUri != target.protoFileUri) {
      importWriter.addImport(
        import,
        prefix: target.importPrefix(context: fileGen),
      );
    } else {
      importWriter.addImport(import);
    }
  }

  /// Writes an export of a pb.dart file corresponding to a .proto file.
  /// (Possibly the same .proto file.)
  void _addExport(
    ImportWriter importWriter,
    OutputConfiguration config,
    Uri target,
    String ext,
  ) {
    final url = config.resolveImport(target, protoFileUri, ext);
    importWriter.addExport(url.toString());
  }
}

class ConditionalConstDefinition {
  final String envName;
  final String constFieldName;

  ConditionalConstDefinition(this.envName)
    : constFieldName = _convertToCamelCase(envName);

  String get constDefinition {
    return 'const $coreImportPrefix.bool $constFieldName = '
        "$coreImportPrefix.bool.fromEnvironment(${quoted('protobuf.$envName')});";
  }

  String createTernary(String ifFalse) {
    return "$constFieldName ? '' : ${quoted(ifFalse)}";
  }

  // Convert foo_bar_baz to _fooBarBaz.
  static String _convertToCamelCase(String lowerUnderscoreCase) {
    final parts = lowerUnderscoreCase.split('_');
    final rest =
        parts.skip(1).map((item) {
          return item.substring(0, 1).toUpperCase() + item.substring(1);
        }).join();
    return '_${parts.first}$rest';
  }
}

const _fileIgnores = {
  'annotate_overrides',
  'camel_case_types',
  'comment_references',
  'constant_identifier_names',
  'curly_braces_in_flow_control_structures',
  'deprecated_member_use_from_same_package',
  'library_prefixes',
  'non_constant_identifier_names',
};
