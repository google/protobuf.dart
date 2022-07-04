#!/usr/bin/env dart

import 'dart:io' show exit, Platform, Process, Directory, ProcessResult;

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
    jobs = int.parse(parsedArgs['jobs']!);
  }

  final targets = <Target>{};
  for (final targetStr in parsedArgs['target'].split(',')) {
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

  // Arg list is immutable, clone it
  final sourceFiles = List.from(parsedArgs.rest);

  if (sourceFiles.isEmpty) {
    // Compile all files in bin/
    final dir = Directory('bin');
    for (final dirFile in dir.listSync(recursive: false)) {
      // Compiler hangs (instead of failing) when passed an .exe, so only try
      // to compile Dart files
      if (path.extension(dirFile.path) == '.dart') {
        sourceFiles.add(dirFile.path);
      }
    }
  }

  final commands = <List<String>>[];

  if (sourceFiles.isNotEmpty && targets.isNotEmpty) {
    try {
      Directory('out').createSync();
    } catch (_) {}
  }

  for (final sourceFile in sourceFiles) {
    for (final target in targets) {
      commands.add(target.compileArgs(sourceFile));
    }
  }

  final pool = Pool(jobs);

  final stream = pool.forEach<List<String>, ProcessResult>(commands,
      (List<String> command) {
    print(command.join(' '));
    return Process.run(command[0], command.sublist(1));
  });

  await for (final processResult in stream) {
    final exitCode = processResult.exitCode;
    if (exitCode != 0) {
      print('Process exited with $exitCode');
      print(
          'Process stdout ---------------------------------------------------');
      print(processResult.stdout);
      print(
          'Process stderr ---------------------------------------------------');
      print(processResult.stderr);
      print(
          '------------------------------------------------------------------');
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
  // This is used in golem "...-dart2js-production" benchmarks.
  // `--benchmarking-production` is not documented, it enables
  // `--omit-implicit-checks` and `--trust-primitives`:
  // https://github.com/dart-lang/sdk/blob/c48f6fea580178bd34f2d872588dcc1c79bdb01c/pkg/compiler/lib/src/options.dart#L764-L767
  //
  // We will probably want to use `-O4` here.
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return [
    'dart',
    'compile',
    'js',
    sourceFile,
    '--benchmarking-production',
    '-o',
    'out/$baseNameNoExt.production.js'
  ];
}
