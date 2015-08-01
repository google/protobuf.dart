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

  bool _resolved = false;

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

  /// Makes the messages, groups, and enums in this file available for use as
  /// field types.
  /// Also makes this file available for use in imports.
  void register(GenerationContext ctx) {
    for (var m in messageGenerators) {
      m.register(ctx);
    }
    for (var e in enumGenerators) {
      e.register(ctx);
    }

    ctx.registerFile(_fileDescriptor.name, this);
  }

  /// Creates the fields in each message.
  /// Resolves field types and extension targets using the supplied context.
  void resolve(GenerationContext ctx) {
    if (_resolved) throw new StateError("already resolved");

    for (var m in messageGenerators) {
      m.resolve(ctx);
    }
    for (var x in extensionGenerators) {
      x.resolve(ctx);
    }

    _resolved = true;
  }

  String get package => _fileDescriptor.package;
  String get classname => '';
  String get fqname => '.${_fileDescriptor.package}';

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

  String _generateLibraryName(Uri protoFilePath) {
    if (_fileDescriptor.package != '') return _fileDescriptor.package;
    return _fileNameWithoutExtension(protoFilePath).replaceAll('-', '_');
  }

  CodeGeneratorResponse_File generateResponse(GenerationContext ctx) {
    MemoryWriter writer = new MemoryWriter();
    IndentingWriter out = new IndentingWriter('  ', writer);

    generate(out, ctx);

    Uri filePath = new Uri.file(_fileDescriptor.name);
    return new CodeGeneratorResponse_File()
        ..name = ctx.outputConfiguration.outputPathFor(filePath).path
        ..content = writer.toString();
  }

  /// Generates the Dart code for this .proto file.
  void generate(IndentingWriter out, GenerationContext ctx) {
    if (!_resolved) throw new StateError("resolve not called");

    Uri filePath = new Uri.file(_fileDescriptor.name);
    if (filePath.isAbsolute) {
        // protoc should never generate a file descriptor with an absolute path.
        throw("FAILURE: File with an absolute path is not supported");
    }

    String libraryName = _generateLibraryName(filePath);

    // Print header and imports. We only add the dart:async import if there
    // are services in the FileDescriptorProto.
    out.println(
      '///\n'
      '//  Generated code. Do not modify.\n'
      '///\n'
      'library $libraryName;\n');
    if (_fileDescriptor.service.isNotEmpty) {
      out.println("import 'dart:async';\n");
    }
    out.println(
      "import 'package:fixnum/fixnum.dart';\n"
      "import 'package:protobuf/protobuf.dart';"
    );

    var mixinImports = findMixinsToImport();
    var importNames = mixinImports.keys.toList();
    importNames.sort();
    for (var imp in importNames) {
      var symbols = mixinImports[imp];
      out.println("import '${imp}' show ${symbols.join(', ')};");
    }

    for (String import in _fileDescriptor.dependency) {
      Uri importPath = new Uri.file(import);
      if (importPath.isAbsolute) {
        // protoc should never generate an import with an absolute path.
        throw("FAILURE: Import with absolute path is not supported");
      }
      // Create a path from the current file to the imported proto.
      Uri resolvedImport = ctx.outputConfiguration.resolveImport(
          importPath, filePath);
      // Find the file generator for this import as it contains the
      // package name.
      FileGenerator fileGenerator = ctx.getFile(import);
      out.print("import '$resolvedImport'");
      if (package != fileGenerator.package && !fileGenerator.package.isEmpty) {
        out.print(' as ${fileGenerator.packageImportPrefix}');
      }
      out.println(';');
    }
    out.println('');

    // Generate code.
    for (EnumGenerator e in enumGenerators) {
      e.generate(out);
    }
    for (MessageGenerator m in messageGenerators) {
      m.generate(out, ctx);
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

class GenerationContext {
  final GenerationOptions options;
  final OutputConfiguration outputConfiguration;
  final Map<String, ProtobufContainer> _typeRegistry =
      <String, ProtobufContainer>{};
  final Map<String, FileGenerator> _files =
      <String, FileGenerator>{};

  GenerationContext(this.options, this.outputConfiguration);

  /// Makes a message, group, or enum available to fields.
  void registerFieldType(String name, ProtobufContainer type) {
    _typeRegistry[name] = type;
  }

  /// Returns the message, group, or enum with the given fully qualified name.
  ProtobufContainer getFieldType(String name) => _typeRegistry[name];

  /// Makes info about a .pb.dart file available to imports.
  void registerFile(String name, FileGenerator file) {
    _files[name] = file;
  }

  /// Returns info about a file being imported.
  FileGenerator getFile(String name) => _files[name];
}
