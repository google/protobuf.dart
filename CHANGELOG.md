## 0.10.2

* Add link to source file in generated code.

## 0.10.1

* Prefix generated Dart proto imports by proto file path instead of by package.
  Tighten up member name checks for generated enum classes.

## 0.10.0

* Breaking change: Support for [any](https://developers.google.com/protocol-buffers/docs/proto3#any) messages.
  Generated files require package:protobuf version 0.10.1 or newer.
  `BuilderInfo.messageName` will now be the fully qualified name for generated messages.

## 0.9.0

* Breaking change: Add `copyWith()` to message classes and update `getDefault()` to use `freeze()`.
  Requires package:protobuf version 0.10.0 or newer.

## 0.8.2

* Generated code now imports 'package:protobuf/protobuf.dart' prefixed.
  This avoids name clashes between user defined message names and the protobuf library.

## 0.8.1

* Adjust dependencies to actually be compatible with Dart 2.0 stable.

## 0.8.0+1

* Dart SDK upper constraint raised to declare compatibility with Dart 2.0 stable.

## 0.8.0

* Breaking change: Generated RpcClient stubs use the generic invoke method.
  Requires package:protobuf version 0.8.0 or newer.
* Dart 2 fixes.

## 0.7.11

* Dart 2 fix.

## 0.7.10

* Small performance tweak for DDC.

## 0.7.9

* Add fast getters for common types.
* Only pass index instead of tag and index in generated code.
* Fix uses-dynamic-as-bottom error in generated gRPC code.

## 0.7.8

* Added enumValues to FieldInfo.

## 0.7.7

* Avoid name clashes between import prefix and field names.
* Avoid name clashes between generated enum and extension class names.
* Updated gRPC client stub generation to match latest changes to dart-lang/grpc-dart.

## 0.7.6

* Updated gRPC client stub generation to produce code matching latest changes to
  dart-lang/grpc-dart.

## 0.7.5

* Use real generic syntax instead of comment-based.
* Support 2.0.0 dev SDKs.

## 0.7.4

* Added call options to gRPC client stubs.

## 0.7.3

### gRPC support

* Added gRPC stub generation.
* Updated descriptor.proto from google/protobuf v3.3.0.

## 0.7.2

* Added CHANGELOG.md

## 0.7.1

* Enable executable for `pub global` usage. Protoc plugin can now be installed by running `pub global activate protoc_plugin`.
* Ensure generated extension class names don't conflict with message class names.
* `Function` will soon be a reserved keyword, so don't generate classes with that name.
* Strong mode tweaks and lint fixes.

## 0.7.0 - Not released

* Change how to customize the Dart name of a field to using a `dart_name` option.
* Implemented support for adding external mixins to generate Dart protos.

## 0.6.0+1 - Not released

* Fix missing import when an extension uses an enum in the same .proto file.

## 0.6.0 - Not released

* Move protobuf enums to a separate .pbenum.dart file.
* Move server-side stubs to .pbserver.dart.

## 0.5.2 - Not released

* Generate separate .pbjson.dart files for constants.

## 0.5.1

### Strong mode and Bazel

* Fixed all analyzer diagnostics in strong mode.
* Added experimental support for Bazel.

## 0.5.0

### Performance improvements

This release requires 0.5.0 of the protobuf library.

* significantly improved performance for getters, setters, and hazzers
* Each enum type now has a $json constant that contains its metadata.

## 0.4.1

### Fixed imports, $checkItem, $json

* Fixed all warnings, including in generated code.
* Started generating $checkItem function for verifying the values of repeated fields
* Fixed service stubs to work when a message is in a different package
* Started generating JSON constants to get the original descriptor data for services

## 0.4.0

### Getters for message fields changed

This release changes how getters work for message fields, to detect a common mistake.

Previously, the protobuf API didn't report any error for an incorrect usage of setters. For example, if field "foo" is a message field of type Foo, this code would silently have no effect:

var msg = new SomeMessage();
msg.foo.bar = 123;
This is because "msg.foo" would call "new Foo()" and return it without saving it.

The example can be fixed like this:

var msg = new SomeMessage();
msg.foo = new Foo();
msg.foo.bar = 123;
Or equivalently:

var msg = new SomeMessage()
   ..foo = (new Foo()..bar = 123);
Starting in 0.4.0, the default value of "msg.foo" is an immutable instance of Foo. You can read
the default value of a field the same as before, but writes will throw UnsupportedError.

## 0.3.11

* Fixes issues with reserved names

## 0.3.10

* Adds support for generating stubs from service definitions.

## 0.3.9

* Modify dart_options support so that it supports alternate mixins.
* Move the experimental map implementation to PbMapMixin

For now, new mixins can only be added using a patch:

* add the new class to the protobuf library
* add the class to the list in mixin.dart.

## 0.3.8

### Added option for experimental map API

* Changed the Map API so that operator [] and operator []= support dotted keys such as "foo.bar".

This new API is subject to change without notice, but if you want to try it out anyway, see the unit test.

## 0.3.7 - Unreleased

### Added option for experimental map API

* Added an option to have GeneratedMessage subclasses implement Map.

## 0.3.6

### Added writeToJsonMap and mergeFromJsonMap to reservedNames

The 0.3.6 version of the dart-protobuf library added two new functions, so this release changes the protobuf compiler to avoid using them.

## 0.3.5

Protobuf changes for smaller dart2js code, Int64 fixes

This change is paired with https://chromiumcodereview.appspot.com/814213003

Reduces code size for one app by 0.9%

1. Allow constants for the default value to avoid many trivial closures.
2. Generate and use static M.create() and M.createRepeated() methods on message classes M to ensure there is a shared copy of these closures rather than one copy per use.
3. Parse Int64 values rather than generate from 'int' to ensure no truncation errors in JavaScript.

## 0.3.4

Parameterize uri resolution and parsing of options, use package:path.

This helps make the compiler more configurable
to embed it in other systems (like pub transformers)

## 0.3.3

Update the version number
