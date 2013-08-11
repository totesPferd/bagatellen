#ifndef LUA_BINDINGS_REDLAND_TRANSACTION_H
#define LUA_BINDINGS_REDLAND_TRANSACTION_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_transaction_gc(lua_State *);

int
lua_bindings_redland_transaction_new(lua_State *);

int
lua_bindings_redland_transaction_new_mt(lua_State *);

int
lua_bindings_redland_transaction_wrap(lua_State *, void *);

int
luaopen_bindings_redland_transaction(lua_State *);

#endif
