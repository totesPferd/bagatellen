#include "flowctrl.h"
#include "tsp.h"

void
flowctrl_init(flowctrl_t *h) {
   pthread_mutex_init(&(h->bufMutex), NULL);
   semaphore_init(&(h->readSemaphore), 0);
   h->readPtr       = 0;
   h->writeCount    = BUFSIZE;
   h->writePtr      = 0;
   pthread_mutex_init(&(h->writeSemaphoreMutex), NULL);

   pthread_cond_init(&(h->cvStop), NULL);
   pthread_mutex_init(&(h->cvStopMutex), NULL);
   semaphore_init(&(h->cvStopSemaphore), 0);
}

void
flowctrl_destroy(flowctrl_t *h) {
   semaphore_destroy(&(h->cvStopSemaphore));
   pthread_mutex_destroy(&(h->cvStopMutex));
   pthread_cond_destroy(&(h->cvStop));

   pthread_mutex_destroy(&(h->writeSemaphoreMutex));
   semaphore_destroy(&(h->readSemaphore));
   pthread_mutex_destroy(&(h->bufMutex));
}

char
flowctrl_read(flowctrl_t *h) {
   char ret = h->buf[h->readPtr];
   if (h->readPtr < BUFSIZE) {
      (h->readPtr)++;
   } else {
      h->readPtr = 0;
   }
   return ret;
}

void
flowctrl_write(flowctrl_t *h, char c) {
   h->buf[h->writePtr] = c;
   if (h->writePtr >= BUFSIZE) {
      h->writePtr = 0;
   } else {
      (h->writePtr)++;
   }
}

int
flowctrl_isActiveWriteSemaphoreDown(flowctrl_t *h) {
   pthread_mutex_lock(&(h->writeSemaphoreMutex));
   (h->writeCount)--;
   int active   = h->writeCount <= STOPLIMIT_WRITE;
   pthread_mutex_unlock(&(h->writeSemaphoreMutex));
   return active;
}

int
flowctrl_isActiveWriteSemaphoreUp(flowctrl_t *h) {
   pthread_mutex_lock(&(h->writeSemaphoreMutex));
   (h->writeCount)++;
   int active   = h->writeCount <= STOPLIMIT_READ;
   pthread_mutex_unlock(&(h->writeSemaphoreMutex));
   return active;
}

char
flowctrl_readChar(flowctrl_t *h) {
tsp_tsp("q # ");
   semaphore_down(&(h->readSemaphore));
tsp_tsp("1 ");
   pthread_mutex_lock(&(h->bufMutex));
   pthread_mutex_lock(&(h->cvStopMutex));
tsp_tsp("2");
tsp_tsp(".\n");
   char ret = flowctrl_read(h);
   pthread_mutex_unlock(&(h->cvStopMutex));
   pthread_mutex_unlock(&(h->bufMutex));
   if (!flowctrl_isActiveWriteSemaphoreUp(h)
     && semaphore_trydown(&(h->cvStopSemaphore))) {
      pthread_mutex_lock(&(h->cvStopMutex));
      pthread_cond_signal(&(h->cvStop));
      flowctrl_go(h);
      pthread_mutex_unlock(&(h->cvStopMutex));
   }
   return ret;
}

int
flowctrl_writeChar(flowctrl_t *h, char c) {
   int ret = flowctrl_isActiveWriteSemaphoreDown(h);
   pthread_mutex_lock(&(h->bufMutex));
   flowctrl_write(h, c);
   if (ret)
      pthread_mutex_lock(&(h->cvStopMutex));
   pthread_mutex_unlock(&(h->bufMutex));
   semaphore_up(&(h->readSemaphore));
   return ret;
}

/* -------------------------------------- */
#include <stdio.h>

void
flowctrl_go(flowctrl_t *h) {
   tsp_tsp(" go!\n");
}

/* ------------------------------------------------- */
#include <lua.h>
#include <lauxlib.h>

int
flowctrl_lua_down(lua_State *L) {
   flowctrl_t *flowctrl = (flowctrl_t *) luaL_checkudata(L, -1, "flowctrl");
   int ret = flowctrl_isActiveWriteSemaphoreDown(flowctrl);
   lua_pop(L, 1);
   lua_pushboolean(L, ret);
   return 1;
}

int
flowctrl_lua_up(lua_State *L) {
   flowctrl_t *flowctrl = (flowctrl_t *) luaL_checkudata(L, -1, "flowctrl");
   int ret = flowctrl_isActiveWriteSemaphoreUp(flowctrl);
   lua_pop(L, 1);
   lua_pushboolean(L, ret);
   return 1;
}

int
flowctrl_lua_read(lua_State *L) {
   flowctrl_t *flowctrl = (flowctrl_t *) luaL_checkudata(L, -1, "flowctrl");
   int ret = flowctrl_readChar(flowctrl);
   lua_pop(L, 1);
   lua_pushlstring(L, (const char *) &ret, (size_t) 1);
   return 1;
}

int
flowctrl_lua_write(lua_State *L) {
   flowctrl_t *flowctrl = (flowctrl_t *) luaL_checkudata(L, -2, "flowctrl");
   const char *arg = luaL_checkstring(L, -1);
   int ret = flowctrl_writeChar(flowctrl, arg[0]);
   lua_pop(L, 2);
   lua_pushboolean(L, ret);
   return 1;
}

int
flowctrl_lua_go(lua_State *L) {
   flowctrl_t *flowctrl = (flowctrl_t *) luaL_checkudata(L, -1, "flowctrl");
   flowctrl_go(flowctrl);
   lua_pop(L, 1);
   return 0;
}

int
flowctrl_lua_gc(lua_State *L) {
   flowctrl_t *flowctrl = (flowctrl_t *) luaL_checkudata(L, -1, "flowctrl");
   flowctrl_destroy(flowctrl);
   lua_pop(L, 1);
   return 0;
}

int
flowctrl_lua_newFlowctrl(lua_State *L) {
   flowctrl_t *flowctrl =
      (flowctrl_t *) lua_newuserdata(L, sizeof(flowctrl_t));
   flowctrl_init(flowctrl);
   luaL_newmetatable(L, "flowctrl");

   {
      lua_pushcfunction(L, &flowctrl_lua_gc);
      lua_setfield(L, -2, "__gc");

      lua_getglobal(L, "flowctrl");
      lua_setfield(L, -2, "__index");
   }

   lua_setmetatable(L, -2);
   return 1;
}

int
luaopen_flowctrl(lua_State *L) {
   lua_newtable(L);

   lua_pushcfunction(L, &flowctrl_lua_newFlowctrl);
   lua_setfield(L, -2, "create");

   lua_pushcfunction(L, &flowctrl_lua_up);
   lua_setfield(L, -2, "up");

   lua_pushcfunction(L, &flowctrl_lua_down);
   lua_setfield(L, -2, "down");

   lua_pushcfunction(L, &flowctrl_lua_go);
   lua_setfield(L, -2, "go");

   lua_pushcfunction(L, &flowctrl_lua_read);
   lua_setfield(L, -2, "read");

   lua_pushcfunction(L, &flowctrl_lua_write);
   lua_setfield(L, -2, "write");

   lua_setglobal(L, "flowctrl");
   return 0;
}
