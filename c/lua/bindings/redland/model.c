#include "model.h"
#include "defs.h"
#include "transaction.h"
#include "world.h"
#include <lauxlib.h>

int
lua_bindings_redland_model_add(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 2);

   int result =  librdf_model_add_statement(*pp_model, *pp_stmt);
   lua_pushnumber(L, result);

   return 1;
}

int
lua_bindings_redland_model_clone(lua_State *L) {
   librdf_model **pp_arg =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   lua_bindings_redland_model_new_mt(L);
   return lua_bindings_redland_model_wrap(
         L
      ,  librdf_new_model_from_model(*pp_arg) );
}

int
lua_bindings_redland_model_context_add(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_node **pp_context =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 3);

   int result =  librdf_model_context_add_statement(
         *pp_model
      ,  *pp_context
      ,  *pp_stmt );
   lua_pushnumber(L, result);

   return 1;
}

int
lua_bindings_redland_model_context_del(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_node **pp_context =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 3);

   if (librdf_model_context_remove_statement(
         *pp_model
      ,  *pp_context
      ,  *pp_stmt )) {
      luaL_error(L, "error: could not delete statement");
   }

   return 0;
}

int
lua_bindings_redland_model_del(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 2);

   if (librdf_model_remove_statement(*pp_model, *pp_stmt)) {
      luaL_error(L, "error: could not delete statement");
   }

   return 0;
}

int
lua_bindings_redland_model_get_feature(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_uri **pp_feature =  (librdf_uri **) luaL_checkudata(
         L
      ,  -1
      ,  uri_userdata_type );

   lua_pop(L, 2);

   librdf_node *result =  librdf_model_get_feature(
         *pp_model
      ,  *pp_feature );
   if (result) {
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, result);
   } else {
      return 0;
   }
}

int
lua_bindings_redland_model_is_containing(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   lua_pop(L, 2);

   int result =  librdf_model_contains_statement(*pp_model, *pp_stmt);
   if (result > 0) {
      luaL_error(L, "error: illegal statement");
   } else {
      lua_pushboolean(L, result);
      return 1;
   }
}

int
lua_bindings_redland_model_is_there_object(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_node **pp_node =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_node **pp_property =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 3);

   int result =  librdf_model_has_arc_out(
         *pp_model
      ,  *pp_node
      ,  *pp_property );
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_model_is_there_subject(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_node **pp_node =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_node **pp_property =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 3);

   int result =  librdf_model_has_arc_in(
         *pp_model
      ,  *pp_node
      ,  *pp_property );
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_model_gc(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   librdf_free_model(*pp_model);

   return 0;
}

int
lua_bindings_redland_model_lookup(lua_State *L) {
   librdf_world **pp_world =  (librdf_world **) luaL_checkudata(
         L
      ,  -2
      ,  world_userdata_type );
   const unsigned int idx =  (const unsigned int) luaL_checkinteger(L, -1);

   lua_pop(L, 2);

   {
      const char *name;
      const char *label;
   
      if (librdf_model_enumerate(*pp_world, idx, &name, &label)) {
         return 0;
      } else {
         lua_newtable(L);

         if (name) {
            lua_pushstring(L, name);
            lua_setfield(L, -2, "name");
         }

         if (label) {
            lua_pushstring(L, label);
            lua_setfield(L, -2, "label");
         }

         return 1;
      }
   }
}

int
lua_bindings_redland_model_new(lua_State *L) {
   librdf_world **pp_world =  (librdf_world **) luaL_checkudata(
         L
      ,  -3
      ,  world_userdata_type );
   librdf_storage **pp_store =  (librdf_storage **) luaL_checkudata(
         L
      ,  -2
      ,  store_userdata_type );
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -1
      ,  hash_userdata_type );

   lua_pop(L, 3);

   librdf_model *p_model =  librdf_new_model_with_options(
         *pp_world
      ,  *pp_store
      ,  *pp_hash );
   if (p_model) {
      lua_bindings_redland_model_new_mt(L);
      return lua_bindings_redland_model_wrap(L, p_model);
   } else {
      return 0;
   }
}

int
lua_bindings_redland_model_set_feature(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_uri **pp_feature =  (librdf_uri **) luaL_checkudata(
         L
      ,  -2
      ,  uri_userdata_type );
   librdf_node **pp_value =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );

   lua_pop(L, 3);

   int result =  librdf_model_set_feature(
         *pp_model
      ,  *pp_feature
      ,  *pp_value );
   lua_pushnumber(L, result);
   return 1;
}

