#ifndef LUA_BINDINGS_REDLAND_STORE_H
#define LUA_BINDINGS_REDLAND_STORE_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_store_add(lua_State *);

int
lua_bindings_redland_store_clone(lua_State *);

int
lua_bindings_redland_store_close(lua_State *);

int
lua_bindings_redland_store_context_add(lua_State *);

int
lua_bindings_redland_store_context_del(lua_State *);

int
lua_bindings_redland_store_del(lua_State *);

int
lua_bindings_redland_store_gc(lua_State *);

int
lua_bindings_redland_store_get_feature(lua_State *);

int
lua_bindings_redland_store_get_world(lua_State *);

int
lua_bindings_redland_store_is_containing(lua_State *);

int
lua_bindings_redland_store_is_supporting_query(lua_State *);

int
lua_bindings_redland_store_is_there_object(lua_State *);

int
lua_bindings_redland_store_is_there_subject(lua_State *);

int
lua_bindings_redland_store_lookup(lua_State *);

int
lua_bindings_redland_store_is_containing(lua_State *);

int
lua_bindings_redland_store_new(lua_State *);

int
lua_bindings_redland_store_new_mt(lua_State *);

int
lua_bindings_redland_store_open(lua_State *);

int
lua_bindings_redland_store_set_feature(lua_State *);

int
lua_bindings_redland_store_size(lua_State *);

int
lua_bindings_redland_store_sync(lua_State *);

int
lua_bindings_redland_store_transaction_commit(lua_State *);

int
lua_bindings_redland_store_transaction_rollback(lua_State *);

int
lua_bindings_redland_store_transaction_start(lua_State *);

int
lua_bindings_redland_store_wrap(lua_State *, librdf_storage *);

int
luaopen_bindings_redland_store(lua_State *);

#endif
