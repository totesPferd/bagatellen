#include "model.h"
#include "defs.h"
#include "node.h"
#include "results.h"
#include "store.h"
#include "stream.h"
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
lua_bindings_redland_model_add_stream(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_stream **pp_stream =  (librdf_stream **) luaL_checkudata(
         L
      ,  -1
      ,  stream_userdata_type );

   lua_pop(L, 2);

   int result =  librdf_model_add_statements(*pp_model, *pp_stream);
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
lua_bindings_redland_model_context_add_stream(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_node **pp_context =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_stream **pp_stream =  (librdf_stream **) luaL_checkudata(
         L
      ,  -1
      ,  stream_userdata_type );

   lua_pop(L, 3);

   int result =  librdf_model_context_add_statements(
         *pp_model
      ,  *pp_context
      ,  *pp_stream );
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
lua_bindings_redland_model_context_serialize(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_node **pp_context =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 2);

   librdf_stream *p_stream =  librdf_model_context_as_stream(
         *pp_model
      ,  *pp_context );

   lua_bindings_redland_stream_new_mt(L);
   return lua_bindings_redland_stream_wrap(L, p_stream);
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

   lua_pushboolean(L, librdf_model_remove_statement(*pp_model, *pp_stmt));

   return 1;
}

int
lua_bindings_redland_model_del_context(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_node **pp_context =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 2);

   lua_pusboolean(L, librdf_model_context_remove_statements(
         *pp_model
      ,  *pp_context ));

   return 1;
}

int
lua_bindings_model_find(lua_State *L) {
   librdf_storage **pp_model =  (librdf_storage **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -1
      ,  stmt_userdata_type );

   librdf_node *p_context =  NULL;
   lua_getfield(L, -1, "context");
   if (!lua_isnil(L, -1)) {
      librdf_node **pp_context =  (librdf_node **) luaL_checkudata(
            L
         ,  -1
         ,  node_userdata_type );
      p_context =  *pp_context;
   }
   lua_pop(L, 1);

   lua_pop(L, 2);

   librdf_stream *p_stream =  librdf_storage_find_statements_in_context(
         *pp_model
      ,  *pp_stmt
      ,  p_context );
   lua_bindings_redland_stream_new_mt(L);
   return lua_bindings_redland_stream_wrap(L, p_stream);
}

int
lua_bindings_model_find_with_options(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_statement **pp_stmt =  (librdf_statement **) luaL_checkudata(
         L
      ,  -2
      ,  stmt_userdata_type );

   librdf_node *p_context =  NULL;
   lua_getfield(L, -1, "context");
   if (!lua_isnil(L, -1)) {
      librdf_node **pp_context =  (librdf_node **) luaL_checkudata(
            L
         ,  -1
         ,  node_userdata_type );
      p_context =  *pp_context;
   }
   lua_pop(L, 1);

   librdf_hash *p_options =  NULL;
   lua_getfield(L, -1, "options");
   if (!lua_isnil(L, -1)) {
      librdf_hash **pp_options =  (librdf_hash **) luaL_checkudata(
            L
         ,  -1
         ,  hash_userdata_type );
      p_options =  *pp_options;
   }
   lua_pop(L, 1);

   lua_pop(L, 3);

   librdf_stream *p_stream =  librdf_model_find_statements_with_options(
         *pp_model
      ,  *pp_stmt
      ,  p_context
      ,  p_options );
   lua_bindings_redland_stream_new_mt(L);
   return lua_bindings_redland_stream_wrap(L, p_stream);
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
lua_bindings_redland_model_get_object(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_node **pp_subject =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_node **pp_predicate =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 3);

   librdf_node *result =  librdf_model_get_target(
         *pp_model
      ,  *pp_subject
      ,  *pp_predicate );
   if (result) {
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, result);
   } else {
      return 0;
   }
}

int
lua_bindings_redland_model_get_predicate(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_node **pp_subject =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_node **pp_object =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 3);

   librdf_node *result =  librdf_model_get_arc(
         *pp_model
      ,  *pp_subject
      ,  *pp_object );
   if (result) {
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, result);
   } else {
      return 0;
   }
}

int
lua_bindings_redland_model_get_store(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   librdf_storage *result =  librdf_model_get_storage(
         *pp_model );
   if (result) {
      lua_bindings_redland_store_new_mt(L);
      return lua_bindings_redland_store_wrap(L, result);
   } else {
      return 0;
   }
}

