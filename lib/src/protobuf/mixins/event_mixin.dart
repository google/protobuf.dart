// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protobuf.mixins.event;

import "dart:async" show Stream, StreamController;
import "dart:collection" show UnmodifiableListView;

import "package:protobuf/protobuf.dart"
    show GeneratedMessage, EventPlugin, EventGroup, ListEventPlugin;

/// Provides a stream of changes to fields in a GeneratedMessage.
/// (Experimental.)
///
/// This mixin is enabled via an option in
/// dart_options.proto in dart-protoc-plugin.
abstract class PbEventMixin {
  final eventPlugin = new EventBuffer();

  /// Changes to fields in the GeneratedMessage.
  ///
  /// Each item in the stream is a group of related changes made
  /// by one GeneratedMessage method call.
  Stream<List<PbFieldChange>> get changes => eventPlugin.changes;
}

/// A change to a field in a GeneratedMessage.
class PbFieldChange {
  final GeneratedMessage message;
  final int tag;
  final oldValue;
  final newValue;
  PbFieldChange(this.message, this.tag, this.oldValue, this.newValue);
}

/// A buffering implementation of event delivery.
/// (Loosely based on package:observe's ChangeNotifier.)
class EventBuffer extends EventPlugin {

  // An EventBuffer is created for each GeneratedMessage, so
  // initialization should be fast; create fields lazily.

  GeneratedMessage _parent;
  StreamController<List<PbFieldChange>> _controller;

  // _buffer is non-null when observing field changes.
  // It should be non-null only inside a group.
  List<PbFieldChange> _buffer;

  // Non-null if we're in a group.
  EventGroup _outerGroup;

  // Non-empty if we're in a nested group.
  List<EventGroup> _groupStack;

  @override
  void attach(GeneratedMessage newParent) {
    assert(_parent == null);
    _parent = newParent;
  }

  // Returns the currently active event groups (for debugging).
  List<String> get groupStack {
    if (_outerGroup == null) return [];
    var result = [_outerGroup];
    if (_groupStack != null) result.addAll(_groupStack);
    return result;
  }

  Stream<List<PbFieldChange>> get changes {
    if (_controller == null) {
      _controller = new StreamController.broadcast(sync: true);
    }
    return _controller.stream;
  }

  @override
  bool startGroup(EventGroup group) {
    assert(group != null);
    if (_outerGroup == null) {
      if (_controller == null || !_controller.hasListener) {
        // skip events for this group (don't enter group)
        return false;
      }
      _outerGroup = group;
      _buffer = <PbFieldChange>[];
      return true;
    } else {
      assert(_buffer != null);

      // enter nested group
      if (_groupStack == null) _groupStack = <EventGroup>[];
      _groupStack.add(group);
      return true;
    }
  }

  @override
  void endGroup(EventGroup group) {
    if (_groupStack != null && _groupStack.isNotEmpty) {
      // exit nested group
      var startGroup = _groupStack.removeLast();
      assert(group == startGroup);
      return;
    }

    assert(_outerGroup == group);
    assert(_buffer != null);

    // exit outer group
    _outerGroup = null;

    // send any events
    if (_controller != null && _controller.hasListener && _buffer.isNotEmpty) {
      _controller.add(new UnmodifiableListView(_buffer));
    }
    _buffer = null;
  }

  @override
  void beforeSetField(int tag, newValue) {
    var oldValue = _parent.getFieldOrNull(tag);
    if (oldValue == null) oldValue = _parent.getDefaultForField(tag);
    if (identical(oldValue, newValue)) return;
    _buffer.add(new PbFieldChange(_parent, tag, oldValue, newValue));
  }

  @override
  void beforeClearField(int tag) {
    var oldValue = _parent.getFieldOrNull(tag);
    if (oldValue == null) return;
    var newValue = _parent.getDefaultForField(tag);
    _buffer.add(new PbFieldChange(_parent, tag, oldValue, newValue));
  }
}
