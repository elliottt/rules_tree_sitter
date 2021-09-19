#include <doctest.h>
#include <string>
#include <tree_sitter/api.h>
#include <tree_sitter/parser.h>

#include <iostream>

using std::string;

extern "C" {
TSLanguage *tree_sitter_hello();
}

void check_node_type(string expected, TSNode &node) {
    CHECK(expected.compare(ts_node_type(node)) == 0);
}

TEST_CASE("hello parser") {

    auto *parser = ts_parser_new();
    ts_parser_set_language(parser, tree_sitter_hello());

    SUBCASE("successful parse") {
        string source{"hello"};

        auto *tree = ts_parser_parse_string(parser, nullptr, source.c_str(), source.size());

        auto root = ts_tree_root_node(tree);
        CHECK(!ts_node_is_null(root));

        check_node_type("source_file", root);

        ts_tree_delete(tree);
    }

    SUBCASE("parse error") {
        string source{"goodbye"};

        auto *tree = ts_parser_parse_string(parser, nullptr, source.c_str(), source.size());

        auto root = ts_tree_root_node(tree);
        CHECK(!ts_node_is_null(root));

        check_node_type("ERROR", root);

        ts_tree_delete(tree);
    }

    ts_parser_delete(parser);
}
