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
        .fold(new BytesBuilder(), (builder, data) => builder..add(data))
        .then((builder) => builder.takeBytes())
        .then((List<int> bytes) {
            var request = new CodeGeneratorRequest.fromBuffer(bytes);
            var response = new CodeGeneratorResponse();

            // Parse the options in the request. Return the errors is any.
            var options = new GenerationOptions(request, response);
            if (options == null) {
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
  final Map<String, String> fieldNameOptions;

  GenerationOptions._(this.fieldNameOptions);

  // Parse the options in the request. If there was an error in the
  // options null is returned and the error is set on the response.
  factory GenerationOptions(request, response) {
    var fieldNameOptions = <String, String>{};
    var parameter = request.parameter != null ? request.parameter : '';
    List<String> options = parameter.trim().split(',');
    List<String> errors = [];
    for (var option in options) {
      option = option.trim();
      if (option.isEmpty) continue;
      List<String> nameValue = option.split('=');
      if (nameValue.length != 1 && nameValue.length != 2) {
        errors.add('Illegal option: $option');
        continue;
      }
      String name = nameValue[0].trim();
      String value;
      if (nameValue.length > 1) value = nameValue[1].trim();
      if (name == 'field_name') {
        if (value == null) {
          errors.add('Illegal option: $option');
          continue;
        }
        List<String> fromTo = value.split('|');
        if (fromTo.length != 2) {
          errors.add('Illegal option: $option');
          continue;
        }
        var fromName = fromTo[0].trim();
        var toName = fromTo[1].trim();
        if (fromName.length == 0 || toName.length == 0) {
          errors.add('Illegal option: $option');
          continue;
        }
        fieldNameOptions['.$fromName'] = toName;
      } else {
        errors.add('Illegal option: $option');
      }
    }
    if (errors.length > 0) {
      response.error = errors.join('\n');
      return null;
    } else {
      return new GenerationOptions._(fieldNameOptions);
    }
  }

  String fieldNameOption(String fqname) => fieldNameOptions[fqname];
}
