#ifndef LUA_BINDINGS_REDLAND_FORMATTER_H
#define LUA_BINDINGS_REDLAND_FORMATTER_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_formatter_gc(lua_State *);

int
lua_bindings_redland_formatter_new_mt(lua_State *);

int
lua_bindings_redland_formatter_wrap(lua_State *, librdf_query_results_formatter *);

int
luaopen_bindings_redland_formatter(lua_State *);

#endif
