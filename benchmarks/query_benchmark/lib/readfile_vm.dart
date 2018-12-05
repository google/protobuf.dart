import 'dart:io';

List<int> readfile(String path) {
  return new File(path).readAsBytesSync();
}
