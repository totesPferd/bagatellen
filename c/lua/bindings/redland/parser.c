#include "parser.h"
#include "defs.h"
#include "node.h"
#include "stream.h"
#include "uri.h"
#include <lauxlib.h>

int
lua_bindings_redland_parser_gc(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -1
         ,  parser_userdata_type );

   lua_pop(L, 1);

   librdf_free_parser(*pp_parser);

   return 0;
}

int
lua_bindings_redland_parser_get_accept_header(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -1
         ,  parser_userdata_type );

   lua_pop(L, 1);

   char *result =  librdf_parser_get_accept_header(*pp_parser);
   lua_pushstring(L, result);
   return 1;
}

int
lua_bindings_redland_parser_get_feature(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -2
         ,  parser_userdata_type );
   librdf_uri **pp_uri
      =  (librdf_uri **) luaL_checkudata(
            L
         ,  -1
         ,  uri_userdata_type );

   lua_pop(L, 2);

   librdf_node *p_node =  librdf_parser_get_feature(*pp_parser, *pp_uri);
   lua_bindings_redland_node_new_mt(L);
   return lua_bindings_redland_node_wrap(L, p_node);
}

int
lua_bindings_redland_parser_get_namespaces_seen_count(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -1
         ,  parser_userdata_type );

   lua_pop(L, 1);

   int result =  librdf_parser_get_namespaces_seen_count(*pp_parser);
   lua_pushnumber(L, result);
   return 1;
}

int
lua_bindings_redland_parser_get_namespaces_seen_prefix(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -2
         ,  parser_userdata_type );
   int offset =  luaL_checkinteger(L, -1);

   lua_pop(L, 2);

   const char *result =  librdf_parser_get_namespaces_seen_prefix(
         *pp_parser
      ,  offset );
   if (result) {
      lua_pushstring(L, result);
      return 1;
   } else {
      return 0;
   }
}

int
lua_bindings_redland_parser_get_namespaces_seen_uri(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -2
         ,  parser_userdata_type );
   int offset =  luaL_checkinteger(L, -1);

   lua_pop(L, 2);

   librdf_uri *p_uri =  librdf_parser_get_namespaces_seen_uri(
         *pp_parser
      ,  offset );
   lua_bindings_redland_uri_new_mt(L);
   return lua_bindings_redland_uri_wrap(L, p_uri);
}

int
lua_bindings_redland_parser_is_there_parser(lua_State *L) {
   librdf_world **pp_world
      =  (librdf_world **) luaL_checkudata(
            L
         ,  -2
         ,  world_userdata_type );
   const char *name =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   int result =  librdf_parser_check_name(*pp_world, name);
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_parser_new(lua_State *L) {
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

   librdf_parser *result =  librdf_new_parser(
         *pp_world
      ,  name
      ,  mime_type
      ,  p_type_uri );
   lua_bindings_redland_parser_new_mt(L);
   return lua_bindings_redland_parser_wrap(L, result);
}

int
lua_bindings_redland_parser_parse(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -4
         ,  parser_userdata_type );
   librdf_uri **pp_uri
      =  (librdf_uri **) luaL_checkudata(
            L
         ,  -3
         ,  uri_userdata_type );
   librdf_model **pp_model
      =  (librdf_model **) luaL_checkudata(
            L
         ,  -2
         ,  model_userdata_type );

   librdf_uri *p_base_uri =  NULL;
   lua_getfield(L, -1, "base_uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_base_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
      p_base_uri =  *pp_base_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 4);

   int result =  librdf_parser_parse_into_model(
         *pp_parser
      ,  *pp_uri
      ,  p_base_uri
      ,  *pp_model );
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_parser_parse_string(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -4
         ,  parser_userdata_type );
   librdf_model **pp_model
      =  (librdf_model **) luaL_checkudata(
            L
         ,  -3
         ,  model_userdata_type );
   const char *content =  luaL_checkstring(L, -2);

   librdf_uri *p_base_uri =  NULL;
   lua_getfield(L, -1, "base_uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_base_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
      p_base_uri =  *pp_base_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 4);

   int result =  librdf_parser_parse_string_into_model(
         *pp_parser
      ,  content
      ,  p_base_uri
      ,  *pp_model );
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_parser_parse_string_into_stream(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -3
         ,  parser_userdata_type );
   const char *content =  luaL_checkstring(L, -2);

   librdf_uri *p_base_uri =  NULL;
   lua_getfield(L, -1, "base_uri");
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_base_uri
         =  (librdf_uri **) luaL_checkudata(
               L
            ,  -1
            ,  uri_userdata_type );
      p_base_uri =  *pp_base_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 3);

   librdf_stream *p_result =  librdf_parser_parse_string_as_stream(
         *pp_parser
      ,  content
      ,  p_base_uri );
   lua_bindings_redland_stream_new_mt(L);
   return lua_bindings_redland_stream_wrap(L, p_result);
}

int
lua_bindings_redland_parser_set_feature(lua_State *L) {
   librdf_parser **pp_parser
      =  (librdf_parser **) luaL_checkudata(
            L
         ,  -3
         ,  parser_userdata_type );
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

   int result =  librdf_parser_set_feature(*pp_parser, *pp_uri, *pp_node);
   lua_pushboolean(L, result);
   return 1;
}



/* ------------------------------------------------------------ */

int
lua_bindings_redland_parser_new_mt(lua_State *L) {
   luaL_newmetatable(L, parser_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_parser_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_parser_wrap(lua_State *L, librdf_parser *p_parser) {
   if (p_parser) {
      librdf_parser **pp_parser
         =  (librdf_parser **) lua_newuserdata(
               L
            ,  sizeof(librdf_parser *) );
      *pp_parser =  p_parser;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      lua_pop(L, 1);
      return 0;
   }
}

int
luaopen_bindings_redland_parser(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_parser_get_accept_header);
   lua_setfield(L, -2, "get_accept_header");

   lua_pushcfunction(L, &lua_bindings_redland_parser_get_feature);
   lua_setfield(L, -2, "get_feature");

   lua_pushcfunction(L, &lua_bindings_redland_parser_get_namespaces_seen_count);
   lua_setfield(L, -2, "get_namespaces_seen_count");

   lua_pushcfunction(L, &lua_bindings_redland_parser_get_namespaces_seen_prefix);
   lua_setfield(L, -2, "get_namespaces_seen_prefix");

   lua_pushcfunction(L, &lua_bindings_redland_parser_get_namespaces_seen_uri);
   lua_setfield(L, -2, "get_namespaces_seen_uri");

   lua_pushcfunction(L, &lua_bindings_redland_parser_is_there_parser);
   lua_setfield(L, -2, "is_there_parser");

   lua_pushcfunction(L, &lua_bindings_redland_parser_new);
   lua_setfield(L, -2, "new");

   lua_pushcfunction(L, &lua_bindings_redland_parser_parse);
   lua_setfield(L, -2, "parse");

   lua_pushcfunction(L, &lua_bindings_redland_parser_parse_string);
   lua_setfield(L, -2, "parse_string");

   lua_pushcfunction(L, &lua_bindings_redland_parser_parse_string_into_stream);
   lua_setfield(L, -2, "parse_string_into_stream");

   lua_pushcfunction(L, &lua_bindings_redland_parser_set_feature);
   lua_setfield(L, -2, "set_feature");

   return 1;
}
