load("@rules_tree_sitter//tree_sitter/internal:repository.bzl", "TOOL_PLATFORMS")
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", "VERSION_SHA256")

TREE_SITTER_TOOLCHAIN_TYPE = "@rules_tree_sitter//tree_sitter:toolchain_type"

TreeSitterToolchainInfo = provider(fields = ["all_files", "tree_sitter_tool", "tree_sitter_lib"])

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
        tree_sitter_lib = ctx.attr.tree_sitter_lib[CcInfo],
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
        "tree_sitter_lib": attr.label(
            mandatory = True,
            providers = [CcInfo],
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

def _toolchain_name(key, version):
    return "toolchain_{key}_v{version}".format(key = key, version = version)

def register_toolchains_for_version(version):
    for key in VERSION_SHA256[version]:
        if key not in TOOL_PLATFORMS:
            continue

        name = _toolchain_name(key, version)

        native.register_toolchains("@rules_tree_sitter//tree_sitter/toolchains:{}".format(name))

def setup_tree_sitter_toolchains():
    for version in VERSION_SHA256:
        for key in VERSION_SHA256[version]:

            if None == TOOL_PLATFORMS.get(key, None):
                continue

            tree_sitter_toolchain_info(
                name = _toolchain_name(key, version),
                tree_sitter_tool = "@tree_sitter_v{version}//bin:{key}".format(version=version, key=key),
                tree_sitter_lib = "@tree_sitter_v{version}//:tree_sitter_lib".format(version=version),
                tags = ["manual"],
                visibility = ["//visibility:public"],
            )


def declare_toolchains():
    for version in VERSION_SHA256:
        for key in VERSION_SHA256[version]:
            platforms = TOOL_PLATFORMS.get(key, None)
            if platforms == None:
                continue

            name = _toolchain_name(key, version)
            toolchain = "@rules_tree_sitter//tree_sitter/internal:{}".format(name)

            native.toolchain(
                name = name,
                toolchain = toolchain,
                toolchain_type = TREE_SITTER_TOOLCHAIN_TYPE,
                exec_compatible_with = platforms,
            )
