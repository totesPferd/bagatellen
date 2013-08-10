#include "hash.h"
#include "defs.h"
#include "world.h"
#include <lauxlib.h>

int
lua_bindings_redland_hash_clone(lua_State *L) {
   librdf_hash **pp_arg =  (librdf_hash **) luaL_checkudata(
         L
      ,  -1
      ,  hash_userdata_type );

   lua_pop(L, 1);

   lua_bindings_redland_hash_new_mt(L);
   return lua_bindings_redland_hash_wrap(L, librdf_new_hash_from_hash(*pp_arg));
}

int
lua_bindings_redland_hash_gc(lua_State *L) {
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -1
      ,  hash_userdata_type );

   lua_pop(L, 1);

   librdf_free_hash(*pp_hash);

   return 0;
}

int
lua_bindings_redland_hash_get(lua_State *L) {
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -2
      ,  hash_userdata_type );
   const char *key =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   char *result =  librdf_hash_get(*pp_hash, key);
   if (result) {
      lua_pushstring(L, result);
      librdf_free_memory(result);
      return 1;
   } else {
      return 0;
   }
}

int
lua_bindings_redland_hash_get_boolean(lua_State *L) {
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -2
      ,  hash_userdata_type );
   const char *key =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   int result =  librdf_hash_get_as_boolean(*pp_hash, key);
   if (result >= 0) {
      lua_pushboolean(L, result);
      return 1;
   } else {
      return 0;
   }
}

int
lua_bindings_redland_hash_get_del(lua_State *L) {
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -2
      ,  hash_userdata_type );
   const char *key =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   char *result =  librdf_hash_get_del(*pp_hash, key);
   if (result) {
      lua_pushstring(L, result);
      librdf_free_memory(result);
      return 1;
   } else {
      return 0;
   }
}

int
lua_bindings_redland_hash_get_long(lua_State *L) {
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -2
      ,  hash_userdata_type );
   const char *key =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   long result =  librdf_hash_get_as_long(*pp_hash, key);
   if (result >= 0) {
      lua_pushnumber(L, result);
      return 1;
   } else {
      return 0;
   }
}

int
lua_bindings_redland_hash_init(lua_State *L) {
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -2
      ,  hash_userdata_type );
   const char *init =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   if (librdf_hash_from_string(*pp_hash, init)) {
      luaL_error(L, "init error");
   }

   return 0;
}

int
lua_bindings_redland_hash_insert(lua_State *L) {
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -3
      ,  hash_userdata_type );
   const char *key =  luaL_checkstring(L, -2);
   const char *value =  luaL_checkstring(L, -1);

   lua_pop(L, 3);

   if (librdf_hash_put_strings(*pp_hash, key, value)) {
      luaL_error(L, "insert error");
   }

   return 0;
}

int
lua_bindings_redland_hash_interpret(lua_State *L) {
   librdf_hash **pp_hash =  (librdf_hash **) luaL_checkudata(
         L
      ,  -4
      ,  hash_userdata_type );
   const char *template =  luaL_checkstring(L, -3);
   const char *prefix =  luaL_checkstring(L, -2);
   const char *suffix =  luaL_checkstring(L, -1);

   lua_pop(L, 4);

   unsigned char *result =  librdf_hash_interpret_template(
         template
      ,  *pp_hash
      ,  prefix
      ,  suffix );
   if (result) {
      lua_pushstring(L, result);
      librdf_free_memory(result);
      return 1;
   } else {
      return 0;
   }
}

int
lua_bindings_redland_hash_new(lua_State *L) {
   librdf_world **pp_world =  (librdf_world **) luaL_checkudata(
         L
      ,  -2
      ,  world_userdata_type );
   const char *name =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   librdf_hash *p_hash =  librdf_new_hash(*pp_world, name);
   lua_bindings_redland_hash_new_mt(L);
   return lua_bindings_redland_hash_wrap(L, p_hash);
}

int
lua_bindings_redland_hash_new_from_string(lua_State *L) {
   librdf_world **pp_world =  (librdf_world **) luaL_checkudata(
         L
      ,  -3
      ,  world_userdata_type );
   const char *name =  luaL_checkstring(L, -2);
   const char *options =  luaL_checkstring(L, -1);

   lua_pop(L, 2);

   librdf_hash *p_hash =  librdf_new_hash_from_string(
         *pp_world
      ,  name
      ,  options );
   lua_bindings_redland_hash_new_mt(L);
   return lua_bindings_redland_hash_wrap(L, p_hash);
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_hash_new_mt(lua_State *L) {
   luaL_newmetatable(L, hash_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_hash_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_hash_wrap(lua_State *L, librdf_hash *p_hash) {
   if (p_hash) {
      librdf_hash **pp_hash =  (librdf_hash **) lua_newuserdata(
            L
         ,  sizeof(librdf_hash *) );
      *pp_hash =  p_hash;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      return 0;
   }
}

int
luaopen_bindings_redland_hash(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_hash_clone);
   lua_setfield(L, -2, "__clone");
   
   lua_pushcfunction(L, &lua_bindings_redland_hash_get);
   lua_setfield(L, -2, "get");
   
   lua_pushcfunction(L, &lua_bindings_redland_hash_get_boolean);
   lua_setfield(L, -2, "get_boolean");
   
   lua_pushcfunction(L, &lua_bindings_redland_hash_get_del);
   lua_setfield(L, -2, "get_del");
   
   lua_pushcfunction(L, &lua_bindings_redland_hash_get_long);
   lua_setfield(L, -2, "get_long");
   
   lua_pushcfunction(L, &lua_bindings_redland_hash_init);
   lua_setfield(L, -2, "init");

   lua_pushcfunction(L, &lua_bindings_redland_hash_insert);
   lua_setfield(L, -2, "insert");

   lua_pushcfunction(L, &lua_bindings_redland_hash_interpret);
   lua_setfield(L, -2, "interpret");
   
   lua_pushcfunction(L, &lua_bindings_redland_hash_new);
   lua_setfield(L, -2, "new");
   
   lua_pushcfunction(L, &lua_bindings_redland_hash_new_from_string);
   lua_setfield(L, -2, "new_from_string");
   
   return 1;
}
