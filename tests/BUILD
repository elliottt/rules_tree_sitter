load("@rules_tree_sitter//tree_sitter:tree_sitter.bzl", "tree_sitter_cc_library")

tree_sitter_cc_library(
    name = "hello",
    grammar = ["hello.js"],
)

cc_test(
    name = "tests",
    srcs = ["tests.cc"],
    deps = [":hello", "@doctest", "@doctest//:doctest_main"],
    copts = ["-std=c++17"],
)

