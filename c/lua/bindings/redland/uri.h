#ifndef LUA_BINDINGS_REDLAND_URI_H
#define LUA_BINDINGS_REDLAND_URI_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_uri_wrap(lua_State *, librdf_uri *);

int
luaopen_bindings_redland_uri(lua_State *);

#endif
