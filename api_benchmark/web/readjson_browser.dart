// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:html" show querySelector;

import 'package:api_benchmark/suites/json.dart' show jsonSuite;
import 'package:api_benchmark/dashboard.dart' show showDashboard;

main() => showDashboard(jsonSuite, querySelector("#dashboard"));
