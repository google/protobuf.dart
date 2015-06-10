// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class FileGenerator extends ProtobufContainer {
  // This should match the extension in dart_options.proto.
  static const int implementMapByDefaultOption = 95333044;

  // Returns true if option implement_map_by_default is on for this file.
  static bool _shouldImplementMapByDefault(FileDescriptorProto desc) {
    if (!desc.hasOptions()) return false;

    var val = desc.options.unknownFields.getField(implementMapByDefaultOption);
    if (val == null || val.length != 1) return false;

    return val.values[0] == 1;
  }

  final FileDescriptorProto _fileDescriptor;
  final ProtobufContainer _parent;
  final GenerationContext _context;

  final List<EnumGenerator> enumGenerators = <EnumGenerator>[];
  final List<MessageGenerator> messageGenerators = <MessageGenerator>[];
  final List<ExtensionGenerator> extensionGenerators = <ExtensionGenerator>[];

  FileGenerator(this._fileDescriptor, this._parent, this._context) {
    _context.register(this);

    bool implementMap = _shouldImplementMapByDefault(_fileDescriptor);

    // Load and register all enum and message types.
    for (EnumDescriptorProto enumType in _fileDescriptor.enumType) {
      enumGenerators.add(new EnumGenerator(enumType, this, _context));
    }
    for (DescriptorProto messageType in _fileDescriptor.messageType) {
      messageGenerators.add(
          new MessageGenerator(messageType, this, _context, implementMap));
    }
    for (FieldDescriptorProto extension in _fileDescriptor.extension) {
      extensionGenerators.add(
          new ExtensionGenerator(extension, this, _context));
    }
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

  CodeGeneratorResponse_File generateResponse() {
    MemoryWriter writer = new MemoryWriter();
    IndentingWriter out = new IndentingWriter('  ', writer);

    generate(out);

    Uri filePath = new Uri.file(_fileDescriptor.name);
    return new CodeGeneratorResponse_File()
        ..name = _context.outputConfiguration.outputPathFor(filePath).path
        ..content = writer.toString();
  }

  void generate(IndentingWriter out) {
    Uri filePath = new Uri.file(_fileDescriptor.name);
    if (filePath.isAbsolute) {
        // protoc should never generate a file descriptor with an absolute path.
        throw("FAILURE: File with an absolute path is not supported");
    }

    String libraryName = _generateLibraryName(filePath);

    out.println(
      '///\n'
      '//  Generated code. Do not modify.\n'
      '///\n'
      'library $libraryName;\n'
      '\n'
      "import 'package:fixnum/fixnum.dart';\n"
      "import 'package:protobuf/protobuf.dart';"
    );

    if (needsMapMixinImport) {
      out.println("import 'dart:collection' show MapMixin;");
    }

    for (String import in _fileDescriptor.dependency) {
      Uri importPath = new Uri.file(import);
      if (importPath.isAbsolute) {
        // protoc should never generate an import with an absolute path.
        throw("FAILURE: Import with absolute path is not supported");
      }
      // Create a path from the current file to the imported proto.
      Uri resolvedImport = _context.outputConfiguration.resolveImport(
          importPath, filePath);
      // Find the file generator for this import as it contains the
      // package name.
      FileGenerator fileGenerator = _context.lookupFile(import);
      out.print("import '$resolvedImport'");
      if (package != fileGenerator.package && !fileGenerator.package.isEmpty) {
        out.print(' as ${fileGenerator.packageImportPrefix}');
      }
      out.println(';');
    }
    out.println('');

    // Initialize Field.
    for (MessageGenerator m in messageGenerators) {
      m.initializeFields();
    }

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
  }

  bool get needsMapMixinImport {
    for (var m in messageGenerators) {
      if (m.needsMapMixinImport) {
        return true;
      }
    }
    return false;
  }
}

class GenerationContext {
  final GenerationOptions options;
  final OutputConfiguration outputConfiguration;
  final Map<String, ProtobufContainer> _registry =
      <String, ProtobufContainer>{};
  final Map<String, FileGenerator> _files =
      <String, FileGenerator>{};

  GenerationContext(this.options, this.outputConfiguration);

  void register(ProtobufContainer container) {
    _registry[container.fqname] = container;
    if (container is FileGenerator) {
      _files[container._fileDescriptor.name] = container;
    }
  }

  ProtobufContainer operator [](String fqname) => _registry[fqname];

  FileGenerator lookupFile(String name) => _files[name];
}
