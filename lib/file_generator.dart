// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

class FileGenerator implements ProtobufContainer {
  final FileDescriptorProto _fileDescriptor;
  final ProtobufContainer _parent;
  final GenerationContext _context;

  final List<EnumGenerator> enumGenerators = <EnumGenerator>[];
  final List<MessageGenerator> messageGenerators = <MessageGenerator>[];
  final List<ExtensionGenerator> extensionGenerators = <ExtensionGenerator>[];

  FileGenerator(this._fileDescriptor, this._parent, this._context) {
    _context.register(this);
    // Load and register all enum and message types.
    for (EnumDescriptorProto enumType in _fileDescriptor.enumType) {
      enumGenerators.add(new EnumGenerator(enumType, this, _context));
    }
    for (DescriptorProto messageType in _fileDescriptor.messageType) {
      messageGenerators.add(new MessageGenerator(messageType, this, _context));
    }
    for (FieldDescriptorProto extension in _fileDescriptor.extension) {
      extensionGenerators.add(
          new ExtensionGenerator(extension, this, _context));
    }
  }

  String get classname => '';
  String get fqname => '.${_fileDescriptor.package}';

  // Extract the filename from a URI and remove the extension.
  String _fileNameWithoutExtension(Uri filePath) {
    String fileName = filePath.pathSegments.last;
    int index = fileName.lastIndexOf(".");
    return index == -1 ? fileName : fileName.substring(0, index);
  }

  // Create the URI for the generated Dart file from the URI of the
  // .proto file.
  Uri _generatedFilePath(Uri protoFilePath) {
    var dartFileName = _fileNameWithoutExtension(protoFilePath) + ".pb.dart";
    return protoFilePath.resolve(dartFileName);
  }

  String _generateClassName(Uri protoFilePath) {
    String s = _fileNameWithoutExtension(protoFilePath).replaceAll('-', '_');
    return '${s[0].toUpperCase()}${s.substring(1)}';
  }

  String _generateLibraryName(Uri protoFilePath) {
    if (_fileDescriptor.package != '') return _fileDescriptor.package;
    return _fileNameWithoutExtension(protoFilePath).replaceAll('-', '_');
  }

  Uri _relative(Uri target, Uri base) {
    // Ignore the last segment of the base.
    List<String> baseSegments =
        base.pathSegments.sublist(0, base.pathSegments.length - 1);
    List<String> targetSegments = target.pathSegments;
    if (baseSegments.length == 1 && baseSegments[0] == '.') {
      baseSegments = [];
    }
    if (targetSegments.length == 1 && targetSegments[0] == '.') {
      targetSegments = [];
    }
    int common = 0;
    int length = min(targetSegments.length, baseSegments.length);
    while (common < length && targetSegments[common] == baseSegments[common]) {
      common++;
    }

    final segments = <String>[];
    if (common < baseSegments.length && baseSegments[common] == '..') {
      throw new ArgumentError(
          "Cannot create a relative path from $base to $target");
    }
    for (int i = common; i < baseSegments.length; i++) {
      segments.add('..');
    }
    for (int i = common; i < targetSegments.length; i++) {
      segments.add('${targetSegments[i]}');
    }
    if (segments.isEmpty) {
      segments.add('.');
    }
    return new Uri(pathSegments: segments);
  }

  CodeGeneratorResponse_File generateResponse() {
    MemoryWriter writer = new MemoryWriter();
    IndentingWriter out = new IndentingWriter('  ', writer);

    generate(out);

    Uri filePath = new Uri(scheme: 'file', path: _fileDescriptor.name);
    return new CodeGeneratorResponse_File()
        ..name = _generatedFilePath(filePath).path
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
      "import 'dart:typed_data';\n"
      '\n'
      "import 'package:fixnum/fixnum.dart';\n"
      "import 'package:protobuf/protobuf.dart';"
    );

    for (String import in _fileDescriptor.dependency) {
      Uri importPath = new Uri.file(import);
      if (importPath.isAbsolute) {
        // protoc should never generate an import with an absolute path.
        throw("FAILURE: Import with absolute path is not supported");
      }
      // Create a relative path from the current file to the import.
      Uri relativeProtoPath = _relative(importPath, filePath);
      out.println("import '${_generatedFilePath(relativeProtoPath)}';");
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
}

class GenerationContext {
  final GenerationOptions options;
  final Map<String, ProtobufContainer> _registry =
      <String, ProtobufContainer>{};

  GenerationContext(this.options);

  void register(ProtobufContainer container) {
    _registry[container.fqname] = container;
  }

  ProtobufContainer operator [](String fqname) => _registry[fqname];
}
