
DEFAULT_VERSION = "0.20.6"

VERSION_SHA256 = {
    "0.20.6": {
        "tree-sitter-linux-x64": "f7001a0ff42cb27c0b0a9023352b31273e98f6c72282003c6bd1fe9ec1018491",
        "tree-sitter-macos-x64": "3719822cbb27ed4e2132a28a9740803b151fc7aa4597986bc0bd51f3a0b8ff1e",
        "source-code": "4d37eaef8a402a385998ff9aca3e1043b4a3bba899bceeff27a7178e1165b9de",
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
