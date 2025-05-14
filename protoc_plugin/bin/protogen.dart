#!/usr/bin/env dart
// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';
import 'package:path/path.dart' as path;

const String description =
    'A wrapper around protoc to make it easier to generate Dart code from '
    'protobuf definitions.';

const String usage = 'usage: dart bin/protogen.dart [options] <proto files>';

void main(List<String> args) {
  final parser = createArgParser();

  ArgResults results;

  try {
    results = parser.parse(args);
  } on ArgParserException catch (e) {
    _usage(e.message, parser, isFailure: true);
  }

  if (results.flag('help')) {
    _usage(description, parser);
  }

  final out = results.option('out');
  final version = results.flag('version');
  final grpc = results.flag('grpc');
  final protoPaths = results.multiOption('proto-path');
  final protos = results.rest;

  if (out == null) {
    _usage('The output directory option (--out) is required.', parser,
        isFailure: true);
  }

  if (protos.isEmpty) {
    _usage('No proto files passed.', parser, isFailure: true);
  }

  for (final dir in protoPaths) {
    if (!Directory(dir).existsSync()) {
      _usage("The --proto-path '$dir' does not exist.", parser,
          isFailure: true);
    }
  }

  for (final file in protos) {
    if (!File(file).existsSync()) {
      _usage("The proto file '$file' does not exist.", parser, isFailure: true);
    }
  }

  // detect protoc ('protoc --version')
  if (_protocVersion() == null) {
    _usage('''
'protoc' not found on the path.

See installation options at: https://protobuf.dev/installation/.
    ''', parser, isFailure: true);
  }

  // handle --version
  if (version) {
    print(_protocVersion());
    exit(0);
  }

  protoc(
    out: out,
    grpc: grpc,
    protoPaths: protoPaths,
    protos: protos,
  );
}

void protoc({
  required String out,
  required bool grpc,
  required List<String> protoPaths,
  required List<String> protos,
}) async {
// protoc --dart_out=grpc:lib/protos \
//   --plugin=/Users/devoncarew/.../protoc_plugin/bin/protoc-gen-dart \
//   --proto_path=protos \
//   protos/google/firestore/v1/*.proto \
//   protos/google/protobuf/*.proto \
//   protos/google/rpc/*.proto \
//   protos/google/type/*.proto

  final script = Platform.script.toFilePath();
  // ignore: non_constant_identifier_names
  final gen_dart = path.join(path.dirname(script), 'protoc-gen-dart');

  final args = <String>[];
  if (grpc) {
    args.add('--dart_out=grpc:$out');
  } else {
    args.add('--dart_out=$out');
  }
  args.add('--plugin=$gen_dart');
  args.addAll([
    ...(protoPaths.map((p) => '--proto_path=$p')),
  ]);
  args.addAll(protos);

  print('protoc ${args.join(' ')}');
  print('');

  final process = await Process.start('protoc', args);
  process.stdout.transform(const Utf8Decoder()).listen((line) {
    stdout.writeln(line);
  });
  process.stderr.transform(const Utf8Decoder()).listen((line) {
    stderr.writeln(line);
  });
  exitCode = await process.exitCode;
}

ArgParser createArgParser() {
  final parser = ArgParser();

  parser.addFlag('help',
      abbr: 'h', negatable: false, help: 'Print this usage information.');
  parser.addFlag('version',
      negatable: false, help: 'Display the protoc version in use.');
  parser.addOption('out',
      valueHelp: 'directory',
      help: 'The output directory for the generated code.');
  parser.addFlag('grpc',
      negatable: false, help: 'Generate gRPC service classes.');
  parser.addMultiOption('proto-path',
      valueHelp: 'directory',
      help: 'Specify the directories in which to search for imported protos.');

  return parser;
}

Never _usage(String message, ArgParser parser, {bool isFailure = false}) {
  stderr.writeln(message);
  stderr.writeln();
  stderr.writeln(usage);
  stderr.writeln(parser.usage);
  exit(isFailure ? 64 : 0);
}

String? _protocVersion() {
  final result = Process.runSync('protoc', ['--version']);
  return result.exitCode == 0 ? (result.stdout as String).trim() : null;
}
