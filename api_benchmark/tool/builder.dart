// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import 'dart:async';
import 'dart:convert';

import 'package:build/build.dart';
import 'package:glob/glob.dart';

Builder benchmarkBuilder(BuilderOptions options) => _BenchmarkBuilder();

class _BenchmarkBuilder implements Builder {
  @override
  Future build(BuildStep buildStep) async {
    var data = <String, String>{};

    await for (var item in buildStep.findAssets(Glob('**/*.pb.json')).where(
        (id) =>
            id.pathSegments.length > 2 &&
            id.pathSegments[0] == 'benchmark' &&
            id.pathSegments[1] == 'data')) {
      data[item.pathSegments.skip(2).join('/')] =
          await buildStep.readAsString(item);
    }

    await buildStep.writeAsString(
        AssetId(buildStep.inputId.package, 'web/data/data.json'),
        JsonEncoder.withIndent(' ').convert(data));
  }

  @override
  final buildExtensions = const {
    r'lib/$lib$': ['web/data/data.json']
  };
}
