#!/usr/bin/env dart

import 'dart:io' show exit, Platform, Process, Directory, ProcessResult;

import 'package:args/args.dart' show ArgParser;
import 'package:path/path.dart' as path;
import 'package:pool/pool.dart' show Pool;

Future<void> main(List<String> args) async {
  final argParser = ArgParser()
    ..addOption('target',
        mandatory: false, defaultsTo: 'exe,jit,js,js-production')
    ..addOption('jobs', abbr: 'j', mandatory: false)
    ..addOption('aot-target', mandatory: false, defaultsTo: 'x64');

  final parsedArgs = argParser.parse(args);

  var jobs = Platform.numberOfProcessors;
  if (parsedArgs['jobs'] != null) {
    jobs = int.parse(parsedArgs['jobs']!);
  }

  final targets = <Target>{};
  for (final targetStr in parsedArgs['target'].split(',')) {
    switch (targetStr) {
      case 'aot':
        if (!bool.hasEnvironment("DART_SDK")) {
          print('\$DART_SDK needs to be set when generating aot snapshots');
          exit(1);
        }
        final dartSdkPath = String.fromEnvironment("DART_SDK");

        final parsedAotTarget = parsedArgs['aot-target'];
        final aotTarget = aotTargets[parsedAotTarget];
        if (aotTarget == null) {
          print('Unsupported aot target: $parsedAotTarget');
          print(
              'Supported aot targets: ${aotTargets.keys.toList().join(', ')}');
          exit(1);
        }

        targets.add(makeAotTarget(dartSdkPath, aotTarget));
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

  final commands = <ProcessInstructions>[];

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

  final stream = pool.forEach<ProcessInstructions, CompileProcess>(commands,
      (ProcessInstructions command) async {
    var envStr = '';
    if (command.environment != null) {
      envStr = command.environment!.entries
              .map((entry) => '${entry.key}=${entry.value}')
              .join(' ') +
          ' ';
    }
    final commandStr =
        '$envStr${command.executable} ${command.arguments.join(' ')}';
    print(commandStr);

    final result = await Process.run(command.executable, command.arguments,
        environment: command.environment);
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

/// Stores [Process.run] arguments
class ProcessInstructions {
  final String executable;
  final List<String> arguments;
  final Map<String, String>? environment;

  ProcessInstructions(this.executable, this.arguments, {this.environment});
}

/// Supported aot snapshot targets
enum AotTarget {
  x64,
  armv7hf,
  armv8,
}

/// Mapping of `--aot-target` arguments to their [AotTarget]s
const aotTargets = <String, AotTarget>{
  'x64': AotTarget.x64,
  'armv7hf': AotTarget.armv7hf,
  'armv8': AotTarget.armv8,
};

/// Packs a debug string for a command being run to the command's result, to be
/// able to show which command failed and why
class CompileProcess {
  final String command;
  final ProcessResult result;

  CompileProcess(this.command, this.result);
}

class Target {
  final String _name;
  final ProcessInstructions Function(String sourceFile) _processArgs;

  const Target(this._name, this._processArgs);

  @override
  String toString() {
    return 'Target($_name)';
  }

  ProcessInstructions compileArgs(String sourceFile) {
    return _processArgs(sourceFile);
  }
}

Target makeAotTarget(String dartSdkPath, AotTarget aotTarget) {
  return Target('aot', (sourceFile) {
    final baseName = path.basename(sourceFile);
    final baseNameNoExt = path.withoutExtension(baseName);
    // TODO: Do we need `-Ddart.vm.product=true`?
    return ProcessInstructions('$dartSdkPath/pkg/vm/tool/precompiler2',
        [sourceFile, 'out/$baseNameNoExt.aot']);
  });
}

const aotTarget = Target('aot', aotProcessArgs);
const exeTarget = Target('exe', exeProcessArgs);
const jitTarget = Target('jit', jitProcessArgs);
const jsTarget = Target('js', jsProcessArgs);
const jsProductionTarget = Target('js-production', jsProductionProcessArgs);

ProcessInstructions aotProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ProcessInstructions('dart',
      ['compile', 'aot-snapshot', sourceFile, '-o', 'out/$baseNameNoExt.aot']);
}

ProcessInstructions exeProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ProcessInstructions(
      'dart', ['compile', 'exe', sourceFile, '-o', 'out/$baseNameNoExt.exe']);
}

ProcessInstructions jitProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ProcessInstructions('dart', [
    '--snapshot-kind=kernel',
    '--snapshot=out/$baseNameNoExt.dill',
    sourceFile
  ]);
}

ProcessInstructions jsProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ProcessInstructions(
      'dart', ['compile', 'js', sourceFile, '-o', 'out/$baseNameNoExt.js']);
}

ProcessInstructions jsProductionProcessArgs(String sourceFile) {
  final baseName = path.basename(sourceFile);
  final baseNameNoExt = path.withoutExtension(baseName);
  return ProcessInstructions('dart', [
    'compile',
    'js',
    sourceFile,
    '-O4',
    '-o',
    'out/$baseNameNoExt.production.js'
  ]);
}