int
lua_bindings_redland_model_get_subject(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_node **pp_predicate =  (librdf_node **) luaL_checkudata(
         L
      ,  -2
      ,  node_userdata_type );
   librdf_node **pp_object =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 3);

   librdf_node *result =  librdf_model_get_source(
         *pp_model
      ,  *pp_predicate
      ,  *pp_object );
   if (result) {
      lua_bindings_redland_node_new_mt(L);
      return lua_bindings_redland_node_wrap(L, result);
   } else {
      return 0;
   }
}

int
lua_bindings_redland_model_is_containing_context(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_node **pp_context =  (librdf_node **) luaL_checkudata(
         L
      ,  -1
      ,  node_userdata_type );

   lua_pop(L, 2);

   int result =  librdf_model_contains_context(
         *pp_model
      ,  *pp_context );
   lua_pushboolean(L, result);
   return 1;
}

int
lua_bindings_redland_model_is_supporting_contexts(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   int result =  librdf_model_supports_contexts(
         *pp_model );
   lua_pushboolean(L, result);
   return 1;
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
lua_bindings_redland_model_load(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -3
      ,  model_userdata_type );
   librdf_uri **pp_uri =  (librdf_uri **) luaL_checkudata(
         L
      ,  -2
      ,  uri_userdata_type );

   lua_getfield(L, -1, "name");
   const char *name =  NULL;
   if (!lua_isnil(L, -1)) {
      name =  luaL_checkstring(L, -1);
   }
   lua_pop(L, 1);

   lua_getfield(L, -1, "mime_type");
   const char *mime_type =  NULL;
   if (!lua_isnil(L, -1)) {
      mime_type =  luaL_checkstring(L, -1);
   }
   lua_pop(L, 1);

   lua_getfield(L, -1, "type");
   librdf_uri *p_type_uri = NULL;
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_type_uri =  (librdf_uri **) luaL_checkudata(
            L
         ,  -1
         ,  uri_userdata_type );
      p_type_uri =  *pp_type_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 3);

   int result =  librdf_model_load(
         *pp_model
      ,  *pp_uri
      ,  name
      ,  mime_type
      ,  p_type_uri );

   lua_pushboolean(L, result);
   return 1;
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
lua_bindings_redland_model_query(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );
   librdf_query **pp_query =  (librdf_query **) luaL_checkudata(
         L
      ,  -1
      ,  query_userdata_type );

   lua_pop(L, 2);

   librdf_query_results *p_qr =  librdf_model_query_execute(
         *pp_model
      ,  *pp_query );
   if (p_qr) {
      lua_bindings_redland_results_new_mt(L);
      return lua_bindings_redland_results_wrap(L, p_qr);
   } else {
      return 0;
   }
}

int
lua_bindings_model_serialize(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -1
      ,  model_userdata_type );

   lua_pop(L, 1);

   librdf_stream *p_stream =  librdf_model_as_stream(*pp_model);
   lua_bindings_redland_stream_new_mt(L);
   return lua_bindings_redland_stream_wrap(L, p_stream);
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
lua_bindings_redland_model_to_string(lua_State *L) {
   librdf_model **pp_model =  (librdf_model **) luaL_checkudata(
         L
      ,  -2
      ,  model_userdata_type );

   lua_getfield(L, -1, "base");
   librdf_uri *p_base_uri = NULL;
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_base_uri =  (librdf_uri **) luaL_checkudata(
            L
         ,  -1
         ,  uri_userdata_type );
      p_base_uri =  *pp_base_uri;
   }
   lua_pop(L, 1);

   lua_getfield(L, -1, "name");
   const char *name =  NULL;
   if (!lua_isnil(L, -1)) {
      name =  luaL_checkstring(L, -1);
   }
   lua_pop(L, 1);

   lua_getfield(L, -1, "mime_type");
   const char *mime_type =  NULL;
   if (!lua_isnil(L, -1)) {
      mime_type =  luaL_checkstring(L, -1);
   }
   lua_pop(L, 1);

   lua_getfield(L, -1, "type");
   librdf_uri *p_type_uri = NULL;
   if (!lua_isnil(L, -1)) {
      librdf_uri **pp_type_uri =  (librdf_uri **) luaL_checkudata(
            L
         ,  -1
         ,  uri_userdata_type );
      p_type_uri =  *pp_type_uri;
   }
   lua_pop(L, 1);

   lua_pop(L, 2);

   unsigned char *result =  librdf_model_to_string(
         *pp_model
      ,  p_base_uri
      ,  name
      ,  mime_type
      ,  p_type_uri );

   if (result) {
      lua_pushstring(L, result);
      return 1;
   } else {
      return 0;
   }
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
      lua_pop(L, 1);
      return 0;
   }
}

