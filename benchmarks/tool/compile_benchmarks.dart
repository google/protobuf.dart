#!/usr/bin/env dart

import 'dart:io' show exit, Platform, Process, Directory;

import 'package:args/args.dart' show ArgParser;
import 'package:path/path.dart' as path;
import 'package:pool/pool.dart' show Pool;

Future<void> main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('target', mandatory: false, defaultsTo: 'jit,aot,js')
    ..addOption('jobs', abbr: 'j', mandatory: false);

  final parsedArgs = argParser.parse(args);

  var jobs = Platform.numberOfProcessors;
  if (parsedArgs['jobs'] != null) {
    jobs = int.parse(parsedArgs['jobs']!);
  }

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

  final commands = [];

  for (final sourceFile in sourceFiles) {
    for (final target in targets) {
      commands.add(target.compileArgs(sourceFile));
    }
  }

  final pool = Pool(jobs);

  final stream = pool.forEach(commands, (a) async {
    var command = a as List<String>;
    print(command.join(' '));
    return Process.run(command[0], command.sublist(1));
  });

  await for (final processResult in stream) {
    final exitCode = processResult.exitCode;
    if (exitCode != 0) {
      print('Process returned exit code $exitCode');
      exit(1);
    }
  }

  await pool.done;
}

class Target {
  final String _name;
  final List<String> Function(String) _processArgs;

  const Target(this._name, this._processArgs);

  @override
  String toString() {
    return 'Target($_name)';
  }

  List<String> compileArgs(String sourceFile) {
    return _processArgs(sourceFile);
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
