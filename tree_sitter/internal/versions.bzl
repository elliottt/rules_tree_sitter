
DEFAULT_VERSION = "0.20.0"

VERSION_SHA256 = {
    "0.20.0": {
        "tree-sitter-linux-x64": "9ba419d37e17c427d12cff58574af6f2bc9d61ccb4e806c3bd31d40ca1b9d935",
        "source-code": "4a8070b9de17c3b8096181fe8530320ab3e8cca685d8bee6a3e8d164b5fb47da",
    }
}

def _key_to_resource(key, version):
    if key == "source-code":
        return ["archive/refs/tags/v{}.tar.gz".format(version), "tree-sitter-{}".format(version)]
    else:
        return ["releases/download/v{}/{}.gz".format(version, key), ""]

_GITHUB_BASE = "https://github.com/tree-sitter/tree-sitter"

def get_version_info(version, url_bases = [_GITHUB_BASE]):
    shas = VERSION_SHA256.get(version, None)
    if shas == None:
        return None

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
