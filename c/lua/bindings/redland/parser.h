#ifndef LUA_BINDINGS_REDLAND_PARSER_H
#define LUA_BINDINGS_REDLAND_PARSER_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_parser_gc(lua_State *);

int
lua_bindings_redland_parser_get_accept_header(lua_State *);

int
lua_bindings_redland_parser_get_feature(lua_State *);

int
lua_bindings_redland_parser_get_namespaces_seen_count(lua_State *);

int
lua_bindings_redland_parser_get_namespaces_seen_prefix(lua_State *);

int
lua_bindings_redland_parser_get_namespaces_seen_uri(lua_State *);

int
lua_bindings_redland_parser_is_there_parser(lua_State *);

int
lua_bindings_redland_parser_new(lua_State *);

int
lua_bindings_redland_parser_new_mt(lua_State *);

int
lua_bindings_redland_parser_parser(lua_State *);

int
lua_bindings_redland_parser_parser_string(lua_State *);

int
lua_bindings_redland_parser_set_feature(lua_State *);

int
lua_bindings_redland_parser_wrap(lua_State *, librdf_parser *);

int
luaopen_bindings_redland_parser(lua_State *);

#endif
