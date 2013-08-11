#include "results.h"
#include "defs.h"
#include <lauxlib.h>

int
lua_bindings_redland_results_gc(lua_State *L) {
   librdf_query_results **pp_results
      =  (librdf_query_results **) luaL_checkudata(
            L
         ,  -1
         ,  qfmt_userdata_type );

   lua_pop(L, 1);

   librdf_free_query_results(*pp_results);

   return 0;
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_results_new_mt(lua_State *L) {
   luaL_newmetatable(L, qfmt_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_results_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_results_wrap(lua_State *L, librdf_query_results *p_results) {
   if (p_results) {
      librdf_query_results **pp_results
         =  (librdf_query_results **) lua_newuserdata(
               L
            ,  sizeof(librdf_query_results *) );
      *pp_results =  p_results;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      return 0;
   }
}

int
luaopen_bindings_redland_results(lua_State *L) {
   lua_newtable(L);

   return 1;
}
