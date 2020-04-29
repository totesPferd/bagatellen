#ifndef FLOWCTRL_TWO_H
#define FLOWCTRL_TWO_H

#include "semaphore.h"

#define BUFSIZE   15

#define STOPLIMIT_READ 2
#define STOPLIMIT_WRITE 7


typedef enum {
   flowctrl_act_no,
   flowctrl_act_go,
   flowctrl_act_stop
} flowctrl_action_t;

typedef enum{
   flowctrl_state_go,
   flowctrl_state_stop,
   flowctrl_state_turn_to_go,
   flowctrl_state_turn_to_stop,
   flowctrl_state_turn_to_any
} flowctrl_state_t;

typedef struct {
   char               buf[BUFSIZE];
   pthread_mutex_t    bufMutex;
   unsigned           readPtr;
   unsigned           writePtr;
   semaphore_t        readSemaphore;
   flowctrl_state_t   state;
   void               (*go)(void *);
   void               (*stop)(void *);
} flowctrl_t;

void
flowctrl_init(flowctrl_t *, void (*)(), void (*)());

void
flowctrl_destroy(flowctrl_t *);

char
flowctrl_readChar(flowctrl_t *);

flowctrl_action_t
flowctrl_writeChar(flowctrl_t *, char c);

flowctrl_action_t
flowctrl_ackGo(flowctrl_t *);

flowctrl_action_t
flowctrl_ackStop(flowctrl_t *);

#endif
