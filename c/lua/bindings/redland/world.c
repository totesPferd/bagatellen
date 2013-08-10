#include "world.h"
#include "defs.h"
#include <lauxlib.h>

static int
lua_bindings_redland_world_gc(lua_State *);

static int
lua_bindings_redland_world_new(lua_State *);

/* ------------------------------------------------------------ */

static int
lua_bindings_redland_world_gc(lua_State *L) {
   librdf_world **pp_world =  (librdf_world **) luaL_checkudata(
         L
      ,  -1
      ,  world_userdata_type );

   lua_pop(L, 1);

   librdf_free_world(*pp_world);

   return 0;
}

static int
lua_bindings_redland_world_new(lua_State *L) {
   librdf_world *p_world =  librdf_new_world();
   librdf_world_open(p_world);
   lua_bindings_redland_world_new_mt(L);
   return lua_bindings_redland_world_wrap(L, p_world);
}



/* ------------------------------------------------------------ */

int
lua_bindings_redland_world_new_mt(lua_State *L) {
   luaL_newmetatable(L, world_userdata_type);

   lua_pushcfunction(L, &lua_bindings_redland_world_gc);
   lua_setfield(L, -2, "__gc");

   return 1;
}

int
lua_bindings_redland_world_wrap(lua_State *L, librdf_world *p_world) {
   if (p_world) {
      librdf_world **pp_world =  (librdf_world **) lua_newuserdata(
            L
         ,  sizeof(librdf_world *) );
      *pp_world =  p_world;

      lua_bindings_redland_world_new_mt(L);
      lua_setmetatable(L, -2);
   
      return 1;
   }
}

int
luaopen_bindings_redland_world(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_world_new);
   lua_setfield(L, -2, "new");
   
   return 1;
}
