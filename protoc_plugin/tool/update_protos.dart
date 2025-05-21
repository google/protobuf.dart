// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

/// Run this script to update to the latest google/protobuf and googleapis
/// protobufs.
library;

import 'dart:io';

void main(List<String> args) async {
  final cacheDir = Directory('.dart_tool/protoc_plugin');
  final protobufDir = Directory('${cacheDir.path}/protobuf');
  final googleapisDir = Directory('${cacheDir.path}/googleapis');

  final destDir = Directory('protos');

  // Update from protocolbuffers/protobuf.
  if (protobufDir.existsSync()) {
    await git(['pull'], cwd: protobufDir);
  } else {
    await git([
      'clone',
      'https://github.com/protocolbuffers/protobuf.git',
      '--depth',
      '1',
    ], cwd: cacheDir);
  }

  copy(protobufDir, destDir, 'src', [
    'google/protobuf/compiler/plugin.proto',
    'google/protobuf/descriptor.proto',
    'google/protobuf/duration.proto',
  ]);

  print('');

  // Update from googleapis/googleapis.
  if (googleapisDir.existsSync()) {
    await git(['pull'], cwd: googleapisDir);
  } else {
    await git([
      'clone',
      'https://github.com/googleapis/googleapis.git',
      '--depth',
      '1',
    ], cwd: cacheDir);
  }

  copy(googleapisDir, destDir, '', [
    'google/api/client.proto',
    'google/api/http.proto',
    'google/api/launch_stage.proto',
    'google/api/routing.proto',
  ]);
}

Future<void> git(List<String> args, {required Directory cwd}) async {
  print('git ${args.join(' ')} [${cwd.path}]');

  if (!cwd.existsSync()) {
    cwd.createSync(recursive: true);
  }

  final result = await Process.run('git', args, workingDirectory: cwd.path);
  stdout.write(result.stdout);
  stderr.write(result.stderr);
  if (result.exitCode != 0) {
    exitCode = result.exitCode;
    throw 'git exited with ${result.exitCode}';
  }
}

void copy(Directory from, Directory to, String fromPrefix, List<String> files) {
  print('copying ${from.path} => ${to.path}');

  if (fromPrefix.isNotEmpty) {
    fromPrefix = '$fromPrefix/';
  }

  for (final file in files) {
    final source = File('${from.path}/$fromPrefix$file');
    final target = File('${to.path}/$file');

    if (!target.parent.existsSync()) {
      target.parent.createSync(recursive: true);
    }

    if (!target.existsSync() ||
        target.readAsStringSync() != source.readAsStringSync()) {
      print('  $file');
      target.writeAsStringSync(source.readAsStringSync());
    }
  }
}
