#include "stream.h"
#include "defs.h"
#include "node.h"
#include "stmt.h"
#include <lauxlib.h>

int
lua_bindings_redland_stream_gc(lua_State *L) {
   librdf_stream **pp_stream =  (librdf_stream **) luaL_checkudata(
         L
      ,  -1
      ,  stream_userdata_type );

   lua_pop(L, 1);

   librdf_free_stream(*pp_stream);

   return 0;
}

int
lua_bindings_redland_stream_get_context(lua_State *L) {
   librdf_stream **pp_stream =  (librdf_stream **) luaL_checkudata(
         L
      ,  -1
      ,  stream_userdata_type );

   lua_pop(L, 1);

   librdf_node *p_context =  librdf_stream_get_context2(*pp_stream);
   if (p_context) {
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(
            L
         ,  librdf_new_node_from_node(p_context) );
   } else {
      return 0;
   }
}

int
lua_bindings_redland_stream_get_stmt(lua_State *L) {
   librdf_stream **pp_stream =  (librdf_stream **) luaL_checkudata(
         L
      ,  -1
      ,  stream_userdata_type );

   lua_pop(L, 1);

   librdf_statement *p_stmt =  librdf_stream_get_object(*pp_stream);
   if (p_stmt) {
      lua_bindings_redland_stmt_new_mt(L);
      return lua_bindings_redland_stmt_wrap(
            L
         ,  librdf_new_statement_from_statement(p_stmt) );
   } else {
      return 0;
   }
}

int
lua_bindings_redland_stream_is_eos(lua_State *L) {
   librdf_stream **pp_stream =  (librdf_stream **) luaL_checkudata(
         L
      ,  -1
      ,  stream_userdata_type );

   lua_pop(L, 1);

   lua_pushboolean(L, librdf_stream_end(*pp_stream));
   return 1;
}

int
lua_bindings_redland_stream_new_empty(lua_State *L) {
   librdf_world **pp_arg_1 =  (librdf_world **) luaL_checkudata(
         L
      ,  -1
      ,  world_userdata_type );

   lua_pop(L, 1);

   {
      librdf_stream *p_stream =  librdf_new_empty_stream(*pp_arg_1);
      lua_bindings_redland_stream_new_mt(L);
      return lua_bindings_redland_stream_wrap(L, p_stream);
   }
}

int
lua_bindings_redland_stream_next(lua_State *L) {
   librdf_stream **pp_stream =  (librdf_stream **) luaL_checkudata(
         L
      ,  -1
      ,  stream_userdata_type );

   lua_pop(L, 1);

   lua_pushboolean(L, librdf_stream_next(*pp_stream));
   return 1;
}



/* ------------------------------------------------------------ */

int
lua_bindings_redland_stream_new_mt(lua_State *L) {
   luaL_newmetatable(L, stream_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_stream_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}
   
int
lua_bindings_redland_stream_wrap(lua_State *L, librdf_stream *p_stream) {
   if (p_stream) {
      librdf_stream **pp_stream =  (librdf_stream **) lua_newuserdata(
            L
         ,  sizeof(librdf_stream *) );
      *pp_stream =  p_stream;
   
      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      lua_pop(L, 1);
      return 0;
   }
}

int
luaopen_bindings_redland_stream(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_stream_get_context);
   lua_setfield(L, -2, "get_context");
   
   lua_pushcfunction(L, &lua_bindings_redland_stream_get_stmt);
   lua_setfield(L, -2, "get_stmt");
   
   lua_pushcfunction(L, &lua_bindings_redland_stream_is_eos);
   lua_setfield(L, -2, "is_eos");
   
   lua_pushcfunction(L, &lua_bindings_redland_stream_new_empty);
   lua_setfield(L, -2, "new_empty");

   lua_pushcfunction(L, &lua_bindings_redland_stream_next);
   lua_setfield(L, -2, "next");

   return 1;
}
