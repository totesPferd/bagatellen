#include "formatter.h"
#include "defs.h"
#include <lauxlib.h>

int
lua_bindings_redland_formatter_gc(lua_State *L) {
   librdf_query_results_formatter **pp_formatter
      =  (librdf_query_results_formatter **) luaL_checkudata(
            L
         ,  -1
         ,  qfmt_userdata_type );

   lua_pop(L, 1);

   librdf_free_query_results_formatter(*pp_formatter);

   return 0;
}


/* ------------------------------------------------------------ */

int
lua_bindings_redland_formatter_new_mt(lua_State *L) {
   luaL_newmetatable(L, qfmt_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_formatter_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_formatter_wrap(lua_State *L, librdf_query_results_formatter *p_formatter) {
   if (p_formatter) {
      librdf_query_results_formatter **pp_formatter
         =  (librdf_query_results_formatter **) lua_newuserdata(
               L
            ,  sizeof(librdf_query_results_formatter *) );
      *pp_formatter =  p_formatter;

      lua_insert(L, -2);
      lua_setmetatable(L, -2);
   
      return 1;
   } else {
      lua_pop(L, 1);
      return 0;
   }
}

int
luaopen_bindings_redland_formatter(lua_State *L) {
   lua_newtable(L);

   return 1;
}
