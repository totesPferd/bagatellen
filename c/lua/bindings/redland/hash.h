#ifndef LUA_BINDINGS_REDLAND_HASH_H
#define LUA_BINDINGS_REDLAND_HASH_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_hash_clone(lua_State *);

int
lua_bindings_redland_hash_gc(lua_State *);

int
lua_bindings_redland_hash_get(lua_State *);

int
lua_bindings_redland_hash_get_boolean(lua_State *);

int
lua_bindings_redland_hash_get_del(lua_State *);

int
lua_bindings_redland_hash_get_long(lua_State *);

int
lua_bindings_redland_hash_init(lua_State *);

int
lua_bindings_redland_hash_insert(lua_State *);

int
lua_bindings_redland_hash_interpret(lua_State *);

int
lua_bindings_redland_hash_new(lua_State *);

int
lua_bindings_redland_hash_new_from_string(lua_State *);

int
lua_bindings_redland_hash_new_mt(lua_State *);

int
lua_bindings_redland_hash_wrap(lua_State *, librdf_hash *);

int
luaopen_bindings_redland_hash(lua_State *);

#endif
