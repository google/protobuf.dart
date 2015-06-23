library protoc;

import 'dart:async';
import 'dart:io';

import 'package:protobuf/protobuf.dart';
import 'package:protobuf/mixins_meta.dart';
import 'package:path/path.dart' as path;

import 'src/descriptor.pb.dart';
import 'src/plugin.pb.dart';
import 'src/dart_options.pb.dart';

part 'code_generator.dart';
part 'enum_generator.dart';
part 'exceptions.dart';
part 'extension_generator.dart';
part 'file_generator.dart';
part 'indenting_writer.dart';
part 'message_generator.dart';
part 'options.dart';
part 'output_config.dart';
part 'protobuf_field.dart';
part 'writer.dart';
