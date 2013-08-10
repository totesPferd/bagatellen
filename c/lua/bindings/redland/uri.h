#ifndef LUA_BINDINGS_REDLAND_URI_H
#define LUA_BINDINGS_REDLAND_URI_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_uri_clone(lua_State *);

int
lua_bindings_redland_uri_eq(lua_State *);

int
lua_bindings_redland_uri_gc(lua_State *);

int
lua_bindings_redland_uri_get_filename(lua_State *);

int
lua_bindings_redland_uri_le(lua_State *);

int
lua_bindings_redland_uri_lt(lua_State *);

int
lua_bindings_redland_uri_new(lua_State *);

int
lua_bindings_redland_uri_new_from_filename(lua_State *);

int
lua_bindings_redland_uri_new_from_local_name(lua_State *);

int
lua_bindings_redland_uri_new_normalized_to_base(lua_State *);

int
lua_bindings_redland_uri_new_relative_to_base(lua_State *);

int
lua_bindings_redland_uri_tostring(lua_State *);

int
lua_bindings_redland_uri_new_mt(lua_State *);

int
lua_bindings_redland_uri_wrap(lua_State *, librdf_uri *);

int
luaopen_bindings_redland_uri(lua_State *);

#endif
