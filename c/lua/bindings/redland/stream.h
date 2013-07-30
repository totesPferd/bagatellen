#ifndef LUA_BINDINGS_REDLAND_STREAM_H
#define LUA_BINDINGS_REDLAND_STREAM_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_stream_gc(lua_State *);

int
lua_bindings_redland_stream_get_context(lua_State *);

int
lua_bindings_redland_stream_get_stmt(lua_State *);

int
lua_bindings_redland_stream_is_eos(lua_State *);

int
lua_bindings_redland_stream_new_empty(lua_State *);

int
lua_bindings_redland_stream_next(lua_State *);

int
lua_bindings_redland_stream_new_mt(lua_State *);

int
lua_bindings_redland_stream_wrap(lua_State *, librdf_stream *);

int
luaopen_bindings_redland_stream(lua_State *);

#endif
