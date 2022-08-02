// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

export 'readfile_vm.dart' if (dart.library.js) 'readfile_d8.dart' show readfile;
