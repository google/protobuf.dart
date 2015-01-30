## 0.3.5+1

 * Bugfix for incorrect decoding of protobuf messages: Uint8List views with
   non-zero offsets were handled incorrectly.

## 0.3.5

 * Allow constants as field initial values as well as creation thunks to reduce
   generated code size.

 * Improve the performance of reading a protobuf buffer.

 * Fixed truncation error in least significant bits with large Int64 constants.
