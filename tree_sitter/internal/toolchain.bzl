TREE_SITTER_TOOLCHAIN_TYPE = "@rules_tree_sitter//tree_sitter:toolchain_type"

TreeSitterToolchainInfo = provider(fields = ["all_files", "tree_sitter_tool"])

def _template_vars(toolchain):
    return platform_common.TemplateVariableInfo({
        "TREE_SITTER": toolchain.tree_sitter_tool.executable.path,
    })

def _tree_sitter_toolchain_info(ctx):
    tree_sitter_runfiles = ctx.attr.tree_sitter_tool[DefaultInfo].default_runfiles.files

    toolchain = TreeSitterToolchainInfo(
        all_files = depset(
            direct = [ctx.executable.tree_sitter_tool],
            transitive = [tree_sitter_runfiles],
        ),
        tree_sitter_tool = ctx.attr.tree_sitter_tool.files_to_run,
    )

    return [
        platform_common.ToolchainInfo(tree_sitter_toolchain = toolchain),
        _template_vars(toolchain),
    ]


tree_sitter_toolchain_info = rule(
    implementation = _tree_sitter_toolchain_info,
    attrs = {
        "tree_sitter_tool": attr.label(
            mandatory = True,
            executable = True,
            cfg = "host",
        ),
    },
    provides = [
        platform_common.ToolchainInfo,
        platform_common.TemplateVariableInfo,
    ],
)


def _tree_sitter_toolchain_alias(ctx):
    toolchain = ctx.toolchains[TREE_SITTER_TOOLCHAIN_TYPE].tree_sitter_toolchain
    return [
        DefaultInfo(files = toolchain.all_files),
        _template_vars(toolchain),
    ]

tree_sitter_toolchain_alias = rule(
    implementation = _tree_sitter_toolchain_alias,
    toolchains = [TREE_SITTER_TOOLCHAIN_TYPE],
    provides = [
        DefaultInfo,
        platform_common.TemplateVariableInfo,
    ],
)
