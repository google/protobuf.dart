Protoc compiler Dart plugin
===========================

This application provides a plugin for protoc compiler which
generates pure Dart library to deal with protobufs.

Please, do not forget that generated libraries depend on runtime
support library which can be found [here](https://github.com/dart-lang/dart-protobuf).

How to build and use
--------------------

*Note:* currently the workflow is POSIX-oriented.

To build standalone `protoc` plugin:
- run `pub install` to install all dependecies
- run `make build-plugin`. That will create a file `out/protoc-gen-dart` which
  is a plugin
- Now you can use it either by adding into `PATH` or passing directly with
  `protoc`'s `--plugin` option.

Please, remember that the plugin is pure Dart script and requires the presence
of `dart` executable in your `PATH`.

When both the `dart` executable and `out/protoc-gen-dart` are in the
`PATH` the protocol buffer compiler can be invoked to generate like this:

    $ protoc --dart_out=. test.proto

### Options to control the generated Dart code

The protocol buffer compiler accepts options for each plugin. For the
Dart plugin, these options are passed together with the `--dart_out`
option. The individial options are separated using comma, and the
final output directive is separated from the options using colon. Pass
options `<option 1>` and `<option 2>` like this:

    --dart_out="<option 1>,<option 2>:."

Using protocol buffer libraries to build new libraries
------------------------------------------------------

The protocol buffer compiler produces one library for each `.proto` file
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

You need to have `protoc` installed.

* Linux Aptitude: `apt-get install protobuf-compiler`
* Mac [homebrew](http://brew.sh/): `brew install protobuf`

Remember to run the tests. That is as easy as `make run-tests`.

The default way of running the Dart protoc plugin is through the
generated `out/protoc-gen-dart` script. However when run this way the
Dart code is assembled into one large Dart file using dart2dart. To
run with the actual source in the repository create an executable
script called `protoc-gen-dart` with the following content:

    #! /bin/bash
    dart bin/protoc_plugin.dart

When running protoc just ensure that this script is first when PATH is
searched. If the script is in the current directory run `protoc` like
this:

    $ PATH=.:$PATH protoc --dart_out=. test.proto

It is also possible to call the script something else than
`protoc-gen-dart` and then refer directly to it using the `--plugin`
option. If the script is called `dart-plugin` run `protoc` like this:

    $ protoc --plugin=protoc-gen-dart=./plugin --dart_out=. test.proto

Useful references
-----------------

* [Main Dart site](http://www.dartlang.org)
* [Main protobuf site](https://code.google.com/p/protobuf)
* [Protobuf runtime support project](https://github.com/dart-lang/dart-protobuf)
* [DartEditor download](http://www.dartlang.org)
* [Pub documentation](http://pub.dartlang.org/doc)
