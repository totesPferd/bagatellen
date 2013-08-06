#include "world.h"
#include <lauxlib.h>

const char *userdata_type =  "redland.world";

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
      ,  userdata_type );
   librdf_free_world(*pp_world);
   lua_pop(L, -1);
   return 0;
}

static int
lua_bindings_redland_world_new(lua_State *L) {
   librdf_world *p_world =  librdf_new_world();
   return lua_bindings_redland_world_wrap(L, p_world);
}



/* ------------------------------------------------------------ */

int
lua_bindings_redland_world_wrap(lua_State *L, librdf_world *p_world) {
   librdf_world **pp_world =  (librdf_world **) lua_newuserdata(
         L
      ,  sizeof(librdf_world *) );
   *pp_world =  p_world;

   luaL_newmetatable(L, userdata_type);
   lua_setmetatable(L, -2);

   return 1;
}

int
luaopen_bindings_redland_world(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &lua_bindings_redland_world_new);
   lua_setfield(L, -2, "new");
   
   return 1;
}
