#ifndef LUA_BINDINGS_REDLAND_RESULTS_H
#define LUA_BINDINGS_REDLAND_RESULTS_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_results_gc(lua_State *);

int
lua_bindings_redland_results_get_boolean(lua_State *);

int
lua_bindings_redland_results_is_binding(lua_State *);

int
lua_bindings_redland_results_is_boolean(lua_State *);

int
lua_bindings_redland_results_is_finished(lua_State *);

int
lua_bindings_redland_results_is_graph(lua_State *);

int
lua_bindings_redland_results_is_syntax(lua_State *);

int
lua_bindings_redland_results_is_there_formatter(lua_State *);

int
lua_bindings_redland_results_new(lua_State *);

int
lua_bindings_redland_results_new_formatter(lua_State *);

int
lua_bindings_redland_results_new_mt(lua_State *);

int
lua_bindings_redland_results_next(lua_State *);

int
lua_bindings_redland_results_size(lua_State *);

int
lua_bindings_redland_results_to_file(lua_State *);

int
lua_bindings_redland_results_to_string(lua_State *);

int
lua_bindings_redland_results_wrap(lua_State *, librdf_query_results *);

int
luaopen_bindings_redland_results(lua_State *);

#endif
