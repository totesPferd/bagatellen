#ifndef LUA_BINDINGS_REDLAND_RESULTS_H
#define LUA_BINDINGS_REDLAND_RESULTS_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_results_gc(lua_State *);

int
lua_bindings_redland_results_new(lua_State *);

int
lua_bindings_redland_results_new_mt(lua_State *);

int
lua_bindings_redland_results_wrap(lua_State *, librdf_query_results *);

int
luaopen_bindings_redland_results(lua_State *);

#endif
