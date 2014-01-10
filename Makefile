PLUGIN_SRC = \
						 prepend.dart \
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

TEST_PROTO_LIST = \
						 google/protobuf/unittest_import \
						 google/protobuf/unittest_optimize_for \
						 google/protobuf/unittest \
						 multiple_files_test \
						 nested_extension \
						 non_nested_extension \
						 reserved_names \
						 duplicate_names_import \
						 package1 \
						 package2 \
						 package3 \
						 toplevel_import \
						 toplevel
TEST_PROTO_DIR=$(OUTPUT_DIR)/protos
TEST_PROTO_LIBS=$(foreach proto, $(TEST_PROTO_LIST), $(TEST_PROTO_DIR)/$(proto).pb.dart)
TEST_PROTO_SRC_DIR=test/protos
TEST_PROTO_SRCS=$(foreach proto, $(TEST_PROTO_LIST), $(TEST_PROTO_SRC_DIR)/$(proto).proto)

PREGENERATED_SRCS=lib/descriptor.proto lib/plugin.proto


$(PLUGIN_PATH): $(PLUGIN_SRC)
	[ -d $(OUTPUT_DIR) ] || mkdir $(OUTPUT_DIR)
	# --categories=all is a hack, it should be --categories=Server once dart2dart bug is fixed.
	dart2js --checked --output-type=dart --package-root=packages --categories=all -o$(PLUGIN_PATH) bin/protoc_plugin.dart
	dart prepend.dart $(PLUGIN_PATH)
	chmod +x $(PLUGIN_PATH)

$(TEST_PROTO_LIBS): $(PLUGIN_PATH) $(TEST_PROTO_SRCS)
	[ -d $(TEST_PROTO_DIR) ] || mkdir $(TEST_PROTO_DIR)
	protoc\
		--dart_out=$(TEST_PROTO_DIR)\
		-I$(TEST_PROTO_SRC_DIR)\
		--plugin=protoc-gen-dart=$(realpath $(PLUGIN_PATH))\
		$(TEST_PROTO_SRCS)

.PHONY: build-plugin update-pregenerated build-test-protos run-tests clean

build-plugin: $(PLUGIN_PATH)

update-pregenerated: $(PLUGIN_PATH) $(PREGENERATED_SRCS)
	protoc --dart_out=lib/src -Ilib --plugin=protoc-gen-dart=$(realpath $(PLUGIN_PATH)) $(PREGENERATED_SRCS)

build-test-protos: $(TEST_PROTO_LIBS)

run-tests: build-test-protos
	dart --checked --package-root=packages/ test/all_tests.dart

clean:
	rm -rf $(OUTPUT_DIR)
