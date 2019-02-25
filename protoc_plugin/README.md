# Dart plugin for the protoc compiler

[![pub package](https://img.shields.io/pub/v/protoc_plugin.svg)](https://pub.dartlang.org/packages/protoc_plugin)

This repository provides a plugin for the [protoc
compiler](https://developers.google.com/protocol-buffers/docs/cpptutorial#compiling-your-protocol-buffers).
It generates Dart files for working with data in protocol buffers format.

Requirements
------------

We only support the full [proto2](https://developers.google.com/protocol-buffers/docs/proto)
schema. Proto3 should work due to backwards compatibility. See
[this issue list](https://github.com/dart-lang/protobuf/issues?q=is%3Aissue+is%3Aopen+label%3Aproto3)
for proto3 schema features which are currently missing.

To compile a .proto file, you must use the 'protoc' command which is [installed
separately](https://developers.google.com/protocol-buffers/docs/downloads).
Protobuf 3.0.0 or above is required.

The generated files are pure Dart code that run in either in the Dart VM or in a
browser (using dart2js). They depend the [protobuf Dart
package](https://pub.dartlang.org/packages/protobuf). A Dart project that
includes generated files should add "protobuf" to its pubspec.yaml file.


How to build and use
--------------------

*Note:* currently the workflow is POSIX-oriented.

To build standalone `protoc` plugin:
- run `pub install` to install all dependencies
- Now you can use the plugin either by adding the `bin` directory to your `PATH`,
  or passing it directly with `protoc`'s `--plugin` option.

Please, remember that the plugin is pure Dart script and requires the presence
of `dart` executable in your `PATH`.

When both the `dart` executable and `bin/protoc-gen-dart` are in the
`PATH` the protocol buffer compiler can be invoked to generate like this:

    $ protoc --dart_out=. test.proto

### Optionally using `pub global`

    $ pub global activate protoc_plugin

And then add `.pub-cache/bin` in your home dir to your `PATH` if you haven't already.

This will activate the latest published version of the plugin. If you wish to use a
local working copy, use

    $ pub global activate -s path <path/to/your/dart-protoc-plugin>


### Options to control the generated Dart code

The protocol buffer compiler accepts options for each plugin. For the
Dart plugin, these options are passed together with the `--dart_out`
option. The individial options are separated using comma, and the
final output directive is separated from the options using colon. Pass
options `<option 1>` and `<option 2>` like this:

    --dart_out="<option 1>,<option 2>:."

 ### Generating Code Info

The plugin includes the `generate_kythe_info` option, which, if passed at run
time, will make the plugin generate metadata files alongside the `.dart` files
generated for the proto messages and their enums. Pass this along with the other
dart_out options:

    --dart_out="generate_kythe_info,<other options>:."

Using protocol buffer libraries to build new libraries
------------------------------------------------------

The protocol buffer compiler produces several files for each `.proto` file
it compiles. In some cases this is not exactly what is needed, e.g one
would like to create new libraries which exposes the objects in these
libraries or create new librares combining object definitions from
several `.proto` libraries into one.

The best way to aproach this is to create the new libraries needed and
re-export the relevant protocol buffer classes.

Say we have the file `m1.proto` with the following content

    message M1 {
      optional string a;
    }

and `m2.proto` containing

    message M2 {
      optional string b;
    }

Compiling these to Dart will produce two libraries in `m1.pb.dart` and
`m2.pb.dart`. The following code shows a library M which combines
these two protocol buffer libraries, exposes the classes `M1` and `M2` and
adds som additional methods.

    library M;

    import "m1.pb.dart";
    import "m2.pb.dart";

    export "m1.pb.dart" show M1;
    export "m2.pb.dart" show M2;

    M1 createM1() => new M1();
    M2 createM2() => new M2();

Hacking
-------

Here are some ways to get protoc:

* Linux: `apt-get install protobuf-compiler`
* Mac [homebrew](http://brew.sh/): `brew install protobuf`

If the version installed this way doesn't work, an alternative is to
[compile protoc from source](https://developers.google.com/protocol-buffers/docs/downloads).

Remember to run the tests. That is as easy as `make run-tests`.

Useful references
-----------------

* [Main Dart site](https://www.dartlang.org/)
* [Main protobuf site](https://github.com/google/protobuf)
* [Protobuf runtime support project](https://github.com/dart-lang/dart-protobuf)
* [Pub documentation](https://www.dartlang.org/tools/pub/get-started.html)