int
luaopen_bindings_redland_model(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_model_add);
   lua_setfield(L, -2, "add");

   lua_pushcfunction(L, &lua_bindings_redland_model_add_stream);
   lua_setfield(L, -2, "add_stream");

   lua_pushcfunction(L, &lua_bindings_redland_model_clone);
   lua_setfield(L, -2, "__clone");

   lua_pushcfunction(L, &lua_bindings_redland_model_context_add);
   lua_setfield(L, -2, "context_add");

   lua_pushcfunction(L, &lua_bindings_redland_model_context_add_stream);
   lua_setfield(L, -2, "context_add_stream");

   lua_pushcfunction(L, &lua_bindings_redland_model_context_del);
   lua_setfield(L, -2, "context_del");

   lua_pushcfunction(L, &lua_bindings_redland_model_context_serialize);
   lua_setfield(L, -2, "context_serialize");

   lua_pushcfunction(L, &lua_bindings_redland_model_del);
   lua_setfield(L, -2, "del");

   lua_pushcfunction(L, &lua_bindings_redland_model_del_context);
   lua_setfield(L, -2, "del_context");

   lua_pushcfunction(L, &lua_bindings_redland_model_find);
   lua_setfield(L, -2, "find");

   lua_pushcfunction(L, &lua_bindings_redland_model_find_with_options);
   lua_setfield(L, -2, "find_with_options");

   lua_pushcfunction(L, &lua_bindings_redland_model_get_feature);
   lua_setfield(L, -2, "get_feature");

   lua_pushcfunction(L, &lua_bindings_redland_model_get_object);
   lua_setfield(L, -2, "get_object");

   lua_pushcfunction(L, &lua_bindings_redland_model_get_predicate);
   lua_setfield(L, -2, "get_predicate");

   lua_pushcfunction(L, &lua_bindings_redland_model_get_store);
   lua_setfield(L, -2, "get_store");

   lua_pushcfunction(L, &lua_bindings_redland_model_get_subject);
   lua_setfield(L, -2, "get_subject");

   lua_pushcfunction(L, &lua_bindings_redland_model_is_containing_context);
   lua_setfield(L, -2, "is_containing_context");

   lua_pushcfunction(L, &lua_bindings_redland_model_is_supporting_contexts);
   lua_setfield(L, -2, "is_supporting_contexts");

   lua_pushcfunction(L, &lua_bindings_redland_model_is_there_object);
   lua_setfield(L, -2, "is_there_object");

   lua_pushcfunction(L, &lua_bindings_redland_model_is_there_subject);
   lua_setfield(L, -2, "is_there_subject");

   lua_pushcfunction(L, &lua_bindings_redland_model_load);
   lua_setfield(L, -2, "load");

   lua_pushcfunction(L, &lua_bindings_redland_model_lookup);
   lua_setfield(L, -2, "lookup");

   lua_pushcfunction(L, &lua_bindings_redland_model_new);
   lua_setfield(L, -2, "new");

   lua_pushcfunction(L, &lua_bindings_redland_model_query);
   lua_setfield(L, -2, "query");

   lua_pushcfunction(L, &lua_bindings_redland_model_serialize);
   lua_setfield(L, -2, "serialize");

   lua_pushcfunction(L, &lua_bindings_redland_model_set_feature);
   lua_setfield(L, -2, "set_feature");

   lua_pushcfunction(L, &lua_bindings_redland_model_size);
   lua_setfield(L, -2, "size");

   lua_pushcfunction(L, &lua_bindings_redland_model_sync);
   lua_setfield(L, -2, "sync");

   lua_pushcfunction(L, &lua_bindings_redland_model_to_string);
   lua_setfield(L, -2, "to_string");

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
