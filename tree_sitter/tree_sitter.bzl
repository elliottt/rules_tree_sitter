
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", _DEFAULT_VERSION = "DEFAULT_VERSION", "VERSION_SHA256")
load("@rules_tree_sitter//tree_sitter/internal:repository.bzl", _tree_sitter_repository = "tree_sitter_repository")
load(
    "@rules_tree_sitter//tree_sitter/internal:toolchain.bzl",
    "TREE_SITTER_TOOLCHAIN_TYPE",
    _register_toolchains_for_version = "register_toolchains_for_version"
)

def tree_sitter_toolchain(ctx):
    return ctx.toolchains[TREE_SITTER_TOOLCHAIN_TYPE].tree_sitter_toolchain

def tree_sitter_register_toolchains(version = _DEFAULT_VERSION):
    repo_name = "tree_sitter_v{}".format(version)
    _tree_sitter_repository(name = repo_name, version = version)
    _register_toolchains_for_version(version)


_TREE_SITTER_LIBRARY = """
export PATH="$PWD/{node_path}:$PATH"
"{tree_sitter}" generate --no-bindings "./{grammar}"
cp src/node-types.json "{node_types_json}"
cp src/parser.c "{parser_c}"
cp src/tree_sitter/parser.h "{parser_h}"

"""

def _tree_sitter_common(ctx):
    node_bin = ctx.attr._node_bin

    toolchain = ctx.toolchains[TREE_SITTER_TOOLCHAIN_TYPE].tree_sitter_toolchain

    node_types_json = ctx.actions.declare_file("node-types.json")
    parser_c = ctx.actions.declare_file("parser.c")
    parser_h = ctx.actions.declare_file("tree_sitter/parser.h")

    ctx.actions.run_shell(
        inputs = [ctx.file.grammar],
        tools = [toolchain.tree_sitter_tool, node_bin.files_to_run],
        outputs = [node_types_json, parser_c, parser_h],
        command = _TREE_SITTER_LIBRARY.format(
            tree_sitter = toolchain.tree_sitter_tool.executable.path,
            grammar = ctx.file.grammar.path,
            node_types_json = node_types_json.path,
            parser_c = parser_c.path,
            parser_h = parser_h.path,
            node_path = node_bin.files_to_run.executable.dirname,
        ),
    )

    return struct(
        toolchain = toolchain,
        outputs = struct(
            node_types_json = node_types_json,
            parser_c = parser_c,
            parser_h = parser_h,
        ),
    )

def _cc_library(ctx, result):
    cc_toolchain = ctx.attr._cc_toolchain[cc_common.CcToolchainInfo]

    cc_feature_configuration = cc_common.configure_features(
        ctx = ctx,
        cc_toolchain = cc_toolchain,
        requested_features = ctx.attr.features,
    )

    (cc_compilation_context, cc_compilation_outputs) = cc_common.compile(
        name = ctx.attr.name,
        actions = ctx.actions,
        cc_toolchain = cc_toolchain,
        feature_configuration = cc_feature_configuration,
        srcs = [result.outputs.parser_c] + ctx.files.srcs,
        private_hdrs = [result.outputs.parser_h],
        compilation_contexts = [result.toolchain.tree_sitter_lib.compilation_context],
    )

    (cc_linking_context, cc_linking_outputs) = cc_common.create_linking_context_from_compilation_outputs(
        name = ctx.attr.name,
        actions = ctx.actions,
        cc_toolchain = cc_toolchain,
        feature_configuration = cc_feature_configuration,
        compilation_outputs = cc_compilation_outputs,
        linking_contexts = [result.toolchain.tree_sitter_lib.linking_context],
    )

    outs = []

    if cc_linking_outputs.library_to_link.static_library:
        outs.append(cc_linking_outputs.library_to_link.static_library)
    if cc_linking_outputs.library_to_link.dynamic_library:
        outs.append(cc_linking_outputs.library_to_link.dynamic_library)

    return struct(
        outs = depset(direct = outs),
        cc_info = CcInfo(
            compilation_context = cc_compilation_context,
            linking_context = cc_linking_context,
        ),
    )

def _tree_sitter_cc_library(ctx):

    result = _tree_sitter_common(ctx)
    lib = _cc_library(ctx, result)

    return [
        lib.cc_info,
        DefaultInfo(files = lib.outs),
    ]

tree_sitter_cc_library = rule(
    _tree_sitter_cc_library,
    attrs = {
        "grammar": attr.label(mandatory = True, allow_single_file = True),
        "srcs": attr.label_list(allow_files = True),
        "_cc_toolchain": attr.label(
            default = "@bazel_tools//tools/cpp:current_cc_toolchain",
        ),
        "_node_bin": attr.label(
            default = "@build_bazel_rules_nodejs//toolchains/node:node_bin",
            allow_single_file = True,
        ),
    },
    provides = [
        CcInfo,
        DefaultInfo,
    ],
    toolchains = [TREE_SITTER_TOOLCHAIN_TYPE],
    fragments = ["cpp"],
)
