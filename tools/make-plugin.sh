#!/usr/bin/env sh

OUTPUT_FILE=out/protoc-gen-dart

[ -d out ] || mkdir out
# --categories=all is a hack, it should be --categories=Server once dart2dart bug is fixed.
dart2js --output-type=dart --package-root=packages --categories=all -o${OUTPUT_FILE} bin/protoc_plugin.dart
sed -i '1i #!/usr/bin/env dart' ${OUTPUT_FILE}
chmod +x ${OUTPUT_FILE}
