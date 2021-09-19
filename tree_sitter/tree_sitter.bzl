
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", _DEFAULT_VERSION = "DEFAULT_VERSION")
load("@rules_tree_sitter//tree_sitter/internal:repository.bzl", _tree_sitter_repository = "tree_sitter_repository")
load("@rules_tree_sitter//tree_sitter/internal:toolchain.bzl", "TREE_SITTER_TOOLCHAIN_TYPE")

def tree_sitter_toolchain(ctx):
    return ctx.toolchains[TREE_SITTER_TOOLCHAIN_TYPE].tree_sitter_toolchain

def tree_sitter_register_toolchains(version = _DEFAULT_VERSION):
    repo_name = "tree_sitter_v{}".format(version)
    _tree_sitter_repository(name = repo_name, version = version)
    native.register_toolchains("@rules_tree_sitter//tree_sitter/toolchains:v{}".format(version))

_TREE_SITTER_LIBRARY = """
"{tree_sitter}" generate --no-bindings --log "./{grammar}"

mkdir -p "$(dirname "{parser_h}")"
cp src/parser.c "{parser_c}"
cp src/tree_sitter/parser.h "{parser_h}"

"""

def _tree_sitter_library(ctx):

    toolchain = ctx.toolchains[TREE_SITTER_TOOLCHAIN_TYPE].tree_sitter_toolchain

    parser_c = ctx.actions.declare_file("parser.c")
    parser_h = ctx.actions.declare_file("tree_sitter/parser.h")

    ctx.actions.run_shell(
        inputs = [ctx.file.src],
        tools = [toolchain.tree_sitter_tool],
        outputs = [parser_c, parser_h],
        command = _TREE_SITTER_LIBRARY.format(
            tree_sitter = toolchain.tree_sitter_tool.executable.path,
            grammar = ctx.file.src.path,
            parser_c = parser_c.path,
            parser_h = parser_h.path,
        ),
    )

    return [
        DefaultInfo(
            files = depset([parser_c, parser_h]),
        )
    ]

tree_sitter_library = rule(
    _tree_sitter_library,
    attrs = {
        "src": attr.label(mandatory = True, allow_single_file = True),
        "deps": attr.label_list(providers = [CcInfo]),
        "_cc_toolchain": attr.label(
            default = "@bazel_tools//tools/cpp:current_cc_toolchain",
        ),
    },
    provides = [
        DefaultInfo,
    ],
    toolchains = [TREE_SITTER_TOOLCHAIN_TYPE],
)
