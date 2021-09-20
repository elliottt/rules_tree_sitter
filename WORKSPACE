workspace(name = "rules_tree_sitter")

load("@rules_tree_sitter//tree_sitter:tree_sitter.bzl", "tree_sitter_register_toolchains")
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", "VERSION_SHA256")
load("@rules_tree_sitter//tree_sitter/internal:repository.bzl", "tree_sitter_repository")

tree_sitter_register_toolchains()

[tree_sitter_repository(
    name = "tree_sitter_v{}".format(version),
    version = version,
) for version in VERSION_SHA256]

load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "doctest",
    urls = ["https://github.com/onqtam/doctest/archive/7d42bd0fab6c44010c8aed9338bd02bea5feba41.zip"],
    sha256 = "b33c8e954d15a146bb744ca29f4ca204b955530f52b2f8a895746a99cee4f2df",
    build_file = "@rules_tree_sitter//third_party:doctest.BUILD",
    strip_prefix = "doctest-7d42bd0fab6c44010c8aed9338bd02bea5feba41",
)

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "4e1a5633267a0ca1d550cced2919dd4148575c0bafd47608b88aea79c41b5ca3",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.2.0/rules_nodejs-4.2.0.tar.gz"],
)

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories")
node_repositories(
    node_version = "10.19.0",
)
