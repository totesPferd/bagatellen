#ifndef FLOWCTRL_H
#define FLOWCTRL_H

#include "semaphore.h"

#define BUFSIZE   15

#define STOPLIMIT_READ 7
#define STOPLIMIT_WRITE 2


typedef struct {
   char            buf[BUFSIZE];
   pthread_mutex_t bufMutex;
   semaphore_t     readSemaphore;
   unsigned        readPtr;
   pthread_mutex_t writeSemaphoreMutex;
   unsigned        writeCount;
   unsigned        writePtr;

   pthread_cond_t  cvStop;
   pthread_mutex_t cvStopMutex;
   semaphore_t     cvStopSemaphore;

} flowctrl_t;

void
flowctrl_init(flowctrl_t *);

void
flowctrl_destroy(flowctrl_t *);

char
flowctrl_readChar(flowctrl_t *);

int
flowctrl_writeChar(flowctrl_t *, char c);

int
flowctrl_isActiveWriteSemaphoreDown(flowctrl_t *);

int
flowctrl_isActiveWriteSemaphoreUp(flowctrl_t *);

void
flowctrl_go(flowctrl_t *);

#endif
