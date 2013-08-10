#ifndef LUA_BINDINGS_REDLAND_HASH_H
#define LUA_BINDINGS_REDLAND_HASH_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_hash_gc(lua_State *);

int
lua_bindings_redland_hash_new(lua_State *);

int
lua_bindings_redland_hash_new_mt(lua_State *);

int
lua_bindings_redland_hash_wrap(lua_State *, librdf_hash *);

int
luaopen_bindings_redland_hash(lua_State *);

#endif
