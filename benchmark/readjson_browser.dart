// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

import "dart:html" show querySelector;

import 'lib/suites/json.dart' show jsonSuite;
import 'lib/dashboard.dart' show showDashboard;

main() => showDashboard(jsonSuite, querySelector("#dashboard"));
