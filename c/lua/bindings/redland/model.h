#ifndef LUA_BINDINGS_REDLAND_MODULE_H
#define LUA_BINDINGS_REDLAND_MODULE_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_model_add(lua_State *);

int
lua_bindings_redland_model_clone(lua_State *);

int
lua_bindings_redland_model_context_add(lua_State *);

int
lua_bindings_redland_model_context_del(lua_State *);

int
lua_bindings_redland_model_del(lua_State *);

int
lua_bindings_redland_model_gc(lua_State *);

int
lua_bindings_redland_model_get_feature(lua_State *);

int
lua_bindings_redland_model_is_containing(lua_State *);

int
lua_bindings_redland_model_is_there_object(lua_State *);

int
lua_bindings_redland_model_is_there_subject(lua_State *);

int
lua_bindings_redland_model_lookup(lua_State *);

int
lua_bindings_redland_model_is_containing(lua_State *);

int
lua_bindings_redland_model_new(lua_State *);

int
lua_bindings_redland_model_new_mt(lua_State *);

int
lua_bindings_redland_model_set_feature(lua_State *);

int
lua_bindings_redland_model_size(lua_State *);

int
lua_bindings_redland_model_sync(lua_State *);

int
lua_bindings_redland_model_transaction_commit(lua_State *);

int
lua_bindings_redland_model_transaction_get_handle(lua_State *);

int
lua_bindings_redland_model_transaction_rollback(lua_State *);

int
lua_bindings_redland_model_transaction_start(lua_State *);

int
lua_bindings_redland_model_transaction_start_with_handle(lua_State *);

int
lua_bindings_redland_model_wrap(lua_State *, librdf_model *);

int
luaopen_bindings_redland_model(lua_State *);

#endif
