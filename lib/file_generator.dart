// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

/// Generates the Dart output files for one .proto input file.
///
/// Outputs include .pb.dart, pbenum.dart, and .pbjson.dart.
class FileGenerator extends ProtobufContainer {
  /// Returns the the mixin to use by default in this file,
  /// or null for no mixin by default.
  static PbMixin _getDefaultMixin(FileDescriptorProto desc) {
    if (!desc.hasOptions()) return null;
    if (!desc.options.hasExtension(Dart_options.defaultMixin)) {
      return null;
    }
    var name = desc.options.getExtension(Dart_options.defaultMixin);
    PbMixin mixin = findMixin(name);
    if (mixin == null) {
      throw ("unknown mixin class: ${name}");
    }
    return mixin;
  }

  final FileDescriptorProto _fileDescriptor;

  // The relative path used to import the .proto file, as a URI.
  final Uri protoFileUri;

  final List<EnumGenerator> enumGenerators = <EnumGenerator>[];
  final List<MessageGenerator> messageGenerators = <MessageGenerator>[];
  final List<ExtensionGenerator> extensionGenerators = <ExtensionGenerator>[];
  final List<ClientApiGenerator> clientApiGenerators = <ClientApiGenerator>[];
  final List<ServiceGenerator> serviceGenerators = <ServiceGenerator>[];

  /// True if cross-references have been resolved.
  bool _linked = false;

  FileGenerator(FileDescriptorProto descriptor)
      : _fileDescriptor = descriptor,
        protoFileUri = new Uri.file(descriptor.name) {
    if (protoFileUri.isAbsolute) {
      // protoc should never generate an import with an absolute path.
      throw "FAILURE: Import with absolute path is not supported";
    }

    var defaultMixin = _getDefaultMixin(_fileDescriptor);

    // Load and register all enum and message types.
    for (EnumDescriptorProto enumType in _fileDescriptor.enumType) {
      enumGenerators.add(new EnumGenerator(enumType, this));
    }
    for (DescriptorProto messageType in _fileDescriptor.messageType) {
      messageGenerators
          .add(new MessageGenerator(messageType, this, defaultMixin));
    }
    for (FieldDescriptorProto extension in _fileDescriptor.extension) {
      extensionGenerators.add(new ExtensionGenerator(extension, this));
    }
    for (ServiceDescriptorProto service in _fileDescriptor.service) {
      var serviceGen = new ServiceGenerator(service, this);
      serviceGenerators.add(serviceGen);
      clientApiGenerators.add(new ClientApiGenerator(serviceGen));
    }
  }

  /// Creates the fields in each message.
  /// Resolves field types and extension targets using the supplied context.
  void resolve(GenerationContext ctx) {
    if (_linked) throw new StateError("cross references already resolved");

    for (var m in messageGenerators) {
      m.resolve(ctx);
    }
    for (var x in extensionGenerators) {
      x.resolve(ctx);
    }

    _linked = true;
  }

  String get package => _fileDescriptor.package;
  String get classname => '';
  String get fqname => '.${_fileDescriptor.package}';
  FileGenerator get fileGen => this;

  // Extract the filename from a URI and remove the extension.
  String _fileNameWithoutExtension(Uri filePath) {
    String fileName = filePath.pathSegments.last;
    int index = fileName.lastIndexOf(".");
    return index == -1 ? fileName : fileName.substring(0, index);
  }

