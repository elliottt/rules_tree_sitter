workspace(name = "rules_tree_sitter")

load("@rules_tree_sitter//tree_sitter:tree_sitter.bzl", "tree_sitter_register_toolchains")
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", "VERSION_SHA256")
load("@rules_tree_sitter//tree_sitter/internal:repository.bzl", "tree_sitter_repository")

tree_sitter_register_toolchains()

[tree_sitter_repository(
    name = "tree_sitter_v{}".format(version),
    version = version,
) for version in VERSION_SHA256]

