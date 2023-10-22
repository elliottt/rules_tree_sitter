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
    urls = ["https://github.com/doctest/doctest/archive/ae7a13539fb71f270b87eb2e874fbac80bc8dda2.zip"],
    sha256 = "ed32c51a7750d5996c7f8bc858890991be9e8153c37f9ad0c1418060ff894f72",
    strip_prefix = "doctest-ae7a13539fb71f270b87eb2e874fbac80bc8dda2",
)

http_archive(
    name = "rules_nodejs",
    sha256 = "d124665ea12f89153086746821cf6c9ef93ab88360a50c1aeefa1fe522421704",
    strip_prefix = "rules_nodejs-6.0.0-beta1",
    url = "https://github.com/bazelbuild/rules_nodejs/releases/download/v6.0.0-beta1/rules_nodejs-v6.0.0-beta1.tar.gz",
)

load("@rules_nodejs//nodejs:repositories.bzl", "DEFAULT_NODE_VERSION", "nodejs_register_toolchains")

nodejs_register_toolchains(
    name = "nodejs",
    node_version = DEFAULT_NODE_VERSION,
)
