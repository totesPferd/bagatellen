#ifndef LUA_BINDINGS_REDLAND_NODE_H
#define LUA_BINDINGS_REDLAND_NODE_H
#include <lua.h>
#include <librdf.h>

int
lua_bindings_redland_node_clone(lua_State *);

int
lua_bindings_redland_node_eq(lua_State *);

int
lua_bindings_redland_node_gc(lua_State *);

int
lua_bindings_redland_node_get_blank(lua_State *);

int
lua_bindings_redland_node_get_li_number(lua_State *);

int
lua_bindings_redland_node_get_literal(lua_State *);

int
lua_bindings_redland_node_get_resource(lua_State *);

int
lua_bindings_redland_node_new_blank(lua_State *);

int
lua_bindings_redland_node_new_literal(lua_State *);

int
lua_bindings_redland_node_new_resource(lua_State *);

int
lua_bindings_redland_node_renew_blank(lua_State *);

int
lua_bindings_redland_node_wrap(lua_State *, librdf_node *);

int
lua_bindings_redland_node_new_mt(lua_State *);

int
luaopen_bindings_redland_node(lua_State *);

#endif
