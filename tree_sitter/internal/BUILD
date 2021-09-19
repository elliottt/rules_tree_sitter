
load("@rules_tree_sitter//tree_sitter/internal:toolchain.bzl", "tree_sitter_toolchain_info")
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", "VERSION_SHA256")

[tree_sitter_toolchain_info(
    name = "toolchain_v{}".format(version),
    tree_sitter_tool = "@tree_sitter_v{}//bin:tree_sitter".format(version),
    tags = ["manual"],
    visibility = ["//visibility:public"],
) for version in VERSION_SHA256]
