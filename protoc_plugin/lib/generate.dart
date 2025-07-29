#!/usr/bin/env dart
// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// A command line utility to allow easy generation of protobuf files.
library;

import 'dart:convert';
import 'dart:io';

import 'package:args/args.dart';

import 'src/generate_utils.dart';

// TODO: update readme docs

// TODO: review the UI here

// TODO: have an option to not include defaults

// TODO: generate grpc by default?

// TODO: add tests

class ProtoGen {
  void generate(List<String> args) {
    final parser = _createArgParser();

    ArgResults results;

    try {
      results = parser.parse(args);
    } on ArgParserException catch (e) {
      _usage(e.message, parser, isFailure: true);
    }

    if (results.flag('help')) {
      _usage(
        'A wrapper around protoc to make it easier to generate Dart code from '
        'protobuf definitions.',
        parser,
      );
    }

    final out = results.option('out');
    final version = results.flag('version');
    final grpc = results.flag('grpc');
    final protoPaths = results.multiOption('proto-path');
    var protos = results.rest;

    if (out == null) {
      _usage(
        'The output directory option (--out) is required.',
        parser,
        isFailure: true,
      );
    } else {
      final outDir = Directory(out);
      if (!outDir.existsSync()) {
        outDir.createSync(recursive: true);
      }
    }

    final protoDir = Directory('protos');

    // paths

    for (final dir in protoPaths) {
      if (!Directory(dir).existsSync()) {
        _usage(
          "The --proto-path '$dir' does not exist.",
          parser,
          isFailure: true,
        );
      }
    }

    // auto-setup protoPaths
    if (protoDir.existsSync() && !protoPaths.contains(protoDir.path)) {
      protoPaths.add(protoDir.path);
    }

    final defaultProtosPath = calculateDefaultProtosPath();
    if (defaultProtosPath != null && !protoPaths.contains(defaultProtosPath)) {
      protoPaths.add(defaultProtosPath);
    }

    // files

    for (final file in protos) {
      if (!File(file).existsSync()) {
        _usage(
          "The proto file '$file' does not exist.",
          parser,
          isFailure: true,
        );
      }
    }

    // We either need an explicit list of files to compile, or that a 'protos'
    // directory exists.
    if (protos.isEmpty) {
      if (protoDir.existsSync()) {
        final protoFiles = protoDir
            .listSync(recursive: true)
            .whereType<File>()
            .where((file) => file.path.endsWith('.proto'));
        protos = protoFiles.map((file) => file.path).toList();
      } else {
        _usage('No proto files passed.', parser, isFailure: true);
      }
    }

    // detect protoc ('protoc --version')
    if (_protocVersion() == null) {
      _usage(
        '''
'protoc' not found on the path.

See installation options at: https://protobuf.dev/installation/.
    ''',
        parser,
        isFailure: true,
      );
    }

    // handle --version
    if (version) {
      print(_protocVersion());
      exit(0);
    }

    protoc(out: out, grpc: grpc, protoPaths: protoPaths, protos: protos);
  }

  void protoc({
    required String out,
    required bool grpc,
    required List<String> protoPaths,
    required List<String> protos,
  }) async {
    final execScriptHelper = TempExecScriptHelper();
    final execScript = execScriptHelper.execScript;

    final args = <String>[];
    if (grpc) {
      args.add('--dart_out=grpc:$out');
    } else {
      args.add('--dart_out=$out');
    }
    args.add('--plugin=${execScript.absolute.path}');
    args.addAll([...(protoPaths.map((p) => '--proto_path=$p'))]);
    args.addAll(protos);

    // todo:
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

    execScriptHelper.dispose();
  }

  static ArgParser _createArgParser() {
    final parser = ArgParser();

    parser.addFlag(
      'help',
      abbr: 'h',
      negatable: false,
      help: 'Print this usage information.',
    );
    parser.addFlag(
      'version',
      negatable: false,
      help: 'Display the protoc version in use.',
    );
    parser.addMultiOption(
      'proto-path',
      valueHelp: 'directory',
      help: 'Specify the directories in which to search for imported protos.',
    );
    parser.addOption(
      'out',
      defaultsTo: 'lib/src/gen',
      valueHelp: 'directory',
      help: 'The output directory for the generated code.',
    );
    parser.addFlag(
      'grpc',
      negatable: false,
      help: 'Generate gRPC service classes.',
    );

    return parser;
  }

  Never _usage(String message, ArgParser parser, {bool isFailure = false}) {
    stderr.writeln(message);
    stderr.writeln();
    stderr.writeln(
      'usage: dart run protoc_plugin:generate [options] <proto files>',
    );
    stderr.writeln(parser.usage);
    exit(isFailure ? 64 : 0);
  }

  static String? _protocVersion() {
    final result = Process.runSync('protoc', ['--version']);
    return result.exitCode == 0 ? (result.stdout as String).trim() : null;
  }
}
