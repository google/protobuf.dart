Protoc compiler Dart plugin
===========================

This application provides a plugin for protoc compiler which
generates pure Dart library to deal with protobufs.

Please, do not forget that generated libraries depend on runtime
support library which can be found [here](https://github.com/dart-lang/dart-protobuf).

How to build and use
--------------------

*Note:* currently the workflow is POSIX-oriented.

To build standalone `protc` plugin, please, run `make build-plugin`. That will
create a file `out/protoc-gen-dart` which is a plugin. Now you can use it either
by adding into `PATH` or passing directly with `protoc`'s `--plugin` option.
Please, remember that the plugin is pure Dart script and requires the presence
of `dart` executable in your `PATH`.

Hacking
-------

The main thing to remember is to run the tests. That is as easy as `make run-tests`.

Useful references
-----------------

* [Main Dart site](http://www.dartlang.org)
* [Main protobuf site](https://code.google.com/p/protobuf)
* [Protobuf runtime support project](https://github.com/dart-lang/dart-protobuf)
* [DartEditor download](http://www.dartlang.org)
* [Pub documentation](http://pub.dartlang.org/doc)
