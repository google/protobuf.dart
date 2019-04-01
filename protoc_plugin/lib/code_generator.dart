// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

abstract class ProtobufContainer {
  // Internal map of proto file URIs to prefix aliases to resolve name conflicts
  static final importPrefixes = <String, String>{};
  static var idx = 0;

  String get package;
  String get classname;
  String get fullName;

  /// The field path contains the field IDs and indices (for repeated fields)
  /// that lead to the proto memeber corresponding to a piece of generated code.
  /// Repeated fields in the descriptor are further identified by the index of
  /// the message in question.
  /// For more information see
  /// https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/descriptor.proto#L728
  List<int> get fieldPath;

  /// The fully qualified name with a leading '.'.
  ///
  /// This exists because names from protoc come like this.
  String get dottedName => '.$fullName';

  String get fileImportPrefix => _getFileImportPrefix();

  String _getFileImportPrefix() {
    String path = fileGen.protoFileUri.toString();
    if (importPrefixes.containsKey(path)) {
      return importPrefixes[path];
    }
    final alias = '\$$idx';
    importPrefixes[path] = alias;
    idx++;
    return alias;
  }

  /// The generator of the .pb.dart file defining this entity.
  ///
  /// (Represents the .pb.dart file that we need to import in order to use it.)
  FileGenerator get fileGen;
}

class CodeGenerator extends ProtobufContainer {
  final Stream<List<int>> _streamIn;
  final IOSink _streamOut;

  CodeGenerator(this._streamIn, this._streamOut);

  /// Runs the code generator. The optional [optionParsers] can be used to
  /// change how command line options are parsed (see [parseGenerationOptions]
  /// for details), and [outputConfiguration] can be used to override where
  /// generated files are created and how imports between generated files are
  /// constructed (see [OutputConfiguration] for details).
  void generate(
      {Map<String, SingleOptionParser> optionParsers,
      OutputConfiguration config}) {
    if (config == null) {
      config = DefaultOutputConfiguration();
    }

    var extensions = ExtensionRegistry();
    Dart_options.registerAllExtensions(extensions);

    _streamIn
        .fold(
            BytesBuilder(), (BytesBuilder builder, data) => builder..add(data))
        .then((builder) => builder.takeBytes())
        .then((List<int> bytes) {
      var request = CodeGeneratorRequest.fromBuffer(bytes, extensions);
      var response = CodeGeneratorResponse();

      // Parse the options in the request. Return the errors is any.
      var options = parseGenerationOptions(request, response, optionParsers);
      if (options == null) {
        _streamOut.add(response.writeToBuffer());
        return;
      }

      // Create a syntax tree for each .proto file given to us.
      // (We may import it even if we don't generate the .pb.dart file.)
      List<FileGenerator> generators = <FileGenerator>[];
      for (FileDescriptorProto file in request.protoFile) {
        generators.add(FileGenerator(file, options));
      }

      // Collect field types and importable files.
      link(options, generators);

      // Generate the .pb.dart file if requested.
      for (var gen in generators) {
        var name = gen.descriptor.name;
        if (request.fileToGenerate.contains(name)) {
          response.file.addAll(gen.generateFiles(config));
        }
      }
      _streamOut.add(response.writeToBuffer());
    });
  }

  String get package => '';
  String get classname => null;
  String get fullName => '';
  get fileGen => null;
  List<int> get fieldPath => [];
}
