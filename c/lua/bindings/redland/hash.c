#include "hash.h"
#include "defs.h"
#include "world.h"
#include <lauxlib.h>

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

   lua_pushcfunction(L, &lua_bindings_redland_hash_new);
   lua_setfield(L, -2, "new");
   
   return 1;
}
