#include "stmt.h"
#include "defs.h"
#include "node.h"
#include <lauxlib.h>

int
lua_bindings_redland_stmt_clear(lua_State *L) {
   librdf_statement **pp_arg =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 1);

   librdf_statement_clear(*pp_arg);

   return 0;
}

int
lua_bindings_redland_stmt_clone(lua_State *L) {
   librdf_statement **pp_arg =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 1);

   lua_bindings_redland_stmt_new_mt(L);
   return lua_bindings_redland_stmt_wrap(
         L
      ,  librdf_new_statement_from_statement(*pp_arg) );
}

int
lua_bindings_redland_stmt_eq(lua_State *L) {
   librdf_statement **pp_arg_1 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -2
      ,  stmt_userdata_type );
   librdf_statement **pp_arg_2 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 2);

   lua_pushboolean(L, librdf_statement_equals(*pp_arg_1, *pp_arg_2));

   return 1;
}

int
lua_bindings_redland_stmt_gc(lua_State *L) {
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 1);

   librdf_free_statement(*pp_stmt);

   return 0;
}

int
lua_bindings_redland_stmt_get_object(lua_State *L) {
   librdf_statement **pp_arg_1 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 1);

   {
      librdf_node *p_node =  librdf_statement_get_object(*pp_arg_1);
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, p_node);
   }
}

int
lua_bindings_redland_stmt_get_predicate(lua_State *L) {
   librdf_statement **pp_arg_1 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 1);

   {
      librdf_node *p_node =  librdf_statement_get_predicate(*pp_arg_1);
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, p_node);
   }
}

int
lua_bindings_redland_stmt_get_subject(lua_State *L) {
   librdf_statement **pp_arg_1 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 1);

   {
      librdf_node *p_node =  librdf_statement_get_subject(*pp_arg_1);
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, p_node);
   }
}
int
lua_bindings_redland_stmt_is_complete(lua_State *L) {
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 1);

   lua_pushboolean(L, librdf_statement_is_complete(*pp_stmt));

   return 1;
}

int
lua_bindings_redland_stmt_is_match(lua_State *L) {
   librdf_statement **pp_arg_1 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -2
      ,  stmt_userdata_type );
   librdf_statement **pp_arg_2 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 2);

   lua_pushboolean(L, librdf_statement_match(*pp_arg_1, *pp_arg_2));

   return 1;
}

int
lua_bindings_redland_stmt_new(lua_State *L) {
   librdf_world **pp_arg_1 =  (librdf_world **) luaL_checkudata(
         L
      ,  -1
      ,  world_userdata_type );

   lua_pop(L, 1);

   {
      librdf_statement *p_stmt =  librdf_new_statement(*pp_arg_1);
      librdf_statement_init(*pp_arg_1, p_stmt);
      lua_bindings_redland_stmt_new_mt(L);
      return lua_bindings_redland_stmt_wrap(L, p_stmt);
   }
}

int
lua_bindings_redland_stmt_set_object(lua_State *L) {
   librdf_statement **pp_arg_1 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -2
      ,  stmt_userdata_type );
   librdf_node **pp_arg_2 =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 2);

   librdf_statement_set_object(
         *pp_arg_1
      ,  librdf_new_node_from_node(*pp_arg_2) );

   return 0;
}

int
lua_bindings_redland_stmt_set_predicate(lua_State *L) {
   librdf_statement **pp_arg_1 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -2
      ,  stmt_userdata_type );
   librdf_node **pp_arg_2 =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 2);

   librdf_statement_set_predicate(
         *pp_arg_1
      ,  librdf_new_node_from_node(*pp_arg_2) );

   return 0;
}

int
lua_bindings_redland_stmt_set_subject(lua_State *L) {
   librdf_statement **pp_arg_1 =  (librdf_statement **) luaL_checkudata(
         L
      ,  -2
      ,  stmt_userdata_type );
   librdf_node **pp_arg_2 =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 2);

   librdf_statement_set_subject(
         *pp_arg_1
      ,  librdf_new_node_from_node(*pp_arg_2) );

   return 0;
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_stmt_new_mt(lua_State *L) {
   luaL_newmetatable(L, stmt_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_stmt_eq);
   lua_setfield(L, -2, "__eq");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}
   
int
lua_bindings_redland_stmt_wrap(lua_State *L, librdf_statement *p_stmt) {
   if (p_stmt) {
      librdf_statement **pp_stmt =  (librdf_statement **) lua_newuserdata(
            L
         ,  sizeof(librdf_statement *) );
      *pp_stmt =  p_stmt;
   
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      return 0;
   }
}

int
luaopen_bindings_redland_stmt(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_stmt_clone);
   lua_setfield(L, -2, "__clone");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_clear);
   lua_setfield(L, -2, "clear");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_get_object);
   lua_setfield(L, -2, "get_object");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_get_predicate);
   lua_setfield(L, -2, "get_predicate");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_get_subject);
   lua_setfield(L, -2, "get_subject");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_is_complete);
   lua_setfield(L, -2, "is_complete");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_is_match);
   lua_setfield(L, -2, "is_match");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_new);
   lua_setfield(L, -2, "new");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_set_object);
   lua_setfield(L, -2, "set_object");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_set_predicate);
   lua_setfield(L, -2, "set_predicate");

   lua_pushcfunction(L, &lua_bindings_redland_stmt_set_subject);
   lua_setfield(L, -2, "set_subject");

   return 1;
}
