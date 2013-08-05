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
            var options;
            var request = new CodeGeneratorRequest.fromBuffer(bytes);
            var response = new CodeGeneratorResponse();

            try {
              if (request.parameter != null) {
                options = new GenerationOptions(request.parameter);
              } else {
                options = new GenerationOptions("");
              }
            } catch (e) {
              response.error = e.toString();
              _streamOut.add(response.writeToBuffer());
              return;
            }

            var ctx = new GenerationContext(options);
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

  String get fqname => '';
  String get classname => null;
}


class GenerationOptions {
  final Map<String, String> _fieldNameOptions = <String, String>{};

  GenerationOptions([String parameter = ""]) {
    parameter = parameter.trim();
    if (parameter.isEmpty) return;
    List<String> options = parameter.split(",");
    for (var option in options) {
      List<String> nameValue = option.split("=");
      if (nameValue.length > 2) {
        throw "Illegal option '$option' ${nameValue.length}";
      }
      String name = nameValue[0].trim();
      String value;
      if (nameValue.length > 1) value = nameValue[1].trim();
      if (name == "field_name") {
        if (value == null) {
          throw "Illegal option '$option' ${nameValue.length}";
        }
        List<String> x = value.split("|");
        if (x.length != 2) {
          throw "Illegal option '$option' ${nameValue.length}";
        }
        _fieldNameOptions[".${x[0].trim()}"] = x[1].trim();
      } else {
        throw "Illegal option '$option' ${nameValue.length}";
      }
    }
  }

  String fieldNameOption(String fqname) => _fieldNameOptions[fqname];
}
