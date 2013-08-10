#ifndef LUA_BINDINGS_REDLAND_STORE_H
#define LUA_BINDINGS_REDLAND_STORE_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_store_gc(lua_State *);

int
lua_bindings_redland_store_lookup(lua_State *);

int
lua_bindings_redland_store_new(lua_State *);

int
lua_bindings_redland_store_new_mt(lua_State *);

int
lua_bindings_redland_store_wrap(lua_State *, librdf_storage *);

int
luaopen_bindings_redland_store(lua_State *);

#endif
