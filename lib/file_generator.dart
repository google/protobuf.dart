// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

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
      throw("unknown mixin class: ${name}");
    }
    return mixin;
  }

  final FileDescriptorProto _fileDescriptor;

  final List<EnumGenerator> enumGenerators = <EnumGenerator>[];
  final List<MessageGenerator> messageGenerators = <MessageGenerator>[];
  final List<ExtensionGenerator> extensionGenerators = <ExtensionGenerator>[];
  final List<ClientApiGenerator> clientApiGenerators = <ClientApiGenerator>[];
  final List<ServiceGenerator> serviceGenerators = <ServiceGenerator>[];

  /// True if cross-references have been resolved.
  bool _linked = false;

  FileGenerator(this._fileDescriptor) {
    var defaultMixin = _getDefaultMixin(_fileDescriptor);

    // Load and register all enum and message types.
    for (EnumDescriptorProto enumType in _fileDescriptor.enumType) {
      enumGenerators.add(new EnumGenerator(enumType, this));
    }
    for (DescriptorProto messageType in _fileDescriptor.messageType) {
      messageGenerators.add(
          new MessageGenerator(messageType, this, defaultMixin));
    }
    for (FieldDescriptorProto extension in _fileDescriptor.extension) {
      extensionGenerators.add(new ExtensionGenerator(extension, this));
    }
    for (ServiceDescriptorProto service in _fileDescriptor.service) {
      serviceGenerators.add(new ServiceGenerator(service));
      clientApiGenerators.add(new ClientApiGenerator(service));
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

  /// Returns the library name at the top of the .pb.dart file.
  ///
  /// (This should be unique to avoid warnings about duplicate Dart libraries.)
  String _generateLibraryName(Uri protoFilePath) {
    var libraryName =
        _fileNameWithoutExtension(protoFilePath).replaceAll('-', '_');

    if (_fileDescriptor.package != '') {
      // Two .protos can be in the same proto package.
      // It isn't unique enough to use as a Dart library name.
      // But we can prepend it.
      return _fileDescriptor.package + "_" + libraryName;
    }

    return libraryName;
  }

  CodeGeneratorResponse_File generateResponse(OutputConfiguration config) {
    MemoryWriter writer = new MemoryWriter();
    IndentingWriter out = new IndentingWriter('  ', writer);

    generate(out, config);

    Uri filePath = new Uri.file(_fileDescriptor.name);
    return new CodeGeneratorResponse_File()
        ..name = config.outputPathFor(filePath).path
        ..content = writer.toString();
  }

  /// Generates the Dart code for this .proto file.
  void generate(IndentingWriter out,
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {
    if (!_linked) throw new StateError("not linked");

    Uri filePath = new Uri.file(_fileDescriptor.name);
    if (filePath.isAbsolute) {
        // protoc should never generate a file descriptor with an absolute path.
        throw("FAILURE: File with an absolute path is not supported");
    }

    generateHeader(out, filePath, config);

    // Generate code.
    for (EnumGenerator e in enumGenerators) {
      e.generate(out);
    }
    for (MessageGenerator m in messageGenerators) {
      m.generate(out);
    }

    // Generate code for extensions defined at top-level using a class
    // name derived from the file name.
    if (!extensionGenerators.isEmpty) {
      // TODO(antonm): do not generate a class.
      String className = _generateClassName(filePath);
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
    for (ServiceGenerator s in serviceGenerators) {
      s.generate(out);
    }
  }

  /// Prints header and imports.
  void generateHeader(IndentingWriter out, Uri filePath,
      [OutputConfiguration config = const DefaultOutputConfiguration()]) {

    String libraryName = _generateLibraryName(filePath);
    out.println(
        '///\n'
        '//  Generated code. Do not modify.\n'
        '///\n'
        'library $libraryName;\n');

    // We only add the dart:async import if there are services in the
    // FileDescriptorProto.
    if (_fileDescriptor.service.isNotEmpty) {
      out.println("import 'dart:async';\n");
    }

    if (_needsFixnumImport) {
      out.println("import 'package:fixnum/fixnum.dart';");
    }
    out.println("import 'package:protobuf/protobuf.dart';");

    var mixinImports = findMixinsToImport();
    var importNames = mixinImports.keys.toList();
    importNames.sort();
    for (var imp in importNames) {
      var symbols = mixinImports[imp];
      out.println("import '${imp}' show ${symbols.join(', ')};");
    }

    for (var imported in _findProtosToImport()) {
      String filename = imported._fileDescriptor.name;
      Uri importPath = new Uri.file(filename);
      if (importPath.isAbsolute) {
        // protoc should never generate an import with an absolute path.
        throw("FAILURE: Import with absolute path is not supported");
      }
      // Create a path from the current file to the imported proto.
      Uri resolvedImport = config.resolveImport(importPath, filePath);
      out.print("import '$resolvedImport'");
      if (package != imported.package && imported.package.isNotEmpty) {
        out.print(' as ${imported.packageImportPrefix}');
      }
      out.println(';');
    }
    out.println();
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

  /// Returns the generator for each .pb.dart file we need to import.
  Set<FileGenerator> _findProtosToImport() {
    var imports = new Set<FileGenerator>.identity();
    for (var m in messageGenerators) {
      m.addImportsTo(imports);
    }
    for (var x in extensionGenerators) {
      x.addImportsTo(imports);
    }
    return imports;
  }

  /// Returns a map from import names to the Dart symbols to be imported.
  Map<String, List<String>> findMixinsToImport() {
    var mixins = new Set<PbMixin>();
    for (MessageGenerator m in messageGenerators) {
      m.addMixinsTo(mixins);
    }

    var imports = {};
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
}
