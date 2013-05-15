// Copyright (c) 2013, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

abstract class ProtobufContainer {
  String get fqname;
  String get classname;
}

class CodeGenerator implements ProtobufContainer {
  final Stream<List<int>> _streamIn;
  final IOSink _streamOut;
  final IOSink _streamErr;

  CodeGenerator(this._streamIn, this._streamOut, this._streamErr);

  void generate() {
    _streamIn
        .fold(<int>[], (bytes, data) => bytes..addAll(data))
        .then((List<int> bytes) {
            var ctx = new GenerationContext(new OutputStreamWriter(_streamErr));
            var request = new CodeGeneratorRequest.fromBuffer(bytes);

            List<FileGenerator> generators = <FileGenerator>[];
            for (FileDescriptorProto file in request.protoFile) {
              var generator = new FileGenerator(file, this, ctx);
              if (request.fileToGenerate.contains(file.name)) {
                generators.add(generator);
              }
            }

            var response = new CodeGeneratorResponse()
                ..file.addAll(generators.map((filegen) => filegen.generate()));
            _streamOut.add(response.writeToBuffer());
    });
  }

  String get fqname => '';
  String get classname => null;
}
