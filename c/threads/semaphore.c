#include "semaphore.h"

void
semaphore_init(semaphore_t *semaphore, unsigned init) {
   semaphore->counter = init;
   pthread_cond_init(&(semaphore->cv), NULL);
   pthread_mutex_init(&(semaphore->mutex), NULL);
}

void
semaphore_destroy(semaphore_t *semaphore) {
   pthread_cond_destroy(&(semaphore->cv));
   pthread_mutex_destroy(&(semaphore->mutex));
}

void
semaphore_up(semaphore_t *semaphore) {
   pthread_mutex_lock(&(semaphore->mutex));
   if (!semaphore->counter) {
      pthread_cond_signal(&(semaphore->cv));
   }
   (semaphore->counter)++;
   pthread_mutex_unlock(&(semaphore->mutex));
}

void
semaphore_down(semaphore_t *semaphore) {
   pthread_mutex_lock(&(semaphore->mutex));
   while(1) {
      if (semaphore->counter) {
         semaphore->counter--;
         break;
      } else {
         pthread_cond_wait(&(semaphore->cv), &(semaphore->mutex));
      }
   }
   pthread_mutex_unlock(&(semaphore->mutex));
}

int
semaphore_trydown(semaphore_t *semaphore) {
   pthread_mutex_lock(&(semaphore->mutex));
   if (semaphore->counter) {
      semaphore->counter--;
      pthread_mutex_unlock(&(semaphore->mutex));
      return 1;
   } else {
      pthread_mutex_unlock(&(semaphore->mutex));
      return 0;
   }
}

/* ------------------------------------------------- */
#include <lua.h>
#include <lauxlib.h>

int
semaphore_lua_down(lua_State *L) {
   semaphore_t *semaphore = (semaphore_t *) luaL_checkudata(L, -1, "semaphore");
   semaphore_down(semaphore);
   lua_pop(L, 1);
   return 0;
}

int
semaphore_lua_trydown(lua_State *L) {
   semaphore_t *semaphore = (semaphore_t *) luaL_checkudata(L, -1, "semaphore");
   int ret = semaphore_trydown(semaphore);
   lua_pop(L, 1);
   lua_pushboolean(L, ret);
   return 1;
}

int
semaphore_lua_up(lua_State *L) {
   semaphore_t *semaphore = (semaphore_t *) luaL_checkudata(L, -1, "semaphore");
   semaphore_up(semaphore);
   lua_pop(L, 1);
   return 0;
}

int
semaphore_lua_gc(lua_State *L) {
   semaphore_t *semaphore = (semaphore_t *) luaL_checkudata(L, -1, "semaphore");
   semaphore_destroy(semaphore);
   lua_pop(L, 1);
   return 0;
}

int
semaphore_lua_newSemaphore(lua_State *L) {
   unsigned init = (unsigned) luaL_checkinteger(L, -1);
   lua_pop(L, 1);
   semaphore_t *semaphore =
      (semaphore_t *) lua_newuserdata(L, sizeof(semaphore_t));
   semaphore_init(semaphore, init);
   luaL_newmetatable(L, "semaphore");

   {
      lua_pushcfunction(L, &semaphore_lua_gc);
      lua_setfield(L, -2, "__gc");

      lua_getglobal(L, "semaphore");
      lua_setfield(L, -2, "__index");
   }

   lua_setmetatable(L, -2);
   return 1;
}

int
luaopen_semaphore(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &semaphore_lua_newSemaphore);
   lua_setfield(L, -2, "create");

   lua_pushcfunction(L, &semaphore_lua_up);
   lua_setfield(L, -2, "up");

   lua_pushcfunction(L, &semaphore_lua_down);
   lua_setfield(L, -2, "down");

   lua_pushcfunction(L, &semaphore_lua_trydown);
   lua_setfield(L, -2, "trydown");

   lua_setglobal(L, "semaphore");
   return 0;
}
