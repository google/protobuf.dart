// Copyright (c) 2018, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

part of protobuf;

class JsonNameMapper extends JsonMapper {
  @override
  Map<String, dynamic> writeToJsonMap(_FieldSet fs) {
    var result = <String, dynamic>{};
    for (var fi in fs._infosSortedByTag) {
      var value = fs._values[fi.index];
      if (value == null || (value is List && value.isEmpty)) {
        continue; // It's missing, repeated, or an empty byte array.
      }
      result['${fi.name}'] = _convertToMap(value, fi.type);
    }
    if (fs._hasExtensions) {
      for (int tagNumber in sorted(fs._extensions._tagNumbers)) {
        var value = fs._extensions._values[tagNumber];
        if (value is List && value.isEmpty) {
          continue; // It's repeated or an empty byte array.
        }
        var fi = fs._extensions._getInfoOrNull(tagNumber);
        result['${fi.name}'] = _convertToMap(value, fi.type);
      }
    }
    return result;
  }

  @override
  void mergeFromJsonMap(
      _FieldSet fs, Map<String, dynamic> json, ExtensionRegistry registry) {
    for (String key in json.keys) {
      var fi = fs._meta.byName[key];
      if (fi == null) {
        if (registry == null) continue; // Unknown tag; skip
        fi = registry.getExtension(fs._messageName, int.parse(key));
        if (fi == null) continue; // Unknown tag; skip
      }
      if (fi.isRepeated) {
        _appendJsonList(fs, json[key], fi, registry);
      } else {
        _setJsonField(fs, json[key], fi, registry);
      }
    }
  }
}
