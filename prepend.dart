#!/usr/bin/env dart
import 'dart:io';

main() {
  final fileName = new Options().arguments.first;
  final file = new File(fileName);
  final content = file.readAsStringSync();
  file.writeAsStringSync('#!/usr/bin/env dart\n$content');
  // For development use the line below instead of the one above to
  // avoid using the dart2dart code.
  // file.writeAsStringSync('#!/bin/bash\ndart bin/protoc_plugin.dart');
}
