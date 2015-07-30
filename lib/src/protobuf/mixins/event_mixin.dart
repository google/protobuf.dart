// Copyright (c) 2015, the Dart project authors.  Please see the AUTHORS file
// for details. All rights reserved. Use of this source code is governed by a
// BSD-style license that can be found in the LICENSE file.

library protobuf.mixins.event;

import "dart:async" show Stream, StreamController, scheduleMicrotask;
import "dart:collection" show UnmodifiableListView;

import "package:protobuf/protobuf.dart"
    show GeneratedMessage, EventPlugin, ListEventPlugin;

/// Provides a stream of changes to fields in a GeneratedMessage.
/// (Experimental.)
///
/// This mixin is enabled via an option in
/// dart_options.proto in dart-protoc-plugin.
abstract class PbEventMixin {
  final eventPlugin = new EventBuffer();

  /// A stream of changes to fields in the GeneratedMessage.
  ///
  /// Events are buffered and delivered via a microtask or in
  /// the next call to [deliverChanges], whichever happens first.
  Stream<List<PbFieldChange>> get changes => eventPlugin.changes;

  /// Delivers buffered field change events synchronously,
  /// instead of waiting for the microtask to run.
  ///
  /// Returns false if no events were queued.
  bool deliverChanges() => eventPlugin.deliverChanges();
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

  // If _buffer is non-null, at least one event is in the buffer
  // and a microtask has been scheduled to empty it.
  List<PbFieldChange> _buffer;

  @override
  void attach(GeneratedMessage newParent) {
    assert(_parent == null);
    _parent = newParent;
  }

  Stream<List<PbFieldChange>> get changes {
    if (_controller == null) {
      _controller = new StreamController.broadcast(sync: true);
    }
    return _controller.stream;
  }

  bool get hasObservers => _controller != null && _controller.hasListener;

  void deliverChanges() {
    var records = _buffer;
    _buffer = null;
    if (records != null && hasObservers) {
      _controller.add(new UnmodifiableListView<PbFieldChange>(records));
    }
  }

  void addEvent(PbFieldChange change) {
    if (!hasObservers) return;
    if (_buffer == null) {
      _buffer = <PbFieldChange>[];
      scheduleMicrotask(deliverChanges);
    }
    _buffer.add(change);
  }

  @override
  void beforeSetField(int tag, newValue) {
    var oldValue = _parent.getFieldOrNull(tag);
    if (oldValue == null) oldValue = _parent.getDefaultForField(tag);
    if (identical(oldValue, newValue)) return;
    addEvent(new PbFieldChange(_parent, tag, oldValue, newValue));
  }

  @override
  void beforeClearField(int tag) {
    var oldValue = _parent.getFieldOrNull(tag);
    if (oldValue == null) return;
    var newValue = _parent.getDefaultForField(tag);
    addEvent(new PbFieldChange(_parent, tag, oldValue, newValue));
  }
}
