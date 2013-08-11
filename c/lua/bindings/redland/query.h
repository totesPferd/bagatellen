#ifndef LUA_BINDINGS_REDLAND_FORMATTER_H
#define LUA_BINDINGS_REDLAND_FORMATTER_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_query_clone(lua_State *);

int
lua_bindings_redland_query_execute(lua_State *);

int
lua_bindings_redland_query_gc(lua_State *);

int
lua_bindings_redland_query_get_limit(lua_State *);

int
lua_bindings_redland_query_get_offset(lua_State *);

int
lua_bindings_redland_query_new(lua_State *);

int
lua_bindings_redland_query_new_mt(lua_State *);

int
lua_bindings_redland_query_set_limit(lua_State *);

int
lua_bindings_redland_query_set_offset(lua_State *);

int
lua_bindings_redland_query_wrap(lua_State *, librdf_query *);

int
luaopen_bindings_redland_query(lua_State *);

#endif
