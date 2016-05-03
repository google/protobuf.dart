// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

abstract class ProtobufContainer {
  String get package;
  String get classname;
  String get fqname;
  String get packageImportPrefix => package.replaceAll('.', r'$');

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
      config = new DefaultOutputConfiguration();
    }

    var extensions = new ExtensionRegistry();
    Dart_options.registerAllExtensions(extensions);

    _streamIn
        .fold(new BytesBuilder(), (builder, data) => builder..add(data))
        .then((builder) => builder.takeBytes())
        .then((List<int> bytes) {
      var request = new CodeGeneratorRequest.fromBuffer(bytes, extensions);
      var response = new CodeGeneratorResponse();

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
        generators.add(new FileGenerator(file));
      }

      // Collect field types and importable files.
      link(options, generators);

      // Generate the .pb.dart file if requested.
      for (var gen in generators) {
        var name = gen._fileDescriptor.name;
        if (request.fileToGenerate.contains(name)) {
          response.file.add(gen.generateResponse(config));
          response.file.add(gen.generateJsonDartResponse(config));
        }
      }
      _streamOut.add(response.writeToBuffer());
    });
  }

  String get package => '';
  String get classname => null;
  String get fqname => '';
  get fileGen => null;
}
