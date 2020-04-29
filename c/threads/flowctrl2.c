#include "flowctrl2.h"
#include "tsp.h"

static flowctrl_action_t checkState(flowctrl_t *h);
static char flowctrl_read(flowctrl_t *h);
static void flowctrl_write(flowctrl_t *h, char c);
static unsigned getWriteCount(flowctrl_t *h);

void
flowctrl_init(flowctrl_t *h, void (*go)(flowctrl_t *), void (*stop)(flowctrl_t *)) {
   pthread_mutex_init(&(h->bufMutex), NULL);
   h->readPtr   = 0;
   h->writePtr  = 0;
   semaphore_init(&(h->readSemaphore), 0);
   h->state     = flowctrl_state_go;
   h->go        = (void (*)(void *)) go;
   h->stop      = (void (*)(void *)) stop;
}

void
flowctrl_destroy(flowctrl_t *h) {
   semaphore_destroy(&(h->readSemaphore));
   pthread_mutex_destroy(&(h->bufMutex));
}

flowctrl_action_t
checkState(flowctrl_t *h) {
   unsigned writeCount = getWriteCount(h);

   {
      char buf[140];
      snprintf(buf, 140, "\n ..................... check state: %d .....................\n", writeCount);
      tsp_tsp(buf);
   }

   if (h->state == flowctrl_state_go && writeCount > STOPLIMIT_WRITE) {
      h->state = flowctrl_state_turn_to_stop;
      return flowctrl_act_stop;
   }

   if (h->state == flowctrl_state_stop && writeCount <= STOPLIMIT_READ) {
      h->state = flowctrl_state_turn_to_go;
      return flowctrl_act_go;
   }

   return flowctrl_act_no;
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

unsigned
getWriteCount(flowctrl_t *h) {
   return (h->writePtr - h->readPtr) % BUFSIZE;
}

flowctrl_action_t
flowctrl_ackGo(flowctrl_t *h) {
   pthread_mutex_lock(&(h->bufMutex));
   if (h->state == flowctrl_state_turn_to_go) {
      h->state = flowctrl_state_go;
   } else if (h->state == flowctrl_state_turn_to_any) {
      h->state = flowctrl_state_turn_to_stop;
   }
   flowctrl_action_t ret = checkState(h);
   pthread_mutex_unlock(&(h->bufMutex));
   return ret;
}

flowctrl_action_t
flowctrl_ackStop(flowctrl_t *h) {
   pthread_mutex_lock(&(h->bufMutex));
   if (h->state == flowctrl_state_turn_to_stop) {
      h->state = flowctrl_state_stop;
   } else if (h->state == flowctrl_state_turn_to_any) {
      h->state = flowctrl_state_turn_to_go;
   }
   flowctrl_action_t ret = checkState(h);
   pthread_mutex_unlock(&(h->bufMutex));
   return ret;
}

char
flowctrl_readChar(flowctrl_t *h) {
   semaphore_down(&(h->readSemaphore));
   pthread_mutex_lock(&(h->bufMutex));
   char ret = flowctrl_read(h);
   flowctrl_action_t act = checkState(h);
   pthread_mutex_unlock(&(h->bufMutex));
   switch(act) {
      case flowctrl_act_go :
         pthread_mutex_lock(&(h->bufMutex));
         if (h->state == flowctrl_state_turn_to_stop) {
            h->state = flowctrl_state_turn_to_any;
         } else {
            h->state = flowctrl_state_turn_to_go;
         }
         pthread_mutex_unlock(&(h->bufMutex));
         (*(h->go))((void *) h);
         break;
      case flowctrl_act_stop :
         pthread_mutex_lock(&(h->bufMutex));
         if (h->state == flowctrl_state_turn_to_go) {
            h->state = flowctrl_state_turn_to_any;
         } else {
            h->state = flowctrl_state_turn_to_stop;
         }
         pthread_mutex_unlock(&(h->bufMutex));
         (*(h->stop))((void  *) h);
         break;
      default:
         break;
   }
   return ret;
}

flowctrl_action_t
flowctrl_writeChar(flowctrl_t *h, char c) {
   pthread_mutex_lock(&(h->bufMutex));
   flowctrl_write(h, c);
   flowctrl_action_t ret = checkState(h);
   pthread_mutex_unlock(&(h->bufMutex));
   semaphore_up(&(h->readSemaphore));
   return ret;
}
