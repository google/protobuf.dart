// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

final _dartIdentifier = RegExp(r'^\w+$');
final _formatter = DartFormatter();
const String _protobufImportPrefix = r'$pb';
const String _asyncImportPrefix = r'$async';
const String _coreImportPrefix = r'$core';
const String _fixnumImportPrefix = r'$fixnum';
const String _grpcImportPrefix = r'$grpc';
const String _mixinImportPrefix = r'$mixin';
const String _protobufImport =
    "import 'package:protobuf/protobuf.dart' as $_protobufImportPrefix;";
const String _asyncImport = "import 'dart:async' as $_asyncImportPrefix;";
const String _coreImport = "import 'dart:core' as $_coreImportPrefix;";
const String _grpcImport =
    "import 'package:grpc/service_api.dart' as $_grpcImportPrefix;";

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
    var dartMixins = <String, DartMixin>{};
    Imports importedMixins = desc.options.getExtension(Dart_options.imports);
    for (DartMixin mixin in importedMixins.mixins) {
      if (dartMixins.containsKey(mixin.name)) {
        throw mixinError('Duplicate mixin name: "${mixin.name}"');
      }
      if (!mixin.name.startsWith(_dartIdentifier)) {
        throw mixinError(
            '"${mixin.name}" is not a valid dart class identifier');
      }
      if (mixin.hasParent() && !mixin.parent.startsWith(_dartIdentifier)) {
        throw mixinError('Mixin parent "${mixin.parent}" of "${mixin.name}" is '
            'not a valid dart class identifier');
      }
      dartMixins[mixin.name] = mixin;
    }

    // Detect cycles and unknown parents.
    for (var mixin in dartMixins.values) {
      if (!mixin.hasParent()) continue;
      var currentMixin = mixin;
      var parentChain = <String>[];
      while (currentMixin.hasParent()) {
        var parentName = currentMixin.parent;

        bool declaredMixin = dartMixins.containsKey(parentName);
        bool internalMixin = !declaredMixin && findMixin(parentName) != null;

        if (internalMixin) break; // No further validation of parent chain.

        if (!declaredMixin) {
          throw mixinError('Unknown mixin parent "${mixin.parent}" of '
              '"${currentMixin.name}"');
        }

        if (parentChain.contains(parentName)) {
          var cycle = parentChain.join('->') + '->$parentName';
          throw mixinError('Cycle in parent chain: $cycle');
        }
        parentChain.add(parentName);
        currentMixin = dartMixins[parentName];
      }
    }

    // Turn DartMixins into PbMixins.
    final pbMixins = <String, PbMixin>{};
    PbMixin resolveMixin(String name) {
      if (pbMixins.containsKey(name)) return pbMixins[name];
      if (dartMixins.containsKey(name)) {
        var dartMixin = dartMixins[name];
        var pbMixin = PbMixin(dartMixin.name,
            importFrom: dartMixin.importFrom,
            parent: resolveMixin(dartMixin.parent));
        pbMixins[name] = pbMixin;
        return pbMixin;
      }
      return findMixin(name);
    }

    for (var mixin in dartMixins.values) {
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
  final Set<String> usedTopLevelNames = Set<String>()
    ..addAll(forbiddenTopLevelNames);

  /// Used to avoid collisions in the service file after names have been mangled
  /// to match the dart style.
  final Set<String> usedTopLevelServiceNames = Set<String>()
    ..addAll(forbiddenTopLevelNames);

  final Set<String> usedExtensionNames = Set<String>()
    ..addAll(forbiddenExtensionNames);

  /// True if cross-references have been resolved.
  bool _linked = false;

  FileGenerator(this.descriptor, this.options)
      : protoFileUri = Uri.file(descriptor.name) {
    if (protoFileUri.isAbsolute) {
      // protoc should never generate an import with an absolute path.
      throw "FAILURE: Import with absolute path is not supported";
    }

    var declaredMixins = _getDeclaredMixins(descriptor);
    var defaultMixinName =
        descriptor.options?.getExtension(Dart_options.defaultMixin) ?? '';
    var defaultMixin =
        declaredMixins[defaultMixinName] ?? findMixin(defaultMixinName);
    if (defaultMixin == null && defaultMixinName.isNotEmpty) {
      throw ('Option default_mixin on file ${descriptor.name}: Unknown mixin '
          '$defaultMixinName');
    }

    // Load and register all enum and message types.
    for (var i = 0; i < descriptor.enumType.length; i++) {
      enumGenerators.add(EnumGenerator.topLevel(
          descriptor.enumType[i], this, usedTopLevelNames, i));
    }
    for (var i = 0; i < descriptor.messageType.length; i++) {
      messageGenerators.add(MessageGenerator.topLevel(descriptor.messageType[i],
          this, declaredMixins, defaultMixin, usedTopLevelNames, i));
    }
    for (var i = 0; i < descriptor.extension.length; i++) {
      extensionGenerators.add(ExtensionGenerator.topLevel(
          descriptor.extension[i], this, usedExtensionNames, i));
    }
    for (ServiceDescriptorProto service in descriptor.service) {
      if (options.useGrpc) {
        grpcGenerators.add(GrpcServiceGenerator(service, this));
      } else {
        var serviceGen =
            ServiceGenerator(service, this, usedTopLevelServiceNames);
        serviceGenerators.add(serviceGen);
        clientApiGenerators
            .add(ClientApiGenerator(serviceGen, usedTopLevelNames));
      }
    }
  }

  /// Creates the fields in each message.
  /// Resolves field types and extension targets using the supplied context.
  void resolve(GenerationContext ctx) {
    if (_linked) throw StateError("cross references already resolved");

    for (var m in messageGenerators) {
      m.resolve(ctx);
    }
    for (var x in extensionGenerators) {
      x.resolve(ctx);
    }

    _linked = true;
  }

  String get package => descriptor.package;
  String get classname => '';
  String get fullName => descriptor.package;
  FileGenerator get fileGen => this;
  List<int> get fieldPath => [];

  /// Generates all the Dart files for this .proto file.
  List<CodeGeneratorResponse_File> generateFiles(OutputConfiguration config) {
    if (!_linked) throw StateError("not linked");

    makeFile(String extension, String content) {
      Uri protoUrl = Uri.file(descriptor.name);
      Uri dartUrl = config.outputPathFor(protoUrl, extension);
      return CodeGeneratorResponse_File()
        ..name = dartUrl.path
        ..content = content;
    }

    IndentingWriter mainWriter = generateMainFile(config);
    IndentingWriter enumWriter = generateEnumFile(config);

    final files = [
      makeFile(".pb.dart", mainWriter.toString()),
      makeFile(".pbenum.dart", enumWriter.toString()),
      makeFile(".pbjson.dart", generateJsonFile(config)),
    ];

    if (options.generateMetadata) {
      files.addAll([
        makeFile(".pb.dart.meta",
            mainWriter.sourceLocationInfo.writeToJson().toString()),
        makeFile(".pbenum.dart.meta",
            enumWriter.sourceLocationInfo.writeToJson().toString())
      ]);
    }
    if (options.useGrpc) {
      if (grpcGenerators.isNotEmpty) {
        files.add(makeFile(".pbgrpc.dart", generateGrpcFile(config)));
      }
    } else {
      files.add(makeFile(".pbserver.dart", generateServerFile(config)));
    }
    return files;
  }

  /// Creates an IndentingWriter with metadata generation enabled or disabled.
  IndentingWriter makeWriter() => IndentingWriter(
      filename: options.generateMetadata ? descriptor.name : null);

  /// Returns the contents of the .pb.dart file for this .proto file.
  IndentingWriter generateMainFile(
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw StateError("not linked");
    IndentingWriter out = makeWriter();

    writeMainHeader(out, config);

    // Generate code.
    for (MessageGenerator m in messageGenerators) {
      m.generate(out);
    }

    // Generate code for extensions defined at top-level using a class
    // name derived from the file name.
    if (extensionGenerators.isNotEmpty) {
      // TODO(antonm): do not generate a class.
      String className = extensionClassName(descriptor, usedTopLevelNames);
      out.addBlock('class $className {', '}\n', () {
        for (ExtensionGenerator x in extensionGenerators) {
          x.generate(out);
        }
        out.println(
            'static void registerAllExtensions($_protobufImportPrefix.ExtensionRegistry '
            'registry) {');
        for (ExtensionGenerator x in extensionGenerators) {
          out.println('  registry.add(${x.name});');
        }
        out.println('}');
      });
    }

    for (ClientApiGenerator c in clientApiGenerators) {
      c.generate(out);
    }
    return out;
  }

  /// Writes the header and imports for the .pb.dart file.
  void writeMainHeader(IndentingWriter out,
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    _writeHeading(out);

    // We only add the dart:async import if there are generic client API
    // generators for services in the FileDescriptorProto.
    if (clientApiGenerators.isNotEmpty) {
      out.println(_asyncImport);
    }

    out.println(_coreImport);
    out.println();

    if (_needsFixnumImport) {
      out.println(
          "import 'package:fixnum/fixnum.dart' as $_fixnumImportPrefix;");
    }

    if (_needsProtobufImport) {
      out.println(_protobufImport);
      out.println();
    }

    final mixinImports = findMixinImports();
    for (var libraryUri in mixinImports) {
      out.println("import '$libraryUri' as $_mixinImportPrefix;");
    }
    if (mixinImports.isNotEmpty) out.println();

    // Import the .pb.dart files we depend on.
    var imports = Set<FileGenerator>.identity();
    var enumImports = Set<FileGenerator>.identity();
    _findProtosToImport(imports, enumImports);

    for (var target in imports) {
      _writeImport(out, config, target, ".pb.dart");
    }
    if (imports.isNotEmpty) out.println();

    for (var target in enumImports) {
      _writeImport(out, config, target, ".pbenum.dart");
    }
    if (enumImports.isNotEmpty) out.println();

    for (int publicDependency in descriptor.publicDependency) {
      _writeExport(out, config,
          Uri.file(descriptor.dependency[publicDependency]), '.pb.dart');
    }

    // Export enums in main file for backward compatibility.
    if (enumCount > 0) {
      Uri resolvedImport =
          config.resolveImport(protoFileUri, protoFileUri, ".pbenum.dart");
      out.println("export '$resolvedImport';");
      out.println();
    }
  }

  bool get _needsFixnumImport {
    for (var m in messageGenerators) {
      if (m.needsFixnumImport) return true;
    }
    for (var x in extensionGenerators) {
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
      Set<FileGenerator> imports, Set<FileGenerator> enumImports) {
    for (var m in messageGenerators) {
      m.addImportsTo(imports, enumImports);
    }
    for (var x in extensionGenerators) {
      x.addImportsTo(imports, enumImports);
    }
    // Add imports needed for client-side services.
    for (var x in serviceGenerators) {
      x.addImportsTo(imports);
    }
    // Don't need to import self. (But we may need to import the enums.)
    imports.remove(this);
  }

  /// Returns a sorted list of imports needed to support all mixins.
  List<String> findMixinImports() {
    var mixins = Set<PbMixin>();
    for (MessageGenerator m in messageGenerators) {
      m.addMixinsTo(mixins);
    }

    return mixins
        .map((mixin) => mixin.importFrom)
        .toSet()
        .toList(growable: false)
          ..sort();
  }

  /// Returns the contents of the .pbenum.dart file for this .proto file.
  IndentingWriter generateEnumFile(
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw StateError("not linked");

    var out = makeWriter();
    _writeHeading(out);

    if (enumCount > 0) {
      // Make sure any other symbols in dart:core don't cause name conflicts
      // with enums that have the same name.
      out.println("// ignore_for_file: UNDEFINED_SHOWN_NAME,UNUSED_SHOWN_NAME");
      out.println(_coreImport);
      out.println(_protobufImport);
      out.println();
    }

    for (EnumGenerator e in enumGenerators) {
      e.generate(out);
    }

    for (MessageGenerator m in messageGenerators) {
      m.generateEnums(out);
    }

    return out;
  }

  /// Returns the number of enum types generated in the .pbenum.dart file.
  int get enumCount {
    var count = enumGenerators.length;
    for (MessageGenerator m in messageGenerators) {
      count += m.enumCount;
    }
    return count;
  }

  /// Returns the contents of the .pbserver.dart file for this .proto file.
  String generateServerFile(
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw StateError("not linked");
    var out = makeWriter();
    _writeHeading(out);

    if (serviceGenerators.isNotEmpty) {
      out.println(_asyncImport);
      out.println();
      out.println(_protobufImport);
      out.println();
      out.println(_coreImport);
    }

    // Import .pb.dart files needed for requests and responses.
    var imports = Set<FileGenerator>();
    for (var x in serviceGenerators) {
      x.addImportsTo(imports);
    }
    for (var target in imports) {
      _writeImport(out, config, target, ".pb.dart");
    }

    // Import .pbjson.dart file needed for $json and $messageJson.
    if (serviceGenerators.isNotEmpty) {
      _writeImport(out, config, this, ".pbjson.dart");
      out.println();
    }

    Uri resolvedImport =
        config.resolveImport(protoFileUri, protoFileUri, ".pb.dart");
    out.println("export '$resolvedImport';");
    out.println();

    for (ServiceGenerator s in serviceGenerators) {
      s.generate(out);
    }

    return out.toString();
  }

  /// Returns the contents of the .pbgrpc.dart file for this .proto file.
  String generateGrpcFile(
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw StateError("not linked");
    var out = makeWriter();
    _writeHeading(out);

    out.println(_asyncImport);
    out.println();
    out.println(_coreImport);
    out.println();
    out.println(_grpcImport);

    // Import .pb.dart files needed for requests and responses.
    var imports = Set<FileGenerator>();
    for (var generator in grpcGenerators) {
      generator.addImportsTo(imports);
    }
    for (var target in imports) {
      _writeImport(out, config, target, ".pb.dart");
    }

    var resolvedImport =
        config.resolveImport(protoFileUri, protoFileUri, ".pb.dart");
    out.println("export '$resolvedImport';");
    out.println();

    for (var generator in grpcGenerators) {
      generator.generate(out);
    }

    return _formatter.format(out.toString());
  }

  /// Returns the contents of the .pbjson.dart file for this .proto file.
  String generateJsonFile(
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw StateError("not linked");
    var out = makeWriter();
    _writeHeading(out);

    // Import the .pbjson.dart files we depend on.
    var imports = _findJsonProtosToImport();
    for (var target in imports) {
      _writeImport(out, config, target, ".pbjson.dart");
    }
    if (imports.isNotEmpty) out.println();

    for (var e in enumGenerators) {
      e.generateConstants(out);
    }
    for (MessageGenerator m in messageGenerators) {
      m.generateConstants(out);
    }
    for (ServiceGenerator s in serviceGenerators) {
      s.generateConstants(out);
    }

    return out.toString();
  }

  /// Returns the generator for each .pbjson.dart file the generated
  /// .pbjson.dart needs to import.
  Set<FileGenerator> _findJsonProtosToImport() {
    var imports = Set<FileGenerator>.identity();
    for (var m in messageGenerators) {
      m.addConstantImportsTo(imports);
    }
    for (var x in extensionGenerators) {
      x.addConstantImportsTo(imports);
    }
    for (var x in serviceGenerators) {
      x.addConstantImportsTo(imports);
    }
    imports.remove(this); // Don't need to import self.
    return imports;
  }

  /// Writes the header at the top of the dart file.
  void _writeHeading(IndentingWriter out) {
    out.println('''
///
//  Generated code. Do not modify.
//  source: ${descriptor.name}
//
// @dart = 2.3
// ignore_for_file: camel_case_types,unnecessary_const,non_constant_identifier_names,library_prefixes,unused_import,unused_shown_name,return_of_invalid_type
''');
  }

  /// Writes an import of a .dart file corresponding to a .proto file.
  /// (Possibly the same .proto file.)
  void _writeImport(IndentingWriter out, OutputConfiguration config,
      FileGenerator target, String extension) {
    Uri resolvedImport =
        config.resolveImport(target.protoFileUri, protoFileUri, extension);
    out.print("import '$resolvedImport'");

    // .pb.dart files should always be prefixed--the protoFileUri check
    // will evaluate to true not just for the main .pb.dart file based off
    // the proto file, but also for the .pbserver.dart, .pbgrpc.dart files.
    if ((extension == ".pb.dart") || protoFileUri != target.protoFileUri) {
      out.print(' as ${target.fileImportPrefix}');
    }
    out.println(';');
  }

  /// Writes an export of a pb.dart file corresponding to a .proto file.
  /// (Possibly the same .proto file.)
  void _writeExport(IndentingWriter out, OutputConfiguration config, Uri target,
      String extension) {
    Uri resolvedImport = config.resolveImport(target, protoFileUri, extension);
    out.println("export '$resolvedImport';");
  }
}
