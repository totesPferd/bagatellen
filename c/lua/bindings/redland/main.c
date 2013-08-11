#include "main.h"
#include "formatter.h"
#include "model.h"
#include "node.h"
#include "results.h"
#include "stmt.h"
#include "store.h"
#include "transaction.h"
#include "uri.h"
#include "world.h"
#include <lauxlib.h>

int
luaopen_bindings_redland(lua_State *L) {
   lua_newtable(L);

   luaopen_bindings_redland_formatter(L);
   lua_setfield(L, -2, "formatter");

   luaopen_bindings_redland_model(L);
   lua_setfield(L, -2, "model");

   luaopen_bindings_redland_node(L);
   lua_setfield(L, -2, "node");

   luaopen_bindings_redland_results(L);
   lua_setfield(L, -2, "results");

   luaopen_bindings_redland_stmt(L);
   lua_setfield(L, -2, "stmt");

   luaopen_bindings_redland_store(L);
   lua_setfield(L, -2, "store");

   luaopen_bindings_redland_transaction(L);
   lua_setfield(L, -2, "transaction");

   luaopen_bindings_redland_uri(L);
   lua_setfield(L, -2, "uri");

   luaopen_bindings_redland_world(L);
   lua_setfield(L, -2, "world");

   return 1;
}
