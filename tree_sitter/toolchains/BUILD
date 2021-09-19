load("@rules_tree_sitter//tree_sitter/internal:toolchain.bzl", "TREE_SITTER_TOOLCHAIN_TYPE")
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", "VERSION_SHA256")

[toolchain(
    name = "v{}".format(version),
    toolchain = "@rules_tree_sitter//tree_sitter/internal:toolchain_v{}".format(version),
    toolchain_type = TREE_SITTER_TOOLCHAIN_TYPE,
) for version in VERSION_SHA256]
