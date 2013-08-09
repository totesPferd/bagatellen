#ifndef LUA_BINDINGS_REDLAND_NODE_H
#define LUA_BINDINGS_REDLAND_NODE_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_node_wrap(lua_State *, librdf_node *);

int
luaopen_bindings_redland_node(lua_State *);

#endif
