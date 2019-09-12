library protoc;

import 'dart:async';
import 'dart:io';

import 'package:dart_style/dart_style.dart';
import 'package:protobuf/protobuf.dart';
import 'package:path/path.dart' as path;

import 'src/dart_options.pb.dart';
import 'src/descriptor.pb.dart';
import 'src/plugin.pb.dart';

import 'const_generator.dart' show writeJsonConst;
import 'indenting_writer.dart';
import 'names.dart';
import 'mixins.dart';

part 'base_type.dart';
part 'client_generator.dart';
part 'code_generator.dart';
part 'enum_generator.dart';
part 'extension_generator.dart';
part 'file_generator.dart';
part 'grpc_generator.dart';
part 'linker.dart';
part 'message_generator.dart';
part 'options.dart';
part 'output_config.dart';
part 'protobuf_field.dart';
part 'service_generator.dart';
part 'well_known_types.dart';
