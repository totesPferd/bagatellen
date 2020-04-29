#include "flowctrl.h"
#include "tsp.h"

flowctrl_t fc;

void *producer(void *);
void *consumer(void *);

int
main(int argc, char **argv) {
  pthread_t th_p, th_c;

  tsp_init();

  flowctrl_init(&fc);
  pthread_create(&th_p, NULL, producer, NULL);
  pthread_create(&th_c, NULL, consumer, NULL);

  sleep(100);
  flowctrl_destroy(&fc);
  printf("\n");
}

void *
producer(void *arg) {
   while (1) {
      char c;
      for (c = (char) 0x20; c < (char) 0x7f; c++) {
         if (flowctrl_writeChar(&fc, c)) {
            semaphore_up(&(fc.cvStopSemaphore));
            tsp_tsp(" stop! #");
            pthread_cond_wait(&(fc.cvStop), &(fc.cvStopMutex));
            tsp_tsp(".\n");
            pthread_mutex_unlock(&(fc.cvStopMutex));
         }
      }
   }
}

void *
consumer(void *arg) {
   while(1) {
      putchar((int) flowctrl_readChar(&fc));
   }
}
