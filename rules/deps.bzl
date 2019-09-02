load(
    "@io_bazel_rules_dart//dart/build_rules/internal:pub.bzl", 
    "pub_repository"
)

def dart_proto_plugin_deps():
    pub_repository(
        name = "vendor_fixnum",
        output = ".",
        package = "fixnum",
        version = "0.10.9",
    )
    pub_repository(
        name = "vendor_path",
        output = ".",
        package = "path",
        version = "1.6.4",
    )
    pub_repository(
        name = "vendor_args",
        output = ".",
        package = "args",
        version = "1.5.2",
    )
    pub_repository(
        name = "vendor_charcode",
        output = ".",
        package = "charcode",
        version = "1.1.0",
    )
    pub_repository(
        name = "vendor_collection",
        output = ".",
        package = "collection",
        version = "1.14.12",
    )
    pub_repository(
        name = "vendor_typed_data",
        output = ".",
        package = "typed_data",
        version = "1.1.6",
    )
    pub_repository(
        name = "vendor_convert",
        output = ".",
        package = "convert",
        version = "2.1.1",
        pub_deps = [
            "charcode",
            "typed_data",
        ]
    )
    pub_repository(
        name = "vendor_crypto",
        output = ".",
        package = "crypto",
        version = "2.1.2",
        pub_deps = [
            "collection",
            "convert",
            "typed_data",
        ]
    )
    pub_repository(
        name = "vendor_kernel",
        output = ".",
        package = "kernel",
        version = "0.3.24",
        pub_deps = [
            "args",
        ]
    )
    pub_repository(
        name = "vendor_package_config",
        output = ".",
        package = "package_config",
        version = "1.1.0",
        pub_deps = [
            "charcode",
            "path",
        ]
    )
    pub_repository(
        name = "vendor_isolate",
        output = ".",
        package = "isolate",
        version = "1.1.0",
    )
    pub_repository(
        name = "vendor_front_end",
        output = ".",
        package = "front_end",
        version = "0.1.24",
        pub_deps = [
            "kernel",
            "package_config",
            "isolate",
        ]
    )
    pub_repository(
        name = "vendor_async",
        output = ".",
        package = "async",
        version = "2.3.0",
        pub_deps = [
            "collection"
        ]
    )
    pub_repository(
        name = "vendor_pedantic",
        output = ".",
        package = "pedantic",
        version = "1.8.0+1",
    )
    pub_repository(
        name = "vendor_meta",
        output = ".",
        package = "meta",
        version = "1.1.7",
    )
    pub_repository(
        name = "vendor_string_scanner",
        output = ".",
        package = "string_scanner",
        version = "1.0.5",
        pub_deps = [
            "charcode",
            "meta",
            "source_span",
        ]
    )
    pub_repository(
        name = "vendor_glob",
        output = ".",
        package = "glob",
        version = "1.1.7",
        pub_deps = [
            "async",
            "collection",
            "path",
            "pedantic",
            "string_scanner",
        ]
    )
    pub_repository(
        name = "vendor_csslib",
        output = ".",
        package = "csslib",
        version = "0.16.1",
        pub_deps = [
            "source_span",
        ]
    )
    pub_repository(
        name = "vendor_html",
        output = ".",
        package = "html",
        version = "0.14.0+2",
        pub_deps = [
            "csslib",
            "source_span",
        ]
    )
    pub_repository(
        name = "vendor_pub_semver",
        output = ".",
        package = "pub_semver",
        version = "1.4.2",
        pub_deps = [
            "collection",
        ]
    )
    pub_repository(
        name = "vendor_watcher",
        output = ".",
        package = "watcher",
        version = "0.9.7+12",
        pub_deps = [
            "async",
            "path",
            "pedantic",
        ]
    )
    pub_repository(
        name = "vendor_yaml",
        output = ".",
        package = "yaml",
        version = "2.1.16",
        pub_deps = [
            "charcode",
            "collection",
            "string_scanner",
            "source_span",
        ]
    )
    pub_repository(
        name = "vendor_analyzer",
        output = ".",
        package = "analyzer",
        version = "0.38.2",
        pub_deps = [
            "args",
            "charcode",
            "collection",
            "convert",
            "crypto",
            "front_end",
            "glob",
            "html",
            "meta",
            "package_config",
            "path",
            "pub_semver",
            "source_span",
            "watcher",
            "yaml",
        ],
    )
    pub_repository(
        name = "vendor_term_glyph",
        output = ".",
        package = "term_glyph",
        version = "1.1.0",
    )
    pub_repository(
        name = "vendor_source_span",
        output = ".",
        package = "source_span",
        version = "1.5.5",
        pub_deps = [
            "charcode",
            "path",
            "term_glyph",
        ]
    )
    pub_repository(
        name = "vendor_dart_style",
        output = ".",
        package = "dart_style",
        version = "1.2.10",
        pub_deps = [
            "analyzer",
            "path",
            "args",
            "source_span"
        ],
    )