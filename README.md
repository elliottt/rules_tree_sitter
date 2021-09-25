# rules_tree_sitter

Bazel rules for interacting with tree-sitter grammars.

## TODO

* [ ] Support compilation of grammars with `externals`
* [ ] Better support for the `tree_sitter` rule

## Usage

```python
load("@bazel_tools//tools/build_defs/repo:http.bzl", "http_archive")

http_archive(
    name = "build_bazel_rules_nodejs",
    sha256 = "4e1a5633267a0ca1d550cced2919dd4148575c0bafd47608b88aea79c41b5ca3",
    urls = ["https://github.com/bazelbuild/rules_nodejs/releases/download/4.2.0/rules_nodejs-4.2.0.tar.gz"],
)

load("@build_bazel_rules_nodejs//:index.bzl", "node_repositories")
node_repositories(
    node_version = "10.19.0",
)

http_archive(
    name = "rules_tree_sitter",
    urls = ["https://github.com/elliottt/rules_tree_sitter/archive/8d4935ff6384cf48411f9cccd3b3ee22231a2893.tar.gz"],
    sha256 = "e2753d418e193da3a14cfad2429d2f0aa3f1fb88c150b33aabc4da5b8b6ba6fb",
    strip_prefix = "rules_tree_sitter-8d4935ff6384cf48411f9cccd3b3ee22231a2893",
)

load("@rules_tree_sitter//tree_sitter:tree_sitter.bzl", "tree_sitter_register_toolchains")
tree_sitter_register_toolchains()
```

```python
load("@rules_tree_sitter//tree_sitter:tree_sitter.bzl", "tree_sitter_cc_library")

tree_sitter_cc_library(
    name = "hello_parser",
    src = "grammar.js",
)

cc_binary(
    name = "hello",
    srcs = ["hello.cc"],
    deps = [":hello_parser"],
)
```

## See also

The structure of this package was inspired by
https://github.com/jmillikin/rules_bison
