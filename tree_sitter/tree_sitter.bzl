
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", "DEFAULT_VERSION")
load("@rules_tree_sitter//tree_sitter/internal:repository.bzl", "tree_sitter_repository")

def tree_sitter_register_toolchains(version = DEFAULT_VERSION):
    repo_name = "tree_sitter_v{}".format(version)
    tree_sitter_repository(name = repo_name, version = version)
