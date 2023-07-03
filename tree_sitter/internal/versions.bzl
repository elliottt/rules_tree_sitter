
DEFAULT_VERSION = "0.20.8"

VERSION_SHA256 = {
    "0.20.8": {
        "tree-sitter-linux-x64": "90734a35cebd1aa4c0a5f7cbe81063724576f489951e5b55f88dcf073057d100",
        "tree-sitter-linux-arm64": "51a50f907f71157003ace392c0bb1c0e8fee2973834e8ee1622da0ac2bb9bffc",
        "tree-sitter-macos-x64": "90e59681b60b15d28b01b3560d2e0e262eacf5efca16990c0fb814c661d992d9",
        "tree-sitter-macos-arm64": "e443779655ed3422d7331089e3fdc3c4be662c271353634a30115ba669bf2c0f",
        "source-code": "6181ede0b7470bfca37e293e7d5dc1d16469b9485d13f13a605baec4a8b1f791",
    }
}

def _key_to_resource(key, version):
    if key == "source-code":
        return ["archive/refs/tags/v{}.tar.gz".format(version), "tree-sitter-{}".format(version)]
    else:
        return ["releases/download/v{}/{}.gz".format(version, key), ""]

_GITHUB_BASE = "https://github.com/tree-sitter/tree-sitter"

def _make_version_info(version, shas, url_bases):
    urls = {}

    for key in shas:
        resource, prefix = _key_to_resource(key, version)
        sha = shas[key]

        urls[key] = {
            "sha256": sha,
            "urls": [ "{}/{}".format(base, resource) for base in url_bases ],
            "prefix": prefix,
        }

    return urls

def get_version_info(version, url_bases = [_GITHUB_BASE]):
    shas = VERSION_SHA256.get(version, None)
    if shas == None:
        return None

    return _make_version_info(version, shas, url_bases)
