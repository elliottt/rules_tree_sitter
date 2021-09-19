
load("@rules_tree_sitter//tree_sitter/internal:versions.bzl", _get_version_info = "get_version_info")

def _tree_sitter_repository(ctx):
    info = _get_version_info(version = ctx.attr.version)
    if info == None:
        fail("No version information available for {}".format(ctx.attr.version))

    for key in info:
        download = info[key]
        if download["prefix"] == "":
            ctx.download(
                url = download["urls"],
                sha256 = download["sha256"],
                output = "bin/{}.gz".format(key)
            )

            ctx.execute(["gunzip", "bin/{}.gz".format(key)])

        else:
            ctx.download_and_extract(
                url = download["urls"],
                sha256 = download["sha256"],
                stripPrefix = download["prefix"],
            )

    fail("thing")

tree_sitter_repository = repository_rule(
    implementation = _tree_sitter_repository,

    attrs = {
        "version": attr.string(mandatory = True),
    },
)
