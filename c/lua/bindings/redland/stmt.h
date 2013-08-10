#ifndef LUA_BINDINGS_REDLAND_STMT_H
#define LUA_BINDINGS_REDLAND_STMT_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_stmt_clear(lua_State *);

int
lua_bindings_redland_stmt_clone(lua_State *);

int
lua_bindings_redland_stmt_eq(lua_State *);

int
lua_bindings_redland_stmt_gc(lua_State *);

int
lua_bindings_redland_stmt_get_object(lua_State *);

int
lua_bindings_redland_stmt_get_predicate(lua_State *);

int
lua_bindings_redland_stmt_get_subject(lua_State *);

int
lua_bindings_redland_stmt_is_complete(lua_State *);

int
lua_bindings_redland_stmt_is_match(lua_State *);

int
lua_bindings_redland_stmt_new(lua_State *);

int
lua_bindings_redland_stmt_set_object(lua_State *);

int
lua_bindings_redland_stmt_set_predicate(lua_State *);

int
lua_bindings_redland_stmt_set_subject(lua_State *);

int
lua_bindings_redland_stmt_new_mt(lua_State *);

int
lua_bindings_redland_stmt_wrap(lua_State *, librdf_statement *);

int
luaopen_bindings_redland_stmt(lua_State *);

#endif
