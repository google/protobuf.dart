#!/usr/bin/env dart

import 'dart:io' show exit, Platform, Process, Directory;

import 'package:args/args.dart' show ArgParser;
import 'package:path/path.dart' as path;
import 'package:pool/pool.dart' show Pool;

Future<void> main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('target', mandatory: false, defaultsTo: 'jit,aot,js');
  final parsedArgs = argParser.parse(args);

  var targets = <Target>{};
  for (final targetStr in parsedArgs['target'].split(',')) {
    switch (targetStr) {
      case 'jit':
        targets.add(jitTarget);
        break;

      case 'aot':
        targets.add(aotTarget);
        break;

      case 'js':
        targets.add(jsTarget);
        break;

      default:
        print(
            'Unsupported target: $targetStr. Supported targets: jit, aot, js');
        exit(1);
    }
  }

  // Arg list is immutable, clone it
  var sourceFiles = List.from(parsedArgs.rest);

  if (sourceFiles.isEmpty) {
    // Compile all files in bin/
    final dir = Directory('bin');
    for (final dirFile in dir.listSync(recursive: false)) {
      sourceFiles.add(dirFile.path);
    }
  }

  final numCpus = Platform.numberOfProcessors;
  final pool = Pool(numCpus);
  final processes = [];

  for (final sourceFile in sourceFiles) {
    for (final target in targets) {
      final resource = await pool.request();
      processes.add(target.compile(sourceFile));
      resource.release();
    }
  }

  for (final process in processes) {
    final process_ = await process;
    final exitCode = await process_.exitCode;
    if (exitCode != 0) {
      print('Process returned exit code $exitCode');
      exit(1);
    }
  }
}

class Target {
  final String _name;
  final List<String> Function(String) _processArgs;

  const Target(this._name, this._processArgs);

  @override
  String toString() {
    return 'Target($_name)';
  }

  Future<Process> compile(String sourceFile) {
    final processArgs = _processArgs(sourceFile);
    print(processArgs.join(' '));
    return Process.start(processArgs[0], processArgs.sublist(1));
  }
}

const jitTarget = Target('jit', jitProcessArgs);
const aotTarget = Target('aot', aotProcessArgs);
const jsTarget = Target('js', jsProcessArgs);

List<String> jitProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  return [
    'dart',
    '--snapshot-kind=kernel',
    '--snapshot=out/$baseName.dill',
    sourceFile
  ];
}

List<String> aotProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ['dart', 'compile', 'exe', sourceFile, '-o', 'out/$baseNameNoExt.exe'];
}

List<String> jsProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ['dart', 'compile', 'js', sourceFile, '-o', 'out/$baseNameNoExt.js'];
}
