#!/usr/bin/env dart
import 'dart:io';

main() {
  final fileName = new Options().arguments.first;
  final file = new File(fileName);
  final content = file.readAsStringSync();
  file.writeAsStringSync('#!/usr/bin/env dart\n$content');
}
