#include "uri.h"
#include "defs.h"
#include <lauxlib.h>

int
lua_bindings_redland_uri_clone(lua_State *L) {
   librdf_uri **pp_arg =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );

   lua_pop(L, 1);

   lua_bindings_redland_uri_new_mt(L);
   return lua_bindings_redland_uri_wrap(L, librdf_new_uri_from_uri(*pp_arg));
}

int
lua_bindings_redland_uri_eq(lua_State *L) {
   librdf_uri **pp_arg_1 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -2
      ,  uri_userdata_type );
   librdf_uri **pp_arg_2 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );

   lua_pop(L, 2);

   lua_pushboolean(L, librdf_uri_equals(*pp_arg_1, *pp_arg_2));

   return 1;
}

int
lua_bindings_redland_uri_gc(lua_State *L) {
   librdf_uri **pp_uri =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );

   lua_pop(L, 1);

   librdf_free_uri(*pp_uri);

   return 0;
}

int
lua_bindings_redland_uri_get_filename(lua_State *L) {
   librdf_uri **pp_uri =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );

   lua_pop(L, 1);

   if (librdf_uri_is_file_uri(*pp_uri)) {
      const char *filename =  librdf_uri_to_filename(*pp_uri);
      lua_pushstring(L, filename);
      librdf_free_memory((void *) filename);

      return 1;
   } else {
      return 0;
   }
}

int
lua_bindings_redland_uri_le(lua_State *L) {
   librdf_uri **pp_arg_1 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -2
      ,  uri_userdata_type );
   librdf_uri **pp_arg_2 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );

   lua_pop(L, 2);

   {
      int cmp_result =  librdf_uri_compare(*pp_arg_1, *pp_arg_2);
      lua_pushboolean(L, cmp_result <= 0);
   }

   return 1;
}

int
lua_bindings_redland_uri_lt(lua_State *L) {
   librdf_uri **pp_arg_1 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -2
      ,  uri_userdata_type );
   librdf_uri **pp_arg_2 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );

   lua_pop(L, 2);

   {
      int cmp_result =  librdf_uri_compare(*pp_arg_1, *pp_arg_2);
      lua_pushboolean(L, cmp_result < 0);
   }

   return 1;
}

int
lua_bindings_redland_uri_new(lua_State *L) {
   librdf_world **pp_arg_1 =  (librdf_world **) luaL_checkudata(
         L
      ,  -2
      ,  world_userdata_type );
   const char *arg_2 =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   {
      librdf_uri *p_uri =  librdf_new_uri(*pp_arg_1, arg_2);
      lua_bindings_redland_uri_new_mt(L);
      return lua_bindings_redland_uri_wrap(L, p_uri);
   }
}

int
lua_bindings_redland_uri_new_from_filename(lua_State *L) {
   librdf_world **pp_arg_1 =  (librdf_world **) luaL_checkudata(
         L
      ,  -2
      ,  world_userdata_type );
   const char *arg_2 =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   {
      librdf_uri *p_uri =  librdf_new_uri_from_filename(*pp_arg_1, arg_2);
      lua_bindings_redland_uri_new_mt(L);
      return lua_bindings_redland_uri_wrap(L, p_uri);
   }
}

int
lua_bindings_redland_uri_new_from_local_name(lua_State *L) {
   librdf_uri **pp_arg_1 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -2
      ,  uri_userdata_type );
   const char *arg_2 =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   {
      librdf_uri *p_uri =  librdf_new_uri_from_uri_local_name(*pp_arg_1, arg_2);
      lua_bindings_redland_uri_new_mt(L);
      return lua_bindings_redland_uri_wrap(L, p_uri);
   }
}

int
lua_bindings_redland_uri_new_normalized_to_base(lua_State *L) {
   librdf_uri **pp_arg_1 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -3
      ,  uri_userdata_type );
   librdf_uri **pp_arg_2 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -2
      ,  uri_userdata_type );
   const char *arg_3 =  luaL_checkstring(L, -1);

   lua_pop(L, 3);

   {
      librdf_uri *p_uri =  librdf_new_uri_normalised_to_base(arg_3, *pp_arg_1, *pp_arg_2);
      lua_bindings_redland_uri_new_mt(L);
      return lua_bindings_redland_uri_wrap(L, p_uri);
   }
}

int
lua_bindings_redland_uri_new_relative_to_base(lua_State *L) {
   librdf_uri **pp_arg_1 =  (librdf_uri **) luaL_checkudata(
         L
      ,  -2
      ,  uri_userdata_type );
   const char *arg_2 =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   {
      librdf_uri *p_uri =  librdf_new_uri_relative_to_base(*pp_arg_1, arg_2);
      lua_bindings_redland_uri_new_mt(L);
      return lua_bindings_redland_uri_wrap(L, p_uri);
   }
}

int
lua_bindings_redland_uri_tostring(lua_State *L) {
   librdf_uri **pp_uri =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );

   lua_pop(L, 1);

   {
      unsigned char *result =  librdf_uri_as_string(*pp_uri);
      lua_pushstring(L, result);
   }

   return 1;
}



/* ------------------------------------------------------------ */

int
lua_bindings_redland_uri_new_mt(lua_State *L) {
   luaL_newmetatable(L, uri_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_uri_eq);
   lua_setfield(L, -2, "__eq");

   lua_pushcfunction(L, &lua_bindings_redland_uri_gc);
   lua_setfield(L, -2, "__gc");

   lua_pushcfunction(L, &lua_bindings_redland_uri_le);
   lua_setfield(L, -2, "__le");

   lua_pushcfunction(L, &lua_bindings_redland_uri_lt);
   lua_setfield(L, -2, "__lt");

   lua_pushcfunction(L, &lua_bindings_redland_uri_tostring);
   lua_setfield(L, -2, "__tostring");

   return 1;
}
   
int
lua_bindings_redland_uri_wrap(lua_State *L, librdf_uri *p_uri) {
   if (p_uri) {
      librdf_uri **pp_uri =  (librdf_uri **) lua_newuserdata(
            L
         ,  sizeof(librdf_uri *) );
      *pp_uri =  p_uri;
   
      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      lua_pop(L, 1);
      return 0;
   }
}

int
luaopen_bindings_redland_uri(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_uri_clone);
   lua_setfield(L, -2, "__clone");

   lua_pushcfunction(L, &lua_bindings_redland_uri_get_filename);
   lua_setfield(L, -2, "get_filename");
   
   lua_pushcfunction(L, &lua_bindings_redland_uri_new);
   lua_setfield(L, -2, "new");

   lua_pushcfunction(L, &lua_bindings_redland_uri_new_from_filename);
   lua_setfield(L, -2, "new_from_filename");

   lua_pushcfunction(L, &lua_bindings_redland_uri_new_from_local_name);
   lua_setfield(L, -2, "new_from_local_name");

   lua_pushcfunction(L, &lua_bindings_redland_uri_new_normalized_to_base);
   lua_setfield(L, -2, "new_normalized_to_base");

   lua_pushcfunction(L, &lua_bindings_redland_uri_new_relative_to_base);
   lua_setfield(L, -2, "new_relative_to_base");

   return 1;
}
