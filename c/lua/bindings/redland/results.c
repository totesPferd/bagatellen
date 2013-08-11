#include "results.h"
#include "defs.h"
#include <lauxlib.h>

int
lua_bindings_redland_results_gc(lua_State *L) {
   librdf_query_results **pp_results
      =  (librdf_query_results **) luaL_checkudata(
            L
         ,  -1
         ,  res_userdata_type );

   lua_pop(L, 1);

   librdf_free_query_results(*pp_results);

   return 0;
}

int
lua_bindings_redland_results_is_finished(lua_State *L) {
   librdf_query_results **pp_results
      =  (librdf_query_results **) luaL_checkudata(
            L
         ,  -1
         ,  res_userdata_type );

   lua_pop(L, 1);

   int result =  librdf_query_results_finished(*pp_results);
   lua_pushboolean(L, result);

   return 1;
}

int
lua_bindings_redland_results_next(lua_State *L) {
   librdf_query_results **pp_results
      =  (librdf_query_results **) luaL_checkudata(
            L
         ,  -1
         ,  res_userdata_type );

   lua_pop(L, 1);

   int result =  librdf_query_results_next(*pp_results);
   lua_pushboolean(L, result);

   return 1;
}

int
lua_bindings_redland_results_size(lua_State *L) {
   librdf_query_results **pp_results
      =  (librdf_query_results **) luaL_checkudata(
            L
         ,  -1
         ,  res_userdata_type );

   lua_pop(L, 1);

   int result =  librdf_query_results_get_count(*pp_results);
   lua_pushnumber(L, result);

   return 1;
}

int
lua_bindings_redland_results_to_file(lua_State *L) {
   librdf_query_results **pp_results
      =  (librdf_query_results **) luaL_checkudata(
            L
         ,  -3
         ,  res_userdata_type );

   const char *name =  luaL_checkstring(L, -2);

   librdf_uri *p_base_uri =  NULL;
   {
      lua_getfield(L, -1, "base");
      if (!lua_isnil(L, -1)) {
         librdf_uri **pp_base_uri
            =  (librdf_uri **) luaL_checkudata(
                  L
               ,  -1
               ,  uri_userdata_type );
         p_base_uri =  *pp_base_uri;
      }
      lua_pop(L, 1);
   }

   lua_getfield(L, -1, "mime_type");
   const char *mime_type =  luaL_checkstring(L, -1);
   lua_pop(L, 1);

   librdf_uri *p_format_uri =  NULL;
   {
      lua_getfield(L, -1, "format");
      if (!lua_isnil(L, -1)) {
         librdf_uri **pp_format_uri
            =  (librdf_uri **) luaL_checkudata(
                  L
               ,  -1
               ,  uri_userdata_type );
         p_format_uri =  *pp_format_uri;
      }
      lua_pop(L, 1);
   }

   lua_pop(L, 3);

   int result =  librdf_query_results_to_file2(
         *pp_results
      ,  name
      ,  mime_type
      ,  p_format_uri
      ,  p_base_uri );
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_results_to_string(lua_State *L) {
   librdf_query_results **pp_results
      =  (librdf_query_results **) luaL_checkudata(
            L
         ,  -3
         ,  res_userdata_type );

   const char *name =  luaL_checkstring(L, -2);

   librdf_uri *p_base_uri =  NULL;
   {
      lua_getfield(L, -1, "base");
      if (!lua_isnil(L, -1)) {
         librdf_uri **pp_base_uri
            =  (librdf_uri **) luaL_checkudata(
                  L
               ,  -1
               ,  uri_userdata_type );
         p_base_uri =  *pp_base_uri;
      }
      lua_pop(L, 1);
   }

   lua_getfield(L, -1, "mime_type");
   const char *mime_type =  luaL_checkstring(L, -1);
   lua_pop(L, 1);

   librdf_uri *p_format_uri =  NULL;
   {
      lua_getfield(L, -1, "format");
      if (!lua_isnil(L, -1)) {
         librdf_uri **pp_format_uri
            =  (librdf_uri **) luaL_checkudata(
                  L
               ,  -1
               ,  uri_userdata_type );
         p_format_uri =  *pp_format_uri;
      }
      lua_pop(L, 1);
   }

   lua_pop(L, 3);

   unsigned char *result =  librdf_query_results_to_string2(
         *pp_results
      ,  name
      ,  mime_type
      ,  p_format_uri
      ,  p_base_uri );
   if (result) {
      lua_pushstring(L, result);
      librdf_free_memory(result);
      return 1;
   } else {
      return 0;
   }
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_results_new_mt(lua_State *L) {
   luaL_newmetatable(L, qfmt_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_results_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_results_wrap(lua_State *L, librdf_query_results *p_results) {
   if (p_results) {
      librdf_query_results **pp_results
         =  (librdf_query_results **) lua_newuserdata(
               L
            ,  sizeof(librdf_query_results *) );
      *pp_results =  p_results;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      return 0;
   }
}

int
luaopen_bindings_redland_results(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_results_is_finished);
   lua_setfield(L, -2, "is_finished");

   lua_pushcfunction(L, &lua_bindings_redland_results_next);
   lua_setfield(L, -2, "next");

   lua_pushcfunction(L, &lua_bindings_redland_results_size);
   lua_setfield(L, -2, "size");

   lua_pushcfunction(L, &lua_bindings_redland_results_to_file);
   lua_setfield(L, -2, "to_file");

   lua_pushcfunction(L, &lua_bindings_redland_results_to_string);
   lua_setfield(L, -2, "to_string");

   return 1;
}
