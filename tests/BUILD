load("@rules_tree_sitter//tree_sitter:tree_sitter.bzl", "tree_sitter_cc_library")

tree_sitter_cc_library(
    name = "hello",
    src = "hello.js",
)

cc_binary(
    name = "parser",
    srcs = ["parser.cc"],
    deps = [":hello"],
    copts = ["-std=c++17"],
)
