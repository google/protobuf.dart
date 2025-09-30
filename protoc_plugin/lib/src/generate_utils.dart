// Copyright (c) 2025, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:io';

import 'package:path/path.dart' as path;

import 'shared.dart';

String? calculateDefaultProtosPath() {
  var protocPath = which('protoc');
  if (protocPath == null) {
    return null;
  }

  // resolve any symlink
  if (FileSystemEntity.isLinkSync(protocPath)) {
    final link = Link(protocPath);
    protocPath = link.resolveSymbolicLinksSync();
  }

  // return the include dir
  // "29.3/bin/protoc-29.3.0" ==> "29.3/include"
  final rootDir = path.dirname(path.dirname(protocPath));
  final includeDir = Directory(path.join(rootDir, 'include'));
  return includeDir.existsSync() ? includeDir.path : null;
}

/// todo: doc
class TempExecScriptHelper {
  late final Directory _tempDir;
  late final File execScript;

  TempExecScriptHelper() {
    _tempDir = Directory.systemTemp.createTempSync();
    execScript = _createTempExecScript(_tempDir);
  }

  void dispose() {
    if (_tempDir.existsSync()) {
      _tempDir.deleteSync(recursive: true);
    }
  }

  static File _createTempExecScript(Directory parentDir) {
    final name = Platform.isWindows ? 'protoc-gen-dart.bat' : 'protoc-gen-dart';
    final file = File(path.join(parentDir.path, name));

    if (Platform.isWindows) {
      file.writeAsStringSync(r'''
@echo off
dart run protoc_plugin -c "$@"
''');
    } else {
      file.writeAsStringSync(r'''
#!/bin/bash
dart run protoc_plugin -c "$@"
''');

      Process.runSync('chmod', ['+x', file.absolute.path]);
    }

    return file;
  }
}
