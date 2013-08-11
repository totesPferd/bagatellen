#include "query.h"
#include "defs.h"
#include "results.h"
#include <lauxlib.h>

int
lua_bindings_redland_query_clone(lua_State *L) {
   librdf_query **pp_query
      =  (librdf_query **) luaL_checkudata(
            L
         ,  -1
         ,  query_userdata_type );

   lua_pop(L, 1);

   librdf_query *result =  librdf_new_query_from_query(*pp_query);
   lua_bindings_redland_query_new_mt(L);
   return lua_bindings_redland_query_wrap(L, result);
}

int
lua_bindings_redland_query_execute(lua_State *L) {
   librdf_query **pp_query
      =  (librdf_query **) luaL_checkudata(
            L
         ,  -2
         ,  query_userdata_type );
   librdf_model **pp_model
      =  (librdf_model **) luaL_checkudata(
            L
         ,  -1
         ,  model_userdata_type );

   lua_pop(L, 2);

   librdf_query_results *result =  librdf_query_execute(
         *pp_query
      ,  *pp_model );
   lua_bindings_redland_results_new_mt(L);
   return lua_bindings_redland_results_wrap(L, result);
}

int
lua_bindings_redland_query_gc(lua_State *L) {
   librdf_query **pp_query
      =  (librdf_query **) luaL_checkudata(
            L
         ,  -1
         ,  query_userdata_type );

   lua_pop(L, 1);

   librdf_free_query(*pp_query);

   return 0;
}

int
lua_bindings_redland_query_get_limit(lua_State *L) {
   librdf_query **pp_query
      =  (librdf_query **) luaL_checkudata(
            L
         ,  -1
         ,  query_userdata_type );

   lua_pop(L, 1);

   int result =  librdf_query_get_limit(*pp_query);
   lua_pushnumber(L, result);

   return 1;
}

int
lua_bindings_redland_query_get_offset(lua_State *L) {
   librdf_query **pp_query
      =  (librdf_query **) luaL_checkudata(
            L
         ,  -1
         ,  query_userdata_type );

   lua_pop(L, 1);

   int result =  librdf_query_get_offset(*pp_query);
   lua_pushnumber(L, result);

   return 1;
}

int
lua_bindings_redland_query_new(lua_State *L) {
   librdf_world **pp_world
      =  (librdf_world **) luaL_checkudata(
            L
         ,  -4
         ,  world_userdata_type );
   const char *name =  luaL_checkstring(L, -3);
   const unsigned char *query_string =  luaL_checkstring(L, -2);

   librdf_uri *p_uri =  NULL;
   lua_getfield(L, -1 , "uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
       p_uri = *pp_uri;
   }
   lua_pop(L, 1);

   librdf_uri *p_base_uri =  NULL;
   lua_getfield(L, -1 , "base_uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_base_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
       p_base_uri = *pp_base_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 4);

   librdf_query *result =  librdf_new_query(
         *pp_world
      ,  name
      ,  p_uri
      ,  query_string
      ,  p_base_uri );
   lua_bindings_redland_query_new_mt(L);
   return lua_bindings_redland_query_wrap(L, result);
}

int
lua_bindings_redland_query_set_limit(lua_State *L) {
   librdf_query **pp_query
      =  (librdf_query **) luaL_checkudata(
            L
         ,  -2
         ,  query_userdata_type );
   int limit =  (int) luaL_checkinteger(L, -1);

   lua_pop(L, 2);

   int result =  librdf_query_set_limit(*pp_query, limit);
   lua_pushboolean(L, result);

   return 1;
}

int
lua_bindings_redland_query_set_offset(lua_State *L) {
   librdf_query **pp_query
      =  (librdf_query **) luaL_checkudata(
            L
         ,  -2
         ,  query_userdata_type );
   int offset =  (int) luaL_checkinteger(L, -1);

   lua_pop(L, 2);

   int result =  librdf_query_set_offset(*pp_query, offset);
   lua_pushboolean(L, result);

   return 1;
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_query_new_mt(lua_State *L) {
   luaL_newmetatable(L, query_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_query_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_query_wrap(lua_State *L, librdf_query *p_query) {
   if (p_query) {
      librdf_query **pp_query
         =  (librdf_query **) lua_newuserdata(
               L
            ,  sizeof(librdf_query *) );
      *pp_query =  p_query;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      return 0;
   }
}

int
luaopen_bindings_redland_query(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_query_clone);
   lua_setfield(L, -2, "__clone");

   lua_pushcfunction(L, &lua_bindings_redland_query_execute);
   lua_setfield(L, -2, "execute");

   lua_pushcfunction(L, &lua_bindings_redland_query_get_limit);
   lua_setfield(L, -2, "get_limit");

   lua_pushcfunction(L, &lua_bindings_redland_query_get_offset);
   lua_setfield(L, -2, "get_offset");

   lua_pushcfunction(L, &lua_bindings_redland_query_new);
   lua_setfield(L, -2, "new");

   lua_pushcfunction(L, &lua_bindings_redland_query_set_limit);
   lua_setfield(L, -2, "set_limit");

   lua_pushcfunction(L, &lua_bindings_redland_query_set_offset);
   lua_setfield(L, -2, "set_offset");

   return 1;
}
