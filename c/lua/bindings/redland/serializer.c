#include "serializer.h"
#include "defs.h"
#include "node.h"
#include "uri.h"
#include <lauxlib.h>

int
lua_bindings_redland_serializer_gc(lua_State *L) {
   librdf_serializer **pp_serializer
      =  (librdf_serializer **) luaL_checkudata(
            L
         ,  -1
         ,  serializer_userdata_type );

   lua_pop(L, 1);

   librdf_free_serializer(*pp_serializer);

   return 0;
}

int
lua_bindings_redland_serializer_get_feature(lua_State *L) {
   librdf_serializer **pp_serializer
      =  (librdf_serializer **) luaL_checkudata(
            L
         ,  -2
         ,  serializer_userdata_type );
   librdf_uri **pp_uri
      =  (librdf_uri **) luaL_checkudata(
            L
         ,  -1
         ,  uri_userdata_type );

   lua_pop(L, 2);

   librdf_node *p_node =  librdf_serializer_get_feature(*pp_serializer, *pp_uri);
   lua_bindings_redland_node_new_mt(L);
   return lua_bindings_redland_node_wrap(L, p_node);
}

int
lua_bindings_redland_serializer_is_there_serializer(lua_State *L) {
   librdf_world **pp_world
      =  (librdf_world **) luaL_checkudata(
            L
         ,  -2
         ,  world_userdata_type );
   const char *name =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   int result =  librdf_serializer_check_name(*pp_world, name);
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_serializer_new(lua_State *L) {
   librdf_world **pp_world
      =  (librdf_world **) luaL_checkudata(
            L
         ,  -2
         ,  world_userdata_type );

   const char *name =  NULL;
   lua_getfield(L, -1, "name");
   if (!lua_isnil(L, -1)) {
      name =  luaL_checkstring(L, -1);
   }
   lua_pop(L, 1);

   const char *mime_type =  NULL;
   lua_getfield(L, -1, "mime_type");
   if (!lua_isnil(L, -1)) {
      mime_type =  luaL_checkstring(L, -1);
   }
   lua_pop(L, 1);

   librdf_uri *p_type_uri =  NULL;
   lua_getfield(L, -1 , "type_uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_type_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
       p_type_uri = *pp_type_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 2);

   librdf_serializer *result =  librdf_new_serializer(
         *pp_world
      ,  name
      ,  mime_type
      ,  p_type_uri );
   lua_bindings_redland_serializer_new_mt(L);
   return lua_bindings_redland_serializer_wrap(L, result);
}

int
lua_bindings_redland_serializer_serialize_to_file(lua_State *L) {
   librdf_serializer **pp_serializer
      =  (librdf_serializer **) luaL_checkudata(
            L
         ,  -4
         ,  serializer_userdata_type );
   librdf_model **pp_model
      =  (librdf_model **) luaL_checkudata(
            L
         ,  -3
         ,  model_userdata_type );
   const char *filename =  luaL_checkstring(L, -1);

   librdf_uri *p_uri =  NULL;
   lua_getfield(L, -1, "base_uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
      p_uri =  *pp_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 4);

   int result =  librdf_serializer_serialize_model_to_file(
         *pp_serializer
      ,  filename
      ,  p_uri
      ,  *pp_model);
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_serializer_serialize_to_string(lua_State *L) {
   librdf_serializer **pp_serializer
      =  (librdf_serializer **) luaL_checkudata(
            L
         ,  -4
         ,  serializer_userdata_type );
   librdf_model **pp_model
      =  (librdf_model **) luaL_checkudata(
            L
         ,  -3
         ,  model_userdata_type );

   librdf_uri *p_uri =  NULL;
   lua_getfield(L, -1, "base_uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
      p_uri =  *pp_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 3);

   unsigned char *result =  librdf_serializer_serialize_model_to_string(
         *pp_serializer
      ,  p_uri
      ,  *pp_model);
   if (result) {
      lua_pushstring(L, result);
      return 1;
   } else {
      return 0;
   }
}

int
lua_bindings_redland_serializer_set_feature(lua_State *L) {
   librdf_serializer **pp_serializer
      =  (librdf_serializer **) luaL_checkudata(
            L
         ,  -3
         ,  serializer_userdata_type );
   librdf_uri **pp_uri
      =  (librdf_uri **) luaL_checkudata(
            L
         ,  -2
         ,  uri_userdata_type );
   librdf_node **pp_node
      =  (librdf_node **) luaL_checkudata(
            L
         ,  -1
         ,  node_userdata_type );

   lua_pop(L, 3);

   int result =  librdf_serializer_set_feature(*pp_serializer, *pp_uri, *pp_node);
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_serializer_set_namespace(lua_State *L) {
   librdf_serializer **pp_serializer
      =  (librdf_serializer **) luaL_checkudata(
            L
         ,  -2
         ,  serializer_userdata_type );

   const char *prefix =  NULL;
   lua_getfield(L, -1, "prefix");
   if (!lua_isnil(L, -1)) {
      prefix =  luaL_checkstring(L, -1);
   }
   lua_pop(L, 1);

   librdf_uri *p_uri =  NULL;
   lua_getfield(L, -1, "uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
      p_uri =  *pp_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 2);

   int result =  librdf_serializer_set_namespace(
         *pp_serializer
      ,  p_uri
      ,  prefix );
   lua_pushboolean(L, result);
   return 1;
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_serializer_new_mt(lua_State *L) {
   luaL_newmetatable(L, serializer_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_serializer_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_serializer_wrap(lua_State *L, librdf_serializer *p_serializer) {
   if (p_serializer) {
      librdf_serializer **pp_serializer
         =  (librdf_serializer **) lua_newuserdata(
               L
            ,  sizeof(librdf_serializer *) );
      *pp_serializer =  p_serializer;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      return 0;
   }
}

int
luaopen_bindings_redland_serializer(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_serializer_get_feature);
   lua_setfield(L, -2, "get_feature");

   lua_pushcfunction(L, &lua_bindings_redland_serializer_is_there_serializer);
   lua_setfield(L, -2, "is_there_serializer");

   lua_pushcfunction(L, &lua_bindings_redland_serializer_new);
   lua_setfield(L, -2, "new");

   lua_pushcfunction(L, &lua_bindings_redland_serializer_serialize_to_file);
   lua_setfield(L, -2, "serialize_to_file");

   lua_pushcfunction(L, &lua_bindings_redland_serializer_serialize_to_string);
   lua_setfield(L, -2, "serialize_to_string");

   lua_pushcfunction(L, &lua_bindings_redland_serializer_set_feature);
   lua_setfield(L, -2, "set_feature");

   lua_pushcfunction(L, &lua_bindings_redland_serializer_set_namespace);
   lua_setfield(L, -2, "set_namespace");

   return 1;
}
