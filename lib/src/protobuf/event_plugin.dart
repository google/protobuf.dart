part of protobuf;

/// An EventPlugin receives callbacks when the fields of a GeneratedMessage
/// change.
///
/// A GeneratedMessage mixin can install a plugin by overriding the eventPlugin
/// property. The intent is provide mechanism, not policy; each mixin defines
/// its own public API, perhaps using streams.
///
/// Plugins will probably want to delay event delivery until the end of a
/// GeneratedMessage method call. For example, we probably don't want event
/// receivers to see a GeneratedMessage that's only half-built during a merge.
/// To support this, GeneratedMessage uses [startGroup] and [endGroup]
/// to indicate the start and end of the events in a method call.
abstract class EventPlugin {

  /// Initializes the plugin.
  ///
  /// GeneratedMessage calls this once in its constructors.
  void attach(GeneratedMessage parent);

  /// Starts a group of events to be buffered and sent at once.
  ///
  /// The plugin should return true if it's observing events.
  /// If it does, GeneratedMessage will call [beforeSetField] or
  /// [beforeClearField] for each event and [endGroup] when finished.
  ///
  /// Otherwise, no more methods will be called for this event group,
  /// except that startGroup will be called again for each nested group.
  ///
  /// (The [group] should be used only for assertions and debugging.)
  bool startGroup(EventGroup group);

  /// Ends a group of events to be sent at once.
  /// The [group] will match the preceding [startGroup] call.
  void endGroup(EventGroup group);

  /// Called before setting a field if startGroup returned true.
  ///
  /// For repeated fields, this will be called in getField() when
  /// the PbList is created.
  void beforeSetField(int tag, newValue);

  /// Called before clearing a field if startGroup returned true.
  void beforeClearField(int tag);
}

enum EventGroup {
  clear,
  binaryMerge,
  jsonMerge,
  messageMerge,
  setField,
  clearField
}
