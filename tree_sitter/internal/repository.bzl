
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", _get_version_info = "get_version_info")

_TREE_SITTER_BUILD = """

cc_library(
    name = "tree_sitter_lib",
    srcs = glob([
        "lib/src/*.c",
        "lib/src/*.h",
        "lib/src/unicode/*.c",
        "lib/src/unicode/*.h"
    ], exclude = ["lib/src/lib.c"]),
    hdrs = glob(["lib/include/tree_sitter/*.h"]),
    includes = ["lib/include", "lib/src"],
    strip_include_prefix = "lib/include",
    linkstatic = True,
    visibility = ["//visibility:public"],
)

"""

_TREE_SITTER_BIN_BUILD_HEADER = """
load("@rules_tree_sitter//tree_sitter/internal:repository.bzl", "tree_sitter_binary")
"""

_TREE_SITTER_BIN_BUILD = """
tree_sitter_binary(
    name = "{key}",
    archive = "{key}.gz",
    visibility = ["//visibility:public"],
    exec_compatible_with = [{platform}],
)

"""

def _tree_sitter_binary(ctx):

    archive = ctx.file.archive
    tree_sitter = ctx.actions.declare_file(ctx.label.name, sibling = archive)

    ctx.actions.run_shell(
        inputs = [ctx.file.archive],
        outputs = [tree_sitter],
        command ="""
        gunzip "{archive}" -c > "{output}"
        chmod +x "{output}"
        """.format(
            archive = ctx.file.archive.path,
            output = tree_sitter.path,
        ),
    )

    return [
        DefaultInfo(executable = tree_sitter)
    ]

tree_sitter_binary = rule(
    implementation = _tree_sitter_binary,
    attrs = {
        "archive": attr.label(
            mandatory = True,
            allow_single_file = True,
        ),
    },
    provides = [DefaultInfo],
)

TOOL_PLATFORMS = {
    "tree-sitter-linux-x64": ["@platforms//os:linux", "@platforms//cpu:x86_64"],
    "tree-sitter-linux-arm64": ["@platforms//os:linux", "@platforms//cpu:aarch64"],
    "tree-sitter-macos-x64": ["@platforms//os:macos", "@platforms//cpu:x86_64"],
    "tree-sitter-macos-arm64": ["@platforms//os:macos", "@platforms//cpu:aarch64"],
}

def _tree_sitter_repository(ctx):
    info = _get_version_info(version = ctx.attr.version)
    if info == None:
        fail("No version information available for {}".format(ctx.attr.version))

    bin_build = _TREE_SITTER_BIN_BUILD_HEADER

    for key in info:
        download = info[key]
        if download["prefix"] == "":

            platform = TOOL_PLATFORMS.get(key, None)
            if platform == None:
                continue

            ctx.download(
                url = download["urls"],
                sha256 = download["sha256"],
                output = "bin/{}.gz".format(key)
            )

            bin_build += _TREE_SITTER_BIN_BUILD.format(
                key = key,
                platform = ", ".join(['"{}"'.format(val) for val in platform]),
            )

        else:
            ctx.download_and_extract(
                url = download["urls"],
                sha256 = download["sha256"],
                stripPrefix = download["prefix"],
            )

    ctx.file("BUILD", _TREE_SITTER_BUILD)
    ctx.file("bin/BUILD", bin_build)


tree_sitter_repository = repository_rule(
    implementation = _tree_sitter_repository,

    attrs = {
        "version": attr.string(mandatory = True),
    },
)