int
lua_bindings_redland_model_size(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   int result =  librdf_model_size(*pp_model);
   lua_pushnumber(L, result);

   return 1;
}

int
lua_bindings_redland_model_sync(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   if (librdf_model_sync(*pp_model)) {
      luaL_error(L, "error: sync");
   }

   return 0;
}

int
lua_bindings_redland_model_transaction_commit(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   if (librdf_model_transaction_commit(*pp_model)) {
      luaL_error(L, "error: transaction commit");
   }

   return 0;
}

int
lua_bindings_redland_model_transaction_get_handle(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   {
      void *p_th =  librdf_model_transaction_get_handle(*pp_model);
      if (p_th) {
         lua_bindings_redland_transaction_new_mt(L);
         return lua_bindings_redland_transaction_wrap(L, p_th);
      } else {
         return 0;
      }
   }
}

int
lua_bindings_redland_model_transaction_rollback(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   if (librdf_model_transaction_rollback(*pp_model)) {
      luaL_error(L, "error: transaction rollback");
   }

   return 0;
}

int
lua_bindings_redland_model_transaction_start(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   if (librdf_model_transaction_start(*pp_model)) {
      luaL_error(L, "error: transaction start");
   }

   return 0;
}

int
lua_bindings_redland_model_transaction_start_with_handle(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   void **pp_th =  luaL_checkudata(
         L
      ,  -1
      ,  th_userdata_type );

   lua_pop(L, 2);

   if (librdf_model_transaction_start_with_handle(*pp_model, *pp_th)) {
      luaL_error(L, "error: transaction start with handle");
   }

   return 0;
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_model_new_mt(lua_State *L) {
   luaL_newmetatable(L, model_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_model_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_model_wrap(lua_State *L, librdf_model *p_model) {
   if (p_model) {
      librdf_model **pp_model =  (librdf_model **) lua_newuserdata(
            L
         ,  sizeof(librdf_model *) );
      *pp_model =  p_model;

      lua_bindings_redland_model_new_mt(L);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      return 0;
   }
}

int
luaopen_bindings_redland_model(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_model_add);
   lua_setfield(L, -2, "add");

   lua_pushcfunction(L, &lua_bindings_redland_model_clone);
   lua_setfield(L, -2, "__clone");

   lua_pushcfunction(L, &lua_bindings_redland_model_context_add);
   lua_setfield(L, -2, "context_add");

   lua_pushcfunction(L, &lua_bindings_redland_model_context_del);
   lua_setfield(L, -2, "context_del");

   lua_pushcfunction(L, &lua_bindings_redland_model_del);
   lua_setfield(L, -2, "del");

   lua_pushcfunction(L, &lua_bindings_redland_model_get_feature);
   lua_setfield(L, -2, "get_feature");

   lua_pushcfunction(L, &lua_bindings_redland_model_is_containing);
   lua_setfield(L, -2, "is_containing");

   lua_pushcfunction(L, &lua_bindings_redland_model_is_there_object);
   lua_setfield(L, -2, "is_there_object");

   lua_pushcfunction(L, &lua_bindings_redland_model_is_there_subject);
   lua_setfield(L, -2, "is_there_subject");

   lua_pushcfunction(L, &lua_bindings_redland_model_lookup);
   lua_setfield(L, -2, "lookup");

   lua_pushcfunction(L, &lua_bindings_redland_model_new);
   lua_setfield(L, -2, "new");

   lua_pushcfunction(L, &lua_bindings_redland_model_set_feature);
   lua_setfield(L, -2, "set_feature");

   lua_pushcfunction(L, &lua_bindings_redland_model_size);
   lua_setfield(L, -2, "size");

   lua_pushcfunction(L, &lua_bindings_redland_model_sync);
   lua_setfield(L, -2, "sync");

   lua_pushcfunction(L, &lua_bindings_redland_model_transaction_commit);
   lua_setfield(L, -2, "transaction_commit");

   lua_pushcfunction(L, &lua_bindings_redland_model_transaction_get_handle);
   lua_setfield(L, -2, "transaction_get_handle");

   lua_pushcfunction(L, &lua_bindings_redland_model_transaction_rollback);
   lua_setfield(L, -2, "transaction_rollback");

   lua_pushcfunction(L, &lua_bindings_redland_model_transaction_start);
   lua_setfield(L, -2, "transaction_start");

   lua_pushcfunction(
         L
      ,  &lua_bindings_redland_model_transaction_start_with_handle );
   lua_setfield(L, -2, "transaction_start_with_handle");

   return 1;
}
