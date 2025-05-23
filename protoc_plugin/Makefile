PLUGIN_SRC = \
	bin/protoc_plugin.dart \
	lib/**/*.dart

OUTPUT_DIR=test/gen
PLUGIN_NAME=protoc-gen-dart
PLUGIN_PATH=bin/$(PLUGIN_NAME)

TEST_PROTO_LIST = \
	_leading_underscores \
	google/protobuf/any \
	google/protobuf/api \
	google/protobuf/duration \
	google/protobuf/empty \
	google/protobuf/field_mask \
	google/protobuf/source_context \
	google/protobuf/struct \
	google/protobuf/timestamp \
	google/protobuf/type \
	google/protobuf/unittest_import \
	google/protobuf/unittest_optimize_for \
	google/protobuf/unittest_well_known_types \
	google/protobuf/unittest \
	google/protobuf/wrappers \
	custom_option \
	dart_name \
	deprecations \
	doc_comments \
	default_value_escape \
	entity \
	enum_extension \
	enum_name \
	enums \
	extend_unittest \
	ExtensionEnumNameConflict \
	ExtensionNameConflict \
	foo \
	high_tagnumber \
	import_clash \
	import_public \
	json_name \
	map_api \
	map_api2 \
	map_enum_value \
	map_field \
	message_set \
	mixins \
	multiple_files_test \
	nested_any \
	nested_extension \
	nested_message \
	non_nested_extension \
	oneof \
	reserved_names \
	reserved_names_extension \
	reserved_names_message \
	duplicate_names_import \
	package1 \
	package2 \
	package3 \
	proto2_repeated \
	proto3_optional \
	proto3_repeated \
	service \
	service2 \
	service3 \
	toplevel_import \
	toplevel \
	using_any
TEST_PROTO_DIR=$(OUTPUT_DIR)
TEST_PROTO_LIBS=$(foreach f, $(TEST_PROTO_LIST), \
  $(TEST_PROTO_DIR)/$(f).pb.dart \
	$(TEST_PROTO_DIR)/$(f).pbjson.dart)
TEST_PROTO_SRC_DIR=test/protos
TEST_PROTO_SRCS=$(foreach proto, $(TEST_PROTO_LIST), \
  $(TEST_PROTO_SRC_DIR)/$(proto).proto)

PREGENERATED_SRCS := $(shell find protos -name '*.proto')

$(TEST_PROTO_LIBS): $(PLUGIN_SRC) $(TEST_PROTO_SRCS)
	mkdir -p $(TEST_PROTO_DIR)

	protoc\
		--dart_out="$(TEST_PROTO_DIR)"\
		-I$(TEST_PROTO_SRC_DIR)\
		-Iprotos\
		--plugin=protoc-gen-dart=$(realpath $(PLUGIN_PATH))\
		$(TEST_PROTO_SRCS)

	dart format $(TEST_PROTO_DIR)

update-pregenerated: $(PLUGIN_PATH) $(PREGENERATED_SRCS)
	protoc --dart_out=lib/src/gen \
	  -Iprotos \
		--plugin=protoc-gen-dart=$(realpath $(PLUGIN_PATH)) $(PREGENERATED_SRCS)
	find lib/src/gen -name '*.pbjson.dart' -delete
	dart format lib/src/gen

protos: $(PLUGIN_PATH) $(TEST_PROTO_LIBS)

run-tests: protos
	dart test

update-goldens: protos
	rm -rf test/goldens
	dart test

clean:
	rm -rf $(OUTPUT_DIR)
