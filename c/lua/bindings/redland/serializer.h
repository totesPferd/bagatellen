#ifndef LUA_BINDINGS_REDLAND_SERIALIZER_H
#define LUA_BINDINGS_REDLAND_SERIALIZER_H
#include <librdf.h>
#include <lua.h>

int
lua_bindings_redland_serializer_gc(lua_State *);

int
lua_bindings_redland_serializer_get_feature(lua_State *);

int
lua_bindings_redland_serializer_is_there_serializer(lua_State *);

int
lua_bindings_redland_serializer_new(lua_State *);

int
lua_bindings_redland_serializer_new_mt(lua_State *);

int
lua_bindings_redland_serializer_serialize_stream_to_file(lua_State *);

int
lua_bindings_redland_serializer_serialize_stream_to_string(lua_State *);

int
lua_bindings_redland_serializer_serialize_to_file(lua_State *);

int
lua_bindings_redland_serializer_serialize_to_string(lua_State *);

int
lua_bindings_redland_serializer_set_feature(lua_State *);

int
lua_bindings_redland_serializer_set_namespace(lua_State *);

int
lua_bindings_redland_serializer_wrap(lua_State *, librdf_serializer *);

int
luaopen_bindings_redland_serializer(lua_State *);

#endif
