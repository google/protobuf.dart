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

PROTO_LIST = \
						 google/protobuf/unittest_import \
						 google/protobuf/unittest_optimize_for \
						 google/protobuf/unittest \
						 multiple_files_test \
						 nested_extension \
						 non_nested_extension

OUTPUT_PROTOS_DIR=$(OUTPUT_DIR)/protos
SRC_PROTOS_DIR=test/protos
GENERATED_PB_LIBS = $(foreach proto, $(PROTO_LIST), $(OUTPUT_PROTOS_DIR)/$(proto).pb.dart)
SRC_PROTOS = $(foreach proto, $(PROTO_LIST), $(SRC_PROTOS_DIR)/$(proto).proto)


$(PLUGIN_PATH): $(PLUGIN_SRC)
	[ -d $(OUTPUT_DIR) ] || mkdir $(OUTPUT_DIR)
	# --categories=all is a hack, it should be --categories=Server once dart2dart bug is fixed.
	dart2js --output-type=dart --package-root=packages --categories=all -o$(PLUGIN_PATH) bin/protoc_plugin.dart
	sed -i '1i #!/usr/bin/env dart' $(PLUGIN_PATH)
	chmod +x $(PLUGIN_PATH)

$(GENERATED_PB_LIBS): $(PLUGIN_PATH) $(SRC_PROTOS)
	[ -d $(OUTPUT_PROTOS_DIR) ] || mkdir $(OUTPUT_PROTOS_DIR)
	protoc --dart_out=$(OUTPUT_PROTOS_DIR) -I$(SRC_PROTOS_DIR) --plugin=protoc-gen-dart=$(realpath $(PLUGIN_PATH)) $(SRC_PROTOS)

.PHONY: build-plugin build-protos

build-plugin: $(PLUGIN_PATH)

build-protos: $(GENERATED_PB_LIBS)
