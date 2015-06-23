// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

abstract class ProtobufContainer {
  String get package;
  String get classname;
  String get fqname;
  String get packageImportPrefix => package.replaceAll('.', r'$');
}

class CodeGenerator extends ProtobufContainer {
  final Stream<List<int>> _streamIn;
  final IOSink _streamOut;
  final IOSink _streamErr;

  CodeGenerator(this._streamIn, this._streamOut, this._streamErr);

  /// Runs the code generator. The optional [optionParsers] can be used to
  /// change how command line options are parsed (see [parseGenerationOptions]
  /// for details), and [outputConfiguration] can be used to override where
  /// generated files are created and how imports between generated files are
  /// constructed (see [OutputConfiguration] for details).
  void generate({
      Map<String, SingleOptionParser> optionParsers,
      OutputConfiguration outputConfiguration}) {

    var extensions = new ExtensionRegistry();
    Dart_options.registerAllExtensions(extensions);

    _streamIn
        .fold(new BytesBuilder(), (builder, data) => builder..add(data))
        .then((builder) => builder.takeBytes())
        .then((List<int> bytes) {
            var request =
                new CodeGeneratorRequest.fromBuffer(bytes, extensions);
            var response = new CodeGeneratorResponse();

            // Parse the options in the request. Return the errors is any.
            var options = parseGenerationOptions(
                request, response, optionParsers);
            if (options == null) {
              _streamOut.add(response.writeToBuffer());
              return;
            }

            var ctx = new GenerationContext(options,
                outputConfiguration == null
                ? new DefaultOutputConfiguration() : outputConfiguration);
            List<FileGenerator> generators = <FileGenerator>[];
            for (FileDescriptorProto file in request.protoFile) {
              var generator = new FileGenerator(file, this, ctx);
              if (request.fileToGenerate.contains(file.name)) {
                generators.add(generator);
              }
            }

            response.file.addAll(
                generators.map((filegen) => filegen.generateResponse()));
            _streamOut.add(response.writeToBuffer());
        });
  }

  String get package => '';
  String get classname => null;
  String get fqname => '';
}
