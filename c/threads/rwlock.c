#include "rwlock.h"

void
rwlock_init(rwlock_t *rwlock) {
 pthread_cond_init(&(rwlock->condVar), NULL);
 pthread_mutex_init(&(rwlock->mutex), NULL);
 rwlock->nrReader = 0;
}

void
rwlock_destroy(rwlock_t *rwlock) {
 pthread_cond_destroy(&(rwlock->condVar));
 pthread_mutex_destroy(&(rwlock->mutex));
}

void
rwlock_read_lock(rwlock_t *rwlock) {
 pthread_mutex_lock(&(rwlock->mutex));
 rwlock->nrReader++;
 pthread_mutex_unlock(&(rwlock->mutex));
}

void
rwlock_read_unlock(rwlock_t *rwlock) {
 pthread_mutex_lock(&(rwlock->mutex));
 rwlock->nrReader--;
 pthread_cond_broadcast(&(rwlock->condVar));
 pthread_mutex_unlock(&(rwlock->mutex));
}

void
rwlock_write_lock(rwlock_t *rwlock) {
 pthread_mutex_lock(&(rwlock->mutex));
 while (rwlock->nrReader > 0)
  pthread_cond_wait(&(rwlock->condVar), &(rwlock->mutex));
}

void
rwlock_write_unlock(rwlock_t *rwlock) {
 pthread_cond_broadcast(&(rwlock->condVar));
 pthread_mutex_unlock(&(rwlock->mutex));
} 

/* ------------------------------------------------- */
#include <lua.h>
#include <lauxlib.h>

static int
rwlock_lua_read_lock(lua_State *L) {
   rwlock_t *rwlock = (rwlock_t *) luaL_checkudata(L, -1, "rwlock");
   rwlock_read_lock(rwlock);
   lua_pop(L, 1);
   return 0;
}

static int
rwlock_lua_read_unlock(lua_State *L) {
   rwlock_t *rwlock = (rwlock_t *) luaL_checkudata(L, -1, "rwlock");
   rwlock_read_unlock(rwlock);
   lua_pop(L, 1);
   return 0;
}

static int
rwlock_lua_write_lock(lua_State *L) {
   rwlock_t *rwlock = (rwlock_t *) luaL_checkudata(L, -1, "rwlock");
   rwlock_write_lock(rwlock);
   lua_pop(L, 1);
   return 0;
}

static int
rwlock_lua_write_unlock(lua_State *L) {
   rwlock_t *rwlock = (rwlock_t *) luaL_checkudata(L, -1, "rwlock");
   rwlock_write_unlock(rwlock);
   lua_pop(L, 1);
   return 0;
}

static int
rwlock_lua_gc(lua_State *L) {
   rwlock_t *rwlock = (rwlock_t *) luaL_checkudata(L, -1, "rwlock");
   rwlock_destroy(rwlock);
   lua_pop(L, 1);
   return 0;
}

int
rwlock_lua_newRwlock(lua_State *L) {
   rwlock_t *rwlock =
      (rwlock_t *) lua_newuserdata(L, sizeof(rwlock_t));
   rwlock_init(rwlock);
   luaL_newmetatable(L, "rwlock");

   {
      lua_pushcfunction(L, &rwlock_lua_gc);
      lua_setfield(L, -2, "__gc");

      lua_getglobal(L, "rwlock");
      lua_setfield(L, -2, "__index");
   }

   lua_setmetatable(L, -2);
   return 1;
}

int
luaopen_rwlock(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &rwlock_lua_newRwlock);
   lua_setfield(L, -2, "create");

   lua_pushcfunction(L, &rwlock_lua_read_lock);
   lua_setfield(L, -2, "readLock");

   lua_pushcfunction(L, &rwlock_lua_read_unlock);
   lua_setfield(L, -2, "readUnlock");

   lua_pushcfunction(L, &rwlock_lua_write_lock);
   lua_setfield(L, -2, "writeLock");

   lua_pushcfunction(L, &rwlock_lua_write_unlock);
   lua_setfield(L, -2, "writeUnlock");

   lua_setglobal(L, "rwlock");
   return 0;
}
