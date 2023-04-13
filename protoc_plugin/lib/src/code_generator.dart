// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io' hide BytesBuilder;
import 'dart:typed_data' show BytesBuilder;

import 'package:fixnum/fixnum.dart';
import 'package:protobuf/protobuf.dart';

import '../names.dart' show lowerCaseFirstLetter;
import '../protoc.dart' show FileGenerator;
import 'generated/dart_options.pb.dart';
import 'generated/plugin.pb.dart';
import 'linker.dart';
import 'options.dart';
import 'output_config.dart';

abstract class ProtobufContainer {
  // Internal map of proto file URIs to prefix aliases to resolve name conflicts
  static final _importPrefixes = <String, String>{};
  static int _idx = 0;

  String get package;
  String? get classname;
  String get fullName;

  /// The field path contains the field IDs and indices (for repeated fields)
  /// that lead to the proto member corresponding to a piece of generated code.
  /// Repeated fields in the descriptor are further identified by the index of
  /// the message in question.
  /// For more information see
  /// https://github.com/protocolbuffers/protobuf/blob/master/src/google/protobuf/descriptor.proto#L728
  List<int>? get fieldPath;

  /// The fully qualified name with a leading '.'.
  ///
  /// This exists because names from protoc come like this.
  String get dottedName => '.$fullName';

  String get fileImportPrefix => _getFileImportPrefix();

  String get binaryDescriptorName =>
      '${lowerCaseFirstLetter(classname!)}Descriptor';

  String _getFileImportPrefix() {
    final path = fileGen!.protoFileUri.toString();
    if (_importPrefixes.containsKey(path)) {
      return _importPrefixes[path]!;
    }
    final alias = '\$$_idx';
    _importPrefixes[path] = alias;
    _idx++;
    return alias;
  }

  /// The generator of the .pb.dart file defining this entity.
  ///
  /// (Represents the .pb.dart file that we need to import in order to use it.)
  FileGenerator? get fileGen;

  // The generator containing this entity.
  ProtobufContainer? get parent;

  /// The top-level parent of this entity, or itself if it is a top-level
  /// entity.
  ProtobufContainer? get toplevelParent {
    if (parent == null) {
      return null;
    }
    if (parent is FileGenerator) {
      return this;
    }
    return parent?.toplevelParent;
  }
}

class CodeGenerator {
  final Stream<List<int>> _streamIn;
  final IOSink _streamOut;

  CodeGenerator(this._streamIn, this._streamOut);

  /// Runs the code generator. The optional [optionParsers] can be used to
  /// change how command line options are parsed (see [parseGenerationOptions]
  /// for details), and [config] can be used to override where
  /// generated files are created and how imports between generated files are
  /// constructed (see [OutputConfiguration] for details).
  void generate(
      {Map<String, SingleOptionParser>? optionParsers,
      OutputConfiguration config = const DefaultOutputConfiguration()}) {
    final extensions = ExtensionRegistry();
    Dart_options.registerAllExtensions(extensions);

    _streamIn
        .fold(
            BytesBuilder(), (BytesBuilder builder, data) => builder..add(data))
        .then((builder) => builder.takeBytes())
        .then((List<int> bytes) {
      // Suppress CodedBufferReader builtin size limitation when reading
      // the request, as protobuf definitions can be larger than default
      // limit of 64Mb.
      final reader = CodedBufferReader(bytes, sizeLimit: bytes.length);
      final request = CodeGeneratorRequest();
      request.mergeFromCodedBufferReader(reader, extensions);
      reader.checkLastTagWas(0);

      final response = CodeGeneratorResponse();

      // Parse the options in the request. Return the errors if any.
      final options = parseGenerationOptions(request, response, optionParsers);
      if (options == null) {
        _streamOut.add(response.writeToBuffer());
        return;
      }

      // Create a syntax tree for each .proto file given to us.
      // (We may import it even if we don't generate the .pb.dart file.)
      final generators = <FileGenerator>[];
      for (final file in request.protoFile) {
        generators.add(FileGenerator(file, options));
      }

      // Collect field types and importable files.
      link(options, generators);

      // Generate the .pb.dart file if requested.
      for (final gen in generators) {
        final name = gen.descriptor.name;
        if (request.fileToGenerate.contains(name)) {
          response.file.addAll(gen.generateFiles(config));
        }
      }
      response.supportedFeatures =
          Int64(CodeGeneratorResponse_Feature.FEATURE_PROTO3_OPTIONAL.value);

      _streamOut.add(response.writeToBuffer());
    });
  }
}