  String _generateClassName(Uri protoFilePath) {
    String s = _fileNameWithoutExtension(protoFilePath).replaceAll('-', '_');
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  /// Generates all the Dart files for this .proto file.
  List<CodeGeneratorResponse_File> generateFiles(OutputConfiguration config) {
    if (!_linked) throw new StateError("not linked");

    makeFile(String extension, String content) {
      Uri protoUrl = new Uri.file(_fileDescriptor.name);
      Uri dartUrl = config.outputPathFor(protoUrl, extension);
      return new CodeGeneratorResponse_File()
        ..name = dartUrl.path
        ..content = content;
    }

    return [
      makeFile(".pb.dart", generateMainFile(config)),
      makeFile(".pbenum.dart", generateEnumFile(config)),
      makeFile(".pbserver.dart", generateServerFile(config)),
      makeFile(".pbjson.dart", generateJsonFile(config)),
    ];
  }

  /// Returns the contents of the .pb.dart file for this .proto file.
  String generateMainFile(
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw new StateError("not linked");
    IndentingWriter out = new IndentingWriter();

    writeMainHeader(out, config);

    // Generate code.
    for (MessageGenerator m in messageGenerators) {
      m.generate(out);
    }

    // Generate code for extensions defined at top-level using a class
    // name derived from the file name.
    if (!extensionGenerators.isEmpty) {
      // TODO(antonm): do not generate a class.
      String className = _generateClassName(protoFileUri);
      out.addBlock('class $className {', '}\n', () {
        for (ExtensionGenerator x in extensionGenerators) {
          x.generate(out);
        }
        out.println('static void registerAllExtensions(ExtensionRegistry '
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
    return out.toString();
  }

  /// Writes the header and imports for the .pb.dart file.
  void writeMainHeader(IndentingWriter out,
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    _writeLibraryHeading(out);

    // We only add the dart:async import if there are services in the
    // FileDescriptorProto.
    if (_fileDescriptor.service.isNotEmpty) {
      out.println("import 'dart:async';\n");
    }

    if (_needsFixnumImport) {
      out.println("import 'package:fixnum/fixnum.dart';");
    }

    if (_needsProtobufImport) {
      out.println("import 'package:protobuf/protobuf.dart';");
      out.println();
    }

    var mixinImports = findMixinsToImport();
    var importNames = mixinImports.keys.toList();
    importNames.sort();
    for (var imp in importNames) {
      var symbols = mixinImports[imp];
      out.println("import '${imp}' show ${symbols.join(', ')};");
    }
    if (mixinImports.isNotEmpty) out.println();

    // Import the .pb.dart files we depend on.
    var imports = new Set<FileGenerator>.identity();
    var enumImports = new Set<FileGenerator>.identity();
    _findProtosToImport(imports, enumImports);

    for (var target in imports) {
      _writeImport(out, config, target, ".pb.dart");
    }
    if (imports.isNotEmpty) out.println();

    for (var target in enumImports) {
      _writeImport(out, config, target, ".pbenum.dart");
    }
    if (enumImports.isNotEmpty) out.println();

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

  /// Returns a map from import names to the Dart symbols to be imported.
  Map<String, List<String>> findMixinsToImport() {
    var mixins = new Set<PbMixin>();
    for (MessageGenerator m in messageGenerators) {
      m.addMixinsTo(mixins);
    }

    var imports = <String, List<String>>{};
    for (var m in mixins) {
      var imp = m.importFrom;
      List<String> symbols = imports[imp];
      if (symbols == null) {
        symbols = [];
        imports[imp] = symbols;
      }
      symbols.add(m.name);
    }

    for (var imp in imports.keys) {
      imports[imp].sort();
    }

    return imports;
  }

  /// Returns the contents of the .pbenum.dart file for this .proto file.
  String generateEnumFile(
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw new StateError("not linked");

    var out = new IndentingWriter();
    _writeLibraryHeading(out, "pbenum");

    if (enumCount > 0) {
      out.println("import 'package:protobuf/protobuf.dart';");
      out.println();
    }

    for (EnumGenerator e in enumGenerators) {
      e.generate(out);
    }

    for (MessageGenerator m in messageGenerators) {
      m.generateEnums(out);
    }

    return out.toString();
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
    if (!_linked) throw new StateError("not linked");
    var out = new IndentingWriter();
    _writeLibraryHeading(out, "pbserver");

    if (serviceGenerators.isNotEmpty) {
      out.println('''
import 'dart:async';

import 'package:protobuf/protobuf.dart';
''');
    }

    // Import .pb.dart files needed for requests and responses.
    var imports = new Set<FileGenerator>();
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

  /// Returns the contents of the .pbjson.dart file for this .proto file.
  String generateJsonFile(
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw new StateError("not linked");
    var out = new IndentingWriter();
    _writeLibraryHeading(out, "pbjson");

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
    var imports = new Set<FileGenerator>.identity();
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

  /// Writes the library name at the top of the dart file.
  ///
  /// (This should be unique to avoid warnings about duplicate Dart libraries.)
  void _writeLibraryHeading(IndentingWriter out, [String extension]) {
    Uri filePath = new Uri.file(_fileDescriptor.name);
    if (filePath.isAbsolute) {
      // protoc should never generate a file descriptor with an absolute path.
      throw "FAILURE: File with an absolute path is not supported";
    }

    var libraryName = _fileNameWithoutExtension(filePath).replaceAll('-', '_');
    if (extension != null) libraryName += "_$extension";
    if (_fileDescriptor.package != '') {
      // Two .protos can be in the same proto package.
      // It isn't unique enough to use as a Dart library name.
      // But we can prepend it.
      libraryName = _fileDescriptor.package + "_" + libraryName;
    }
    out.println('''
///
//  Generated code. Do not modify.
///
library $libraryName;
''');
  }

  /// Writes an import of a .dart file corresponding to a .proto file.
  /// (Possibly the same .proto file.)
  void _writeImport(IndentingWriter out, OutputConfiguration config,
      FileGenerator target, String extension) {
    Uri resolvedImport =
        config.resolveImport(target.protoFileUri, protoFileUri, extension);
    out.print("import '$resolvedImport'");
    if (package != target.package && target.package.isNotEmpty) {
      out.print(' as ${target.packageImportPrefix}');
    }
    out.println(';');
  }
}
