PLUGIN_SRC = \
	prepend.dart \
	bin/protoc_plugin.dart \
	lib/*.dart \
	lib/src/descriptor.pb.dart \
	lib/src/plugin.pb.dart

OUTPUT_DIR=out
PLUGIN_NAME=protoc-gen-dart
PLUGIN_PATH=bin/$(PLUGIN_NAME)

BENCHMARK_PROTOS = $(wildcard benchmark/protos/*.proto)

TEST_PROTO_LIST = \
	google/protobuf/unittest_import \
	google/protobuf/unittest_optimize_for \
	google/protobuf/unittest \
	dart_name \
	dart_options \
	descriptor_2_5_opensource \
	enum_extension \
	ExtensionNameConflict \
	map_api \
	map_api2 \
	mixins \
	multiple_files_test \
	nested_extension \
	non_nested_extension \
	reserved_names \
	duplicate_names_import \
	package1 \
	package2 \
	package3 \
	service \
	service2 \
	service3 \
	toplevel_import \
	toplevel
TEST_PROTO_DIR=$(OUTPUT_DIR)/protos
TEST_PROTO_LIBS=$(foreach f, $(TEST_PROTO_LIST), \
  $(TEST_PROTO_DIR)/$(f).pb.dart \
	$(TEST_PROTO_DIR)/$(f).pbenum.dart \
	$(TEST_PROTO_DIR)/$(f).pbserver.dart \
	$(TEST_PROTO_DIR)/$(f).pbjson.dart)
TEST_PROTO_SRC_DIR=test/protos
TEST_PROTO_SRCS=$(foreach proto, $(TEST_PROTO_LIST), \
  $(TEST_PROTO_SRC_DIR)/$(proto).proto)

PREGENERATED_SRCS=lib/descriptor.proto lib/plugin.proto

$(TEST_PROTO_LIBS): $(PLUGIN_PATH) $(TEST_PROTO_SRCS)
	[ -d $(TEST_PROTO_DIR) ] || mkdir -p $(TEST_PROTO_DIR)
	protoc\
		--dart_out=$(TEST_PROTO_DIR)\
		-I$(TEST_PROTO_SRC_DIR)\
		--plugin=protoc-gen-dart=$(realpath $(PLUGIN_PATH))\
		$(TEST_PROTO_SRCS)

.PHONY: build-plugin build-benchmark-protos build-benchmarks \
	update-pregenerated protos run-tests clean

build-plugin: $(PLUGIN_PATH)

update-pregenerated: $(PLUGIN_PATH) $(PREGENERATED_SRCS)
	protoc --dart_out=lib/src -Ilib --plugin=protoc-gen-dart=$(realpath $(PLUGIN_PATH)) $(PREGENERATED_SRCS)

protos: $(PLUGIN_PATH) $(TEST_PROTO_LIBS)
	mkdir -p benchmark/lib/generated
	protoc \
		--dart_out=benchmark/lib/generated \
		-Ibenchmark/protos \
		--plugin=protoc-gen-dart=$(realpath $(PLUGIN_PATH)) \
		$(BENCHMARK_PROTOS)

run-tests: protos
	pub run test

clean:
	rm -rf benchmark/lib/generated
	rm -rf $(OUTPUT_DIR)
