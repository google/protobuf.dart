PLUGIN_SRC = \
						 bin/protoc_plugin.dart \
						 lib/code_generator.dart \
						 lib/enum_generator.dart \
						 lib/exceptions.dart \
						 lib/extension_generator.dart \
						 lib/file_generator.dart \
						 lib/indenting_writer.dart \
						 lib/message_generator.dart \
						 lib/protobuf_field.dart \
						 lib/protoc.dart \
						 lib/src/descriptor.pb.dart \
						 lib/src/plugin.pb.dart \
						 lib/writer.dart

OUTPUT_DIR=out
PLUGIN_NAME=protoc-gen-dart
PLUGIN_PATH=$(OUTPUT_DIR)/$(PLUGIN_NAME)

$(PLUGIN_PATH): $(PLUGIN_SRC)
	[ -d $(OUTPUT_DIR) ] || mkdir $(OUTPUT_DIR)
	# --categories=all is a hack, it should be --categories=Server once dart2dart bug is fixed.
	dart2js --output-type=dart --package-root=packages --categories=all -o$(PLUGIN_PATH) bin/protoc_plugin.dart
	sed -i '1i #!/usr/bin/env dart' $(PLUGIN_PATH)
	chmod +x $(PLUGIN_PATH)

.PHONY: build-plugin

build-plugin: $(PLUGIN_PATH)
