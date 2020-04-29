#ifndef SEMAPHORE_H
#define SEMAPHORE_H

#include <pthread.h>

typedef struct {
   unsigned           counter;
   pthread_cond_t     cv;
   pthread_mutex_t    mutex;
} semaphore_t;

void
semaphore_init(semaphore_t *, unsigned);

void
semaphore_destroy(semaphore_t *);

void 
semaphore_down(semaphore_t *);

int
semaphore_trydown(semaphore_t *);

void
semaphore_up(semaphore_t *);

#endif
