#include "store.h"
#include "defs.h"
#include <lauxlib.h>

int
lua_bindings_redland_store_gc(lua_State *L) {
   librdf_storage **pp_store =  (librdf_storage **) luaL_checkudata(
         L
      ,  -1
      ,  store_userdata_type );

   lua_pop(L, 1);

   librdf_free_storage(*pp_store);

   return 0;
}

int
lua_bindings_redland_store_lookup(lua_State *L) {
   librdf_world **pp_world =  (librdf_world **) luaL_checkudata(
         L
      ,  -2
      ,  world_userdata_type );
   const unsigned int idx =  (const unsigned int) luaL_checkinteger(L, -1);

   lua_pop(L, 2);

   {
      const char *name;
      const char *label;
   
      if (librdf_storage_enumerate(*pp_world, idx, &name, &label)) {
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

/* ------------------------------------------------------------ */

int
lua_bindings_redland_store_new_mt(lua_State *L) {
   luaL_newmetatable(L, store_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_store_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_store_wrap(lua_State *L, librdf_storage *p_store) {
   if (p_store) {
      librdf_storage **pp_store =  (librdf_storage **) lua_newuserdata(
            L
         ,  sizeof(librdf_storage *) );
      *pp_store =  p_store;

      lua_bindings_redland_store_new_mt(L);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      return 0;
   }
}

int
luaopen_bindings_redland_store(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_store_lookup);
   lua_setfield(L, -2, "lookup");

   return 1;
}
