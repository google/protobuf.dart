#!/usr/bin/env dart

import 'dart:io' show Directory, Platform, Process, ProcessResult, exit;

import 'package:args/args.dart' show ArgParser;
import 'package:path/path.dart' as path;
import 'package:pool/pool.dart' show Pool;

Future<void> main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('target',
        mandatory: false, defaultsTo: 'aot,exe,jit,js,js-production')
    ..addOption('jobs', abbr: 'j', mandatory: false);

  final parsedArgs = argParser.parse(args);

  var jobs = Platform.numberOfProcessors;
  if (parsedArgs['jobs'] != null) {
    jobs = int.parse(parsedArgs['jobs'] as String);
  }

  final targets = <Target>{};
  for (final targetStr in (parsedArgs['target'] as String).split(',')) {
    switch (targetStr) {
      case 'aot':
        targets.add(aotTarget);
        break;

      case 'exe':
        targets.add(exeTarget);
        break;

      case 'jit':
        targets.add(jitTarget);
        break;

      case 'js':
        targets.add(jsTarget);
        break;

      case 'js-production':
        targets.add(jsProductionTarget);
        break;

      default:
        print(
            'Unsupported target: $targetStr. Supported targets: aot, exe, jit, js, js-production');
        exit(1);
    }
  }

  var sourceFiles = parsedArgs.rest;

  if (sourceFiles.isEmpty) {
    // Compile all files in bin/
    sourceFiles = Directory('bin')
        .listSync(recursive: false)
        .where((dirFile) => path.extension(dirFile.path) == '.dart')
        .map((dirFile) => dirFile.path)
        .toList();
  }

  final commands = <List<String>>[];

  if (sourceFiles.isNotEmpty && targets.isNotEmpty) {
    try {
      Directory('out').createSync(recursive: true);
    } catch (e) {
      print("Error while creating 'out' directory: $e");
      exit(1);
    }
  }

  for (final sourceFile in sourceFiles) {
    for (final target in targets) {
      commands.add(target.compileArgs(sourceFile));
    }
  }

  final pool = Pool(jobs);

  final stream = pool.forEach<List<String>, CompileProcess>(commands,
      (List<String> command) async {
    final commandStr = command.join(' ');
    print(commandStr);
    final result = await Process.run(command[0], command.sublist(1));
    return CompileProcess(commandStr, result);
  });

  await for (final compileProcess in stream) {
    final exitCode = compileProcess.result.exitCode;
    if (exitCode != 0) {
      print('Process exited with $exitCode');
      print('Command: ${compileProcess.command}');
      print(
          'Process stdout ---------------------------------------------------');
      print(compileProcess.result.stdout);
      print(
          'Process stderr ---------------------------------------------------');
      print(compileProcess.result.stderr);
      print(
          '------------------------------------------------------------------');
      exit(1);
    }
  }

  await pool.done;
}

class CompileProcess {
  final String command;
  final ProcessResult result;

  CompileProcess(this.command, this.result);
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

const aotTarget = Target('aot', aotProcessArgs);
const exeTarget = Target('exe', exeProcessArgs);
const jitTarget = Target('jit', jitProcessArgs);
const jsTarget = Target('js', jsProcessArgs);
const jsProductionTarget = Target('js-production', jsProductionProcessArgs);

List<String> aotProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return [
    'dart',
    'compile',
    'aot-snapshot',
    sourceFile,
    '-o',
    'out/$baseNameNoExt.aot'
  ];
}

List<String> exeProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ['dart', 'compile', 'exe', sourceFile, '-o', 'out/$baseNameNoExt.exe'];
}

List<String> jitProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return [
    'dart',
    '--snapshot-kind=kernel',
    '--snapshot=out/$baseNameNoExt.dill',
    sourceFile
  ];
}

List<String> jsProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ['dart', 'compile', 'js', sourceFile, '-o', 'out/$baseNameNoExt.js'];
}

List<String> jsProductionProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return [
    'dart',
    'compile',
    'js',
    sourceFile,
    '-O4',
    '-o',
    'out/$baseNameNoExt.production.js'
  ];
}
