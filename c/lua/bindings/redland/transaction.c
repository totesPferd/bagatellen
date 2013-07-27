#include "transaction.h"
#include "defs.h"
#include <lauxlib.h>

int
lua_bindings_redland_transaction_gc(lua_State *L) {
   void **pp_transaction =  luaL_checkudata(
         L
      ,  -1
      ,  th_userdata_type );

   lua_pop(L, 1);

   librdf_free_memory(*pp_transaction);

   return 0;
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_transaction_new_mt(lua_State *L) {
   luaL_newmetatable(L, th_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_transaction_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_transaction_wrap(lua_State *L, void *p_transaction) {
   if (p_transaction) {
      void **pp_transaction =  (void **) lua_newuserdata(
            L
         ,  sizeof(void *) );
      *pp_transaction =  p_transaction;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      lua_pop(L, 1);
      return 0;
   }
}

int
luaopen_bindings_redland_transaction(lua_State *L) {
   lua_newtable(L);

   return 1;
}
