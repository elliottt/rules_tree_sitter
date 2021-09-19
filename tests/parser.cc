#include <tree_sitter/parser.h>
#include <tree_sitter/api.h>

#include <fstream>
#include <iostream>
#include <string>

extern "C" {
TSLanguage *tree_sitter_hello();
}

using std::ifstream, std::string, std::cout, std::endl;

int main(int argc, char **argv) {
    if (argc < 2) {
        return 0;
    }

    string source;
    {
        ifstream in{argv[1]};
        if (!in.is_open()) {
            cout << "Failed to open input: " << argv[1] << endl;
            return 0;
        }

        string line;
        while (std::getline(in, line)) {
            source += line;
        }
    }

    cout << "input:" << endl;
    cout << source << endl;

    TSParser *parser = ts_parser_new();
    ts_parser_set_language(parser, tree_sitter_hello());

    TSTree *tree = nullptr;
    tree = ts_parser_parse_string(parser, nullptr, source.c_str(), source.size());

    cout << ts_node_type(ts_tree_root_node(tree)) << endl;

    ts_tree_delete(tree);
    ts_parser_delete(parser);

    return 0;
}
