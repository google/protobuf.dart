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

    $ protoc --out_dart=. test.proto

### Options to control the generated Dart code

The protocol buffer compiler accepts options for each plugin. For the
Dart plugin, these options are passed together with the `--dart_out`
option. The individial options are separated using comma, and the
final output directive is separated from the options using colon. Pass
options `<option 1>` and `<option 2>` like this:

    --dart_out="<option 1>,<option 2>:."

#### Option for setting the name of field accessors

The following message definition has the field name `has_field`.

    message MyMessage {
      optional string has_field = 1;
    }

This poses the problem, that the Dart class will have a getter and a
setter called `hasField`. This conflicts with the method `hasField`
which is already defined on the superclass `GeneratedMessage`.

To work around this problem the option `field_name` can be
used. Option `field_name` takes two values separated by the vertical
bar. The first value is the full name of the field and the second
value is the name of the field in the generated Dart code. Passing the
following option:

    --dart_out="field_name=MyMessage.has_field|HasFld:."

Will generate the following message field accessors:

    String get hasFld => getField(1);
    void set hasFld(String v) { setField(1, v); }
    bool hasHasFld() => hasField(1);
    void clearHasFld() => clearField(1);

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
