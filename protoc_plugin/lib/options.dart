// Copyright (c) 2014, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protoc;

/// Helper function implementing a generic option parser that reads
/// `request.parameters` and treats each token as either a flag ("name") or a
/// key-value pair ("name=value"). For each option "name", it looks up whether a
/// [SingleOptionParser] exists in [parsers] and delegates the actual parsing of
/// the option to it. Returns `true` if no errors were reported.
bool genericOptionsParser(CodeGeneratorRequest request,
    CodeGeneratorResponse response, Map<String, SingleOptionParser> parsers) {
  var parameter = request.parameter != null ? request.parameter : '';
  var options = parameter.trim().split(',');
  var errors = [];

  for (var option in options) {
    option = option.trim();
    if (option.isEmpty) continue;
    void reportError(String details) {
      errors.add('Error found trying to parse the option: $option.\n$details');
    }

    var nameValue = option.split('=');
    if (nameValue.length != 1 && nameValue.length != 2) {
      reportError('Options should be a single token, or a name=value pair');
      continue;
    }
    var name = nameValue[0].trim();
    var parser = parsers[name];
    if (parser == null) {
      reportError('Unknown option ($name).');
      continue;
    }

    var value = nameValue.length > 1 ? nameValue[1].trim() : null;
    parser.parse(name, value, reportError);
  }

  if (errors.length == 0) return true;

  response.error = errors.join('\n');
  return false;
}

/// Options expected by the protoc code generation compiler.
class GenerationOptions {
  final bool useGrpc;

  GenerationOptions({this.useGrpc = false});
}

/// A parser for a name-value pair option. Options parsed in
/// [genericOptionsParser] delegate to instances of this class to
/// parse the value of a specific option.
abstract class SingleOptionParser {
  /// Parse the [name]=[value] value pair and report any errors to [onError]. If
  /// the option is a flag, [value] will be null. Note, [name] is commonly
  /// unused. It is provided because [SingleOptionParser] can be registered for
  /// multiple option names in [genericOptionsParser].
  void parse(String name, String value, onError(String details));
}

class GrpcOptionParser implements SingleOptionParser {
  bool grpcEnabled = false;

  @override
  void parse(String name, String value, onError(String details)) {
    if (value != null) {
      onError('Invalid grpc option. No value expected.');
      return;
    }
    grpcEnabled = true;
  }
}

/// Parser used by the compiler, which supports the `rpc` option (see
/// [RpcOptionParser]) and any additional option added in [parsers]. If
/// [parsers] has a key for `rpc`, it will be ignored.
GenerationOptions parseGenerationOptions(
    CodeGeneratorRequest request, CodeGeneratorResponse response,
    [Map<String, SingleOptionParser> parsers]) {
  final newParsers = <String, SingleOptionParser>{};
  if (parsers != null) newParsers.addAll(parsers);

  final grpcOptionParser = new GrpcOptionParser();
  newParsers['grpc'] = grpcOptionParser;

  if (genericOptionsParser(request, response, newParsers)) {
    return new GenerationOptions(useGrpc: grpcOptionParser.grpcEnabled);
  }
  return null;
}
